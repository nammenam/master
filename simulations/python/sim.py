# from config import NETWORK_SHAPE
# import numpy as np
# import time
# import threading
# import random
# from core import intensity_to_delay_encoding
# import heapq

# GROWTH_PROBABILITY = 0.05
# SYNAPSE_DELAY = 5.0

# class Simulation:
#     def __init__(self, data: np.ndarray):
#         print("[Sim] Initializing simulation...")
#         self.now_time = 0.0
#         self.iteration = 0
#         self.event_queue = [] 
#         self.neurons = np.zeros(NETWORK_SHAPE[0] + NETWORK_SHAPE[1])
#         self.connections = {}
#         self.fill_event_queue(data[0], self.now_time)
#         print(f"[Sim] Built event queue with {len(self.event_queue)} events.")

#     def advance(self, time_slice: float):
#         target_time = self.now_time + time_slice
#         newly_spiked_indices = []
#         newly_grown_synapses = []
        
#         is_empty = False
#         if not self.event_queue:
#             is_empty = True

#         while self.event_queue and self.event_queue[0][0] <= target_time:
#             event_time, target_idx = heapq.heappop(self.event_queue)
#             self.now_time = event_time 
#             newly_spiked_indices.append(target_idx)
#             if 0 <= target_idx < NETWORK_SHAPE[0]:
#                 if random.random() < GROWTH_PROBABILITY:
#                     post_idx = random.randint(NETWORK_SHAPE[0], NETWORK_SHAPE[0] + NETWORK_SHAPE[1] - 1)
#                     if post_idx not in self.connections.get(target_idx, []):
#                         self.connections.setdefault(target_idx, []).append(post_idx)
#                         newly_grown_synapses.append((target_idx, post_idx))

#                 if target_idx in self.connections:
#                     for post_idx in self.connections[target_idx]:
#                         new_event_time = self.now_time + SYNAPSE_DELAY
#                         new_event = (new_event_time, post_idx)
#                         heapq.heappush(self.event_queue, new_event)

#         self.now_time = target_time
#         return newly_spiked_indices, newly_grown_synapses, is_empty

#     def fill_event_queue(self, input_image, start_time):
#         spikes = intensity_to_delay_encoding(input_image)
#         height, width = spikes.shape
#         y_coords, x_coords = np.where(~np.isnan(spikes))
#         times = spikes[y_coords, x_coords] + start_time
#         neuron_indices = y_coords * width + x_coords
#         sorted_indices = np.argsort(times)
#         spikes = times[sorted_indices]
#         indices = neuron_indices[sorted_indices]
#         for t, target in zip(spikes, indices):
#             heapq.heappush(self.event_queue, (t, target))
#         return input_image

#     def next_data(self, data):
#         self.iteration += 1
#         if self.iteration >= len(data):
#             print("[Sim] End of data, looping.")
#             self.iteration = 0 # Loop back to start
#         self.fill_event_queue(data[self.iteration], self.now_time)




from config import NETWORK_SHAPE
import numpy as np
import time
import threading
import random
from core import intensity_to_delay_encoding
import heapq
from collections import deque # <-- For spike history "memory"

# --- Synapse Constants ---
SYNAPSE_DELAY = 1.0 # 5ms delay

# --- New Growth Rule Constants ---
# Rule 1: "post neuron has a small chance to grow unconditionally if it has no connections"
UNCONDITIONAL_GROWTH_PROB = 0.01 # 5% chance per update() tick

# Rule 2: "if a post neuron has a connection and any pre neuron... fire it has a greater chance"
ASSOCIATIVE_GROWTH_PROB = 0.4  # 10% chance when a post-neuron is spiked
SPIKE_HISTORY_WINDOW = 1.0  # 20ms time window to be "co-active"


class Simulation:
    def __init__(self, data: np.ndarray):
        print("[Sim] Initializing simulation...")
        self.now_time = 0.0
        self.iteration = 0
        self.event_queue = [] 
        
        # --- 1. Add tie-breaker counter ---
        self.event_counter = 0

        self.neurons = np.zeros(NETWORK_SHAPE[0] + NETWORK_SHAPE[1])
        
        # --- 2. Add new connection maps ---
        # "Left-to-Right" (for spike propagation)
        self.connections = {} # {pre_idx: [post_idx, ...]}
        # "Right-to-Left" (for your new growth rules)
        self.post_to_pre_connections = {} # {post_idx: [pre_idx, ...]}
        
        # --- 3. Add "short-term memory" for spikes ---
        self.pre_spike_history = deque() # Stores (event_time, pre_neuron_index)

        self.fill_event_queue(data[0], self.now_time)
        print(f"[Sim] Built event queue with {len(self.event_queue)} events.")

    def _add_synapse(self, pre_idx, post_idx):
        """
        Helper function to add a synapse and keep both maps in sync.
        Returns (pre_idx, post_idx) if a new synapse was created, else None.
        """
        if post_idx not in self.connections.get(pre_idx, []):
            self.connections.setdefault(pre_idx, []).append(post_idx)
            self.post_to_pre_connections.setdefault(post_idx, []).append(pre_idx)
            return (pre_idx, post_idx)
        return None

    def advance(self, time_slice: float):
        target_time = self.now_time + time_slice
        newly_spiked_indices = []
        newly_grown_synapses = []
        
        is_empty = False
        if not self.event_queue:
            is_empty = True
            
        # --- 4. Clean up old spike history ---
        while self.pre_spike_history and \
              self.pre_spike_history[0][0] < self.now_time - SPIKE_HISTORY_WINDOW:
            self.pre_spike_history.popleft()

        # --- 5. Process event queue ---
        while self.event_queue and self.event_queue[0][0] <= target_time:
            
            # --- 6. Unpack new 4-item tuple ---
            event_time, _counter, event_type, target_idx = heapq.heappop(self.event_queue)
            
            self.now_time = event_time 
            newly_spiked_indices.append(target_idx)

            if event_type == 'FF':
                pre_idx = target_idx
                # Add this spike to our short-term memory
                self.pre_spike_history.append((event_time, pre_idx))
                
                # Propagate spike to existing connections
                if pre_idx in self.connections:
                    for post_idx in self.connections[pre_idx]:
                        new_event_time = self.now_time + SYNAPSE_DELAY
                        new_event = (new_event_time, self.event_counter, 'spike', post_idx)
                        heapq.heappush(self.event_queue, new_event)
                        self.event_counter += 1

            # --- Event Type 'spike' (Post-Neuron Receives Spike) ---
            elif event_type == 'spike':
                post_idx = target_idx
                
                # --- This is the trigger for RULE 2 ---
                if random.random() < ASSOCIATIVE_GROWTH_PROB:
                    # Find all pre-neurons we are *already* connected to
                    connected_pre = set(self.post_to_pre_connections.get(post_idx, []))
                    
                    # Find "candidate" neurons:
                    # 1. Are in the recent spike history
                    # 2. Are NOT already connected to this post-neuron
                    candidates = [
                        p_idx for (t, p_idx) in self.pre_spike_history 
                        if p_idx not in connected_pre
                    ]
                    
                    if candidates:
                        # Choose one of these "co-active" neurons to connect to
                        pre_to_connect = random.choice(candidates)
                        
                        # Create the new synapse
                        new_synapse = self._add_synapse(pre_to_connect, post_idx)
                        if new_synapse:
                            newly_grown_synapses.append(new_synapse)

        # --- 8. Implement RULE 1 (Unconditional Growth) ---
        # (This runs once per 'advance' call, *after* the event loop)
        if random.random() < UNCONDITIONAL_GROWTH_PROB:
            # Pick a random post-neuron
            post_idx = random.randint(NETWORK_SHAPE[0], NETWORK_SHAPE[0] + NETWORK_SHAPE[1] - 1)
            
            # "if it has no connections"
            if post_idx not in self.post_to_pre_connections:
                # "grow... right to left" (find a random pre-neuron to connect *from*)
                pre_idx = random.randint(0, NETWORK_SHAPE[0] - 1)
                
                new_synapse = self._add_synapse(pre_idx, post_idx)
                if new_synapse:
                    newly_grown_synapses.append(new_synapse)

        self.now_time = target_time
        return newly_spiked_indices, newly_grown_synapses, is_empty

    def fill_event_queue(self, input_image, start_time):
        spikes = intensity_to_delay_encoding(input_image)
        height, width = spikes.shape
        y_coords, x_coords = np.where(~np.isnan(spikes))
        times = spikes[y_coords, x_coords] + start_time
        neuron_indices = y_coords * width + x_coords
        sorted_indices = np.argsort(times)
        spikes = times[sorted_indices]
        indices = neuron_indices[sorted_indices]
        
        # --- 9. Push the new 4-item tuple ---
        for t, target in zip(spikes, indices):
            entry = (t, self.event_counter, 'FF', target) # (time, counter, type, index)
            heapq.heappush(self.event_queue, entry)
            self.event_counter += 1
            
        return input_image

    def next_data(self, data):
        self.iteration += 1
        if self.iteration >= len(data):
            print("[Sim] End of data, looping.")
            self.iteration = 0 
        self.fill_event_queue(data[self.iteration], self.now_time)

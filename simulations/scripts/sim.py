from config import NETWORK_SHAPE
import numpy as np
import time
import threading
import random
from core import intensity_to_delay_encoding

def fill_event_queue(event_queue, arrival_times, target_indices):
    for t, target in zip(arrival_times, target_indices):
        event_queue.append((t, 'FF', {'target': target }))
    event_queue.sort(key=lambda x: x[0])

class Simulation:
    def __init__(self, data: np.ndarray):
        print("[Sim] Initializing simulation...")
        self.now_time = 0.0
        self.event_queue = []
        self.neurons = np.zeros(NETWORK_SHAPE[0] + NETWORK_SHAPE[1]) # Example state
        self.output_image = np.zeros((10, 10), dtype=np.uint8) # Example

        for iteration in range(data.shape[0]):
            input_image = data[iteration]
            spikes = intensity_to_delay_encoding(input_image)
            height, width = spikes.shape
            y_coords, x_coords = np.where(~np.isnan(spikes))
            times = spikes[y_coords, x_coords]
            neuron_indices = y_coords * width + x_coords
            sorted_indices = np.argsort(times)
            spikes = times[sorted_indices]
            indices = neuron_indices[sorted_indices]
            fill_event_queue(self.event_queue, spikes, indices)
            
            # --- DUMMY event queue for demonstration ---
            # (Replace this with your real queue-filling logic)
            for i in range(NETWORK_SHAPE[0]):
                # (time, type, data)
                spike_time = (iteration * 5) + random.random() * 5 # Spikes over 5s
                self.event_queue.append( (spike_time, "spike", {"target": i}) )
        
        # --- CRITICAL: Sort the queue by time! ---
        self.event_queue.sort(key=lambda x: x[0])
        print(f"[Sim] Built event queue with {len(self.event_queue)} events.")

    def advance(self, time_slice: float):
        target_time = self.now_time + time_slice
        newly_spiked_indices = []
        while len(self.event_queue) > 0:
            event_time, event_type, event_data = self.event_queue[0] # Just peek
            if event_time > target_time:
                break 
                
            self.event_queue.pop(0) 
            self.now_time = event_time 
            target_idx = event_data['target']

            # --- Do your simulation logic ---
            # (e.g., update potentials, propagate spikes, etc.)
            
            # For visualization, record the spike
            newly_spiked_indices.append(target_idx)

        self.now_time = target_time
        return newly_spiked_indices, self.output_image

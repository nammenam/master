
from math import sin, exp, pi
import numpy as np
import random
import threading
import dearpygui.dearpygui as dpg
import time
import collections
import bisect

from theme import create_global_theme, create_line_series_theme, load_font, scatter_green, scatter_orange
from core import intensity_to_delay_encoding,create_conv_connections, get_postsynaptic_events

MAX_POINTS = 2000
TIME_STEP = 0.01
# INPUT_SHAPE = (28, 28)
# OUTPUT_SHAPE = (28, 28)
INPUT_SHAPE = (8, 8)
OUTPUT_SHAPE = (6, 6)
OUTPUT_WIDTH = OUTPUT_SHAPE[1]
NUM_NEURONS_PER_MAP = OUTPUT_SHAPE[0] * OUTPUT_SHAPE[1]
TOTAL_NEURONS = NUM_NEURONS_PER_MAP * 2
# LIF Neuron Parameters
TAU_M = 10.0          # Membrane time constant (ms)
V_THRESH = 3        # Firing threshold
V_REST = 0.0          # Resting potential
W_LATERAL_INH = -0.5  # Weight of lateral inhibition
LATERAL_DELAY = 1.0   # Delay for lateral inhibition spike (ms)
TARGET_Y = 3
TARGET_X = 3

is_paused = False
step_event = threading.Event()
simulation_time = 0.0

start_time = -(MAX_POINTS - 1) * TIME_STEP
initial_time_data = np.linspace(start_time, 0.0, num=MAX_POINTS)
time_data = collections.deque(initial_time_data, maxlen=MAX_POINTS)
simulation_time = 0
connections = []
neurons     = []

def key_press_handler(sender, app_data):
    global is_paused
    key = app_data
    if key == 524:
        is_paused = not is_paused
        if not is_paused:
            step_event.set()
        print(f"Simulation {'Paused' if is_paused else 'Playing'}")
    elif key == 559 and is_paused:
        step_event.set()

def scale_image(image: np.ndarray, factor: int) -> np.ndarray:
    return np.repeat(np.repeat(image, factor, axis=0), factor, axis=1)

def rgba_image(image: np.ndarray):
    h, w = image.shape
    rgba_image = np.zeros((h, w, 4), dtype=np.float32)
    rgba_image[..., :3] = image[..., np.newaxis]
    rgba_image[..., 3] = 1.0
    return rgba_image

def update_text():
    global simulation_time
    while True:
        dpg.set_value("frame_text", f"Frame: {dpg.get_frame_count()}")
        dpg.set_value("time_text", f"Time: {simulation_time}")
        time.sleep(0.1)

def fill_event_queue(event_queue, arrival_times, target_indices, weights):
    for t, target, w in zip(arrival_times, target_indices, weights):
        event_queue.append((t, 'FF', {'target': target, 'weight': w}))
    event_queue.sort(key=lambda x: x[0])

def update_series_data(spikes, indices):
    global simulation_time
    connection_map = create_conv_connections(INPUT_SHAPE, OUTPUT_SHAPE)
    sorted_indices = np.argsort(spikes)
    spikes = spikes[sorted_indices]
    indices = indices[sorted_indices]
    arrival_times, target_indices, weights = get_postsynaptic_events(
        input_spike_times=spikes,
        input_spike_indices=indices,
        connections=connection_map
    )

    event_queue = []
    fill_event_queue(event_queue,arrival_times,target_indices,weights)
    membrane_potentials = np.full(TOTAL_NEURONS, V_REST, dtype=float)
    last_update_times = np.zeros(TOTAL_NEURONS, dtype=float)
    output_spike_times = np.full(TOTAL_NEURONS, np.nan, dtype=float)
    output_image = np.zeros(OUTPUT_SHAPE, dtype=np.float32)
    out_img = rgba_image(output_image)
    output_spike_list_x, output_spike_list_y, output_spike_list_idx = [], [], []

    while True:
        if is_paused:
            step_event.wait()
            step_event.clear()

        event_time, event_type, data = event_queue.pop(0)
        if len(event_queue) == 0:
            fill_event_queue(event_queue,arrival_times,target_indices,weights)
            last_update_times = np.zeros(TOTAL_NEURONS, dtype=float)
        now_time = event_time
        out_img = out_img * 0.999
        if now_time < simulation_time:

            target_idx = data['target']
            weight = data['weight']

            if not np.isnan(output_spike_times[target_idx]):
                continue

            time_delta = event_time - last_update_times[target_idx]
            if time_delta > 0:
              membrane_potentials[target_idx] *= exp(-time_delta / TAU_M)
        
            membrane_potentials[target_idx] += weight
            last_update_times[target_idx] = event_time

            if membrane_potentials[target_idx] >= V_THRESH:
                output_spike_times[target_idx] = event_time
                membrane_potentials[target_idx] = V_REST
            output_spike_list_x.append(event_time)
            output_spike_list_y.append(target_idx)
            map_offset = 0
            if target_idx >= NUM_NEURONS_PER_MAP:
                map_offset = NUM_NEURONS_PER_MAP
                
            neuron_2d_idx = target_idx - map_offset
            y = neuron_2d_idx // OUTPUT_WIDTH
            x = neuron_2d_idx % OUTPUT_WIDTH
            max_time = spikes[-1] if len(spikes) > 0 else 1.0
            # brightness = max(0.01, 1.0 - (event_time / max_time))
            brightness = output_spike_times[target_idx]
            out_img[y,x,0] = brightness
            out_img[y,x,1] = brightness
            out_img[y,x,2] = brightness * weight
            out_img[y,x,3] = 1
            # LATERAL INHIBITION
            #     neighbors = [target_idx - 1, target_idx + 1]
            #     for neighbor_idx in neighbors:
            #         if 0 <= neighbor_idx < TOTAL_NEURONS and (neighbor_idx // OUTPUT_WIDTH) == (target_idx // OUTPUT_WIDTH):
            #             inhib_event = (event_time + LATERAL_DELAY, 'LI', {'target': neighbor_idx, 'weight': W_LATERAL_INH})
            #             bisect.insort(event_queue, inhib_event, key=lambda x: x[0])


            # exc_mask = weights > 0
            # exc_times = arrival_times[exc_mask]
            # exc_indices = target_indices[exc_mask]
            # inh_mask = weights < 0
            # inh_times = arrival_times[inh_mask]
            # inh_indices = target_indices[inh_mask]

            # spike_times_exc = [s[0] for s in incoming_spikes if s[1] == 1 and time_data[0] <= s[0] <= time_data[-1]]
            # spike_times_inh = [s[0] for s in incoming_spikes if s[1] == -1 and time_data[0] <= s[0] <= time_data[-1]]
            # spike_times_out = [s[0] for s in incoming_spikes if s[1] == 2 and time_data[0] <= s[0] <= time_data[-1]]

        # Only update GUI periodically to avoid lag
        # if len(output_spike_list_x) % 10 == 0 or is_paused:
            # dpg.set_value("out_spikes_series", [output_spike_list_x, output_spike_list_y])
        scaled_img = scale_image(out_img, int(256/OUTPUT_SHAPE[0]))
        dpg.set_value("neurons0",scaled_img.flatten() )
            # dpg.set_value('exc_spikes_series', [list(neuron_input_times), list(neuron_input_weights)])
        # dpg.set_value('exc_spikes_series', [list(exc_times), list(exc_indices)])
        # dpg.set_value('inh_spikes_series', [list(inh_times), list(inh_indices)])
        simulation_time += TIME_STEP
        time_data.append(simulation_time)
        time.sleep(0.01)

def reset_simulation():
    global simulation_time
    simulation_time = 0.0
    # incoming_spikes.clear()
    time_data.clear()
    time_data.extend(initial_time_data)
    print("Simulation Reset")

def inject_excitatory_spike():
    incoming_spikes.append((simulation_time, 1))

def inject_inhibitory_spike():
    incoming_spikes.append((simulation_time, -1))

# --- GUI Layout ---
VIEWPORT_WIDTH = 2300
VIEWPORT_HEIGHT = 1300

def run_gui(input_image):

    spikes = intensity_to_delay_encoding(input_image)
    height, width = spikes.shape
    y_coords, x_coords = np.where(~np.isnan(spikes))
    times = spikes[y_coords, x_coords]
    neuron_indices = y_coords * width + x_coords
    sorted_indices = np.argsort(times)
    spikes = times[sorted_indices]
    indices = neuron_indices[sorted_indices]
    dpg.create_context()

    load_font(dpg)

    with dpg.handler_registry():
        dpg.add_key_press_handler(callback=key_press_handler)

    with dpg.window(tag="primary_window",
                    pos=[0, 0],
                    width=VIEWPORT_WIDTH,
                    height=VIEWPORT_HEIGHT,
                    no_move=True,
                    no_resize=True,
                    no_close=True,
                    no_collapse=True,
                    no_title_bar=True):
        with dpg.group(horizontal=True):
            with dpg.child_window(width=VIEWPORT_WIDTH * 0.7):
                
                SCALE_FACTOR_OUT = int(256 / OUTPUT_SHAPE[0])
                default_value = np.zeros(OUTPUT_SHAPE, dtype=np.float32)
                default_image = scale_image(default_value, SCALE_FACTOR_OUT)
                default_image_rbga = rgba_image(default_image).flatten()
                with dpg.texture_registry(show=True):
                    dpg.add_dynamic_texture(
                        width=default_image.shape[1],
                        height=default_image.shape[0],
                        default_value=default_image_rbga,
                        tag="neurons0"
                    )
                    # dpg.add_dynamic_texture(
                    #     width=default_image.shape[1],
                    #     height=default_image.shape[0],
                    #     default_value = default_image_rbga,
                    #     tag="neurons1"
                    # )

                with dpg.group(horizontal=True):
                    dpg.add_image("neurons0")
                    # dpg.add_image("neurons1")
                dpg.add_separator()

                with dpg.drawlist(width=300, height=1980):
                    for i in range(INPUT_SHAPE[0] * INPUT_SHAPE[1]):
                        dpg.draw_circle((5,i*8 + 15),3, fill=(255,255,255))
                    for i in range(OUTPUT_SHAPE[0] * OUTPUT_SHAPE[1]):
                        dpg.draw_circle((200,i*8 + 115),3, fill=(255,255,255))

            with dpg.child_window(width=-1):
                dpg.add_button(label="Reset Simulation", callback=reset_simulation, width=-1, height=40)
                dpg.add_separator()

                SCALE_FACTOR = int(256 / INPUT_SHAPE[0])
                normalized_image = input_image.astype(np.float32) / 255.0
                scaled_image = scale_image(normalized_image, SCALE_FACTOR)
                scaled_image_rgba = rgba_image(scaled_image)

                with dpg.texture_registry(show=True):
                    dpg.add_static_texture(
                        width=scaled_image.shape[1],
                        height=scaled_image.shape[0],
                        default_value=scaled_image_rgba,
                        tag="input_image"
                    )
                with dpg.group(horizontal=True):
                    dpg.add_image("input_image")
                    with dpg.drawlist(width=30, height=100):  # or you could use dpg.add_drawlist and set parents manually
                        dpg.draw_line((0, 0), (0, 100), color=(255, 255, 0, 255), thickness=30)
                dpg.add_separator()
                dpg.add_text(f"Frame: {dpg.get_frame_count()}", tag="frame_text")
                dpg.add_text(f"Time:  {simulation_time}", tag="time_text")

    dpg.create_viewport(title='Neuron Simulation', width=VIEWPORT_WIDTH, height=VIEWPORT_HEIGHT)
    dpg.set_viewport_vsync(True)
    dpg.setup_dearpygui()
    update_thread = threading.Thread(target=update_series_data, args=(spikes, indices), daemon=True)
    frame_thread = threading.Thread(target=update_text, daemon=True)
    update_thread.start()
    frame_thread.start()
    dpg.show_viewport()
    dpg.start_dearpygui()
    dpg.destroy_context()

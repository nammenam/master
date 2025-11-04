from PIL import Image
import numpy as np
from data import scale_image, create_random_image_one_channel
from MNIST import parse_MNIST, MNIST_train_images_path, MNIST_test_images_path
import random
import pyglet
from pyglet.window import key
from pyglet.window import mouse
from pyglet.shapes import Circle, Rectangle, Line
from config import NETWORK_SHAPE, WINDOW_HEIGHT, WINDOW_WIDTH, X_MARGIN, LAYER_SPACING


# --- Import the simulation code ---
import threading
from sim import Simulation

def np_to_pyglet_image(np_array):
    np_array = scale_image(np_array,16)
    height, width = np_array.shape
    raw_data = np_array.tobytes()
    return pyglet.image.ImageData(width, height, 'I', raw_data)

def center_image(image):
    image.anchor_x = image.width // 2
    image.anchor_y = image.height // 2

def draw_neurons(batch):
    circles = []
    height = NETWORK_SHAPE[0] * 16
    y_offset = (WINDOW_HEIGHT - height) // 2
    for i in range(NETWORK_SHAPE[0]):
        neuron_x = (i // 100) * 16 + X_MARGIN
        neuron_y = (i % 100) * 16 + y_offset
        new_circle = Circle(x=neuron_x, y=neuron_y, radius=3, color=(225, 225, 225),batch=batch)
        circles.append(new_circle)
    height = NETWORK_SHAPE[1] * 16
    y_offset = (WINDOW_HEIGHT - height) // 2
    for j in range(NETWORK_SHAPE[1]):
        neuron_x = (j // 100) * 16 + LAYER_SPACING + X_MARGIN
        neuron_y = (j % 100) * 16 + y_offset
        new_circle = Circle(x=neuron_x, y=neuron_y, radius=3, color=(225, 225, 225),batch=batch)
        circles.append(new_circle)
    return circles

def draw_connections(batch):
    lines = []
    height = NETWORK_SHAPE[0] * 16
    y_offset = (WINDOW_HEIGHT - height) // 2
    height_dest = NETWORK_SHAPE[1] * 16
    y_offset_dest = (WINDOW_HEIGHT - height_dest) // 2
    for i in range(NETWORK_SHAPE[0]):
        neuron_x = (i // 100) * 16 + X_MARGIN
        neuron_y = (i % 100) * 16 + y_offset
        for j in range(NETWORK_SHAPE[1]):
            neuron_x_dest = (j // 100) * 16 + LAYER_SPACING + X_MARGIN
            neuron_y_dest = (j % 100) * 16 + y_offset_dest
            new_line = Line(neuron_x, neuron_y, neuron_x_dest, neuron_y_dest,
                            thickness=2, color=(225, 225, 225, 0),batch=batch)
            lines.append(new_line)
    return lines



playback_speed = 1
# image_path = 'data/doomguy.jpg'
# image_path = 'data/lenna.png'
# original_image = Image.open(image_path)
# grayscale_image = original_image.convert('L')
# MNIST = parse_MNIST(MNIST_train_images_path)
# max_dim = 28
# low_res_image_pil = grayscale_image.resize((max_dim, max_dim), Image.Resampling.LANCZOS)
random_image = create_random_image_one_channel(8,8)
random_image1 = create_random_image_one_channel(8,8)
random_image2 = create_random_image_one_channel(8,8)
# input_image = np.array(low_res_image_pil)
# input_image = generate_checkerboard(size=max_dim, block_size=int(max_dim/7))
# input_image = MNIST[24]
# visualize_image(input_image)
data = np.array([random_image,random_image1,random_image2])
window = pyglet.window.Window(WINDOW_WIDTH, WINDOW_HEIGHT)

sim = Simulation(data)
# pyglet.resource.path = ['../data']
# pyglet.resource.reindex()
image = np_to_pyglet_image(data[0])
center_image(image)
batch = pyglet.graphics.Batch()
connections = draw_connections(batch)
neurons = draw_neurons(batch)
label = pyglet.text.Label('SPIKING NEURAL NETWORK SIMULATOR V1',
                          font_name='GeistMono NF Medium',
                          font_size=18,
                          x=window.width//2, y=window.height-18,
                          anchor_x='center', anchor_y='center')
time_label = pyglet.text.Label('',
                          font_name='GeistMono NF Medium',
                          font_size=11,
                          x=window.width-20, y=20,
                          anchor_x='right', anchor_y='center')



def update(dt):
    global playback_speed
    time_slice = dt * playback_speed
    if time_slice <= 0: # Do nothing if paused
        return

    # 2. Tell the simulation to advance and get results
    spiked_indices, output_img = sim.advance(time_slice)
    # --- 3. Update GUI (This is all 100% safe) ---
    # Fade old spikes
    for neuron in neurons:
        if neuron.color != (225, 225, 225):
             neuron.color = (
                 min(225, neuron.color[0] + 5), 
                 min(225, neuron.color[1] - 10),
                 min(225, neuron.color[2] - 10)
             )
             if neuron.color[1] < 50:
                 neuron.color = (225, 225, 225)
    # Light up new spikes
    for idx in spiked_indices:
        if 0 <= idx < len(neurons):
            neurons[idx].color = (50, 255, 50) # Bright green

    # Update labels and output image
    time_label.text = f'{sim.now_time:.2f}s'

@window.event
def on_key_press(symbol, modifiers):
    if symbol == key.A:
        print('The "A" key was pressed.')
    elif symbol == key.LEFT:
        print('The left arrow key was pressed.')
    elif symbol == key.ENTER:
        print('The enter key was pressed.')

@window.event
def on_mouse_press(x, y, button, modifiers):
    if button == mouse.LEFT:
        print(f'The left mouse button was pressed. [{x}, {y}]')


@window.event
def on_draw():
    window.clear()
    image.blit(window.width - 64, window.height - 64)
    label.draw()
    time_label.draw()
    batch.draw()

pyglet.clock.schedule_interval(update, 1/120)
pyglet.app.run()

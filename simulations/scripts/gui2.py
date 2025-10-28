import random
import pyglet
from pyglet.window import key
from pyglet.window import mouse
from pyglet.shapes import Circle,Rectangle

WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080
window = pyglet.window.Window(WINDOW_WIDTH, WINDOW_HEIGHT, resizable=True)

def center_image(image):
    """Sets an image's anchor point to its center"""
    image.anchor_x = image.width // 2
    image.anchor_y = image.height // 2


pyglet.resource.path = ['../data']
pyglet.resource.reindex()
image = pyglet.resource.image('doomguy.jpg')
center_image(image)
batch = pyglet.graphics.Batch()
label = pyglet.text.Label('SPIKING NEURAL NETWORK SIMULATOR V1',
                          font_name='GeistMono NF',
                          font_size=18,
                          x=window.width//2, y=window.height//2,
                          anchor_x='center', anchor_y='center')

def neurons(num_neurons):
    neurons = []
    for i in range(num_neurons):
        neuron_x = random.randint(0, WINDOW_WIDTH)
        neuron_y = random.randint(0, WINDOW_HEIGHT)
        new_neuron = Circle(x=neuron_x, y=neuron_y, radius=3, color=(225, 225, 225),batch=batch)
        neurons.append(new_neuron)
    return neurons

n = neurons(1000)

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
    image.blit(window.width//2, window.height//2)
    label.draw()
    batch.draw()

pyglet.app.run()

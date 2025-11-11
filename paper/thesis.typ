#import "@preview/droplet:0.3.1": dropcap
#import "@preview/wordometer:0.1.5": word-count, total-words
#import "@preview/lovelace:0.3.0": pseudocode-list
#import "@preview/glossarium:0.5.9": make-glossary, register-glossary, print-glossary, gls, glspl
#import "uiomasterfp/frontpage.typ": cover
#import "uiomasterfp/frontpage.typ": colors
#import "glossary.typ": entry-list

#show: make-glossary
#show: word-count

#set text(font: "Geist", size: 10pt)
#show math.equation : set text(font:"TeX Gyre Schola Math", size: 10.5pt)
#show raw : set text(font:"GeistMono NF", weight: "medium", size:9pt)
#set list(marker: sym.bullet, indent: 1em)
#show heading: set text(font:"Geist",weight: "bold", style:"normal")
#show heading.where( level: 1 ): it => block(width: 100%)[
  #set align(left + horizon); #set text(24pt)
  #upper(it)
  #v(.8em)
]
#show heading.where( level: 2 ): it => block(width: 100%)[
  #set align(left + horizon); #set text(16pt)
  #upper(it)
  #v(.8em)
]
#show heading.where( level: 3 ): it => block(width: 100%)[
  #set text(12pt,weight: "semibold"); #upper(it) #v(0.4em)
]
#show heading.where( level: 4 ): it => block(width: 100%)[
  #set text(11pt,weight: "semibold"); #upper(it) #v(0.3em)
]

#show figure.caption: it => {
  set align(left)
  set par(justify: true)
  it
}

// #set heading(numbering: "1.1 \u{00B7}")
#set heading(numbering: "1.1 \u{2022}")

#let serif-text(body) = {
  set text(font: "Source Serif 4 18pt", size: 11pt)
  body
}

#let mono-text(body) = {
  set text(font: "GeistMono NF", size: 9pt, weight: "medium")
  body
}

#let box-text(body) = {
block(stroke:(thickness:0pt, paint:luma(0)), inset: 10pt, radius: 0pt, fill: colors.gray.light,
  width: 100%)[#text(weight:"medium", font:"Geist", size:10pt,body)]
}

// FRONTPAGE
#cover()

// ABSTRACT, ACKNOWLEDGEMENTS AND OUTLINE
#set page(fill:none, margin:auto, numbering: "1")


#set page(footer: align(center, text(size:10pt, weight: "medium", font:"Geist",
context { counter(page).display("1") })))

#set par(justify: true)
#counter(page).update(1)

#v(1.2cm)
#align(center)[
#block(width:90%, inset: 2em)[
#align(left)[
  #text(weight:"semibold",size:16pt,[ABSTRACT])

  #serif-text()[
    #lorem(200)
  ]]
]]

#v(3cm)
#align(center)[
#block(width:100%)[
  #align(left)[
  #text(weight:"semibold",size:16pt,[ACKNOWLEDGEMENTS])

  #serif-text()[
    #lorem(78)
  ]]
]]

#pagebreak()

#{
  set text(font: "Geist", weight: "medium", size: 10pt)
  outline(depth:3, indent: auto)
}

#v(.5em)
#text(size: 9pt, weight: "medium")[
Wordcount: #total-words
]

#pagebreak()

#heading(outlined: false, numbering: none, level: 1)[GLOSSARY]
#{
set text(font: "Geist", weight: "medium", size: 10pt)
register-glossary(entry-list)
print-glossary(
 entry-list
)
}

#pagebreak()

= Introduction <intro>

#serif-text()[
The quest to create intelligent machines is one of humanity's oldest and most profound ambitions, spanning the realms of philosophy, mathematics, and engineering. It is intertwined with our deepest questions: What is the nature of intelligence, how does it emerge from inert matter, and can we, its creators, reproduce it artificially? Today, this ancient quest is no longer confined to speculation. We are at the heart of a technological revolution that places this question at the center of our scientific and economic lives. Answering it promises not only to unlock a deeper understanding of our own minds but also to yield transformative tools—from hyper-personalized medicine and the discovery of novel materials to automated scientific discovery. It may, as some have suggested, be the last invention humans ever need to make.

In recent years, @ai has experienced a "Big Bang" moment. Deep Learning, a computational approach built on multi-layered @ann, has broken one performance barrier after another. It has achieved demonstrably superhuman results in domains once thought to be the exclusive purview of human intuition, from the intricate protein folding of AlphaFold to the complex, emergent strategies of Go and the stunning fluency of large-scale language models. This wave of success has cemented #gls("ai",display:"AI's") place as a general-purpose technology, poised to reshape every corner of society.

However, beneath the surface of this explosive progress, a fundamental and unsustainable flaw has been exposed. The triumph of modern deep learning is built on a paradigm of brute force, and we are beginning to hit the wall. This "success" comes at a staggering, and rapidly inflating, computational cost. The training of a single state-of-the-art model can consume megawatts of power, emitting a carbon footprint equivalent to the lifetime of several cars. This isn't a problem that can be solved with slightly better chips; it's an architectural crisis.

This voracious hunger for power is matched by an insatiable appetite for data. These models demand planet-scale datasets, which are increasingly difficult to source, curate, and maintain. Worse still, new evidence suggests that this brute-force approach may be yielding diminishing returns on intelligence. Despite their superhuman acuity in narrow tasks, these models often prove to_be brittle, statistically-driven correlation engines. They show a profound lack of common-sense reasoning, struggle with robust out-of-distribution generalization, and can fail in spectacularly simple, non-human ways.

This triad of challenges—spiraling energy costs, insatiable data demands, and limited, "un-intelligent" learning—should be a definitive wake-up call. We are building digital supercomputers to simulate intelligence rather than building efficient, intelligent machines. The very hardware we use is part of the problem. We are running brain-inspired algorithms on an architecture that is fundamentally not brain-like. Today's systems are built on the 80-year-old von Neumann architecture, a relic of serial computation now forced to handle a massively parallel problem. This design creates the infamous "memory bottleneck" by physically separating processing and memory, forcing the system to waste the vast majority of its time and energy shuttling data between the two.

In stark, almost humbling contrast, the human brain—our "gold standard" of efficient intelligence—performs tasks of far greater complexity on a mere 20 watts of power. It doesn't just "think"; it simultaneously manages a complex biological system, processes a continuous flood of multi-sensory data, and navigates a dynamic world in real-time. It achieves this miracle of efficiency by being a completely different kind of computer. It has no separation between memory and processing; computation is the memory, integrated at the synaptic level. It is a massively parallel, low-power system that thrives on sparse, event-driven communication.

This vast disparity proves that while our models are potent, our paradigm is profoundly inefficient. It suggests that contemporary @ann:pl, and the hardware they run on, are missing or disastrously oversimplifying the fundamental principles that make biological intelligence so scalable and robust.

The path forward must therefore be one of biological inspiration, not just in theory but in practice. The next generation of @ai must mimic the brain's architectural and computational strategies more closely, and our hardware must be rebuilt to bake these computations in directly.

In this thesis, we explore new approaches that, first and foremost, might solve the critical limitations of scalability and energy efficiency in artificial intelligence. But more hopefully, they may lay the foundation for systems that can move beyond statistical mimicry and unlock a more robust, generalizable, and truly cognitive AGI.

This likely requires moving beyond the current mainstream of dense, synchronous ANNs. We will explore the potential of incorporating more sophisticated biological principles into @ai design. This involves investigating alternative computational paradigms inspired by the brain's own solutions: mechanisms such as the sparse, event-driven processing seen in Spiking Neural Networks @snn; the crucial role of temporal dynamics in neural coding; or the potential computational advantages of systems operating near critical states.

The central challenge, and the focus of this work, lies in identifying and abstracting the truly essential biological mechanisms—distinguishing the core principles of computation from the intricate biological details that may not be necessary for an artificial implementation. Concretely, this thesis aims to
]

#box-text()[
  - Explore how information-flow based on sparse events might be implemented in a network
  - Explore learning algorithms suitable for such a network
]

#serif-text()[
In the succeeding sections I will try to lay the foundations for neuromorphic engineering starting with background material covering early neroscience and developments of artificial neural networks based on simple models of the brain. In the neuroscience section we review modern neruscience literature and use concepts from that in the methodology section. 
]

#pagebreak()

= Background <background>


#serif-text()[
The success of modern artificial intelligence is shadowed by an unsustainable efficiency crisis. This power wall is not an accident, but the direct consequence of a decades-long divergence between mainstream @ai and its original biological inspiration. To fully understand the solution proposed in this thesis—neuromorphic computing—we must first trace this history. This chapter tells the story of the two "schools of @ai that emerged from a single, shared ancestor.

We will begin at that shared origin point, a time when computer science and neuroscience were one and the same. We will then follow the "mainstream" path of deep learning to understand why it is so powerful but also how it became so inefficient. Finally, we will explore the "neuromorphic path," the modern neuroscience it is built upon, and the specific, unsolved challenges that this thesis confronts. We begin at the very beginning: the first formal attempt to mathematically model a biological neuron.
]

#v(2em)
== Early Computational Neuroscience

#serif-text()[
Before any computational model could be built, a fundamental biological question had to be answered: what is the brain made of? For centuries, the dominant theory was "reticular theory," which held that the brain was a single, continuous, fused network of tissue (a reticulum). This was definitively overturned by the meticulous work of Spanish neuroscientist Santiago Ramón y Cajal. Using novel staining techniques, he established the "neuron doctrine" at the turn of the 20th century, proving that the brain was composed of discrete, individual cells—the neurons—which acted as the fundamental units of the nervous system.

This insight paved the way for the first true marriage of neuroscience and computation. In 1943, neurophysiologist Warren McCulloch and logician Walter Pitts published their seminal paper, "A Logical Calculus of the Ideas Immanent in Nervous Activity." They proposed the McCulloch-Pitts (M-P) neuron, the first mathematical model of a biological neuron.

Their model was a radical simplification, but its genius was in that simplicity. It abstracted the neuron into a binary decision device:

#box-text()[
- It receives multiple binary inputs (either '1' for excitatory or '-1' for inhibitory).
- It sums these inputs.
- If the sum exceeds a fixed threshold, the neuron outputs a '1' (it "fires").
- If the sum does not meet the threshold, it outputs a '0' (it remains "silent").
]

By combining these simple units, McCulloch and Pitts demonstrated that they could construct any logical operation (AND, OR, NOT). This was a profound revelation: the brain's fundamental components could be modeled as simple logic gates. The M-P neuron was the common ancestor of both artificial intelligence and computational neuroscience. However, the M-P neuron was static; its connections were fixed. The next critical question was learning. In 1949, psychologist Donald Hebb provided the theoretical answer in his book The Organization of Behavior. He proposed a mechanism for how learning could occur in the brain, now famously summarized as "Hebb's Rule" or "Hebbian learning."

The principle states:
]
#box-text()[
"When an axon of cell A is near enough to excite a cell B and repeatedly or persistently takes part in firing it, some growth process or metabolic change takes place in one or both cells such that A's efficiency, as one of the cells firing B, is increased." @Placeholder
]

#serif-text()[
In simpler terms: neurons that fire together, wire together. This was a local and decentralized learning rule. A synapse didn't need a "teacher" or a global error signal; it only needed to know if it successfully contributed to its post-synaptic neuron's firing. At this midpoint in the 20th century, the fields of artificial intelligence and neuroscience were one and the same. The pioneers were neuroscientists, logicians, and psychologists all working on a single problem: reverse-engineering the brain to understand, and eventually replicate, intelligence.
]

#v(1em)
=== The Perceptron

#box(width: 48%)[#serif-text()[
In 1957, psychologist Frank Rosenblatt took these theoretical ideas and created the first practical, engineered neural network: The Perceptron. It was a direct hardware implementation (the "Mark I Perceptron") of the McCulloch-Pitts neuron, but with one crucial addition: a trainable learning rule based on Hebb's ideas. Rosenblatt's key contribution was the perceptron learning rule, an algorithm that could automatically adjust the weights to learn. The machine was shown a pattern (e.g., a letter) and it would guess a classification. If the guess was wrong, the algorithm would slightly increase the weights of connections that should have fired and decrease the weights of those that fired incorrectly. The Perceptron was capable of classifying linearly separable patterns, and
]]
#h(2%)
#box(width: 48%, height: 8cm)[
#figure(include("figures/perceptron.typ"),caption:[The perceptron---a simple model of how a neuron operates. Inputs $x_i$ get multiplied by weights $w_i$ and summed. If the sum $∑ w_i x_i$ surpasses a threshold (or "bias" $b$), the neuron fires.
])]
#serif-text()[
its creation sparked immense optimism. It was hailed as the first "thinking machine." However, this excitement was brought to an abrupt halt. In 1969, @ai pioneers Marvin Minsky and Seymour Papert published their book Perceptrons, a rigorous mathematical analysis of the model's limitations. Their most famous critique was the "XOR problem." They proved that a single-layer perceptron could learn simple logic functions like AND or OR, but it was fundamentally incapable of learning the @xor function. The problem is that the "true" and "false" cases for XOR cannot be separated by a single straight line, and a single perceptron is only capable of drawing a single line.

This critique was devastating. It demonstrated that this simple model was a dead end for solving more complex, real-world problems. The book's impact led to a near-total collapse in neural network funding, an era now known as the "First @ai Winter."

This failure, however, created the very problem that the next generation of @ai researchers had to solve, and it marks the beginning of the great divergence. Minsky and Papert themselves noted that a @mlp, stacking multiple layers of these units—could theoretically solve the XOR problem by creating more complex decision boundaries. The challenge was that no one knew how to train it. Rosenblatt's rule only worked for a single layer.

The critical breakthrough that solved this problem was the independent development and subsequent popularization of the backpropagation algorithm in the 1970s and 1980s. Backpropagation provided an efficient method to calculate the gradient of the error function with respect to all of the network's weights, even in deep layers, allowing for effective training.

This combination—multiple layers of interconnected units @mlp:pl trained via backpropagation—defines the architecture that became the foundation for the deep learning revolution. The neural networks of today, from the @cnn that process images to the Transformers (like GPT) that handle language, all descend from this "mainstream" path. They are all, at their core, vast, multi-layer networks of simple perceptron-like units, trained with a variation of backpropagation.
]

#serif-text()[
above a threshold it will fire and pass the signal downstream to another reciving neuron. Which is conceptually similar to how real neurons operate. This simple model is called a perceptron, which introduced a learning rule for a single computational neuron capable of classifying linearly separable patterns. However, to the MLP was the understanding that stacking multiple layers of these perceptron-like units could overcome these limitations by creating more complex decision boundaries. The critical breakthrough enabling the practical use of MLPs was the independent development and subsequent popularization of the backpropagation algorithm. Backpropagation provided an efficient method to calculate the gradient of the error function with respect to the network's weights, allowing for effective training of these deeper, multi-layered architectures. This combination---multiple layers of interconnected units
typically using non-linear activation functions, trained via backpropagation---defines the MLP, which became a foundational architecture for neural networks and paved the way for the deep learning revolution. GPT, alphafold, etc. all use these fundamentals with differetn variations of architechtures which boils down to how many layers how large layers how dense layers and how they should be connected (attention, RNN, CNN, resnet )
]

#v(2em)
== The Deep Learning Path

#serif-text()[
This section explains how mainstream @ai solved the Perceptron's problem by abandoning biological realism, The Solution: Backpropagation (1980s): Introduce backpropagation as a powerful, mathematical solution for training multi-layer perceptrons. The Divergence: This is your key argument. Explicitly state why backpropagation is not biologically plausible: Non-local learning: A neuron at the beginning of the network needs an "error signal" from the very end. The brain doesn't do this. Weight Transport Problem: It requires the exact same connection weights to be used for the forward pass (signal) and the backward pass (error), which is not how synapses work. The Result: This path led to modern Deep Learning (ANNs, CNNs, Transformers) on GPUs. The Problem (Revisited): This is where you circle back to your intro. This "engineering" path works, but it led us back to the power and efficiency crisis (von Neumann bottleneck, megawatt models) that you mentioned in Chapter 1.

The term Artificial Intelligence forms an umbrella over many different techniques that make use of machines to do some intelligent task. The most promising way to achieve @ai today is through deep neural networks. The neural networks of today are almost exclusively based on the simple perceptron neuron model. It is a fairly old idea based on a simple model of how the brain processes information. The model of the neuron that it is based on has "synapses" just like the biological one. The synapses function as inputs, each with a "weight" (strength). When inputs are active, they excite the receiving neuron more or less depending on the strength of this connection
]


#v(1em)
=== Problems With Mainstream Deep Learning

#serif-text()[
It was mentioned in the introduction that the deep learning technique is ineficient compared to the brain. The reason why is not clear, from a hardware standpoint the brain simply has better hardware much more connections per area and the computation is baked into the hardware. From an algorithmic standpoint there may also be room for imporovement, In order to compute with deep learning and perceptron networks we need to compute all the entries even tho they might not contribute or are zero. Take an image for example, the human visual system is really good at ignoring unimportant details and we only have a tiny area of focus. even then we dont porcess much unless something interesting happens like movement. In deep learning we have to process the entire image. The status quo needs global synchronization, every previous layer need to finish computing before the next can start, this can be hard to scale for large systems where multiple proccesors need to talk to eachother. The same applies to backpropagation it requires freezing the entire network and separates computation and learning into two separate stages, local connectetions that should be independent of eachother have to wait extreme quantization models (1bit) also highlight the ineficiency
]

#v(2em)
== Birth Of Neuromorphic Computing

#serif-text()[
While one branch of @ai was abstracting the neuron into a mathematical function to be simulated on digital sequential processors (the von Neumann architecture), Caltech's Carver Mead saw a fundamental inefficiency. He observed that the digital simulation of neural processes was incredibly power-hungry, whereas the brain itself runs complex computations on just a few watts.

In the 1980s, Mead proposed neuromorphic engineering. The core idea was not to simulate the logic of a neuron, but to emulate its physics. He championed using VLSI (Very-Large-Scale Integration) analog circuits to build artificial neurons and synapses directly in silicon.

His key insight was to operate transistors in their "sub-threshold" regime—an analog, low-power state where their behavior (the relationship between current and voltage) is governed by the same exponential physics that dictates the flow of ions through a neuron's membrane.

This approach offered several revolutionary advantages:
Co-location of Memory and Processing: In a von Neumann computer, data is constantly shuttled between the CPU and memory (the "von Neumann bottleneck"). In Mead's silicon neurons, the "memory" (the synaptic weight) is physically part of the same circuit as the "processor" (the neuron body), just as it is in the brain.
Massive Parallelism: Each silicon neuron and synapse operates in parallel, just like their biological counterparts.
Power Efficiency: By emulating the analog physics directly, these circuits could be thousands or even millions of times more power-efficient than a digital simulation of the same process. Event-Driven: Like real neurons, these circuits were designed to be event-driven, meaning they only consume power when a spike (an electrical pulse) actually occurs.

Mead's early work, like the silicon retina, proved the concept. It was a chip that didn't just capture pixels, but processed visual information (like edge detection and motion) directly on the sensor in an analog, brain-inspired way. This marked the birth of a field dedicated to building hardware that is the network, rather than hardware that just runs a simulation of one.
]

#v(2em)
== Modern Neuroscience

#serif-text()[
Section intro ...
]

#v(1em)
=== Neuron Models And Dynamics
#serif-text()[
The artificial neurons used in most deep learning models (like ReLU or sigmoid units) are static. They compute a weighted sum of their inputs, apply an activation function, and output a single, continuous value (like 0.83 or 5.2). This value is assumed to represent the neuron's firing rate. Biological neurons don't work this way. They are spiking neurons, and their computation is:
]
#box-text()[
- Temporal: They integrate inputs over time. A neuron's internal state (its membrane potential) rises and falls based on when inputs arrive.
- Event-Driven: They do not communicate with continuous values. They communicate using discrete, all-or-nothing electrical pulses called action potentials, or "spikes." A neuron only fires a spike when its internal potential crosses a specific threshold. 
- Efficient: Because they are event-driven, they are sparse. A neuron spends most of its time silent, only consuming energy when it receives or sends a spike.
]
#serif-text()[
In this model, information is not just in how many spikes there are (a rate code), but when they occur (a temporal code). A spike arriving a few milliseconds earlier or later can completely change the computational outcome.
]
#figure(include("figures/neurondynamics.typ"),caption:[Neuron dynamics])
#serif-text()[
Write about dynamical models and hoph bifucations, write about modes of firing depending on bifurcations ...
]

#serif-text()[
The biological neuron is the fundamental building block of the brain. The biological neuron consists of a cell body also called the soma, which contains all of the core machinery that other cells have, like the nucleus and mitochondria. However, it also has distinct structures:
#box-text()[
- Dendrites: A branching "input" tree that receives signals from other neurons.
- Axon: A long "output" cable (which can be over a meter long in humans) that transmits the neuron's own signal.
- Synapses: The junctions where an axon's terminal meets another neuron's dendrite to pass the signal.
]

When pre-synaptic neurons fire, they release neurotransmitters (like glutamate or dopamine) across the synapse. These chemicals open ion channels on the post-synaptic neuron, causing its internal electrical potential (the "membrane potential") to increase. If this potential, which is integrated over time, reaches a critical threshold, the neuron itself fires an action potential (a spike) down its axon.

Although the perceptron captures the basic idea of "integrating inputs to make a decision," a lot is left on the table. A lot of progress and new ideas have surfaced since its invention. The neuron, once thought to be a simple switch, turns out to be a complex computational device.

This forces us to rethink everything:
- Information Encoding: How is information represented? Is it in the rate of spikes, the precise timing of the first spike, or in correlations between patterns of spikes? This is a key research topic not explored by older models.
- Learning Rules: How does the brain learn? It is entirely different from what deep learning uses. The brain's learning is local (like STDP) and continuous.
- Network Architecture: The brain isn't a simple feed-forward stack of layers. It is a deeply recurrent, complex, and fully asynchronous graph where signals propagate at their own speed.

A lot of work has been put into modeling the neuron. The most biologically realistic models, like the Hodgkin-Huxley model, are incredibly complex and computationally expensive, simulating the precise dynamics of multiple ion channels.

For most neuromorphic computing, a balance is struck with simpler, more efficient models. The most popular are the Leaky Integrate-and-Fire (LIF) models.
- Integrate: The model's potential rises as it receives input spikes (summing their weights).
- Leaky: The potential "leaks" away over time, modeling the neuron's tendency to return to its resting state.
- Fire: If the potential crosses the threshold, it fires a spike and its potential is reset.

The Generalized Leaky Integrate-and-Fire (GLIF) and other variants (like the Izhikevich model) are the best models we have today for large-scale, efficient simulation. They add more biological realism (like adaptation, where a neuron's firing rate slows over time) without the extreme computational cost of full biophysical models.
]

#v(1em)
=== Encoding Mystery
#serif-text()[
It is observed that neurons fire in short bursts called spikes. Experiments show that neurons fire repetably. A sequence of spikes is called a spike train, and exactly how information is encoded in a spike train is a topic of hot debate in neuroscience. A popular idea is that information is encoded in the average value of spikes per time called rate encoding. Temporal encoding the brain most likely uses a combination of all. The time to first spike encoding could be understood like this it is not about the absolute timing of the neurons rather a race of which spikes come first. the first connections would exite the post-synaptic neurons first and they should inhibit the others (lateral inhibition)
]

#v(1em)
=== Biological Learning
#serif-text()[
This different model of computation requires a different model of learning. Deep learning's backpropagation is a "global" algorithm. To update a synapse in the first layer, you need an error signal calculated at the very last layer and propagated all the way back. This is highly effective but biologically implausible; there is no known mechanism for such a precise, "backward" error signal in the brain.

Instead, the brain appears to use local learning rules. The most famous is Hebb's rule: "Neurons that fire together, wire together."

A modern, measurable version of this principle is Spike-Timing-Dependent Plasticity (STDP). STDP is a learning rule that adjusts the strength (the "weight") of a synapse based purely on the relative timing of spikes between the pre-synaptic neuron (the sender) and the post-synaptic neuron (the receiver). 

The rule is simple and local:
- LTP (Long-Term Potentiation): If the pre-synaptic neuron fires just before the post-synaptic neuron (meaning it likely contributed to the firing), the connection between them is strengthened.
- LTD (Long-Term Depression): If the pre-synaptic neuron fires just after the post-synaptic neuron (meaning it fired too late and did not contribute), the connection is weakened.

This mechanism allows the network to learn correlations, causal relationships, and temporal patterns directly from the stream of incoming spikes, without any "supervisor" or global error signal. It is the biological alternative to backpropagation and a cornerstone of modern neuromorphic learning.
]

#serif-text()[
- no evidence that brain does not use global error signal like backpropagation uses
- each neuron weight gets updated by a local rule
- spikes are discrete and does not have a gradient
While spiking neural networks offer greater biological plausibility and potential advantages in processing temporal information and energy efficiency, their adoption faces significant challenges, primarily stemming from the nature of their core computational element: the discrete spike.

A cornerstone of the success of modern deep learning, particularly with Multi-Layer Perceptrons (MLPs) and related architectures, is the backpropagation algorithm. Backpropagation relies fundamentally on the network's components being differentiable; specifically, the activation functions mapping a neuron's weighted input sum to its output must have a well-defined gradient. This allows the chain rule of calculus to efficiently compute how small changes in network weights affect the final output error, enabling effective gradient-based optimization (like Stochastic Gradient Descent and its variants). These techniques have proven exceptionally powerful for training deep networks on large datasets.

However, when we transition from the continuous-valued, rate-coded signals typical of MLPs to the binary, event-based spikes used in SNNs, this differentiability is lost. The spiking mechanism itself—where a neuron fires an all-or-none spike only when its internal state (e.g., membrane potential) crosses a threshold—is inherently discontinuous. Mathematically, this firing decision is often represented by a step function (like the Heaviside step function), whose derivative is zero almost everywhere and undefined (or infinite) at the threshold.

Consequently, standard backpropagation cannot be directly applied to SNNs. Gradients calculated using the chain rule become zero or undefined at the spiking neurons, preventing error signals from flowing backward through the network to update the weights effectively. This incompatibility represents a substantial obstacle, as it seemingly precludes the use of the highly successful and well-understood gradient-based optimization toolkit that underpins much of modern @ai.

Surrogate Gradients: A popular approach involves using a "surrogate" function during the backward pass of training. While the forward pass uses the discontinuous spike generation, the backward pass replaces the step function's derivative with a smooth, differentiable approximation (e.g., a fast sigmoid or a clipped linear function). This allows backpropagation-like algorithms (often termed "spatio-temporal backpropagation" or similar) to estimate gradients and train deep SNNs, albeit with approximations.
]

#v(1em)
=== Neural Network

#serif-text()[
However, this abstraction, while powerful, significantly simplifies the underlying neurobiology. Decades of rigorous neuroscience research reveal that brain function emerges from complex electro-chemical and molecular dynamics far richer than the simple weighted sum and static activation. While it's crucial to discern which biological details are fundamental to computation versus those that are merely implementation specifics
moving beyond the standard MLP model is necessary to capture more sophisticated aspects of neural processing.

A primary departure lies in the nature of neural communication. Unlike the continuous-valued activations typically passed between layers in an MLP (often interpreted as representing average firing rates), biological neurons communicate primarily through discrete, stereotyped, all-or-none electrical events known as action potentials, or 'spikes'. Information in the brain is encoded not just in the rate of these spikes (rate coding), but critically also in their precise timing, relative delays, and synchronous firing across populations (temporal coding) (Gerstner et al., 2014). For instance, the relative timing of spikes arriving at a neuron can determine its response, allowing the brain to process temporal patterns with high fidelity – a capability less naturally captured by standard MLPs. Spikes can thus be seen as event-based signals carrying rich temporal information.

Furthermore, neural systems exhibit complex dynamics beyond simple feedforward processing. Evidence suggests that cortical networks may operate near a critical state, balanced at the 'edge of chaos,' a regime potentially optimal for information transmission, storage capacity, and computational power. Systems like the visual cortex demonstrate this complexity, where intricate patterns of spatio-temporal spiking activity underlie feature detection, object recognition, and dynamic processing. These biologically observed principles---event-based communication, temporal coding, and complex network dynamics---motivate the exploration of Spiking Neural Networks (SNNs), which explicitly model individual spike events and their timing, offering a potentially more powerful and biologically plausible framework for computation than traditional MLPs. This path (Neuromorphic) is the one that directly addresses the efficiency problem by using event-driven, spiking, and local learning rules, just like the brain.
]

#v(2em)
== Neuromorphic State Of The Art\ & Research Gaps

#serif-text()[
Disentangling core computational mechanisms from biological implementation details is a major ongoing challenge in neuroscience and neuromorphic engineering. Some complex molecular processes might be essential for learning or adaptation, while others might primarily serve metabolic or structural roles not directly involved in the instantaneous computation being modeled.
]

#serif-text()[
The principles of neuromorphic computing, born from Carver Mead's vision and informed by modern neuroscience, have matured from theoretical concepts into a vibrant field of applied research. This progress is best seen in two key areas: the development of specialized, brain-inspired hardware and the creation of sophisticated software frameworks for simulating and deploying spiking neural networks (SNNs).
#v(1em)
=== Neuromorphic Hardware
The primary goal of neuromorphic hardware is to escape the von Neumann bottleneck and emulate the power efficiency and massive parallelism of the brain. Two landmark systems define the state of the art:

IBM TrueNorth: A prominent early example, TrueNorth is a fully digital, real-time, event-driven chip. It consists of 4,096 "neurosynaptic cores," collectively housing one million digital neurons and 256 million synapses. Its architecture is explicitly non-von Neumann; processing and memory are tightly integrated within each core. TrueNorth's key achievement is its staggering power efficiency: it can perform complex SNN inference tasks (like real-time video object detection) while consuming only tens of milliwatts—orders of magnitude less than a CPU or GPU performing a similar task. However, its architecture is largely fixed, making it a powerful "inference engine" but less flexible for researching novel, on-chip learning rules.

Intel Loihi (and Loihi 2): Intel's line of neuromorphic research chips, starting with Loihi in 2017, represents a significant step towards flexible, on-chip learning. Like TrueNorth, Loihi is an asynchronous, event-driven digital chip, but with a key difference: it features programmable "learning engines" within each of its 128 neuromorphic cores. This allows researchers to implement and test dynamic learning rules, such as STDP and its variants, directly on the hardware in real-time. The second generation, Loihi 2, further refines this with greater scalability, improved performance, and more advanced, programmable neuron models, positioning it as a leading platform for cutting-edge neuromorphic algorithm research. 

#v(1em)
=== Simulation and Software Frameworks
Before algorithms can be deployed on specialized hardware, they must be designed, tested, and validated. This is the role of SNN simulators, which function as the "TensorFlow" or "PyTorch" of the neuromorphic world.

Brian: A highly flexible and popular SNN simulator used extensively in the computational neuroscience community. Its strength lies in its intuitive syntax, which allows researchers to define neuron models and network rules directly as a set of mathematical equations (e.g., the differential equations of a Leaky Integrate-and-Fire neuron). This makes it an ideal tool for exploring the detailed dynamics of biologically realistic models.

Nengo: A powerful, high-level framework that functions as a "neural compiler." Nengo is built on a strong theoretical foundation (the Neural Engineering Framework) that allows users to define complex computations and dynamical systems in high-level Python code. Nengo then "compiles" this functional description into an equivalent SNN. Its key advantage is its backend-agnostic nature; the same Nengo-defined network can be run on a standard CPU, a GPU, or deployed directly to neuromorphic hardware like Intel's Loihi.

#v(1em)
=== The Research Gap: The Learning Problem
Despite this immense progress in hardware and software, a fundamental challenge remains, creating a critical research gap: the training problem.

Mainstream deep learning has a powerful, universal tool: backpropagation. Neuromorphic computing does not yet have a clear equivalent. While these systems exist, they still struggle with finding an efficient, scalable, and powerful learning algorithm that is both biologically plausible and computationally effective.

This gap manifests in several ways:
1.  Limited Supervised Learning: "Local" rules like STDP are fundamentally unsupervised. They are excellent for finding patterns and correlations but struggle with complex, task-driven "supervised" problems (e.g., "classify this audio signal into one of ten specific words").
2.  The "Conversion" Compromise: A popular workaround is to first train a conventional, non-spiking ANN using backpropagation, and then "convert" its weights to an SNN for efficient inference. This method, while practical, is a compromise. It discards the rich temporal dynamics SNNs are capable of and does not represent true "neuromorphic learning."
3.  The "Surrogate Gradient" Challenge: The "firing" of a spiking neuron is a non-differentiable event, which makes it incompatible with standard backpropagation. New methods, like "surrogate gradient" learning, attempt to approximate this spike event with a smooth function to enable gradient-based learning, but this is an area of intense and ongoing research.

This thesis confronts this central challenge: How to effectively and efficiently train spiking neural networks for complex, real-world temporal tasks. While hardware like Loihi provides the platform for on-chip learning, it still requires a robust and scalable algorithm. The existing approaches of ANN-to-SNN conversion or simple Hebbian rules are insufficient.

This thesis proposes a method to bridge this gap by... (...for example: "...developing a novel, event-driven surrogate gradient algorithm capable of training deep SNNs directly in the temporal domain," or "...introducing a hybrid learning rule that combines the efficiency of STDP with the task-driven power of error-based feedback," or "...proposing a new architecture for temporal credit assignment that is both hardware-friendly and scalable.")
]

#pagebreak()

= Proposed Neuromorphic Framework <theory>

#serif-text()[
(e.g., "A Novel Framework for On-Chip Synaptic Plasticity") This chapter is your first contribution. It's where you present your new idea. Derivation: Start from first principles. Walk the reader through the math, the logic, or the formal model you developed. The Model: Formally present your new algorithm, equation, or architecture. This is the "pure" theoretical part. Hypotheses: End the chapter by explicitly stating the hypotheses your theory predicts. Example: "Based on this framework, it is hypothesized that an SNN implementing this rule (1) will be able to learn the N-MNIST dataset... (2) will do so with a lower average spike rate than a baseline model... and (3) will be robust to synaptic noise..."
By doing this, you've already "banked" a major contribution before you even show a single graph.
]

#v(2em)
== Neurons And Encoding
#serif-text()[
A neuron should have the following charecteristcs
]
#box-text()[
  - Acuumulate spikes in some form (integrate)
  - Fire when some treshold has been reached
  - Leak the potential over time
]
#serif-text()[
A neural code should
]
#box-text()[
  - be fast
  - be effecient in terms of neurons used
  - able to encode a wide range of stimuli
  - robust to noise
]

#serif-text()[
Problem of phase for temporal encodings
For rate coding phase is a non issue as we can find the instantanious firing rate at any phase, for time to first spike encoding we need a reference signal. If the reference signal starts at time t0 we have started the phase and if the pattern does not match up with the reference signal we could miss it. Evidence suggests that brain waves could play the role of a global reference signal. This is the fundamental trade off between the two.

A learning scheme where inputs have to occur in the same episode repeatedly two inputs that happen at the same time yields a stronger response. If the pattern is random then they would sometimes occur in the same episode and sometimes not. Two strong responses should occur in the same time frame. 

If the post neuron fires then we should strengthen the weights

#figure(
  include("figures/spiketrain.typ"),
  caption: [Proposed simplifed layout of a SNN. The neurons are connected with hirearcical busses
  that allow for the network to be configured as a _small world network_]
)

Footnote digression for longer patterns
Longer patterns require a latched state such as neurons entering repeated firing like a state machine

An important point is to declare whether a mechanism is bio plausible. An engineer might not care wether or not a mechanism is used by the brain and is crucial to the brains function. An engineer might only care about if the mechanics works and is effective for the system that is created in the engineers vision. An engineer might just use the brain as an inspiration. Evolution althoug achieved remarkable feats is not guaranteed to foster up the most optimal solution, only good enough to survive to the next generation. However discussing wether or not a mechanism is bio plausible is still useful for understanding our own brain. And creating bio plausible artificial systems can contribute to more than one field.

Some neurons have other properties like bursting modes or continuous firing once the threshold has been reached.

Inhibition should make a neuron not fire

$ T = sum w/t $

In a time to first spike scheme of we care about the order (the relative values since information is stored in time and order) we have to use weights and a neuron model that distinguish between inputs arriving earlier than others. I present a scheme where the first neuron that arrives starts a linear count where the slope of the counter is the weight additional inputs will increase or decrease the slope according to their weight. We can see that neurons arriving earlier will get more time to increase the counter and thus will carry a higher value. If the counter reaches a threshold the neuron will fire. The astute will notice that in this scheme the neuron will fire even for the smallest stimulus since the counter will count up a non zero value and eventually reach the threshold, to mitigate this we can simply say that if the counter is too slow the neuron will not fire we will see later that this scheme satisfies the criteria above.

The problem with this decoding is for strong stimuli we would ideally make the neuron respond immediately and fire, but it has to wait until the counter has reached the threshold to fix this we can also add the weight of the input directly to the potential while also starting a counter. Now if early strong inputs arrive they will fill up the potential and make the neuron fire almost immediately. Small inputs wil take some time 
]

#figure(
  include("figures/neuronmodel.typ"),
  caption: [Proposed simplifed layout of a SNN. The neurons are connected with hirearcical busses
  that allow for the network to be configured as a _small world network_]
)


#serif-text()[
Leaky integrate and fire models seem the best bet, however complex dynamics like exponential decay and analog weights and potentials seem excessive, we might do without. Binary weights 1 for excitatory and and 0 for inhibitory. Stronger weights can be modeled with multiple parallel synapses
]

#serif-text()[
Another way which is also based on relative firing order of single spikes could be a passcode encoding. Such an encoding could work by having neurons only react to a sequence. It has an internal state machine of sorts and will only advance to the next state if recives the correct input in the correct order. This encoding does only care about relative order not relative timings.
]

#v(2em)
== Learning

#serif-text()[
learning with binary weights
learning with more steps of quantized or continous weights
Say we want to detect the pattern ABC and the pattern ABD. First of all if the order does not matter set all the weights equal. If the order does matter the weights determine the order. Now if a neuron learns pattern ABC so well that it learns to fire on only AB then it can fire faster. However if a second neuron wants to learn ABD then inhibition from the AB neuron prohibits it. A solution can be that if a neuron originally learned ABC but now fires on AB but stil has a strong weight on C it should remember this and if it fires on AB but then C does not arrive it should be like "oh, C did not show maybe I am wrong to fire early" eg. Decrease weights for A and B
It predicts!

A second way is to have a hierarchy with bypass. So one layer detects only AB then the next layer has bypass of the first layer and the second combining AB and C or D

A second problem is how to decode order. When do we start the decreasing timer, how fast, should it be in time or in amount of spikes, what to do with phase? The phase should correct itself. The weights need to be as presise as the timing of the spikes? Or we could make the neuron sensitivity proportional to its inverse potential and add leaking
]

#v(2em)
== Network

#figure(
  include("figures/architecture.typ"),
  caption: [Proposed simplifed layout of a SNN. The neurons are connected with hirearcical busses
  that allow for the network to be configured as a _small world network_]
)

#pagebreak()

= Proof of Concept Method <method>

#figure(
caption: [Unsupervised local learning rule for induvidual neurons. Based on STDP],
supplement: [Algorithm],
mono-text(pseudocode-list(hooks:.5em, indentation:1em, booktabs:true)[
+ start with a collection of neurons with arbitrary connections #h(1fr)
+ *if* a pre-synaptic neuron fires *then*
  + it has a chance to grow a synapse to a random post-synaptic neuron 
+ *if* a post-synaptic neuron fires *then*
  + strengthen all connections to pre-synaptic neruons that fired before
  + remove connections to pre-synaptic neurons that did not fire or fired after
- 🛈  a neuron can be both pre-synaptic and post-synaptic
]))

#figure(
caption: [Growing rules for synapses],
supplement: [Algorithm],
mono-text(pseudocode-list(hooks:.5em, indentation:1em, booktabs:true)[
+ probability of growing a synapse is inversely\ proportional to the amount it already has #h(1fr)
+ earlier firings should get a better chance to grow synapses,\ although this is regulated by
  inhibitory action
]))


#v(2em)
== Simulator

#pagebreak()

= Results <results>

#serif-text()[
#lorem(180)

#lorem(180)

#lorem(180)
]

#pagebreak()

= Discussion <discussion>

#serif-text()[
#lorem(180)

#lorem(180)

#lorem(180)
]

#pagebreak()

= Conclusion <conclusion>

#serif-text()[
#lorem(180)

#lorem(180)

#lorem(180)
]

#pagebreak()

#set text(weight: "medium")
#bibliography("references.bib")

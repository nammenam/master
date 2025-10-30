#import "@preview/lovelace:0.3.0": pseudocode-list

// CONFIG
#set text(font: "Geist", size: 10pt)
#show math.equation : set text(font:"TeX Gyre Schola Math", size: 10.5pt)
#show raw : set text(font:"GeistMono NF", weight: "medium", size:9pt)
#set list(marker: sym.square.filled.small, indent: 1em)
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

#set heading(numbering: "1.1 \u{00B7}")

#let serif-text(body) = {
  set text(font: "Source Serif 4 18pt", size: 11pt)
  body
}

#let mono-text(body) = {
  set text(font: "GeistMono NF", size: 9pt, weight: "medium")
  body
}

// FRONTPAGE
#import "uiomasterfp/frontpage.typ": cover
#import "uiomasterfp/frontpage.typ": colors
#cover()

// ABSTRACT, ACKNOWLEDGEMENTS AND OUTLINE
#set page(fill:none, margin:auto, numbering: "1")
#set par(justify: true)
#counter(page).update(1)

#v(2cm)
#align(center ,[
// #place(top + left, dx: -2cm, rect(width: 120%, height: 9.27cm, fill: colors.gray.light))
#block(width:90%, inset: 2em, [
#align(left)[
#text(weight:"semibold",size:16pt,[ABSTRACT])

#serif-text()[
#lorem(200)
]]])])

#v(3cm)
#align(center,[
#block(width:100%,[
#align(left)[
#text(weight:"semibold",size:16pt,[ACKNOWLEDGEMENTS])

#serif-text()[
#lorem(80)
]]])])
#pagebreak()

#{
  set text(font: "Geist", weight: "medium", size: 10pt)
  outline(depth:3, indent: auto)
}
#pagebreak()

= Introduction <intro>


#serif-text()[
The "Hook": Start broad. The AI revolution, its impact.
The "Problem" (The Motivation): Introduce the core limitations of current AI (deep learning, ANNs). This is your "why deep learning is not optimal" part 1. Focus on power, efficiency, and the von Neumann bottleneck.
The "Solution Concept": Introduce the brain as the "gold standard" of efficient computation.
The "Specific Field": Introduce neuromorphic computing as the field attempting to learn from this "gold standard."
The "Gap": State what is specifically missing in the field of neuromorphic computing that your thesis will solve. (e.g., "While hardware like Loihi exists, efficient on-chip learning algorithms remain a challenge...")
Thesis Statement / Research Questions: A clear, 1-2 sentence statement. "This thesis designs and evaluates a novel spike-timing-dependent learning rule for..." followed by 3-4 specific research questions.
Thesis Roadmap: "Chapter 2 reviews... Chapter 3 details... etc."
 
Making machines more capable and intelligent is an ongoing perpetual struggle The concept of intelligence, how it arises and what needs to be in place for it to occur, is probably been some of the longest standing questions in human history. How and if it can be reproduced artificially is a particuarly hot topic today. Getting answers to these questions will not only help us understand our own minds but also brings the promise of unlocking new technology discovering new drugs or materials, it may be the last invention humans ever need to make. In recent years we have crept ever closer to answer some of these questions. New state of the art artificial inteligence systems have achieved remarkable success like the sophisticated language capabilities of GPT models and the protein-folding predictions of AlphaFold.

Despite these triumphs, a significant gap persists between artificial systems and their biological counterparts. Evidently, these AI systems might posses superhuman capabilities in one or a few domains but none of them surpass humans in all, what we call Artificial General Inteligence (AGI). Also more relevant to this thesis is that current state-of-the-art ANNs, require vast amount of data, computatuon and energy resources. This demand stands in stark contrast to the biological brain---an extraordinarily complex and efficient organ estimated to operate on merely 20-30 Watts while also sitting comfortably in the AGI category. This profound difference in efficiency and capability suggests that contemporary ANN paradigms, might be missing or oversimplifying fundamental principles crucial for truly intelligent and scalable computation.

#lorem(180)

#lorem(180)

#lorem(100)

In this thesis we explore new approaches that first and foremost might solve the critical limitations of scalability and energy efficiency in artificial intelligence. But also hopefully lay the foundation for systems that might eventually unlock true AGI. This likely requires moving beyond current mainstream ANN architectures. We will explore the potential of incorporating more sophisticated biological principles into AI design. This involves investigating alternative computational paradigms, inspired by mechanisms such as sparse, event-driven processing observed in Spiking Neural Networks (SNNs), the role of temporal dynamics in neural coding, or the potential computational advantages of systems operating near critical states. The central challenge lies in identifying and abstracting the truly essential biological mechanisms for intelligence and efficiency, distinguishing core principles from intricate biological details that may not be necessary for artificial implementation. Concretly this thesis wants to
]

#block(stroke:(thickness:0pt, paint:luma(0)), inset: 10pt, radius: 0pt, fill: colors.gray.light,
  width: 100%, [#text(weight:"semibold",[
  - Explore how information-flow based on sparse events might be implemented in a network
  - Explore learning algorithms suitable for such a network
  ])]
)

#serif-text()[
In the succeeding sections I will try to lay the foundations for neuromorphic engineering starting with background material covering early neroscience and developments of artificial neural networks based on simple models of the brain. In the neuroscience section we review modern neruscience literature and use concepts from that in the methodology section. 
]

#pagebreak()

= Background <background>


#serif-text()[
In this section we will dive further into the background, cronological development interleaved with neuroscience
]

#v(2em)
== Early Computational Neuroscience

#serif-text()[
This is where you put your 1950s neuroscience. You establish the original ideas that both fields grew from. The Biological Neuron: Start with the basic "neuron doctrine" (Ramón y Cajal). The First Model (1943): Introduce the McCulloch-Pitts neuron. Explain it as the first attempt to mathematically model the neuron as a simple logic gate (sum inputs -> check threshold -> fire 1 or 0).   The First Learning Rule (1949): Introduce Hebb's Rule ("neurons that fire together, wire together"). Explain this is a local, decentralized learning rule. Chapter Conclusion: At this point, the fields of "AI" and "neuroscience" are one and the same.
]

#v(2em)
== The Perceptron (1957)

#serif-text()[
Now, you show the first engineering attempt to build a machine based on these ideas. Introduce Rosenblatt's Perceptron. Explain it as a direct hardware implementation of the McCulloch-Pitts neuron with a Hebbian-style learning rule. The "First Winter": Briefly explain its limitations (the "XOR problem" identified by Minsky & Papert). This is crucial because it creates the problem that the next generation of AI researchers had to solve.
]

#v(2em)
== The Engineering Path\ Mainstream Deep Learning

#serif-text()[
This section explains how mainstream AI solved the Perceptron's problem by abandoning biological realism, The Solution: Backpropagation (1980s): Introduce backpropagation as a powerful, mathematical solution for training multi-layer perceptrons. The Divergence: This is your key argument. Explicitly state why backpropagation is not biologically plausible: Non-local learning: A neuron at the beginning of the network needs an "error signal" from the very end. The brain doesn't do this. Weight Transport Problem: It requires the exact same connection weights to be used for the forward pass (signal) and the backward pass (error), which is not how synapses work. The Result: This path led to modern Deep Learning (ANNs, CNNs, Transformers) on GPUs. The Problem (Revisited): This is where you circle back to your intro. This "engineering" path works, but it led us back to the power and efficiency crisis (von Neumann bottleneck, megawatt models) that you mentioned in Chapter 1.
#lorem(92)
]

#box(
width: 49%,
serif-text()[
The term Aritifical Inteligence forms an umbrella over many different techniques that make use of machines to do some intelligent task. The most promising way to acheive AI to day is trough deep neural networks. The neural networks of today are almost exclusivly based on the simple perceptron neuron model. It is a fairly old idea based on a simple model on how the brain processes information. The model of the neuron that the is based on has synapses just like the biological one, the synapses functions as inputs which when firing will exite the reciving neuron more or less depending on the strenth of the connection. If the reciving neuron get exited
])
#h(2%)
#box( width: 48%, height: 7cm,
figure(
  include("figures/perceptron.typ"),
  caption: [
  The perceptron---a simple model of how a neuron operates. Inputs gets multiplied by weights and
  summed, if the sum surpasses a threshold known as the bias, the neuron fires.
  ]
))
#serif-text()[
above a threshold it will fire and pass the signal downstream to another reciving neuron. Which is conceptually similar to how real neurons operate. This simple model is called a perceptron, which introduced a learning rule for a single computational neuron capable of classifying linearly separable patterns. However, to the MLP was the understanding that stacking multiple layers of these perceptron-like units could overcome these limitations by creating more complex decision boundaries. The critical breakthrough enabling the practical use of MLPs was the independent development and subsequent popularization of the backpropagation algorithm. Backpropagation provided an efficient method to calculate the gradient of the error function with respect to the network's weights, allowing for effective training of these deeper, multi-layered architectures. This combination---multiple layers of interconnected units
#footnote[
  While often conceptualized in layers (e.g., layers of the neocortex), the brain's connectivity is vastly more complex than typical feedforward ANNs, featuring extensive recurrent connections, feedback loops, and long-range projections that make a simple 'unrolling' into discrete layers an oversimplification
],
typically using non-linear activation functions, trained via backpropagation---defines the MLP, which became a foundational architecture for neural networks and paved the way for the deep learning revolution. GPT, alphafold, etc. all use these fundamentals with differetn variations of architechtures which boils down to how many layers how large layers how dense layers and how they should be connected (attention, RNN, CNN, resnet )
]

#v(1em)
=== Problems With Mainstream Deep Learning

#serif-text()[
It was mentioned in the introduction that the deep learning technique is ineficient compared to the brain. The reason why is not clear, from a hardware standpoint the brain simply has better hardware much more connections per area and the computation is baked into the hardware. From an algorithmic standpoint there may also be room for imporovement, In order to compute with deep learning and perceptron networks we need to compute all the entries even tho they might not contribute or are zero. Take an image for example, the human visual system is really good at ignoring unimportant details and we only have a tiny area of focus. even then we dont porcess much unless something interesting happens like movement. In deep learning we have to process the entire image. The status quo needs global synchronization, every previous layer need to finish computing before the next can start, this can be hard to scale for large systems where multiple proccesors need to talk to eachother. The same applies to backpropagation it requires freezing the entire network and separates computation and learning into two separate stages, local connectetions that should be independent of eachother have to wait extreme quantization models (1bit) also highlight the ineficiency
]

#v(2em)
== Neuromorphic Computing

#serif-text()[
Now, you introduce your field as the "other path"—the one that stuck with the biology. **The "Father": Carver Mead (1980s): Explain that at the same time backpropagation was taking off, Carver Mead proposed a different path: instead of simulating simplified neurons on digital computers (like deep learning), we should emulate the analog physics of real neurons in silicon (VLSI).
]

#v(1em)
=== How the Brain Really Works

#serif-text()[
This is where you put the rest of your neuroscience. Spiking Neurons: Explain how they are different from the simple "0 or 1" model. They are temporal and event-driven. They communicate with spikes. Biological Learning: Introduce Spike-Timing-Dependent Plasticity (STDP). Frame this as the biological alternative to backpropagation. It's a modern, measurable version of Hebb's rule that is local and temporal.
]

#v(1em)
=== Chapter Conclusion
#serif-text()[
This path (Neuromorphic) is the one that directly addresses the efficiency problem by using event-driven, spiking, and local learning rules, just like the brain.
]

#v(2em)
== State of the Art & The Research Gap

#serif-text()[
"Where we are now." Briefly cover the hardware (Loihi, TrueNorth) and simulators (Brian, Nengo) that implement the ideas from 2.4.
 End the chapter by perfectly setting up your own work: "While these systems exist, they still struggle with [the specific problem your thesis solves]... This thesis proposes a method to..."
]

#v(2em)
== Neuroscience 101

#serif-text()[
Altough the perceptron captures common key aspects of biologial neuron models A lot is left on the table. A lot of progress and new ideas has surfaced since the invention of the perceptron. The simple neuron previously though to be simple like the perceptron model turns out to be more complex, the information encoding is also a key research topic not explored by older models. How to brain learn is also entirly different than what deep learning uses, changing the models and information encoding forces us to rethink how the learning algorithms in the brain works. Network architechture, fully asynchronus
]

=== Neuron Models

#serif-text()[
The neuron is the fundamental bulding block of the brain. Comprised of an axon synapses dendrites. When presynaptic neurons fire the postsynaptic neuron increaes in potential if it reaches a threshold it will itself fire. Neurons communicate with neurotransmitters such as dopmine and glutamate. There are ion channels and some calsium idk.
]

=== Encoding

#serif-text()[
It is observed that neurons fire in short bursts called spikes. Experiments show that neurons fire repetably. A sequence of spikes is called a spike train, and exactly how information is encoded in a spike train is a topic of hot debate in neuroscience. A popular idea is that information is encoded in the average value of spikes per time called rate encoding. Temporal encoding the brain most likely uses a combination of all. The time to first spike encoding could be understood like this it is not about the absolute timing of the neurons rather a race of which spikes come first. the first connections would exite the post-synaptic neurons first and they should inhibit the others (lateral inhibition)
]

=== Learning

#serif-text()[
_Spikes Do Not Play Nice With Gradients_. While models like Spiking Neural Networks (SNNs) offer greater biological plausibility and potential advantages in processing temporal information and energy efficiency, their adoption faces significant challenges, primarily stemming from the nature of their core computational element: the discrete spike.

A cornerstone of the success of modern deep learning, particularly with Multi-Layer Perceptrons (MLPs) and related architectures, is the backpropagation algorithm. Backpropagation relies fundamentally on the network's components being differentiable; specifically, the activation functions mapping a neuron's weighted input sum to its output must have a well-defined gradient. This allows the chain rule of calculus to efficiently compute how small changes in network weights affect the final output error, enabling effective gradient-based optimization (like Stochastic Gradient Descent and its variants). These techniques have proven exceptionally powerful for training deep networks on large datasets.

However, when we transition from the continuous-valued, rate-coded signals typical of MLPs to the binary, event-based spikes used in SNNs, this differentiability is lost. The spiking mechanism itself—where a neuron fires an all-or-none spike only when its internal state (e.g., membrane potential) crosses a threshold—is inherently discontinuous. Mathematically, this firing decision is often represented by a step function (like the Heaviside step function), whose derivative is zero almost everywhere and undefined (or infinite) at the threshold.

Consequently, standard backpropagation cannot be directly applied to SNNs. Gradients calculated using the chain rule become zero or undefined at the spiking neurons, preventing error signals from flowing backward through the network to update the weights effectively. This incompatibility represents a substantial obstacle, as it seemingly precludes the use of the highly successful and well-understood gradient-based optimization toolkit that underpins much of modern AI.

Surrogate Gradients: A popular approach involves using a "surrogate" function during the backward pass of training. While the forward pass uses the discontinuous spike generation, the backward pass replaces the step function's derivative with a smooth, differentiable approximation (e.g., a fast sigmoid or a clipped linear function). This allows backpropagation-like algorithms (often termed "spatio-temporal backpropagation" or similar) to estimate gradients and train deep SNNs, albeit with approximations.
]

=== Network

#serif-text()[
However, this abstraction, while powerful, significantly simplifies the underlying neurobiology. Decades of rigorous neuroscience research reveal that brain function emerges from complex electro-chemical and molecular dynamics far richer than the simple weighted sum and static activation. While it's crucial to discern which biological details are fundamental to computation versus those that are merely implementation specifics
#footnote[
  Disentangling core computational mechanisms from biological implementation details is a major ongoing challenge in neuroscience and neuromorphic engineering. Some complex molecular processes might be essential for learning or adaptation, while others might primarily serve metabolic or structural roles not directly involved in the instantaneous computation being modeled.
],
moving beyond the standard MLP model is necessary to capture more sophisticated aspects of neural processing.

A primary departure lies in the nature of neural communication. Unlike the continuous-valued activations typically passed between layers in an MLP (often interpreted as representing average firing rates), biological neurons communicate primarily through discrete, stereotyped, all-or-none electrical events known as action potentials, or 'spikes'. Information in the brain is encoded not just in the rate of these spikes (rate coding), but critically also in their precise timing, relative delays, and synchronous firing across populations (temporal coding) (Gerstner et al., 2014). For instance, the relative timing of spikes arriving at a neuron can determine its response, allowing the brain to process temporal patterns with high fidelity – a capability less naturally captured by standard MLPs. Spikes can thus be seen as event-based signals carrying rich temporal information.

Furthermore, neural systems exhibit complex dynamics beyond simple feedforward processing. Evidence suggests that cortical networks may operate near a critical state, balanced at the 'edge of chaos,' a regime potentially optimal for information transmission, storage capacity, and computational power. Systems like the visual cortex demonstrate this complexity, where intricate patterns of spatio-temporal spiking activity underlie feature detection, object recognition, and dynamic processing. These biologically observed principles—event-based communication, temporal coding, and complex network dynamics—motivate the exploration of Spiking Neural Networks (SNNs), which explicitly model individual spike events and their timing, offering a potentially more powerful and biologically plausible framework for computation than traditional MLPs.
]

== Neuromorphic engineering <intro1.3>

#pagebreak()

= Novel Framework <theory>
// Chapter 3: [Your Theoretical Contribution]
// (e.g., "A Novel Framework for On-Chip Synaptic Plasticity")
// This chapter is your first contribution. It's where you present your new idea.
// Derivation: Start from first principles. Walk the reader through the math, the logic, or the formal model you developed.
// The Model: Formally present your new algorithm, equation, or architecture. This is the "pure" theoretical part.
// Hypotheses: End the chapter by explicitly stating the hypotheses your theory predicts.
// Example: "Based on this framework, it is hypothesized that an SNN implementing this rule (1) will be able to learn the N-MNIST dataset... (2) will do so with a lower average spike rate than a baseline model... and (3) will be robust to synaptic noise..."
// By doing this, you've already "banked" a major contribution before you even show a single graph.

#pagebreak()

= Proof of Concept Methodology <method>

#serif-text()[
Say we want to detect the pattern ABC and the pattern ABD. First of all if the order does not matter set all the weights equal. If the order does matter the weights determine the order. Now if a neuron learns pattern ABC so well that it learns to fire on only AB then it can fire faster. However if a second neuron wants to learn ABD then inhibition from the AB neuron prohibits it. A solution can be that if a neuron originally learned ABC but now fires on AB but stil has a strong weight on C it should remember this and if it fires on AB but then C does not arrive it should be like "oh, C did not show maybe I am wrong to fire early" eg. Decrease weights for A and B
It predicts!

A second way is to have a hierarchy with bypass. So one layer detects only AB then the next layer has bypass of the first layer and the second combining AB and C or D

A second problem is how to decode order. When do we start the decreasing timer, how fast, should it be in time or in amount of spikes, what to do with phase? The phase should correct itself. The weights need to be as presise as the timing of the spikes? Or we could make the neuron sensitivity proportional to its inverse potential and add leaking

Problem of phase
For rate coding phase is a non issue as we can find the instantanious firing rate at any phase, for time to first spike encoding we need a reference signal. If the reference signal starts at time t0 we have started the phase and if the pattern does not match up with the reference signal we could miss it. Evidence suggests that brain waves could play the role of a global reference signal. This is the fundamental trade off between the two.



A learning scheme where inputs have to occur in the same episode repeatedly two inputs that happen at the same time yields a stronger response. If the pattern is random then they would sometimes occur in the same episode and sometimes not. Two strong responses should occur in the same time frame. 

If the post neuron fires then we should strengthen the weights

Footnote digression for longer patterns
Longer patterns require a latched state such as neurons entering repeated firing like a state machine


An important point is to declare whether a mechanism is bio plausible. An engineer might not care wether or not a mechanism is used by the brain and is crucial to the brains function. An engineer might only care about if the mechanics works and is effective for the system that is created in the engineers vision. An engineer might just use the brain as an inspiration. Evolution althoug achieved remarkable feats is not guaranteed to foster up the most optimal solution, only good enough to survive to the next generation. However discussing wether or not a mechanism is bio plausible is still useful for understanding our own brain. And creating bio plausible artificial systems can contribute to more than one field.

An encoding should be fast
Robust to noise
Use limited resources

A neuron should accumulate change (intrgrate)
It should fire when its threshold has been reached 
It should leak charge over time

Some neurons have other properties like bursting modes or continuous firing once the threshold has been reached.

Inhibition should make a neuron not fire

In a time to first spike scheme of we care about the order (the relative values since information is stored in time and order) we have to use weights and a neuron model that distinguish between inputs arriving earlier than others. I present a scheme where the first neuron that arrives starts a linear count where the slope of the counter is the weight additional inputs will increase or decrease the slope according to their weight. We can see that neurons arriving earlier will get more time to increase the counter and thus will carry a higher value. If the counter reaches a threshold the neuron will fire. The astute will notice that in this scheme the neuron will fire even for the smallest stimulus since the counter will count up a non zero value and eventually reach the threshold, to mitigate this we can simply say that if the counter is too slow the neuron will not fire we will see later that this scheme satisfies the criteria above.

The problem with this decoding is for strong stimuli we would ideally make the neuron respond immediately and fire, but it has to wait until the counter has reached the threshold to fix this we can also add the weight of the input directly to the potential while also starting a counter. Now if early strong inputs arrive they will fill up the potential and make the neuron fire almost immediately. Small inputs wil take some time 
]

#figure(
  image("figures/spiketrain.svg"),
  caption: [Spike train]
)
#figure(
  include("figures/architecture.typ"),
  caption: [Proposed simplifed layout of a SNN. The neurons are connected with hirearcical busses
  that allow for the network to be configured as a _small world network_]
)

== Neuron Models

#serif-text()[
Leaky integrate and fire models seem the best bet, however complex dynamics like exponential decay and analog weights and potentials seem excessive, we might do without. Binary weights 1 for excitatory and and 0 for inhibitory. Stronger weights can be modeled with multiple parallel synapses
]

== Learning


#figure(
caption: [Unsupervised local learning rule for induvidual neurons. Based on STDP],
supplement: [Algorithm],
mono-text(pseudocode-list(hooks:.5em, indentation:1em, booktabs:true)[
+ start with a collection of neurons with arbitrary connections
+ *if* a pre-synaptic neuron fires *then*
  + it has a chance to grow a synapse to a random post-synaptic neuron 
+ *if* a post-synaptic neuron fires *then*
  + strengthen all connections to pre-synaptic neruons that fired before
  + wither all connections to pre-synaptic neurons that did not fire, or fired after
- 🛈  a neuron can be both pre-synaptic and post-synaptic
]))

#figure(
caption: [Growing rules for synapses],
supplement: [Algorithm],
mono-text(pseudocode-list(hooks:.5em, indentation:1em, booktabs:true)[
+ probability of growing a synapse is inversely proportional to the amount it already has
+ earlier firings should get a better chance to grow synapses, although this is regulated by
  inhibitory action
]))

== Network

#pagebreak()

= Results <results3>

#pagebreak()

= Discussion <discussion4>

#pagebreak()

#bibliography("references.bib")

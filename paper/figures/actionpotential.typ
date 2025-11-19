#import "@preview/lilaq:0.5.0" as lq
#import "@preview/cetz-plot:0.1.3"
#import "@preview/zero:0.4.0": set-num
#import "@preview/cetz:0.4.2"

#set-num(math: false)
#set text(font: "GeistMono NF", weight: "medium", size: 9pt)

// --- Data Preparation ---
#let data = (
  (0.0, -70), (0.5, -70.2), (1.0, -69.8), (1.5, -70),
  (1.8, -55),
  (1.9, -40), (2.0, -10), (2.1, 20), (2.2, 35), (2.25, 40),
  (2.3, 30), (2.4, 10), (2.5, -10), (2.6, -30), (2.7, -50), (2.8, -65),
  (3.0, -75), (3.5, -80), (4.0, -82), (4.5, -80), (5.0, -75),
  (6.0, -71), (7.0, -70.5), (8.0, -70)
)

// Lilaq expects separate arrays for x and y
#let t = data.map(p => p.at(0))
#let v = data.map(p => p.at(1))

#let threshold_t = (0, 8)
#let threshold_v = (-55, -55)

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
    content((5, -2), anchor: "south", [
    #lq.diagram(
      width: 8cm, 
      height: 4cm,
      xlabel: [Time (ms)], 
      ylabel: [Voltage (mV)],
      
      // The Action Potential Curve (Lilac)
      lq.plot(t, v, stroke: (paint: green, thickness: 2pt)),
      
      // The Threshold Line (Dashed)
      lq.plot(threshold_t, threshold_v, stroke: (paint: gray, dash: "dashed"))
    )
  ])
  // 1. Title and Annotations (Relative to Canvas)
  content((5, 5.5), text(size: 11pt, weight: "bold", "Action Potential Recording"))

  content((1.5, 5), text(fill: gray, size: 9pt, "Depolarization"))
  content((3.5, 3), text(fill: gray, size: 9pt, "Repolarization"))
  content((5.8, 1), text(fill: gray, size: 9pt, "Hyperpolarization"))
  
  line((3.6, 2.0), (3.6, 2.6), mark: (end: ">"), stroke: (thickness: 1pt))
  content((3.6, 1.8), text(size: 9pt, "Peak (+40mV)"))

  // 2. The Lilaq Diagram
  // Placed at the center of the previous coordinate system
})

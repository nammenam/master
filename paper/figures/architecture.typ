#import "@preview/cetz:0.4.2"
// #set page(width: auto, height: auto, margin: .5cm)

// #show math.equation: block.with(fill: white, inset: 1pt)
#set text(size: 9pt, font: "GeistMono NF", weight: "medium")

#cetz.canvas({
  import cetz.draw: *

  set-style(
    stroke: (paint: rgb("838B92")),
    fill: rgb("B3EBF2"),
  )
  rect((4,14),(rel:(1.2,1.2)),radius:15%, name:"r")
  content((v => cetz.vector.add(v, (2, 0)), "r.east"), "= interconnect")
  set-style(
    stroke: (paint: rgb("808080")),
    fill: rgb("FFEE8C"),
  )

  rect((0,14),(rel:(1.2,1.2)),radius:15%, name:"r")
  content((v => cetz.vector.add(v, (1, 0)), "r.east"), "= neuron")
  
  let pos_x = 0
  let pos_y = 0
  for i in range(8) {
    pos_y = 0
    if (calc.rem(i, 4) == 0 and (i > 0)) {
      pos_x += 0.5
    }
    for j in range(8) {
      if (calc.rem(j, 4) == 0 and (j > 0)) {
        pos_y += 0.5
      }
      rect((pos_x,pos_y),(rel:(1.2,1.2)),radius:15%, name:"r")
      pos_y += 1.5
    }
    pos_x += 1.5
  }

})

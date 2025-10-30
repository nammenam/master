#import "@preview/cetz:0.4.2"
#show math.equation : set text(font:"TeX Gyre Schola Math", size: 10.5pt)
// #set page(width: auto, height: auto, margin: 0.6pt)

#cetz.canvas({
  import cetz.draw: *
  set-style(
    stroke:(thickness:2pt)
  )

  let radius = 1
  let point_size = 2pt
  let xprev = 0
  let yprev = 0
  let x = 0
  let y = 0
  let xc = 0
  let yc = 0
  for i in range(7) {
    // Calculate the angle for each point.
    // 360deg / 6 points = 60deg per point.
    let angle = i * 60deg
    x = radius * calc.cos(angle)
    y = radius * calc.sin(angle)
    let anglec = i * 60deg - 30deg
    xc = radius * calc.cos(anglec) * 0.5
    yc = radius * calc.sin(anglec) * 0.5
    // Place a solid black circle at the (x, y) position.
    // circle((x,y),radius:.1)
    // circle((xprev,yprev),radius:.1, fill:blue)
    // circle((xc,yc),radius:.1)
    if i > 0 {
      bezier((x,y),(xprev,yprev),(xc,yc))
    }
    xprev = x
    yprev = y
      // circle(radius: point_size, fill: black)
  }
  circle((0,0),radius:.4)
  let startx = radius * calc.cos(180deg)
  let startx2 = radius * calc.cos(0deg)
  let end = (startx,0)
  let end2 = (startx2,0)

  let i = (-1.5,1.5)
  let j = (-1.5,.5)
  let k = (-1.5,0)
  let l = (-1.5,-.5)
  let m = (-1.5,-1.5)
  let n = (-2.5,1.5)
  let o = (-2.5,.5)
  let p = (-2.5,0)
  let q = (-2.5,-.5)
  let r = (-2.5,-1.5)
  let i2 = (1.5,1.5)
  let j2 = (1.5,.5)
  let k2 = (1.5,0)
  let l2 = (1.5,-.5)
  let m2 = (1.5,-1.5)
  let n2 = (2.5,1.5)
  let o2 = (2.5,.5)
  let p2 = (2.5,0)
  let q2 = (2.5,-.5)
  let r2 = (2.5,-1.5)
  // line((startx,0),end)
  line((startx2,0),end2)
  bezier(end, n, k, i)
  bezier(end, o, k, j)
  bezier(end, q, k, l)
  bezier(end, r, k, m)
  content((0,2.5),[$
    y = cases(
      1 "if" sum_(i=0)^n x_i w_i >= b,
      0 "if" sum_(i=0)^n x_i w_i < b
    )
  $])
  content((v => cetz.vector.add(v,(-.5,0)),n), [$x_0$])
  content((v => cetz.vector.add(v,(-.5,0)),o), [$x_1$])
  content((v => cetz.vector.add(v,(-.5,0)),p), [$dots.v$])
  content((v => cetz.vector.add(v,(-.5,0)),q), [$x_(n-1)$])
  content((v => cetz.vector.add(v,(-.5,0)),r), [$x_n$])
  content((v => cetz.vector.add(v,(.5,0)),n2), [$y$])
  content((v => cetz.vector.add(v,(.5,0)),o2), [$y$])
  content((v => cetz.vector.add(v,(.5,0)),p2), [$dots.v$])
  content((v => cetz.vector.add(v,(.5,0)),q2), [$y$])
  content((v => cetz.vector.add(v,(.5,0)),r2), [$y$])
  bezier(end2, n2, k2, i2)
  bezier(end2, o2, k2, j2)
  bezier(end2, q2, k2, l2)
  bezier(end2, r2, k2, m2)

})

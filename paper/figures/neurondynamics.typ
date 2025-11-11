#import "@preview/lilaq:0.5.0" as lq
#import "@preview/zero:0.4.0": set-num
#set-num(math: false)

#set text(font: "GeistMono NF", weight: "medium", size: 9pt)
#let sans-text(body) = {
  set text(font: "Geist", size: 10pt, weight: "regular")
  body
}


#let xs = (0, 1, 2, 3, 4)

#lq.diagram(
  title: sans-text()[Neuron dynamics],
  lq.quiver(
    lq.arange(-2, 3),
    lq.arange(-2, 3),
    (x, y) => (x + y, y - x)
  )
))

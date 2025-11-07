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
  title: sans-text()[Precious data],
  xlabel: [t], 
  ylabel: [potential],

  lq.plot(xs, (3, 5, 4, 2, 3), mark: "s", label: [A]),
  lq.plot(
    xs, x => 2*calc.cos(x) + 3, 
    mark: "s", label: [B]
  )
)

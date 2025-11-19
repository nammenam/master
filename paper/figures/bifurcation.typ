#import "@preview/lilaq:0.5.0" as lq
#import "@preview/zero:0.4.0": set-num

#set-num(math: false)
#set text(font: "GeistMono NF", weight: "medium", size: 9pt)
#let sans-text(body) = {
  set text(font: "Geist", size: 10pt, weight: "regular")
  body
}

// --- AdEx Parameters ---
#let C = 281.0
#let gL = 30.0
#let EL = -70.6
#let VT = -50.4
#let DeltaT = 2.0
#let a = 4.0
#let tau_w = 144.0
#let b = 80.5

// --- Simulation Logic ---
#let get-bounds(I_val) = {
  let v = -70.6
  let w = 0.0
  let dt = 0.1
  let steps = 4000 
  let transient = 2000

  let min_v = 100.0
  let max_v = -100.0

  for i in range(steps) {
    let exp_term = gL * DeltaT * calc.exp((v - VT) / DeltaT)
    let dv = (-gL * (v - EL) + exp_term - w + I_val) / C
    let dw = (a * (v - EL) - w) / tau_w
    
    v = v + dv * dt
    w = w + dw * dt
    
    if v >= -30 { // Spike
      v = -70.6
      w = w + b
    }
    
    if i > transient {
      if v < min_v { min_v = v }
      if v > max_v { max_v = v }
    }
  }
  
  // Return min and max values
  (min_v, max_v)
}

// --- Generate Data ---
#let i_vals = range(400, 1000, step: 20)
#let v_min_arr = ()
#let v_max_arr = ()

#for i in i_vals {
  let (mn, mx) = get-bounds(i)
  v_min_arr.push(mn)
  // If fixed point (diff is small), push min again to keep lines clean
  // If spiking, push max
  if (mx - mn) < 0.5 {
    v_max_arr.push(mn) 
  } else {
    v_max_arr.push(mx)
  }
}

// --- Diagram ---
#lq.diagram(
  title: sans-text([AdEx Bifurcation Diagram]),
  xlabel: [$I_"ext"$ (pA)],
  ylabel: [$V$ (Voltage mV)],
  width: 12cm,
  height: 7cm,
  
  // 1. Minimum Voltage Branch (Fixed Point)
  lq.plot(
    i_vals, 
    v_min_arr,
    stroke: (paint: blue, thickness: 1.5pt),
    label: sans-text("Stable Fixed Point / Min Voltage")
  ),

  // 2. Maximum Voltage Branch (Spiking Peak)
  lq.plot(
    i_vals, 
    v_max_arr,
    stroke: (paint: red, thickness: 1.5pt),
    label: sans-text("Spiking Peak")
  ),
  
  // 3. Annotation for Bifurcation
  lq.plot(
     (500, 500), (-75, -40), // Vertical dashed line at bifurcation approx
     stroke: (paint: gray, dash: "dotted")
  )
)

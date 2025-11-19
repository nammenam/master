#import "@preview/lilaq:0.5.0" as lq
#import "@preview/zero:0.4.0": set-num
#set-num(math: false)

#set text(font: "GeistMono NF", weight: "medium", size: 9pt)
#let sans-text(body) = {
  set text(font: "Geist", size: 10pt, weight: "regular")
  body
}

// --- AdEx Model Parameters (Tonic Spiking) ---
// C dV/dt = -gL(V - EL) + gL*DeltaT*exp((V-VT)/DeltaT) - w + I
// tau_w dw/dt = a(V - EL) - w
//
// Reset: If V > V_peak: V -> V_reset, w -> w + b

#let C = 281.0        // Membrane Capacitance (pF)
#let gL = 30.0        // Leak Conductance (nS)
#let EL = -70.6       // Leak Reversal Potential (mV)
#let VT = -50.4       // Threshold Potential (mV)
#let DeltaT = 2.0     // Slope Factor (mV)
#let a = 4.0          // Subthreshold Adaptation (nS)
#let tau_w = 144.0    // Adaptation Time Constant (ms)
#let b = 80.5         // Spike-triggered Adaptation (pA)
#let I = 800.0        // Injected Current (pA)

#let V_reset = -70.6  // Reset Potential (mV)
#let V_peak = -30.0   // Spike Cutoff (mV) - Artificial threshold for plotting

// --- 1. Nullclines Equations ---

// V-Nullcline: w = -gL(V - EL) + gL*DeltaT*exp((V-VT)/DeltaT) + I
#let v-nullcline(v) = {
  -gL * (v - EL) + gL * DeltaT * calc.exp((v - VT) / DeltaT) + I
}

// w-Nullcline: w = a(V - EL)
#let w-nullcline(v) = {
  a * (v - EL)
}

// --- 2. Simulation (Euler Method with Reset) ---
#let solve-adex(steps, dt, v0, w0) = {
  let path_v = (v0,)
  let path_w = (w0,)
  let resets = () // Store pairs of (start, end) points for reset lines

  let v = v0
  let w = w0
  
  for i in range(steps) {
    // Calculate derivatives
    let exp_term = gL * DeltaT * calc.exp((v - VT) / DeltaT)
    let dv = (-gL * (v - EL) + exp_term - w + I) / C
    let dw = (a * (v - EL) - w) / tau_w
    
    // Update state
    v = v + dv * dt
    w = w + dw * dt
    
    // Check Reset Condition
    if v >= V_peak {
      let v_prev = v
      let w_prev = w
      
      // Apply Reset
      v = V_reset
      w = w + b
      
      // Record the jump for plotting
      resets.push( ((v_prev, w_prev), (v, w)) )
      
      // Start new segment (optional in simple plot, but good for data continuity)
      path_v.push(v_prev) // To draw up to peak
      path_w.push(w_prev)
      path_v.push(v)      // Jump to reset
      path_w.push(w)
    } else {
      path_v.push(v)
      path_w.push(w)
    }
  }
  (path_v, path_w, resets)
}

// Generate Data
#let range-v = lq.arange(-80, -30, step: 0.5)
#let nc_v_y = range-v.map(v => v-nullcline(v))
#let nc_w_y = range-v.map(v => w-nullcline(v))

// Run Simulation
#let (traj_v, traj_w, resets) = solve-adex(2000, 0.1, -70.0, 0.0)

// --- Diagram ---
#lq.diagram(
  title: sans-text([AdEx State Space (Tonic Spiking)]),
  xlabel: [$V$ (Membrane Potential mV)],
  ylabel: [$w$ (Adaptation Current pA)],
  width: 12cm,
  height: 8cm,
  xlim: (-80, -30),
  ylim: (-50, 400),

  // 1. Vector Field
  lq.quiver(
    lq.arange(-80, -30, step: 4),
    lq.arange(-50, 400, step: 30),
    (v, w) => {
       let exp_term = gL * DeltaT * calc.exp((v - VT) / DeltaT)
       let dv = (-gL * (v - EL) + exp_term - w + I) / C
       let dw = (a * (v - EL) - w) / tau_w
       
       // Heavily normalize because exponential term explodes
       let mag = calc.sqrt(dv*dv + dw*dw)
       if mag != 0 { (dv/mag, dw/mag) } else { (0,0) }
    },
    scale: 1.5, // Scale up normalized arrows
    stroke: (paint: gray.lighten(60%), thickness: 0.5pt)
  ),

  // 2. Nullclines
  lq.plot(
    range-v, nc_v_y, 
    stroke: (paint: blue.lighten(20%), thickness: 2pt),
    label: sans-text("V-Nullcline")
  ),
  lq.plot(
    range-v, nc_w_y, 
    stroke: (paint: red.lighten(20%), thickness: 2pt),
    label: sans-text("w-Nullcline")
  ),

  // 3. Trajectory
  lq.plot(
    traj_v, traj_w, 
    stroke: (paint: black, thickness: 1.2pt),
    label: sans-text("Limit Cycle")
  ),
  
  // 4. Manually draw Reset Lines (The "Jump")
  ..resets.map(pair => 
    lq.plot(
      (pair.at(0).at(0), pair.at(1).at(0)), 
      (pair.at(0).at(1), pair.at(1).at(1)),
      stroke: (paint: red, dash: "dashed", thickness: 1pt)
    )
  )
)

let epsilon = 0.001
let t_max = 1.0e30
let pi = 3.14159265359

let valid t = 
  epsilon <= t && t <= t_max

type t = int * int * int

let min_val = 0
let max_val = 255

let create r g b =
  (r, g, b)

let values (r, g, b) =
  (r, g, b)

let add (r1, g1, b1) (r2, g2, b2) = 
  (r1 + r2, g1 + g2, b1 + b2)

let mul (r1, g1, b1) (r2, g2, b2) = 
  (r1 * r2, g1 * g2, b1 * b2)

let mulf (r, g, b) x = 
  let f c = float_of_int c *. x |> int_of_float in
  (f r, f g, f b)

let fit ?(min_v=min_val) ?(max_v=max_val) (r, g, b) = 
  let f c = max min_v (min max_v c) in
  (f r, f g, f b)
  
let white = create 255 255 255
let black = create 0 0 0
let red = create 255 0 0
let green = create 0 255 0
let blue = create 0 0 255

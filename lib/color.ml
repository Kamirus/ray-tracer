type t = float * float * float

let min_val = 0.
let max_val = 1.

let from_rgb rgb_val = 
  float_of_int rgb_val /. 255.

let to_rgb x =
  x *. 255. |> int_of_float

let create r g b =
  (from_rgb r, from_rgb g, from_rgb b)

let values (r, g, b) =
  (to_rgb r, to_rgb g, to_rgb b)

let add (r1, g1, b1) (r2, g2, b2) = 
  (r1 +. r2, g1 +. g2, b1 +. b2)

let mul (r1, g1, b1) (r2, g2, b2) = 
  (r1 *. r2, g1 *. g2, b1 *. b2)

let mulf (r, g, b) x = 
  (r *. x, g *. x, b *. x)

let fit (r, g, b) = 
  let f c = max min_val (min max_val c) in
  (f r, f g, f b)
  
let white = create 255 255 255
let black = create 0 0 0
let red = create 255 0 0
let green = create 0 255 0
let blue = create 0 0 255

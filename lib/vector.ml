type t = float * float * float

let create x y z = 
  (x, y, z)

let create_ints x y z = 
  (float_of_int x, float_of_int y, float_of_int z)

let add (x1, y1, z1) (x2, y2, z2) = 
  (x1 +. x2, y1 +. y2, z1 +. z2)

let sub (x1, y1, z1) (x2, y2, z2) = 
  (x1 -. x2, y1 -. y2, z1 -. z2)

let mul n (x, y, z) = 
  (x *. n, y *. n, z *. n)

let div n (x, y, z) = 
  (x /. n, y /. n, z /. n)

let neg (x, y, z) = 
  (-.x, -.y, -.z)

let length2 (x, y, z) = 
  x *. x +. y *. y +. z *. z

let length t = 
  t |> length2 |> sqrt

let normalize t = 
  div (length t) t

let dot (x1, y1, z1) (x2, y2, z2) = 
  (x1 *. x2 +. y1 *. y2 +. z1 *. z2)

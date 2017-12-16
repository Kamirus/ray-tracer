type t = int * int * int

let create r g b =
  (r, g, b)

let white = create 255 255 255
let black = create 0 0 0
let red = create 255 0 0
let green = create 0 255 0
let blue = create 0 0 255

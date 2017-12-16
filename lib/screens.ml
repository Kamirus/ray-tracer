module type SCREEN = sig
  type point
  type t

  val pixel_position : t -> int -> int -> point option
  val pixel_ray : t -> int -> int -> Ray.t option
end


module NoPerspectiveFixedScreen : SCREEN 
  with type t = int * int and type point = Vector.t
= struct
  type point = Vector.t
  type t = int * int

  let pixel_position (x_max, y_max) x y = 
    if 0 <= x && x < x_max && 0 <= y && y < y_max
    then Some (Vector.create_ints x y 0)
    else None

  let pixel_ray t x y = 
    match pixel_position t x y with
    | None -> None
    | Some p -> 
      (* create ray from pixel p *)
      let v = Vector.create 0. 0. 1. in
      Some (Ray.create p v)
end

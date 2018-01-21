module type SCREEN = sig
  type t

  val create : t -> t

  (** [pixel_ray x y] takes x and y coordinates of the screen
      and translates it to the ray that needs to be traces in order
      to determine the color for (x, y) pixel *)
  val pixel_ray : t -> int -> int -> Ray.t
end

module type SCREEN_INSTANCE = sig
  module S : SCREEN
  val this : S.t
end

let create_instance (type a) (module S : SCREEN with type t = a) t = 
  (module struct 
    module S = S
    let this = S.create t
  end : SCREEN_INSTANCE)

(* --- *)

(** [vec2d_from_center_to_pixel x_max y_max ratio x y] 
    translate (x,y) from (0,0) in the bottom left corner 
    to the center of the screen *)
let vec2d_from_center_to_pixel x_max y_max ratio x y =
  let one x x_max =
    (* from x perspective *)
    (* left bottom corner of the screen is 0,0 *)
    let x = x - x_max / 2 in
    (* screen center is now 0,0 *)
    (* take random offset (-0.5, 0.5) *)
    let off = Random.float 1. -. 0.5 in
    (* translate physical coordinates into virtual (from pixels to units) *)
    x |> float_of_int |> (+.) off |> ( *.) ratio
  in
  (one x x_max, one y y_max)

(* --- *)

module MakePerspectiveScreen (C : Cameras.CAMERA) : SCREEN 
  with type t = C.t * int * int * float
= struct
  type t = C.t * int * int * float

  (** [create (camera, x_max, y_max, ratio)]
      x_max, y_max - output picture resolution
      ratio - number of units per pixel *)
  let create (camera, x_max, y_max, ratio) = 
    (camera, abs x_max, abs y_max, abs_float ratio)

  let pixel_ray (camera, x_max, y_max, ratio) x y = 
    let to_xy = vec2d_from_center_to_pixel x_max y_max ratio x y in
    C.shoot camera to_xy
end

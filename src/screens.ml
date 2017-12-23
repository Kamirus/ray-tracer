module type SCREEN = sig
  type t

  val create : t -> t
  val pixel_ray : t -> int -> int -> Ray.t option
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

(** [valid_xy (x_max, y_max) x y] bottom left corner is (0,0) point *)
let valid_xy (x_max, y_max) x y = 
  0 <= x && x < x_max && 0 <= y && y < y_max

(** [vec2d_to_pixel x_max y_max ratio x y] 
    translate (x,y) from (0,0) in the bottom left corner 
    to the center of the screen *)
let vec2d_to_pixel x_max y_max ratio x y =
  (* from x,y perspective *)
  (* left bottom corner of the screen is 0,0 *)
  let x = x - x_max / 2
  and y = y - y_max / 2 in
  (* screen center is now 0,0 *)
  (* translate physical coordinates into virtual (from pixels to units) *)
  let x' = float_of_int x *. ratio 
  and y' = float_of_int y *. ratio in
  (x', y')

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
    if not @@ valid_xy (x_max, y_max) x y then None
    else
      let xy = vec2d_to_pixel x_max y_max ratio x y in
      let ray = C.shoot camera xy in
      Some ray
end

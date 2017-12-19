module type CAMERA = sig
  type t

  val create : t -> t

  (**[shoot t v] shoot ray from camera to the point on the screen
     relatively given by 2D vector v (x,y) from screen center *)
  val shoot : t -> float * float -> Ray.t
end


type camera_t = Point.t * Vector.t * float

module Camera : CAMERA
  with type t = camera_t
= struct
  type t = camera_t

  let create (center, direction, distance_from_screen) = 
    (center, Vector.normalize direction, abs_float distance_from_screen)

  let shoot (c, dir, d) (x, y) = 
    (* screen center *)
    let sc = Vector.add c (Vector.mul d dir)
    (* Vector from screen center to xy *)
    and sc_to_xy = Vector.create x y 0. in
    (* destination xy point *)
    let xy = Vector.add sc sc_to_xy in
    (* ray from c to xy *)
    Ray.create c (Vector.sub xy c)
end

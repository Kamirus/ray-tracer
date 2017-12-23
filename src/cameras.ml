module type CAMERA = sig
  type config
  type t

  val create : config -> t

  (**[shoot t v] shoot ray from camera to the point on the screen
     relatively given by 2D vector v (x,y) from screen center *)
  val shoot : t -> float * float -> Ray.t
end

module type CAMERA_INSTANCE = sig
  module C : CAMERA
  val this : C.t
end

let create_instance (type a) (module C : CAMERA with type config = a) cfg = 
  (module struct 
    module C = C
    let this = C.create cfg
  end : CAMERA_INSTANCE)

(* --- *)

type camera_cfg = Point.t * Vector.t * Vector.t * float
module Camera : CAMERA
  with type config = camera_cfg
= struct
  type config = camera_cfg
  type t = { center : Point.t
           ; screen_center : Point.t
           ; forward : Vector.t
           ; up : Vector.t
           ; right : Vector.t }

  let create (center, forward, up, distance_from_screen) = 
    let forward = Vector.normalize forward in
    let up = Vector.normalize up in
    assert (Vector.dot up forward < Util.epsilon);
    let right = Vector.cross up forward in
    let distance = abs_float distance_from_screen in
    let screen_center = Vector.add center (Vector.mul distance forward) in
    {center; screen_center; forward; up; right}

  let shoot {center; screen_center; right; up} (x, y) = 
    let to_right = Vector.mul x right in
    let to_up = Vector.mul y up in
    let point = screen_center 
                |> Vector.add to_right
                |> Vector.add to_up in
    Ray.create center (Vector.sub point center)
end

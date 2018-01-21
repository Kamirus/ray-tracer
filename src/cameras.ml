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

(* Since there's no inheritance of implementation for modules
   I extracted common implementation here. *)
module CameraCommon = struct
  type camera_t = { center : Point.t
                  ; screen_center : Point.t
                  ; forward : Vector.t
                  ; up : Vector.t
                  ; right : Vector.t }

  let create (center, forward, up, distance_from_screen) = 
    let forward = Vector.normalize forward in
    let up = Vector.normalize up in
    (* assert (Vector.dot up forward < Util.epsilon); *)
    let right = Vector.cross up forward in
    let distance = abs_float distance_from_screen in
    let screen_center = Vector.add center (Vector.mul distance forward) in
    {center; screen_center; forward; up; right}

  let shoot ~center ~screen_center ~right ~up (x, y) = 
    let to_right = Vector.mul x right in
    let to_up = Vector.mul y up in
    let destination = screen_center 
                      |> Vector.add to_right
                      |> Vector.add to_up in
    let direction_center_to_dest = Vector.sub destination center in
    Ray.create center direction_center_to_dest
end


type camera_cfg = Point.t * Vector.t * Vector.t * float

module Camera : CAMERA
  with type config = camera_cfg
= struct
  module C = CameraCommon
  type config = camera_cfg
  type t = CameraCommon.camera_t

  let create = C.create

  let shoot {C.center; screen_center; right; up} xy = 
    C.shoot ~center ~screen_center ~right ~up xy
end


type sensor_cfg = camera_cfg * float * float

module Sensor : CAMERA
  with type config = sensor_cfg
= struct
  module C = CameraCommon
  type config = sensor_cfg
  type t = { camera : CameraCommon.camera_t
           ; width : float
           ; height : float }

  let create (camera_cfg, width, height) =
    let camera = CameraCommon.create camera_cfg in
    { camera; width; height }

  let random_xy { width; height } =
    (* range: [-a/2, a/2] *)
    let rand_range a = Random.float a  -. a  /. 2. in
    let x = rand_range width in
    let y = rand_range height in
    (x, y)

  let random_source ({ camera = { C.center; right; up } } as t) =
    let x, y = random_xy t in
    let to_right = Vector.mul x right in
    let to_up = Vector.mul y up in
    center |> Point.add to_right |> Point.add to_up

  let shoot ({ camera = { C.screen_center; right; up } } as t) xy =
    let center = random_source t in
    C.shoot ~center ~screen_center ~right ~up xy
end

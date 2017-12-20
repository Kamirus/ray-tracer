module type LIGHT = sig
  type t

  val create : t -> t
  val get_color : t -> Ray.t -> Color.t
  val ray_to_light : t -> Point.t -> Ray.t
end

module type LIGHT_INSTANCE = sig
  module Light : LIGHT
  val this : Light.t
end

let create_instance (type a) (module L : LIGHT with type t = a) t = 
  (module struct 
    module Light = L
    let this = L.create t
  end : LIGHT_INSTANCE)

(* --- *)

type sun_t = { dir : Vector.t
             ; color : Color.t }
module Sun : LIGHT
  with type t = sun_t
= struct
  type t = sun_t

  let create { dir; color } = 
    let dir = Vector.normalize dir in
    { dir; color }

  let get_color { color } _ = 
    color

  let ray_to_light { dir } point =
    Ray.create point (Vector.mul (-.1.) dir)
end
 
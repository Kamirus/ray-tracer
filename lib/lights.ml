module type LIGHT = sig
  type t

  val create : t -> t
  val point : t -> Point.t
  val get_color : t -> Ray.t -> Color.t
end

module type LIGHT_INSTANCE = sig
  module Light : LIGHT
  val this : Light.t
end

let create_instance (type a) (module L : LIGHT with type t = a) t = 
  (module struct 
    module Light = L
    let this = t
  end : LIGHT_INSTANCE)

(* --- *)

type sun_t = Point.t

module Sun : LIGHT
  with type t = sun_t
= struct
  type t = sun_t

  let create point = point
  let point point = point
  let get_color p r = Color.white
end

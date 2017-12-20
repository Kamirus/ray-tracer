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
    let this = L.create t
  end : LIGHT_INSTANCE)

(* --- *)

type sun_t = Point.t

module Sun : LIGHT
  with type t = sun_t
= struct
  type t = sun_t

  let create center = center
  let point center = center
  let get_color center ray = Color.white
end

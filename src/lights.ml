module type LIGHT = sig
  type t

  val create : t -> t
  val get_color : t -> Point.t -> Color.t
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


type light_point_t = { source : Point.t
                     ; color : Color.t
                     ; intensity : float }
module LightPoint : LIGHT
  with type t = light_point_t
= struct
  type t = light_point_t

  let create { source; color; intensity } = 
    { source; color; intensity }

  let get_color { source; color; intensity } p = 
    let d2 = Vector.sub p source |> Vector.length2 in
    let k = 4. *. Util.pi *. d2 in
    Color.mulf color @@ intensity /. k |> Color.fit

  let ray_to_light { source } point =
    let dir = Vector.sub source point in
    let max_d = Vector.length dir in
    Ray.create ~max_d point dir
end

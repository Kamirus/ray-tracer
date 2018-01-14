module type LIGHT = sig
  include Objects.OBJECT

  (* val create : t -> t *)
  val calc_color : t -> Point.t -> Color.t
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

  let get_color { color } =
    color

  let intersect { dir; color } ray =
    None

  let create { dir; color } = 
    let dir = Vector.normalize dir in
    { dir; color }

  let calc_color { color } _ = 
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

  let get_color { color } =
    color

  let intersect t ray =
    None

  let create t = 
    t

  let calc_color { source; color; intensity } p = 
    let d2 = Vector.sub p source |> Vector.length2 in
    let k = 4. *. Util.pi *. d2 in
    Color.fit @@ Color.mulf (intensity /. k) color

  let ray_to_light { source } point =
    let dir = Vector.sub source point in
    let max_d = Vector.length dir in
    Ray.create ~max_d point dir
end


type light_sphere_t = { center : Point.t
                      ; color : Color.t
                      ; intensity : float
                      ; radius : float }
module LightSphere : LIGHT
  with type t = light_sphere_t
= struct
  type t = light_sphere_t

  let get_color { color } =
    color

  let intersect { color; center; radius } ray =
    match Ray.distance_to_sphere ray ~center ~radius with
    | None -> None
    | Some d -> 
      let hit_point = Ray.calc_point ray d in
      (* inverted normal pointing center *)
      let normal = Vector.direction_from_to hit_point center in
      let albedo = 0. in (* nasty workaround to prevent indirect illumination and reflection *)
      Some (Intersection.create ~ray ~d ~color ~normal ~albedo)

  let create t = 
    t

  let calc_color { center; color; intensity } p = 
    let d2 = Vector.sub p center |> Vector.length2 in
    let k = 4. *. Util.pi *. d2 in
    Color.fit @@ Color.mulf (intensity /. k) color

  let ray_to_light { center; radius } point =
    let vec = Vector.sub center point in
    let d = Vector.length vec in
    if d <= radius
    then Ray.create ~max_d:0. point vec
    else
      let dir = Vector.normalize vec in

      let cosmin = 1. -. radius ** 2. /. d ** 2. |> sqrt in
      let dir = Util.rand_dir dir ~cosmin in

      (* prevent intersecting with itself *)
      let max_d = d -. radius -. Util.epsilon in
      Ray.create ~max_d point dir
end

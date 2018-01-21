module type OBJECT = sig
  type t

  val create : t -> t

  (** [intersect t ray] Object checks if [ray] hits it.
      If so then useful information is provided as Intersection.t *)
  val intersect : t -> Ray.t -> Intersection.t option
end

module type OBJECT_INSTANCE = sig
  module Object : OBJECT
  val this : Object.t
end

let create_instance (type a) (module O : OBJECT with type t = a) t = 
  (module struct 
    module Object = O
    let this = O.create t
  end : OBJECT_INSTANCE)

(* --- *)

type plane_t = { point  : Point.t
               ; normal : Vector.t
               ; albedo : float
               ; color  : Color.t }

type sphere_t = { center : Point.t
                ; radius : float
                ; albedo : float
                ; color  : Color.t }

module Plane : OBJECT
  with type t = plane_t
= struct
  type t = plane_t

  let create {point; normal; albedo; color} = 
    let normal = Vector.normalize normal in
    {point; normal; albedo; color}

  let get_normal {point; normal} p =
    let point_to_p = Vector.sub p point in
    if Vector.dot normal point_to_p < 0.
    then Vector.mul (-1.) normal (* p on the other side *)
    else normal

  let intersect ({point; normal; color; albedo} as t) ray = 
    let raydir_dot_normal = Vector.dot normal (Ray.direction ray) in
    if abs_float raydir_dot_normal < Util.epsilon 
    then None (* 90deg, we want just one point *)
    else
      let pr = Ray.source ray in
      let point_dot_normal = Vector.dot point normal
      and pr_dot_normal = Vector.dot pr normal in
      let d = (point_dot_normal -. pr_dot_normal) /. raydir_dot_normal in
      if not @@ Util.valid d || d > Ray.max_d ray then None
      else
        Some (Intersection.create ~ray ~d ~color ~normal:(get_normal t pr) ~albedo)
end

module Sphere : OBJECT 
  with type t = sphere_t
= struct
  type t = sphere_t

  let create t = 
    t

  let intersect { center; radius; color; albedo } ray =
    match Ray.distance_to_sphere ray ~center ~radius with
    | None -> None
    | Some d -> 
      let hit_point = Ray.calc_point ray d in
      let normal = Vector.direction_from_to center hit_point in
      Some (Intersection.create ~ray ~d ~color ~normal ~albedo)
end

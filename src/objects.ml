module type OBJECT = sig
  type t

  val create : t -> t
  val get_color : t -> Color.t
  (* val normal : t -> Point.t -> Vector.t *)
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

type plane_t = Point.t * Vector.t * Color.t
type sphere_t = Point.t * float * Color.t

module Plane : OBJECT
  with type t = plane_t
= struct
  type t = plane_t

  let create (point, vector, color) = 
    (point, Vector.normalize vector, color)
  let get_color (_, _, c) = 
    c
  let normal (pp, v, _) p =
    let pp_to_p = Vector.sub p pp in
    if Vector.dot v pp_to_p < 0.
    then Vector.mul (-1.) v
    else v
  let intersect ((pp, n, c) as t) ray = 
    let pr = Ray.point ray in
    let raydir_dot_n = Vector.dot n (Ray.direction ray) in
    if abs_float raydir_dot_n < Util.epsilon 
    then None (* 90deg, we want just one point *)
    else 
      let pp_dot_n = Vector.dot pp n
      and pr_dot_n = Vector.dot pr n in
      let d = (pp_dot_n -. pr_dot_n) /. raydir_dot_n in
      if not @@ Util.valid d then None
      else
        Some (Intersection.create ray d c @@ normal t pr)
end

module Sphere : OBJECT 
  with type t = sphere_t
= struct
  type t = sphere_t

  let create (center, radius, color) = 
    (center, radius, color)
  let get_color (_, _, c) = 
    c
  let normal (c, r, _) p = 
    Vector.sub p c |> Vector.normalize
  let intersect ((center, r, color) as t) ray =
    let raydir = Ray.direction ray
    and p = Vector.sub (Ray.point ray) center in

    let a = Vector.length2 raydir
    and b = 2. *. Vector.dot raydir p
    and c = Vector.length2 p -. r *. r in

    let delta = b ** 2. -. 4. *. a *. c in

    if delta < 0. then None
    else
      let return d =
        let hit_point = Ray.calc_point ray d in
        let normal = normal t hit_point in
        Some (Intersection.create ray d color normal)
      in
      let d1 = (-. b -. sqrt delta) /. (2. *. a) in
      if Util.valid d1 then return d1
      else
        let d2 = (-. b +. sqrt delta) /. (2. *. a) in
        if Util.valid d2 then return d2 else None
end

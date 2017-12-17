module type OBJECT = sig
  type t

  val create : t -> t
  val get_color : t -> Color.t
  val intersect : t -> Ray.t -> float option
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
  let intersect (pp, n, _) ray = 
    let pr = Ray.point ray
    and d = Ray.direction ray in
    let d_dot_n = Vector.dot d n in
    if abs_float d_dot_n < Util.epsilon 
    then None (* 90deg, we want just one point *)
    else 
      let pp_dot_n = Vector.dot pp n
      and pr_dot_n = Vector.dot pr n in
      let t = (pp_dot_n -. pr_dot_n) /. d_dot_n in
      if Util.valid t then Some t else None
end

module Sphere : OBJECT 
  with type t = sphere_t
= struct
  type t = sphere_t

  let create (center, radius, color) = 
    (center, radius, color)
  let get_color (_, _, c) = c
  let intersect (center, r, _) ray =
    let d = Ray.direction ray
    and p = Vector.sub (Ray.point ray) center in

    let a = Vector.length2 d
    and b = 2. *. Vector.dot d p
    and c = Vector.length2 p -. r *. r in

    let delta = b ** 2. -. 4. *. a *. c in

    if delta < 0. then None
    else
      let t1 = (-. b -. sqrt delta) /. (2. *. a) in
      if Util.valid t1 then Some t1
      else
        let t2 = (-. b +. sqrt delta) /. (2. *. a) in
        if Util.valid t2 then Some t2 else None
end

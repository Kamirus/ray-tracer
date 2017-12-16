module type RAY = sig
  type point
  type t

  val create : ?d_max:float -> point -> Vector.t -> t
  (** [create ?d_max position direction] ...
      d_max - maximum distance *)

  val calc_point : t -> float -> point
end


module Ray : RAY
  with type point = Vector.t
= struct
  type point = Vector.t
  type t = point * Vector.t * float

  let create ?(d_max=1.0e30) p v =
    let v = Vector.normalize v in
    (p, v, d_max)

  let calc_point (p, v, _) d =
    Vector.add p (Vector.mul d v)
end

include Ray

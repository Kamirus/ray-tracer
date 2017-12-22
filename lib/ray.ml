type t = Point.t * Vector.t * float

let create ?(max_d=Util.t_max) p v =
  (p, Vector.normalize v, max_d)

let source (p, _, _) = p

let direction (_, v, _) = v

let max_d (_, _, max_d) =
  max_d

let calc_point (p, v, _) t =
  Vector.add p (Vector.mul t v)

type t = Point.t * Vector.t

let create p v =
  (p, Vector.normalize v)

let source (p, _) = p

let direction (_, v) = v

let calc_point (p, v) t =
  Vector.add p (Vector.mul t v)

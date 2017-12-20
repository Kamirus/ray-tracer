type t

(** [create ?d_max position direction] ...
    d_max - maximum distance *)
val create : Point.t -> Vector.t -> t

val source : t -> Point.t

val direction : t -> Vector.t

val calc_point : t -> float -> Point.t

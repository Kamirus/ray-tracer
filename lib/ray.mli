type t

(** [create ?max_d position direction] ...
    max_d - maximum distance *)
val create : ?max_d:float -> Point.t -> Vector.t -> t

val source : t -> Point.t

val direction : t -> Vector.t

val max_d : t -> float

val calc_point : t -> float -> Point.t

type t

(** [create ?max_d position direction] ...
    max_d - maximum distance *)
val create : ?max_d:float -> Point.t -> Vector.t -> t

val source : t -> Point.t

val direction : t -> Vector.t

val max_d : t -> float

val calc_point : t -> float -> Point.t

(** [distance_to_sphere ray ~center ~radius]
    center - sphere center
    radius - sphere radius
*)
val distance_to_sphere : t -> center:Point.t -> radius:float -> float option

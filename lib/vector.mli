type t

val create : float -> float -> float -> t

val create_ints : int -> int -> int -> t
(** [create_ints x y z] create using integer values *)

val length : t -> float

val length2 : t -> float
(** [length2 t] same as (length t) ** 2. *)

val normalize : t -> t

val add : t -> t -> t

val sub : t -> t -> t

val neg : t -> t

val mul : float -> t -> t

val div : float -> t -> t

val dot : t -> t -> float

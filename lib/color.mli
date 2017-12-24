type t

val white : t
val black : t
val red : t
val green : t
val blue : t

val create : int -> int -> int -> t
val values : t -> int * int * int
val add : t -> t -> t
val mul : t -> t -> t
val mulf : float -> t -> t
val fit : t -> t

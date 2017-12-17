type t

val min_val : int
val max_val : int

val white : t
val black : t
val red : t
val green : t
val blue : t

val create : int -> int -> int -> t
val values : t -> int * int * int
val add : t -> t -> t
val mul : t -> t -> t
val mulf : t -> float -> t
val fit : ?min_v:int -> ?max_v:int -> t -> t

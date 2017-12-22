(** [raytracer path] takes path to json file
    and creates function, that takes pixel coordinates,
    returns it's color *)
val raytracer : string -> (int -> int -> Color.t option)
val settings : string -> (string * string * Color.t)

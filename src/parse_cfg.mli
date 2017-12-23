(** [raytracer path] takes path to json file
    and creates function, that takes pixel coordinates,
    returns it's color *)
val parse : string -> (int -> int -> Color.t) * string * string


(** [make_raytracer samples (module S) (module Struct)]
    takes # of antialiasing samples, Screen and Structure instances
    returns function which calculates pixel's color *)
let make_raytracer samples
    (module S : Screens.SCREEN_INSTANCE)
    (module Struct : Structures.STRUCTURE_INSTANCE) = 
  let rec aux i acc x y =
    let ray = S.S.pixel_ray S.this x y in
    if i <= 0 
    then Color.mulf (1. /. (float_of_int samples)) acc |> Color.fit
    else
      let c = Struct.S.calc_color Struct.this ray in
      aux (i - 1) (Color.add acc c) x y
  in
  aux samples Color.black

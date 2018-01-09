
let make_raytracer
    (module S : Screens.SCREEN_INSTANCE)
    (module Struct : Structures.STRUCTURE_INSTANCE) = 
  fun x y ->
    match S.S.pixel_ray S.this x y with
    | None -> 
      failwith "Screen rejected this ray"
    | Some ray -> 
      Struct.S.calc_color Struct.this ray

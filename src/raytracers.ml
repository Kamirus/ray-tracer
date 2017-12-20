module MakeRayTracer 
    (Screen : Screens.SCREEN) 
    (Structure : Structures.STRUCTURE)
= struct
  type t = { screen : Screen.t 
           ; structure : Structure.t }

  let create screen structure = 
    { screen; structure }

  let calc_color { screen; structure } x y = 
    match Screen.pixel_ray screen x y with
    | None -> 
      failwith "Screen rejected this ray"
    | Some ray -> 
      Structure.calc_color structure ray
end

module SimpleRayTracer = MakeRayTracer (Screens.NoPerspectiveFixedScreen) (Structures.ListStructure)

module RayTracerWithPerspectiveScreen = MakeRayTracer (Screens.PerspectiveScreen) (Structures.ListStructure)

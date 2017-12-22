module Ss = Structures

(* let screen = Screens.NoPerspectiveFixedScreen.create (800, 600) *)
let camera = Cameras.Camera.create 
    (Point.create_ints 40 30 (-100), Vector.create_ints 0 0 1, 100.)
let screen = Screens.PerspectiveScreen.create 
    (camera, 800, 600, 0.1)

let structure = 
  (* let light = Lights.create_instance (module Lights.Sun)
      { Lights.dir = Vector.create 0. (-.1.) 0.; Lights.color = Color.white } in *)
  let light = Lights.create_instance (module Lights.LightPoint)
      { Lights.source = Point.create_ints 30 40 44; 
      Lights.intensity = 30000.; Lights.color = Color.create 255 0 0 } in
  let light2 = Lights.create_instance (module Lights.LightPoint)
      { Lights.source = Point.create_ints 50 40 44;
      Lights.intensity = 30000.; Lights.color = Color.create 0 0 255 } in
  let plane = Objects.create_instance (module Objects.Plane)
      (Point.create_ints 40 20 44, Vector.create 0. 1. (-.0.1), Color.white) in
  let sphere = Objects.create_instance (module Objects.Sphere)
      (Point.create_ints 40 30 44, 10., Color.white) in
  Ss.ListStructure.create
    { Ss.lights = [light; light2]; Ss.objects = [plane; sphere] }

(* let tracer = Raytracers.SimpleRayTracer.create screen structure *)
let tracer = Raytracers.RayTracerWithPerspectiveScreen.create
    screen structure

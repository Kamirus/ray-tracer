let screen = Screens.NoPerspectiveFixedScreen.create (800, 600)

module Ss = Structures

let structure = 
  let light = Lights.create_instance (module Lights.Sun)
      (Point.create_ints 200 600 444) in
  let plane = Objects.create_instance (module Objects.Plane)
      (Point.create_ints 400 200 444, Vector.create 0. 1. (-.0.1), Color.green) in
  let sphere = Objects.create_instance (module Objects.Sphere)
      (Point.create_ints 400 300 444, 100., Color.red) in
  Ss.ListStructure.create
    { Ss.lights = [light]; Ss.objects = [plane; sphere] }

let tracer = Raytracers.SimpleRayTracer.create screen structure

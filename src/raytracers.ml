(* module type RAYTRACER = sig
  type t
  type config

  val create : config -> t
  val calc_color : t -> int -> int -> Color.t option
end

module MakeRayTracer
    (Screen : Screens.SCREEN) 
    (Structure : Structures.STRUCTURE) : RAYTRACER
  with type config = Screen.t * Structure.t
= struct
  type config = Screen.t * Structure.t
  type t = { screen : Screen.t 
           ; structure : Structure.t }

  let create (screen, structure) = 
    {screen; structure}

  let calc_color { screen; structure } x y = 
    match Screen.pixel_ray screen x y with
    | None -> 
      failwith "Screen rejected this ray"
    | Some ray -> 
      Structure.calc_color structure ray
end

module type RAYTRACER_INSTANCE = sig
  module RT : RAYTRACER
  val this : RT.t
end

let create_instance (type a) (module RT : RAYTRACER with type config = a) cfg = 
  (module struct 
    module RT = RT
    let this = RT.create cfg
  end : RAYTRACER_INSTANCE) *)

(* --- *)

(* module SimpleRayTracer = MakeRayTracer (Screens.NoPerspectiveFixedScreen) (Structures.ListStructure) *)

(* module RayTracerWithPerspectiveScreen = MakeRayTracer (Screens.PerspectiveScreen) (Structures.ListStructure) *)

let make_raytracer
    (module S : Screens.SCREEN_INSTANCE)
    (module Struct : Structures.STRUCTURE_INSTANCE) = 
  fun x y ->
    match S.S.pixel_ray S.this x y with
    | None -> 
      failwith "Screen rejected this ray"
    | Some ray -> 
      Struct.S.calc_color Struct.this ray

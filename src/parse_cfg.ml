module U = Yojson.Basic.Util

let get_type json =
  U.member "type" json |> U.to_string

let to_pair f json = 
  let take_pair = function
    | x :: y :: _ -> (x, y)
    | _ -> failwith "not enough for take_pair" in
  json |> U.to_list |> List.map f |> take_pair

let to_three f json = 
  let take_3 = function
    | x :: y :: z :: _ -> (x, y, z)
    | _ -> failwith "not enough for take_3" in
  json |> U.to_list |> List.map f |> take_3

let to_float json = 
  try begin
    try U.to_float json with
    | U.Type_error _ -> U.to_int json |> float_of_int
  end with
  | U.Type_error (msg, _) -> failwith @@ "to_float err: " ^ msg

let point json =
  let x, y, z = json |> to_three to_float in
  Point.create x y z

let vector json =
  let x, y, z = json |> to_three to_float in
  Vector.create x y z

let color ?(name="color") json =
  let r,g,b = json |> U.member name |> to_three U.to_int in
  Color.create r g b

let center json = 
  json |> U.member "center" |> point

let camera_instance json = 
  let c = center json in
  let forward = json |> U.member "forward" |> vector in
  let up = json |> U.member "up" |> vector in
  let d = json |> U.member "distanceFromScreen" |> to_float in
  Cameras.create_instance (module Cameras.Camera) (c, forward, up, d) 

let screen_instance json = 
  let perspective_screen json = 
    let (module C : Cameras.CAMERA_INSTANCE) = 
      json |> U.member "camera" |> camera_instance in
    let x, y = json |> U.member "resolution" |> to_pair U.to_int in
    let ratio = json |> U.member "unitsPerPixel" |> to_float in
    let module S = Screens.MakePerspectiveScreen (C.C) in
    Screens.create_instance (module S) (C.this, x, y, ratio)
  in
  match get_type json with
  | "PerpectiveScreen" -> perspective_screen json
  | other -> failwith @@ "screen type: " ^ other ^ " not supported"

let structure_instance ~objects ~lights json =
  let open Structures in
  match get_type json with
  | "ListStructure" -> 
    create_instance (module ListStructure) {objects; lights}
  | other -> failwith @@ "structure type: " ^ other ^ " not supported"

let object_instance json = 
  let plane json = 
    let p = json |> U.member "point" |> point in
    let normal = json |> U.member "normal" |> vector in
    let color = color json in
    Objects.create_instance (module Objects.Plane) (p, normal, color)
  in
  let sphere json = 
    let c = center json in
    let r = json |> U.member "radius" |> to_float in
    let color = color json in
    Objects.create_instance (module Objects.Sphere) (c, r, color)
  in
  match get_type json with
  | "Plane" -> plane json
  | "Sphere" -> sphere json
  | other -> failwith @@ "object type: " ^ other ^ " not supported"

let light_instance json = 
  let sun json = 
    let dir = json |> U.member "direction" |> vector in
    let color = color json in
    Lights.create_instance (module Lights.Sun) {Lights.dir; color} 
  in
  let light_point json = 
    let source = center json in
    let color = color json in
    let intensity = json |> U.member "intensity" |> to_float in
    Lights.create_instance (module Lights.LightPoint) 
      {Lights.source; color; intensity}
  in
  match get_type json with
  | "Sun" -> sun json
  | "LightPoint" -> light_point json
  | other -> failwith @@ "light type: " ^ other ^ " not supported"

let raytracer json_path = 
  let json = Yojson.Basic.from_file json_path in
  let screen =
    json |> U.member "screen" |> screen_instance in
  let objects =
    json |> U.member "objects" |> U.to_list |> List.map object_instance in
  let lights =
    json |> U.member "lights" |> U.to_list |> List.map light_instance in
  let structure = 
    json |> U.member "structure" |> structure_instance ~objects ~lights in
  Raytracers.make_raytracer screen structure

let settings json_path = 
  let json = Yojson.Basic.from_file json_path in
  let default_color = 
    json |> U.member "screen" |> color ~name:"defaultColor" in
  let x, y = 
    json |> U.member "screen" |> U.member "resolution" |> to_pair U.to_int in
  (string_of_int x, string_of_int y, default_color)

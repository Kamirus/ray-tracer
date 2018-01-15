module U = Yojson.Basic.Util

(* Basic building blocks *)

let get name f json =
  try U.member name json |> f with
  | Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing '%s'" err name

let get_list name f json = 
  try get name U.to_list json |> List.map f with
  | Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing list '%s'" err name

(* Custom convertions *)

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

(* Parsing basic types *)

let typ json =
  get "type" U.to_string json

let point name json =
  let x, y, z = json |> get name (to_three to_float) in
  Point.create x y z

let vector name json =
  let x, y, z = json |> get name (to_three to_float) in
  Vector.create x y z

let color ?(name="color") json =
  let r,g,b = json |> get name (to_three U.to_int) in
  Color.create r g b

(* settings *)
type settings = { default_color : Color.t
                ; max_rec : int
                ; no_indirect_samples : int
                ; is_indirect : bool
                ; samples : int }

let parse_settings json = 
  let get name f default json =
    try get name f json with
    | _ -> default
  in
  let indirect json = 
    let no_indirect_samples = json |> get "#samples" U.to_int 32 in
    let is_indirect = json |> get "turned on" U.to_bool false in
    (no_indirect_samples, is_indirect)
  in
  let default_color = json |> color ~name:"defaultColor" in
  let max_rec = json |> get "maxRecursion" U.to_int 10 in
  let no_indirect_samples, is_indirect = json |> get "indirectIllumination" indirect (32, false) in
  let samples = json |> get "#samples" U.to_int 1 in
  { default_color; max_rec; no_indirect_samples; is_indirect; samples }

(* Parsing compound objects *)

let camera_instance json = 
  let c = json |> point "center" in
  let forward = json |> vector "forward" in
  let up = json |> vector "up" in
  let d = json |> get "distanceFromScreen" to_float in
  Cameras.create_instance (module Cameras.Camera) (c, forward, up, d) 

let sensor_instance json = 
  let camera = camera_instance json in
  Cameras.create_instance (module Cameras.Sensor) (camera, )

let screen_instance json = 
  let perspective_screen json = 
    let (module C : Cameras.CAMERA_INSTANCE) = 
      json |> get "camera" camera_instance in
    let x, y = json |> get "resolution" @@ to_pair U.to_int in
    let ratio = json |> get "unitsPerPixel" to_float in
    let module S = Screens.MakePerspectiveScreen (C.C) in
    Screens.create_instance (module S) (C.this, x, y, ratio)
  in
  let main json =
    match typ json with
    | "PerpectiveScreen" -> perspective_screen json
    | other -> failwith @@ "screen type: " ^ other ^ " not supported"
  in
  try main json with Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing screen '%s'" err @@ typ json

let structure_instance ~objects ~lights 
    {default_color; max_rec; no_indirect_samples; is_indirect} json =
  let main json =
    let open Structures in
    match typ json with
    | "ListStructure" -> 
      create_instance (module ListStructure) {objects; lights; default_color; max_rec; no_indirect_samples; is_indirect}
    | other -> failwith @@ "structure type: " ^ other ^ " not supported"
  in
  try main json with Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing structure '%s'" err @@ typ json

let object_instance json = 
  let plane json = 
    let point = json |> point "point" in
    let normal = json |> vector "normal" in
    let albedo = json |> get "albedo" to_float in
    let color = json |> color in
    Objects.create_instance (module Objects.Plane) {Objects.point; normal; albedo; color}
  in
  let sphere json = 
    let center = json |> point "center" in
    let radius = json |> get "radius" to_float in
    let albedo = json |> get "albedo" to_float in
    let color = json |> color in
    Objects.create_instance (module Objects.Sphere) {Objects.center; radius; albedo; color}
  in
  let main json =
    match typ json with
    | "Plane" -> plane json
    | "Sphere" -> sphere json
    | other -> failwith @@ "object type: " ^ other ^ " not supported"
  in
  try main json with Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing object '%s'" err @@ typ json

let light_instance json = 
  let sun json = 
    let dir = json |> vector "direction" in
    let color = json |> color in
    Lights.create_instance (module Lights.Sun) {Lights.dir; color} 
  in
  let light_point json = 
    let source = json |> point "center" in
    let color = json |> color in
    let intensity = json |> get "intensity" to_float in
    Lights.create_instance (module Lights.LightPoint) 
      {Lights.source; color; intensity}
  in
  let light_sphere json =
    let center = json |> point "center" in
    let color = json |> color in
    let intensity = json |> get "intensity" to_float in
    let radius = json |> get "radius" to_float in
    Lights.create_instance (module Lights.LightSphere) 
      {Lights.center; color; intensity; radius}
  in
  let main json = 
    match typ json with
    | "Sun" -> sun json
    | "LightPoint" -> light_point json
    | "LightSphere" -> light_sphere json
    | other -> failwith @@ "light type: " ^ other ^ " not supported"
  in 
  try main json with Failure err -> failwith @@ Printf.sprintf "%s\nduring parsing light '%s'" err @@ typ json

let cast_list ?(acc=[]) lights =
  let cast (module L : Lights.LIGHT_INSTANCE) = 
    Objects.create_instance (module L.Light) L.this
  in
  List.fold_left (fun acc l -> cast l :: acc) acc lights

(* PUBLIC *)

let parse json_path = 
  let json = Yojson.Basic.from_file json_path in
  let screen = json |> get "screen" screen_instance in
  let objects = json |> get_list "objects" object_instance in
  let lights = json |> get_list "lights" light_instance in
  let objects = cast_list lights ~acc:objects in (* add lights to objects *)
  let settings = json |> get "settings" parse_settings in
  let structure = json |> get "structure" @@ structure_instance ~objects ~lights settings in
  let x, y = 
    json |> get "screen" @@ get "resolution" @@ to_pair U.to_int in
  let raytracer = Raytracers.make_raytracer settings.samples screen structure in
  (raytracer, string_of_int x, string_of_int y)

let parse json_path =
  try parse json_path with Failure err -> print_endline err; failwith err

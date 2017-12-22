module Y = Yojson.Basic

let filepaths =
  List.tl @@ Array.to_list Sys.argv
  |> List.map (fun n -> "cfgs/" ^ n ^ ".json")

module Parse = struct
  module U = Y.Util

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

  let point (x, y, z) =
    Point.create x y z

  let vector (x, y, z) =
    Vector.create x y z

  let color json =
    let r,g,b = json |> U.member "color" |> to_three U.to_int in
    Color.create r g b

  let center json = 
    json |> U.member "center" |> to_three U.to_float |> point

  let camera_instance json = 
    let c = center json in
    let dir = json |> U.member "direction" |> to_three U.to_float |> vector in
    let d = json |> U.member "distanceFromScreen" |> U.to_float in
    Cameras.create_instance (module Cameras.Camera) (c, dir, d) 

  let screen_instance json = 
    let perspective_screen json = 
      let (module C : Cameras.CAMERA_INSTANCE) = 
        json |> U.member "camera" |> camera_instance in
      let x, y = json |> U.member "resolution" |> to_pair U.to_int in
      let ratio = json |> U.member "unitsPerPixel" |> U.to_float in
      let module S = Screens.MakePerspectiveScreen (C.C) in
      Screens.create_instance (module S) (C.this, x, y, ratio)
    in
    match get_type json with
    | "PerpectiveScreen" -> perspective_screen json
    | other -> failwith @@ "screen type: " ^ other ^ " not supported"

  let object_instance json = 
    let plane json = 
      let p = json |> U.member "point" |> to_three U.to_float |> point in
      let normal = json |> U.member "normal" |> to_three U.to_float |> vector in
      let color = color json in
      Objects.create_instance (module Objects.Plane) (p, normal, color)
    in
    let sphere json = 
      let c = center json in
      let r = json |> U.member "radius" |> U.to_float in
      let color = color json in
      Objects.create_instance (module Objects.Sphere) (c, r, color)
    in
    match get_type json with
    | "Plane" -> plane json
    | "Sphere" -> sphere json
    | other -> failwith @@ "object type: " ^ other ^ " not supported"

  let light_instance json = 
    let sun json = failwith "not implemented" in
    let light_point json = 
      let source = center json in
      let color = color json in
      let intensity = json |> U.member "intensity" |> U.to_float in
      Lights.create_instance (module Lights.LightPoint) 
        {Lights.source; color; intensity}
    in
    match get_type json with
    | "Sun" -> sun json
    | "LightPoint" -> light_point json
    | other -> failwith @@ "light type: " ^ other ^ " not supported"
end

let () =
  let f filepath = 
    let json = Y.from_file filepath in
    let open Y.Util in
    let screen = member "screen" json in
    let objects = member "objects" json |> to_list in
    let lights = member "lights" json |> to_list in
    Y.to_string json |> print_endline
  in
  List.iter f filepaths


let to_filepath filename = 
  "cfgs/" ^ filename ^ ".json"

let render_on_screen filename =
  let path = to_filepath filename in
  let x, y, default_color = Parse_cfg.settings path in
  let resolution = x ^ "x" ^ y in
  let raytracer = Parse_cfg.raytracer path in
  Draw.draw ~default_color ~resolution ~raytracer

(* let filepaths =
  List.tl @@ Array.to_list Sys.argv
  |> List.map (fun n -> "cfgs/" ^ n ^ ".json") *)

let () =
  match Sys.argv with
  | [| _; filename |] -> render_on_screen filename
  | _ -> failwith "provide config file name"

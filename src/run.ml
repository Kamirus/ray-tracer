
let to_filepath filename = 
  "cfgs/" ^ filename ^ ".json"

let render_on_screen filename =
  let path = to_filepath filename in
  let raytracer, x, y, default_color = Parse_cfg.parse path in
  let resolution = x ^ "x" ^ y in
  Draw.draw ~default_color ~resolution ~raytracer

(* let filepaths =
  List.tl @@ Array.to_list Sys.argv
  |> List.map (fun n -> "cfgs/" ^ n ^ ".json") *)

let () =
  match Sys.argv with
  | [| _; filename |] -> render_on_screen filename
  | _ -> failwith "provide config file name"

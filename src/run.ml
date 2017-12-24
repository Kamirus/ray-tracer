
let to_filepath filename = 
  "cfgs/" ^ filename ^ ".json"

let render_on_screen filename =
  let path = to_filepath filename in
  let raytracer, x, y = Parse_cfg.parse path in
  let resolution = x ^ "x" ^ y in
  Draw.main ~resolution ~raytracer ~cfg:path

let toimage filename = 
  let path = to_filepath filename in
  let raytracer, x, y = Parse_cfg.parse path in
  let x_max = int_of_string x in
  let y_max = int_of_string y in
  Toimage.main ~x_max ~y_max ~name:filename ~raytracer

let () =
  match Sys.argv with
  | [| _; filename |] -> render_on_screen filename
  | [| _; filename; "save" |] -> toimage filename
  | _ -> failwith "provide config file name"

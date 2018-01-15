
let to_filepath filename = 
  "cfgs/" ^ filename ^ ".json"

let pixels ~xmax ~ymax ~raytracer =
  let a = Array.make_matrix xmax ymax Color.black in
  for x = 0 to xmax - 1 do
    for y = 0 to ymax - 1 do
      a.(x).(y) <- raytracer x y;
    done
  done;
  a

let get_gen_pixels filename =
  let path = to_filepath filename in
  fun () ->
    let raytracer, x, y = Parse_cfg.parse path in
    pixels ~raytracer ~xmax:(int_of_string x) ~ymax:(int_of_string y)

(* let () =
  Draw.main ~gen_pixels:(get_gen_pixels "c1") *)

let () =
  match Sys.argv with
  | [| _; filename |] -> 
    Draw.main ~gen_pixels:(get_gen_pixels filename)
  | [| _; filename; output_name |] -> 
    Toimage.main ~name:output_name ~pixels:(get_gen_pixels filename ())
  | _ -> failwith "provide config file name"


let to_filepath filename = 
  "cfgs/" ^ filename ^ ".json"

let fit arr maxv =
  let v = float_of_int maxv in
  print_float v; print_newline ();
  let f x =
    x |> float_of_int |> ( *.) 255. |> (/.) v |> int_of_float
    (* x |> float_of_int |> ( *.) (255. /. v) |> int_of_float *)
  in
  let one color =
    let r, g, b = Color.values color in
    Color.create (f r) (f g) (f b) 
  in
  let xmax = Array.length arr
  and ymax = Array.length arr.(0) in
  for x = 0 to xmax - 1 do
    for y = 0 to ymax - 1 do
      arr.(x).(y) <- one arr.(x).(y)
    done
  done

let pixels ~xmax ~ymax ~raytracer =
  let max cur_max color = 
    let r, g, b = Color.values color in
    cur_max |> max r |> max g |> max b
  in
  let maxv = ref 0 in (* current max value *)
  let a = Array.make_matrix xmax ymax Color.black in
  for x = 0 to xmax - 1 do
    for y = 0 to ymax - 1 do
      a.(x).(y) <- raytracer x y;
      maxv := max !maxv a.(x).(y);
    done;
  done;
  (* if !maxv > 255 then fit a !maxv; *)
  print_int !maxv; print_newline ();
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
  | [| _; filename; "save" |] -> 
    Toimage.main ~name:filename ~pixels:(get_gen_pixels filename ())
  | _ -> failwith "provide config file name"

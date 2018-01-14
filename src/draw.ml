open Graphics

let draw pixels =
  let xmax = Array.length pixels     in
  let ymax = Array.length pixels.(0) in
  for x = 0 to xmax - 1 do
    for y = 0 to ymax - 1 do
      let r, g, b = pixels.(x).(y) |> Color.values in
      rgb r g b |> set_color;
      plot x y;
    done
  done;
  auto_synchronize false;
  synchronize ()

let main ~gen_pixels =
  let pixels = gen_pixels () in
  let x = Array.length pixels     |> string_of_int in
  let y = Array.length pixels.(0) |> string_of_int in
  open_graph @@ " " ^ x ^ "x" ^ y;
  auto_synchronize false;
  clear_graph ();

  set_window_title "Ray Tracer @KamilListopad";

  draw pixels;

  (* loop forever *)
  let rec loop () : unit = 
    (* let _ = wait_next_event [Mouse_motion; Button_down; Button_up; Key_pressed] in *)
    Unix.sleep 1;
    gen_pixels () |> draw;
    loop ()
  in
  loop ()

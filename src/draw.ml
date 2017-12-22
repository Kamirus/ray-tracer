open Graphics

let draw ~resolution ~default_color ~raytracer =
  let calc_color x y = 
    match raytracer x y with
    | None -> default_color |> Color.values
    | Some c -> Color.values c
  in

  open_graph @@ " " ^ resolution;
  (* auto_synchronize false; *)
  clear_graph ();

  set_window_title "Ray Tracer @KamilListopad";

  for x = 0 to size_x () - 1 do
    for y = 0 to size_y () - 1 do
      let r, g, b = calc_color x y in
      rgb r g b |> set_color;
      plot x y;
    done
  done;
  synchronize ();

  (* loop forever *)
  let rec loop () : unit = 
    let _ = 
      wait_next_event [Mouse_motion; Button_down; Button_up; Key_pressed] in
    loop ()
  in
  loop ()

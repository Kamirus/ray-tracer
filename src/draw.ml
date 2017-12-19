open Graphics

let calc_color x y = 
  match Raytracers.RayTracerWithPerspectiveScreen.calc_color Testdata.tracer x y with
  | None -> Color.create 100 100 100 |> Color.values
  | Some c -> Color.values c

let draw resolution =
  open_graph @@ " " ^ resolution;
  auto_synchronize false;  
  clear_graph ();
  auto_synchronize true;

  set_window_title "Ray Tracer @KamilListopad";

  for x = 0 to size_x () - 1 do
    for y = 0 to size_y () - 1 do
      let r, g, b = calc_color x y in
      rgb r g b |> set_color;
      plot x y;
    done
  done;

  (* loop forever *)
  let rec loop () : unit = 
    let _ = 
      wait_next_event [Mouse_motion; Button_down; Button_up; Key_pressed] in
    loop ()
  in
  loop ()

let () =
  draw "800x600"

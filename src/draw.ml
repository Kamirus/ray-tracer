open Graphics

let () =
  open_graph " 800x600";
  auto_synchronize false;  
  clear_graph ();
  auto_synchronize true;

  set_window_title "wow it draws!";

  for x = 0 to size_x () do
    for y = 0 to size_y () do
      set_color yellow;
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

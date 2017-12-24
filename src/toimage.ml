let () =
  let width  = 800
  and length = 600
  and name   = "cool-pic.png" in
  let image = Image.create_rgb 800 600 in
  for x = 0 to 49 do
    for y = 0 to 100 do
      Image.write_rgb image x y 255 0 0;
    done;
  done;
  ImageLib.PNG.write_png name image

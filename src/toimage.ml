let main ~x_max ~y_max ~name ~raytracer =
  let name = "pics/" ^ name ^ ".png" in
  let image = Image.create_rgb x_max y_max in
  
  for x = 0 to x_max - 1 do
    for y = 0 to y_max - 1 do
      let c = raytracer x (y_max - 1 - y) in
      let r, g, b = Color.values c in
      Image.write_rgb image x y r g b
    done
  done;
  ImageLib.PNG.write_png name image

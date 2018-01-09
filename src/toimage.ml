let main ~name ~pixels =
  let name = "pics/" ^ name ^ ".png" in
  let xmax = Array.length pixels     in
  let ymax = Array.length pixels.(0) in
  let image = Image.create_rgb xmax ymax in

  for x = 0 to xmax - 1 do
    for y = 0 to ymax - 1 do
      let r, g, b = pixels.(x).(ymax - 1 - y) |> Color.values in
      Image.write_rgb image x y r g b
    done
  done;
  ImageLib.PNG.write_png name image

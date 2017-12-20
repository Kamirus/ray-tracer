module Y = Yojson.Basic

let filepaths =
  List.tl @@ Array.to_list Sys.argv
  |> List.map (fun n -> "cfgs/" ^ n)

let () =
  let f filepath = 
    let json = Y.from_file filepath in
    Y.to_string json |> print_endline
  in
  List.iter f filepaths

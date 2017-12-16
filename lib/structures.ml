module type STRUCTURE = sig
  type t

  val calc_color : t -> Ray.t -> Color.t option
end

(* --- *)

module Os = Objects
module Ls = Lights

type list_structure_t = 
  { lights  : (module Ls.LIGHT_INSTANCE ) list
  ; objects : (module Os.OBJECT_INSTANCE) list }

module ListStructure : STRUCTURE 
  with type t = list_structure_t
= struct
  type t = list_structure_t

  let closest objects ray = 
    let min (t : float) instance = function
      | None -> 
        Some (t, instance)
      | Some (prev_t, prev_this) as prev ->
        if t < prev_t then Some (t, instance)
        else prev
    in
    let rec aux objects acc = 
      match objects with
      | [] -> acc
      | (module I : Os.OBJECT_INSTANCE) as instance :: tail ->
        let t = I.Object.intersect I.this ray in
        match t with
        | None -> 
          aux tail acc
        | Some t -> 
          aux tail @@ min t instance acc
    in
    aux objects None

  let calc_color {lights; objects} ray =
    match closest objects ray with
    | None -> None
    | Some (t, instance) -> 
      let point = Ray.calc_point ray t in
      let colors = (* from point to every light *)
        let f (module L : Ls.LIGHT_INSTANCE) =
          let light_point = L.Light.point L.this in
          let direction = Vector.sub light_point point in
          let r = Ray.create point direction in
          match closest objects r with
          | None -> Some (L.Light.get_color L.this r)
          | Some _ -> None
        in
        Core.Std.List.filter_map ~f lights
      in
      let color = List.fold_left (fun acc c -> Color.add c acc) Color.black colors in
      Some (Color.fit color)
end

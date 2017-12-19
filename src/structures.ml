module type STRUCTURE = sig
  type config
  type t

  val create : config -> t
  val calc_color : t -> Ray.t -> Color.t option
end

(* --- *)

module Os = Objects
module Ls = Lights

type list_structure_t = 
  { lights  : (module Ls.LIGHT_INSTANCE ) list
  ; objects : (module Os.OBJECT_INSTANCE) list }

module ListStructure : STRUCTURE 
  with type config = list_structure_t and type t = list_structure_t
= struct
  type t = list_structure_t
  type config = list_structure_t

  let create cfg = 
    cfg

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
    (* check if ray hits sth *)
    match closest objects ray with
    | None -> None (* nope *)
    | Some (t, (module I : Os.OBJECT_INSTANCE)) -> 
      (* ray hit *)
      let hit_point = Ray.calc_point ray t in
      (* let rev_ray_direction = Vector.mul (-1.) (Ray.direction ray) in *)
      (* let obj_normal = I.Object.normal I.this hit_point in *)
      let colors =
        let f (module L : Ls.LIGHT_INSTANCE) =
          let light_point = L.Light.point L.this in
          let direction = Vector.sub light_point hit_point in
          let r = Ray.create hit_point direction in
          match closest objects r with
          | None ->
            let sunlight = L.Light.get_color L.this r in
            let objcolor = I.Object.get_color I.this in
            let full_color = Color.mul sunlight objcolor in
            (* let k = max 0. (Vector.dot obj_normal rev_ray_direction) in *)
            (* let color = Color.mulf full_color k in *)
            Some (full_color)
          | Some _ -> None
        in
        Core.Std.List.filter_map ~f lights
      in
      let color = List.fold_left (fun acc c -> Color.add c acc) Color.black colors in
      Some (Color.fit color)
end

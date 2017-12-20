module type STRUCTURE = sig
  type config
  type t

  val create : config -> t
  val calc_color : t -> Ray.t -> Color.t option
end

(* --- *)

module Os = Objects
module Ls = Lights
module I = Intersection

(** [facing_ratio color normal dir] apply simple shader
    color - 100% color without shading
    normal - object's normal vector
    dir - direction of the ray (from point to light) *)
let facing_ratio color normal dir =
  let ratio = Vector.dot normal dir in
  Color.mulf color ratio

let ray_from_point_to_light point (module L : Ls.LIGHT_INSTANCE) = 
  L.Light.ray_to_light L.this point

(* Assume that point is being lit by L (not blocked by anything)
   calculate the partial color in this position provided by L light *)
let color_by_single_light { I.biased_point; I.color; I.normal } 
    (module L : Ls.LIGHT_INSTANCE) =
  let sunlight = L.Light.get_color L.this biased_point in
  let full_color = Color.mul sunlight color in
  (* shading *)
  let dir = L.Light.ray_to_light L.this biased_point |> Ray.direction in
  facing_ratio full_color normal dir

(* --- *)

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
    let min ({ I.d } as intersection) = function
      | None -> 
        Some intersection
      | Some { I.d = prev_d } as acc ->
        if d < prev_d then Some intersection
        else acc
    in
    let rec aux objects acc = 
      match objects with
      | [] -> acc
      | (module O : Os.OBJECT_INSTANCE) :: tail ->
        match O.Object.intersect O.this ray with
        | None -> 
          aux tail acc
        | Some intersection -> 
          aux tail (min intersection acc)
    in
    aux objects None

  let calc_color {lights; objects} ray =
    (* check if ray hit sth *)
    match closest objects ray with
    | None -> None (* nope *)
    | Some ({ I.d; I.biased_point } as intersection) -> 
      (* --- *)
      (* TODO: global illumination *)
      (* TODO: reflect (and/or refract) if object surface allows to *)
      (* calc colors from every light and add them *)
      let color_from_lights = 
        let f acc light = 
          let ray = ray_from_point_to_light biased_point light in
          match closest objects ray with
          | None ->
            let c = color_by_single_light intersection light in
            Color.add acc c
          | Some _ -> acc
        in
        List.fold_left f Color.black lights
      in
      (* combine colors *)
      Some (Color.fit color_from_lights)
end

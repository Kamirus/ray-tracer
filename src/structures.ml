module type STRUCTURE = sig
  type config
  type t

  val create : config -> t
  val calc_color : t -> Ray.t -> Color.t
end

module type STRUCTURE_INSTANCE = sig
  module S : STRUCTURE
  val this : S.t
end

let create_instance (type a) (module S : STRUCTURE with type config = a) cfg = 
  (module struct 
    module S = S
    let this = S.create cfg
  end : STRUCTURE_INSTANCE)

(* --- *)

module Os = Objects
module Ls = Lights
module I = Intersection
module V = Vector

(** [facing_ratio color normal dir] apply simple shader
    color - 100% color without shading
    normal - object's normal vector
    dir - direction of the ray (from point to light) *)
let facing_ratio color normal dir =
  let ratio = V.dot normal dir in
  Color.mulf ratio color

let ray_from_point_to_light point (module L : Ls.LIGHT_INSTANCE) = 
  L.Light.ray_to_light L.this point

(* Assume that point is being lit by L (not blocked by anything)
   calculate the partial color in this position provided by L light *)
let color_by_single_light { I.biased_point; I.color; I.normal } ray_dir
    (module L : Ls.LIGHT_INSTANCE) =
  let sunlight = L.Light.calc_color L.this biased_point in
  let full_color = Color.mul sunlight color in
  (* shading *)
  (* let dir = L.Light.ray_to_light L.this biased_point |> Ray.direction in *)
  facing_ratio full_color normal ray_dir

let reflect {I.biased_point; I.normal; I.albedo; I.ray} calc_color = 
  let rd = Ray.direction ray in
  let dir = V.sub rd @@ V.mul (2. *. V.dot normal rd) normal in
  let ray = Ray.create biased_point dir in
  let color = calc_color ray in
  Color.mulf albedo color

(** compute indirect illumination *)
let indirect {I.biased_point; I.normal; I.albedo; I.ray} calc_color no_indirect_samples = 
  let rec aux j acc = 
    if j > no_indirect_samples then acc
    else
      let dir = Util.rand_dir normal in
      let ray = Ray.create biased_point dir in
      aux (j + 1) @@ Color.add acc @@ calc_color ray
  in
  aux 0 Color.black
  |> Color.mulf @@ 1. /. float_of_int no_indirect_samples

(* --- *)

type list_structure_t = 
  { lights  : (module Ls.LIGHT_INSTANCE ) list
  ; objects : (module Os.OBJECT_INSTANCE) list
  ; default_color : Color.t
  ; max_rec : int
  ; no_indirect_samples : int
  ; is_indirect : bool }

module ListStructure : STRUCTURE 
  with type config = list_structure_t
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

  (** compute direct illumination *)
  let direct {objects; lights} ({I.biased_point; I.albedo} as intersection) =
    if albedo >= 1. then Color.black
    else 
      let f acc light = 
        let ray = ray_from_point_to_light biased_point light in
        match closest objects ray with
        | None ->
          let c = color_by_single_light intersection (Ray.direction ray) light in
          Color.add acc c
        | Some _ -> acc
      in
      List.fold_left f Color.black lights

  let calc_color ({objects; max_rec; no_indirect_samples; is_indirect; default_color} as t) ray =
    let rec aux b k ray =
      (* check if ray hit sth *)
      match closest objects ray with
      | None -> default_color (* nope *)
      | Some ({I.albedo} as intersection) -> 
        (* --- *)
        let reflected = 
          if albedo > 0. && k < max_rec
          then reflect intersection (aux b @@ k + 1)
          else Color.black in
        let direct_c = direct t intersection in
        let indirect_c = 
          if b && albedo < 1. && k < max_rec
          then indirect intersection (aux false @@ k + 1) no_indirect_samples
          else Color.black in
        (* combine colors *)
        Color.add direct_c indirect_c
        |> Color.mulf (1. -. albedo)
        |> Color.add reflected
    in
    Color.fit @@ aux is_indirect 1 ray
end

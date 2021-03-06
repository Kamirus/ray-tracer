(* biased_point - slightly corrected hitpoint
   to ensure that this point is above the surface *)
type t = { ray : Ray.t
         ; d : float
         ; color : Color.t
         ; albedo : float
         ; normal : Vector.t
         ; biased_point : Point.t }

(** [create ~ray ~d ~color ~normal ~albedo] Create intersection
    ray - that hit the object
    d - distance from ray.source to hit point
    color - object full color at the hit point
    normal - normal vector 
    albedo - object's reflected_light / received_light *)
let create ~ray ~d ~color ~normal ~albedo = 
  let normal = Vector.normalize normal in
  let hit_point = Ray.calc_point ray d in
  let biased_point = Vector.add hit_point (Vector.mul Util.epsilon normal) in
  { ray; d; color; normal; biased_point; albedo }

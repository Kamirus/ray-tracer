let epsilon = 0.001
let t_max = max_float
let pi = 3.14159265359
let max_rec = 10

let valid t = 
  epsilon <= t && t <= t_max

(** [rand_dir ?cosmin normal]
    creates random vector-direction so that
    result is tilted relative to [normal] by angle in range [0, A]
    where A is described by cosA in range [cosmin, 1]
    example: default cosmin=0 yields results tilted by max 90deg *)
let rand_dir ?(cosmin=0.) normal =
  let coordinate_system n =
    let (x, y, z) = Vector.values n in
    let nt = if abs_float x > abs_float y
      then Vector.create z 0. (-.x)
           |> Vector.mul @@ 1. /. sqrt (x *. x +. z *. z)
      else Vector.create 0. (-.z) y 
           |> Vector.mul @@ 1. /. sqrt (y *. y +. z *. z) in
    let nb = Vector.cross n nt in
    nt, nb
  in
  let sample () =
    let r1 = Random.float (1. -. cosmin) +. cosmin in (* cos(theta) = r1 = y *)
    let r2 = Random.float 1. in
    let sin_theta = 1. -. r1 *. r1 |> sqrt in 
    let phi = 2. *. pi *. r2 in
    let x = sin_theta *. cos phi in 
    let z = sin_theta *. sin phi in
    (x, r1, z)
  in
  let nt, nb = coordinate_system normal
  and sx, sy, sz = sample ()
  and nx, ny, nz = Vector.values normal in
  let ntx, nty, ntz = Vector.values nt in
  let nbx, nby, nbz = Vector.values nb in
  (* translate *)
  Vector.create
    (sx *. nbx +. sy *. nx +. sz *. ntx)
    (sx *. nby +. sy *. ny +. sz *. nty)
    (sx *. nbz +. sy *. nz +. sz *. ntz)

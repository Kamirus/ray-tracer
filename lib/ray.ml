type t = Point.t * Vector.t * float

let create ?(max_d=Util.t_max) p v =
  (p, Vector.normalize v, max_d)

let source (p, _, _) = p

let direction (_, v, _) = v

let max_d (_, _, max_d) =
  max_d

let calc_point (p, v, _) t =
  Vector.add p (Vector.mul t v)

let distance_to_sphere (source, raydir, max_d) ~center ~radius =
  let p = Vector.sub source center in

  let a = Vector.length2 raydir
  and b = 2. *. Vector.dot raydir p
  and c = Vector.length2 p -. radius ** 2. in

  let delta = b ** 2. -. 4. *. a *. c in

  if delta < 0. then None
  else
    let valid x = Util.valid x && x <= max_d in
    let x1 = (-. b -. sqrt delta) /. (2. *. a) in
    if valid x1 then Some x1
    else
      let x2 = (-. b +. sqrt delta) /. (2. *. a) in
      if valid x2 then Some x2
      else None

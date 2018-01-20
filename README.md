# Ray Tracer


## What is it?
The program is used to render the 3D scene view. Description of the scene is loaded from input file. Rendering technique: [**ray tracing**](https://en.wikipedia.org/wiki/Ray_tracing_(graphics))


## How to build and run?
- Get *ocaml* and *opam* installed
- Install other dependencies (using `opam install ...`): *ocamlbuild*, *yojson*, *imagelib*
- `make run`
- `./run.native c1`


## How to use it?
 - **usage: `./run.native <CFG> [<OUTPUT>]`**
 - *note: paths are relative to your working directory*
 - `<CFG>` = filename (without extension) in `./cfgs/` directory *(example: to run file `./cfgs/c1.json` -> `./run.native c1`)*
 - to show rendered scene on screen just provide 1st argument
 - 2nd argument is used to save rendered scene as **png** file under `./pics/<OUTPUT>.png` path


## Scene description
 - examples can be found in `cfgs/` directory
 - more detailed information about format and available options is in `DESC.md`


## Implemented features
Available objects to render: **sphere**, **plane**.

Every object has position properties, but also **color** and **albedo**. Albedo values are in range [0.0, 1.0], where 1.0 means perfect mirror and 0.0 describes perfectly diffusing surface. 

Available light sources: **sun**, **light point**, **light sphere**. **Sun** illuminates scene from one direction. **Light point** is meant to work like light bulb except that it's invisible in the scene.

**Light sphere** can be seen as very bright sphere that emits light rays like **light point**, more interestingly it can be used to aquire effects like **soft shadows** or it can illuminate objects indirectly via mirrors.

Scene is being rendered from **Camera** point of view. The camera can be modeled as a single point in 3D space or as a rectangular sensor (receptor). First method produces a very sharp image while the sensor reduces **depth of field** (the wider the more).

To reduce pixelated edges (aliasing) method called **supersampling** was implemented. For every pixel more rays are shot (it linearly extends the rendering time). Quality can be set in scene description file.

To simulate how light is bounced off of diffuse surfaces onto others (indirect light), method called **global illumination** was implemented. Quality can be set in scene description file.

Others:
- **simple shading** - facing ratio
- **perspective screen**
- rendered picture on screen is being rerender every 1s to apply changed settings without restarting program


## Flow of control

Simple command line handler in `run.ml` orders `parse_cfg.ml` to parse scene description file, which as a result returns **raytracer** function that takes x and y coordinates of a pixel and produces *color*. It's used to create 2D array of *colors* that corresponds to every pixel that is going to be rendered next by `draw.ml` (or saved as an image by `toimage.ml`)

Let's focus now what is being done in **raytracer** function.

First **(x, y)** pixel coordinates are being traslated by **Screen** (from `screens.ml`) into *ray*. So in order to find color for (x, y) pixel, we need to know where the *ray* hit. 

The *ray* is being passed to **Structure** (from `structures.ml`). It's job is to test this ray against every **Object** (from `objects.ml`) to determine closest *intersection* with the *ray*. Now having point of *intersection* with the closest **Object** we have to tell what's color out there. Here we need to separately calculate **reflection**, **direct** and **indirect illumination**.

Computing **reflection** is pretty straight forward, we just produce reflected ray (according to law of reflection) and recursively calculate the color.

To calculate **direct illumination** we need to know which **Light** (from `lights.ml`) contributes light directly at the intersection point. Then shading is applied to the resulted color. 

**indirect illumination** is acquired by shooting many random rays, tracing them recursively to get colors and averaging the result.

These three parts of the color are combined together based on albedo (the ratio of reflected light to received) of the **Object**.


## Architecture

This project is divided into two parts: `lib` and `src`. First contains modules which interfaces are unlikely to change, so these can be considered as simple building blocks (like vectors, colors, rays, etc.).

### Core

Every module (example: `foos.ml`) listed below contains signature (`FOO`) and one or many implementations (`FuzzyFoo`, `Foo`, ...). 

In every signature there's `create` function that returns structured information about created 'thing', which is necessary for every other function in signature (it's like constructing object in OOP language, but the result is just *state* (fields) without methods) (`create : ... -> Foo.t`).

Now in order to bound created state (`Foo.t`) with it's implementation (`module Foo`), there is function that takes these two values and encapsulates them in the **module instance** (of type `FOO_INSTANCE`)

- `raytracers.ml` - has one constructor function that takes number of samples (from supersampling) and instance of **Screen** and **Structure**. Antialiasing is implemented here. Every sample is traced independently, then re

- `screens.ml` -

- `cameras.ml` -

- `structures.ml` -

- `objects.ml` -

- `lights.ml` -

### Miscellaneous

run
parse_cfg
draw
toimage

---

# TODO

## Key features
- [x] configuration file
- [ ] raport
- [ ] documentation
- [x] update cfg specification
- [x] perspective camera
- [x] dump to img file

## Other features
- [x] decrease in light intensity
- [x] configurable screen (position, resolution)
- [x] simple shading - `Facing Ratio`
- [x] new surface type: mirror
- [x] mixed surface type (diffuse + reflection)
- [x] DOF
- [x] supersampling (+ configurable in cfg)
- [x] soft shadows for LightSphere
- [x] indirect illumination (+ configurable in cfg)
- [ ] Gamma correction

## Improvements
- [x] configurable light color
- [x] extract calculatin color out of structure module
- [x] interactive cfg (reload after a few seconds)
- [x] rename ray.point to ray.source
- [ ] use records instead of type tuples
- [x] usefull err messages for cfg
- [x] configurable max recursion and indirect illumination
- [ ] creating needed directories for cfgs and pics
- [x] color scaling (other branch)
- [ ] customizable recursion depth in indirect lightning

## Bugs
- [x] sqrt vs ** 2.
- [x] restrict ray distance `(bug1.json)`
- [x] `bug2.json` weird picture stretching
- [x] implement sun parsing in cfg
- [x] objs are not being lit by reflected light (indirect illumination && hittable lights)
- [x] keep proportions independently from resolution

## Descoped
- [ ] merge objects and lights

---

Misc:
```bash
for x in $(ls cfgs | grep .json | cut -d "." -f1); do ./run.native $x $x & done;
```

reflections -> m1

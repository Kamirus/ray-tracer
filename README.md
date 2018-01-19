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

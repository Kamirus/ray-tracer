# Ray Tracer

## Dependencies
| package    | version  |
| ---------- | -------- |
| ocaml      | ?        |
| ocamlbuild | ?        |
| graphics   | 1.0      |
| graphics   | 1.0      |
| yojson     | 1.4.0    |
| imagelib   | 20170118 |

## Usage
1. **Build:** `make`
2. Make sure directiories named `cfgs` and `pics` are created
3. `cfgs` contains scene description files (more info `DESC.md`)
4. `pics` is used to store saved images
5. **Run:** `./run.native <cfg_filename> [save]`
6. **Example:** `./run.native c1`
7. **Example:** `./run.native c3 save` to save image in `pics/c3.png`


# TODO

## Key features
- [x] configuration file
- [ ] raport
- [ ] documentation
- [ ] update cfg specification
- [ ] update dependecies
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

# Questions
- [x] Multiple light sources? -> add colors
- [x] Ray from camera can hit obj before reaching screen: bug or feature? -> feature
- [x] How to do glowing objects? How to shoot ray(s) from point to this object?
- [x] How to implement indirect illumination via mirrors (not only planes)

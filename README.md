# Ray Tracer

# TODO

## Key features
- [x] configuration file
- [ ] raport
- [ ] documentation - .mli's
- [x] perspective camera
- [ ] dump to img file

## Other features
- [x] decrease in light intensity
- [x] configurable screen (position, resolution)
- [x] simple shading - `Facing Ratio`
- [x] new surface type: mirror
- [x] mixed surface type 
- [ ] Gamma correction
- [ ] merge objects and lights
- [ ] better structure - optimization
- [ ] shutter + physical sizes of light sources
- [ ] supersampling
- [ ] creating needed directories for cfgs and pics

## Improvements
- [x] configurable light color
- [x] extract calculatin color out of structure module
- [ ] plane slice
- [x] rename ray.point to ray.source
- [ ] use records instead of type tuples
- [ ] usefull err messages for cfg
- [ ] better interactive cfg
- [ ] configurable max recursion
- [ ] eliminate not tail recursive calls

## Bugs
- [x] sqrt vs ** 2.
- [x] restrict ray distance `(bug1.json)`
- [x] `bug2.json` weird picture stretching
- [x] implement sun parsing in cfg
- [ ] objs are not being lit by reflected light

# Questions
- [x] Multiple light sources? -> add
- [ ] Ray from camera can hit obj without reaching screen: bug or feature?
- [ ] How to do glowing objects? How to shoot ray(s) from point to this object?
- [ ] How to implement indirect illumination via mirrors (not only planes)
- [ ] wtf ... * albedo / PI in *)

# Ray Tracer

## TODO

### Key features
- [x] configuration file
- [ ] raport
- [ ] documentation - .mli's
- [x] perspective camera
- [ ] dump to img file

### Other features
- [x] decrease in light intensity
- [x] configurable screen (position, resolution)
- [x] simple shading - `Facing Ratio`
- [x] new surface type: mirror
- [x] mixed surface type 
- [ ] Gamma correction
- [ ] better structure - optimization
- [ ] shutter + physical sizes of light sources

### Improvements
- [x] configurable light color
- [x] extract calculatin color out of structure module
- [ ] plane slice
- [x] rename ray.point to ray.source
- [ ] use records instead of type tuples
- [ ] usefull err messages for cfg
- [ ] interactive cfg

### Bugs
- [x] sqrt vs ** 2.
- [x] restrict ray distance `(bug1.json)`
- [x] `bug2.json` weird picture stretching
- [x] implement sun parsing in cfg

## Questions
- [x] Multiple light sources? -> add

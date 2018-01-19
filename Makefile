OCB_FLAGS = -use-ocamlfind
OCB = ocamlbuild $(OCB_FLAGS)

run: run.native

all: basics complex cfgs

basics: vector.cmo point.cmo ray.cmo color.cmo util.cmo intersection.cmo

complex: screens.cmo cameras.cmo objects.cmo lights.cmo structures.cmo raytracers.cmo

cfgs: draw.cmo parse_cfg.cmo toimage.cmo run.cmo

clean: 
	$(OCB) -clean
	rm -f *.native
	rm -f *.byte

%.native:
	$(OCB) $@

%.byte:
	$(OCB) $@

%.cmo:
	$(OCB) $@

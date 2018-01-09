# just for `%.top:` target
OCAMLINIT_PATH = "/home/kamirus/.ocamlinit"

OCB_FLAGS = -use-ocamlfind
OCB = ocamlbuild $(OCB_FLAGS)

run: run.native

all: basics complex cfgs

basics: vector.cmo point.cmo ray.cmo color.cmo util.cmo intersection.cmo

complex: screens.cmo objects.cmo lights.cmo structures.cmo raytracers.cmo

cfgs: draw.cmo parse_cfg.cmo toimage.cmo

clean: 
	$(OCB) -clean
	rm -f *.native
	rm -f *.byte

test:
	$(OCB) test.native
	./test.native

%.native:
	$(OCB) $@

%.byte:
	$(OCB) $@

%.cmo:
	$(OCB) $@

%.top: %.cmo
	cat $(OCAMLINIT_PATH) > .ocamlinit_tmp
	for file in $(shell find ./_build -type d); do \
		echo "#directory \"$$file\";;" >> .ocamlinit_tmp;\
	done
	echo '#load_rec "$<";;' >> .ocamlinit_tmp
	utop -init .ocamlinit_tmp

OUT_DIR:=build
CMD="openscad"
MKDIR_P = mkdir -p

.PHONY: directories

top_level_modules_2d:=\
	base-plate-outline.scad\
	base-pcb-outline.scad\
	design-under-test-pcb-outline.scad\
	base-plate-support-combined-outline.scad\
	pressure-plate-outline.scad\
	cradle-support-bracket-outline.scad\
	support-plate-jig-a-outline.scad


top_level_modules_3d:=\
	cradle.scad
	#assembly.scad\
	#cradle_assembly.scad


setting_files:=alignment-pins.csv\
	pressure-pins.csv\
	probes.csv


generated_source:=$(setting_files:.csv=.scad)
objects_base:=$(top_level_modules_2d:.scad=.svg)
objects_base:=$(objects_base) $(top_level_modules_2d:.scad=.dxf)
objects_base:=$(objects_base) $(top_level_modules_2d:.scad=.png)
objects_base:=$(objects_base) $(top_level_modules_2d:.scad=.eps)
objects_base_3d:=$(top_level_modules_3d:.scad=.png)
objects_base_3d:=$(objects_base_3d) $(top_level_modules_3d:.scad=.amf)
objects_base_3d:=$(objects_base_3d) $(top_level_modules_3d:.scad=.stl)
objects_base_3d:=$(objects_base_3d) $(top_level_modules_3d:.scad=.png)
objects_2d := $(addprefix $(OUT_DIR)/,$(objects_base))
objects_3d := $(addprefix $(OUT_DIR)/,$(objects_base_3d))


all: directories ${generated_source} ${objects_2d} ${objects_3d}

clean:
	rm $(objects_2d)
	rm $(objects_3d)

print:
	echo $(objects_2d)
	echo $(objects_3d)

directories: ${OUT_DIR}

${OUT_DIR}:
	        ${MKDIR_P} ${OUT_DIR}


objects_dir:=../../source/press-jig-type-a/objects
${OUT_DIR}/%.stl: ${objects_dir}/%.scad
	${CMD} -m make -o $@ -d $@.deps $<

${OUT_DIR}/%.svg: ${objects_dir}/%.scad
	${CMD} -m make -o $@ -d $@.deps $<

${OUT_DIR}/%.eps: ${OUT_DIR}/%.svg ${objects_dir}/%.scad 
	inkscape $< --export-eps=$@
	#${CMD} -m make -o $@ -d $@.deps $<

${OUT_DIR}/%.dxf: ${objects_dir}/%.scad
	${CMD} -m make -o $@ -d $@.deps $<

${OUT_DIR}/%.png: ${objects_dir}/%.scad
	${CMD} -m make -o $@ -d $@.deps $< --imgsize 1024,1024 --preview #--viewall --autocenter#--projection=p --colorscheme Sunset# --view axes --view scales --camera translate_x

${OUT_DIR}/%.amf: ${objects_dir}/%.scad
	${CMD} -m make -o $@ -d $@.deps $<

${generated_source}: ${setting_files}
	python3 ../../bin/dataframe_to_openscad.py --alignment-pins alignment-pins.csv --probes probes.csv --pressure-pins pressure-pins.csv


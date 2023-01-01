+ Each section imports the design
+ Design modules etc. only used for a single model are only in the corresponding models directory

+ cradle should be able to plug into various types of jigs
    + Needs enough mounting holes


+ For building, designing, and exporting without confusion (WYSIWYG) have a file for each object concept with no design dependancies.
    + In the assembly or sub assembly have a module with no inputs which makes a concrete object. This is then called in another file to allow exporting.
    + a concrete file should have a single use statement and a single module call.
    + When more than a single concrete object is desired, make a seperate file
+ For parts that can be 2d the assembly should extrude the part with the top level module being the projection.


## Module Naming
    + top level modules have no arguments, are centered at 0,0, named the object
    + Creation templates are wrapped by a top level module to set the config data
        + These are named make_*
    + Other modules can be named however following a decent style code



## Manuafacturing
    + Export the 2d and 3d models with a make file
    + Each object has a translation unit that we can call
    + The 2D parts will be milled or laser cut
    + Find ways of putting parts in parts, merge the pcb baseplate and the support plate


TODO
    + Add generation of design file from config



## Build
+ Break parts into categories of 3d and 2d parts, compile the matching types


+ For customization all variables need to exist in the top module


## File types
+ Top level: Intended for use with a customizer, breaks settings out to abstractions
+ Abstraction: Expresses the idea of a part without holding the concrete data.
+ Object: Calls a top level module only, allowing a part to be created
+ Assembly: Brings together inter related designs. Objects call modules in this to make objects.



## Reuse
+ Sections that are to be reused need to have the data pertaining to them broken off to a standalone module.
+ Tool sets can be used but should be minimized to describe the part as simply and in as stand alone manner as possible.
+ Would like more interchangable parts so the craddle should be the same size if possible

+ If the craddle size is the same for different boards then only the craddle needs to be replaced


+ Pressure pins are mirrored relative to board position like the probes
+ Add pressure pin positions to the PCB on a drawing label with the correct radius, this will help avoid interferace.
    + There are only a few pressure pins so these are chosen by hand.
    + One option is using a large grid and assembling as needed.
        + 5mm seems to be good, choose the location on the resulting grid
            + Use drill press for this?


+ Standard libraries are added to the OPENSCADPATH, these are submoduled
+ Add a shell script with the OPENSCADPATH that can be sourced
+ soft link or copy the assembly and craddle_assembly files
+ Set the construction type with the OPENSCADPATH


+ setup environment by adding setup-shell-environment.sh setting OPENSCADPATH
+ run source setup-shell-environment.sh && make all -j${nproc --all}
+ To run openscad normally with the assembly the press-jig files can be softlinked in (ln -s press-jig-type-a/* ./). This will work identically as adding press-jig-type-a to the path. The path to the library will still need to be included. The assembly in the library can also be used as the path is set.




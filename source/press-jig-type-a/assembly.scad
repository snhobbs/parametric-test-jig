/*
  Version 0.1.0:
    - First Version
 
  Version 0.1.1:
    ## Issues
    - Support plate holes should be clearance holes if the material is not steel.
    - Pressure plate center hole is too small
    - Hardware mounting holes on pressure plate are incorrectly places  
    - Support plate should have clearance holes if acrylic
    - Base plate needs more edge clearance
    - Use acrylic for all plates, cut from single piece
*/


include<design.scad>

use<cradle_assembly.scad>;
use<press-jig-type-a/pressure-plate.scad>;
use<press-jig-type-a/support-plate.scad>;
use<press-jig-type-a/test-jig-press-type-a.scad>;

use<openscad-testjig-components/pressure-pins/pressure-pins.scad>;
use<openscad-testjig-components/standoffs.scad>;
use<openscad-utilities/tools.scad>;
use<openscad-utilities/fasteners.scad>;


use<press-jig-abstractions/base-plate.scad>;
use<press-jig-abstractions/design-under-test-pcb.scad>;
use<press-jig-abstractions/base-pcb.scad>;
use<press-jig-abstractions/cradle-support-bracket.scad>;



/* [View] */
$fa=1;
$fs=1;
$fn=72;
$vpr = [ 83.00, 0.00, 6.10 ];
$vpd=140.0;

pressure_plate=true;
dut = true;
cradle=true;
screws=true;
support=true;
bracket_supports = true;
pcb_assembly=true;
cradle_clearance = 1;//get_cradle_clearance();

/* [Options] */
pcb_thickness = 1.6;
acrylic_thickness = 25.4/4;
steel_thickness = 3;
pressure_pin_length = 20;

materials = [
    ["steel", "grey", steel_thickness],
    ["acrylic", "blue", acrylic_thickness],
    ["pcb", "green", pcb_thickness]
];

dut_pcb_thickness = pcb_thickness;
function get_pressure_pin_fastener() = "M3";


function get_pressure_pin_length() = pressure_pin_length;
function get_cradle_clearance() = cradle_clearance;

function get_through_all_height() = 1000;

function cradle_bottom_z() = get_cradle_pcb_support_height() + get_cradle_base_height();


/*  Tools & Orphans  */
module round_head_bolt(d, l, hd) {
    union(){
        translate([0,0,-l/2])cylinder(h=l, d=d, center=true);
        difference(){
            sphere(r=hd/2);
            translate([0,0,-get_through_all_height()/2])cube([100,100,get_through_all_height()], center=true);
        };
    };
};


module shaft(od=18, id=11, l=25) {
    union() {
        difference() {
            translate([0,0,l/2])cylinder(h=l, d=od, center=true);
            cylinder(h=get_through_all_height(), d=id, center=true);
        };    
    };
};


function get_material(name) = materials[search([name], materials)[0]];

function get_pressure_pin_position(pin) = [pin.x, pin.y];
module make_pressure_pin(pin, length=12) {
    dimensions = pin[2];
    color("white")
        pressure_pin(length=length, d_tip=dimensions[1], b_base=dimensions[2], thread=dimensions[0], shaft_length=length-dimensions[3]);
};



function get_pressure_pin_hole(pin) = [pin[2][0], get_pressure_pin_position(pin)];


/*  Top level modules   */
module pressure_plate_outline() {
    fastener = get_fastener(get_pressure_pin_fastener());
    pressure_pin_holes = [for(pt=get_pressure_pins()) get_pressure_pin_hole(pt)];
    make_pressure_plate_outline(holes=pressure_pin_holes);
};

/*
+ Overhang maximizes cradle width
+ screws are as close the edge as they can be
*/
module cradle_support_bracket_outline(width=get_support_bracket_width(), cradle_curf_width=get_cradle_outline_overhang_width()) {
    case_clearance = 25.4;
    margin = 25.4;

    length = min([get_cradle_length()+margin*2, get_test_jig_plate_size().y-case_clearance]);
    //bracket_hole_center=(get_cradle_width()+get_fastener_field(m3_fastener, "standard clearance"))/2;
    holes = fastener_positions_to_holes(get_support_bracket_mounting_holes(), "standard clearance");

    make_support_bracket_outline(mounting_size=[width, length], support_size=[cradle_curf_width,3*get_cradle_length()/4], holes=holes);
};


module support_plate_outline() {
    cradle_clearance = get_cradle_clearance();

    // FIXME get holes, put them on both side of the outline    

    bracket_mounting_holes = fastener_positions_to_holes(get_support_bracket_mounting_holes(), "standard clearance");
    
    bracket_holes = concat(
        [for (hole=bracket_mounting_holes) [hole[0], [(get_cradle_width()/2-hole[1].x), hole[1].y]]],
        [for (hole=bracket_mounting_holes) [hole[0], [-(get_cradle_width()/2-hole[1].x), hole[1].y]]]
    );
        
    hole_size = [get_cradle_width()+cradle_clearance, get_cradle_length()+cradle_clearance];

    make_support_plate_outline(hole_size=hole_size, holes=bracket_holes);
};


/*
    Make the base plate the same size as the cradle.
    This will allow both plates to be cut at once from the
    same piece.
*/
function get_base_plate_size() = [get_cradle_width(), get_cradle_length()];
module base_plate_outline() {
    size = get_base_plate_size();
    fastener = get_fastener("M3");
    clearance = get_fastener_field(fastener, "minimal edge clearance");
    hole_diameter = get_fastener_field(fastener,     "tap diameter");

    pcb_holes = fastener_positions_to_holes(get_test_pcb_mounting_holes(), "tap_diameter");
    cradle_holes = fastener_positions_to_holes(get_cradle_mounting_holes(), "tap_diameter");
    base_plate_holes = fastener_positions_to_holes(get_base_plate_mounting_holes(), "standard clearance");


    //  FIXME this needs to be part of the design as its global

    holes = concat(cradle_holes, base_plate_holes, pcb_holes);

    //  FIXME add PCB mounting holes

    make_base_plate_outline(size=size, holes=holes);
};


module dut_pcb_outline() {
    square(size=get_board_size(), center=true);    
};


module base_pcb_outline() {
    holes = fastener_positions_to_holes(get_test_pcb_mounting_holes(), "standard clearance");
    make_base_pcb_outline(holes=holes, size=get_test_pcb_size());
};



/*  Constructed Modules  */
module support_plate() {
    material=get_material(name="acrylic");
    thickness = material.z;
    color(material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
          support_plate_outline();
};


module base_plate() {
    material=get_material(name="acrylic");
    thickness = material.z;
    color(material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
            rotate(180, [0,1,0])  //  measure from the top instead of from the bottom
                base_plate_outline();
};


/*  Assemblies  */
//  Pressure plate assembly is dependant on the jig
module pressure_plate_assembly() {
    // pressure plate
    h = 25;
    

    plate_material=get_material(name="acrylic");
    // plate_material=get_material(name="steel");
    thickness = plate_material.z;
    pp_height = h-thickness/2;

    color(plate_material.y)
      translate([0,0,h])
        translate([0,0,thickness/2])
          linear_extrude(height=thickness, center=true)
            pressure_plate_outline();

    // place pressure pins
    for(pt=get_pressure_pins()){
        color("white")
          translate([pt.x, pt.y,pp_height-get_pressure_pin_length()])
            make_pressure_pin(pin=pt, length=get_pressure_pin_length());
        //translate([120, 60, 60])metric_bolt(headtype="socket", size=3, l=20);
    };
    
    // screws
    for(pin=get_pressure_pins()) {
      let(hole=get_pressure_pin_hole(pin)) {
      color("black")translate([hole[1].x, hole[1].y, pp_height+3])hex(d=3, hd=5.5, hl=3, l=12);
      };
    };
    
    // shaft and mounting screw
    union(){
        translate([0, 0, pp_height])rotate(180, [1, 0, 0])round_head_bolt(d=10, l=15, hd=20);
        translate([0,0,pp_height+3])shaft(od=18, id=11, l=50);
    };
};


/* Make the 2x support brackets. These could be spring loaded to make fast changes possible 

+ mirrored across x=0
*/
module support_plate_assembly() {
    translate_x = get_cradle_width()/2;

    bracket_material=get_material(name="acrylic");
    thickness = bracket_material.z;

    /* Left Bracket */
    translate([-translate_x,0,0])rotate(180, [1,0,0])
    color(bracket_material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
          cradle_support_bracket_outline();

    /* Right Bracket */
    translate([translate_x,0,0])rotate(180, [0,1,0])
    color(bracket_material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
          cradle_support_bracket_outline();


    bracket_mounting_holes = get_support_bracket_mounting_holes();
    bracket_holes = concat(
        [for (hole=bracket_mounting_holes) [hole[0], [(get_cradle_width()/2-hole[1].x), hole[1].y]]],
        [for (hole=bracket_mounting_holes) [hole[0], [-(get_cradle_width()/2-hole[1].x), hole[1].y]]]
    );


    for(hole=bracket_holes)color("black")rotate(180,[1, 0, 0])translate([hole[1].x, hole[1].y, thickness])hex(d=3, hd=5.5, hl=3, l=18);

    support_plate();

    length = 18;
    for(hole=get_support_plate_holes())color("black")rotate(180,[1, 0, 0])translate([hole[1].x, hole[1].y, 0])hex(d=4, hd=5.5, hl=3, l=length);
};


module test_pcb_assembly() {
    standoff_od = 6;
    standoff_id = 4.2; // M4 spacers for both
    
    // Standoffs
    long_standoff_height=35;
    for(mh=get_cradle_mounting_holes()){
    color("white")translate([mh[1].x, mh[1].y, 0])  unthreaded_standoff(long_standoff_height, id=standoff_id, od=standoff_od);
    };
    
    //  top of base plate is z=0
    pcb_standoff_height=5;

    holes = get_test_pcb_mounting_holes();
    for(mh=holes){
        rotate(180, [0,1,0])color("white")translate([mh[1].x, mh[1].y, long_standoff_height])unthreaded_standoff(pcb_standoff_height, id=standoff_id, od=standoff_od);
    };
    
    
    // base plate
    translate([0,0,-long_standoff_height])base_plate();
    
    // test pcb
    pcb_top_z=-long_standoff_height+pcb_standoff_height+1.6;
    translate([0,0,-long_standoff_height+pcb_standoff_height])base_pcb();  

    for(hole=get_test_pcb_mounting_holes())color("black")
      translate([hole[1].x, hole[1].y, pcb_top_z])hex(d=3, hd=5.5, hl=3, l=15);    
};

/*****************************************************************************
*
* Construction views
*
*****************************************************************************/

module assembly(){
// Pressure plate mounted to press, removed with 4 bearing screws and the plunger screw.
if(pressure_plate) {
pressure_plate_assembly();
}
//  Cradle assembly mounts through 4x M4 screws in the corners. This is mounted to a PCB and a support plate with standoffs
if(cradle){
cradle_assembly();
}

if (dut){
//  Design PCB sits in the cradle
  dut_board();
}

/*
aligning the cradle
The cradle has to be aligned relative to the alignment pins. This can be done with a shim. The important alignment is internal to the cradle.
*/

// The cradle is supported on the narrow edge by brackets mounted on the base plate.
// The cradle sits in the base plate and on the brackets


if (support) {
  translate([0, 0, -cradle_bottom_z()])support_plate_assembly();
}
/* The PCB assembly mounts to the through all screws from the cradle. 
    Replacing the cassette is removing the two gap pads and pulling the unit through. Since the cassette is smaller than the base plate there are no restrictions on the PCB assembly. The support plate can be lifted off directly.
*/

if (pcb_assembly) {
translate([0,0,-cradle_bottom_z()])test_pcb_assembly();
}

if (screws) {
   for(hole=get_cradle_mounting_holes())color("black")translate([hole[1].x, hole[1].y, get_cradle_board_clearance_height()])hex(d=4, hd=7, hl=4, l=60);    
}
};

assembly();

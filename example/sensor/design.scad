use<openscad-utilities/fasteners.scad>
use<openscad-utilities/tools.scad>
use<cradle.scad>
include<pressure-pins.scad>;
include<alignment-pins.scad>
include<probes.scad>

/* Board Description */
function get_board_length() = 87;
function get_board_width() = 57;
function get_board_size()=[get_board_width(), get_board_length()];
function get_board_file()="/home/simon/projects/building_a_test_jig/parametric-test-jig/example/sensor/board.stl";


/* Cradle */
function get_cradle_base_height() = 7.5;
function get_cradle_pcb_support_height() = 5;
function get_cradle_board_clearance_height() = 5;
function get_cradle_height() = get_cradle_base_height() + get_cradle_pcb_support_height()-get_cradle_base_height();
function get_cradle_outline_overhang_width() = 10;
function get_board_gap()=[1,1];
function get_cradle_outline_size() = [75, 100];
function get_craddle_fastner()="M4";

/* Test PCB */
function get_test_pcb_size() = [75, 80];
function get_test_pcb_mounting_holes() = make_even_mounting_holes(fastener_name="M3", size=get_test_pcb_size());
function get_test_board_file()="/home/simon/projects/building_a_test_jig/parametric-test-jig/example/sensor/test-board-pcb.stl";

/* Base Plate */
function get_base_plate_size() = [get_cradle_width(), get_cradle_length()];
function get_base_plate_mounting_holes()= make_odd_mounting_holes(fastener_name="M3", size=get_base_plate_size()) ;


function get_pressure_pin_fastener() = "M3";
function get_alignment_pin_depth_setting() = -2;

function design_pins() = get_design_pins(pin_depth=get_alignment_pin_depth_setting());

function design_probes() = get_design_probes(ground_height=get_probe_ground_height());


/*
module dut_pcb_outline() {
    square(size=get_board_size(), center=true);    
};

module dut_board() {
    material=get_material(name="pcb");
    thickness = material.z;
    color(material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
            dut_pcb_outline();
};
*/

module dut_board(){
  rotate(180, [0,0,1])%import(get_board_file());
};


/*
module base_pcb() {
    material=get_material(name="pcb");
    thickness = material.z;

    color(material.y)
    translate([0,0,thickness/2])
        linear_extrude(height=thickness, center=true)
            base_pcb_outline();
};
*/

module base_pcb() {
    rotate(180, [0,0,1])%import(get_test_board_file());
};


function get_support_bracket_mounting_holes() = let(fastener_name="M3", clearance=get_fastener_field_by_name(fastener_name, "minimal edge clearance")) make_linear_odd_mounting_holes(fastener_name=fastener_name, length=get_cradle_length(), spacing=25.4, x=-clearance);

module make_board_clearance_outline(gap, board_size) {
    length = board_size.y + gap.y;
    width = board_size.x + gap.x;
    square([width, length], center=true);
    
    // corner reliefs
    board_outline_relief_diameter = 2;
    for(pos=[[1,1], [-1,1], [1,-1], [-1,-1]]){
        translate([width/2*pos.x, length/2*pos.y, 0])circle(d=    board_outline_relief_diameter);
    };
}

//  Take the outline and add supports
module make_board_support_outline(gap, board_size) {
    length = board_size.y + gap.y;
    width = board_size.x + gap.x;

    support_size = [18, 20];
    difference() {
        make_board_clearance_outline(gap, board_size);
        mid_supports = [
            [[-board_size.x/2, 0], [18,12]],
            [[board_size.x/2, -(board_size.y)/6], [16, 6]],
        ];
        corner_supports = [for( p = [[1,1], [-1,1], [1,-1], [-1,-1]]) [[board_size.x/2*p.x, board_size.y/2*p.y], support_size]];
        for(support=mid_supports) {
            translate([support[0].x, support[0].y])square(support[1], center=true);
        };
        for(support=corner_supports) {
            translate([support[0].x, support[0].y])square(support[1], center=true);
        };
    };
};


/* Probes */
probe_ground_height=-7;
function get_probe_ground_height()=probe_ground_height;

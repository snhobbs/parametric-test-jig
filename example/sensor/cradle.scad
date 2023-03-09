use<design.scad>

use<openscad-testjig-components/alignment-pins/GP-2S.scad>;
use<openscad-testjig-components/test_probes/P100-R100_2W.scad>;
use<openscad-testjig-components/testprobe.scad>;
use<openscad-testjig-components/sockets.scad>;
use<openscad-testjig-components/alignment_pins.scad>;
use<openscad-testjig-components/alignment-pins/GP-2S.scad>

use<openscad-utilities/fasteners.scad>
use<openscad-utilities/tools.scad>;


/*
  Cradle description holds the data required to reuse a cradle outline
  and mounting strategy. Since only the outline matters the other section
  looks after the z dimension
*/

function get_cradle_width() = get_cradle_outline_size().x;
function get_cradle_length() = get_cradle_outline_size().y;

function get_cradle_mounting_holes() = make_even_mounting_holes(
    fastener_name=get_cradle_fastner(),
    size=get_cradle_outline_size());


module make_cradle_outline(size) {
  square([size.x, size.y], center=true);
};

/*
    Make base relies on a function:
        + cradle_outline(); 
        + board_support_outline(); -> clearance space required
        + board_clearance_outline();  -> lip around pcb height
*/
module make_cradle_base(base_height, board_clearance_height, board_support_height) {
    //  Subtract the board clearance from the support
    // Remove the board support negative from the block
    through_all_height = 1000;
    difference() {
    //  Main block, centered and offset so the PCB bottom face is at z=0
        difference() {
            block_height = base_height+board_clearance_height+board_support_height;
            offset_z = base_height+board_support_height;  //  position of bottom PCB face
            //  make block offset a bit
            translate([0,0,block_height/2-offset_z])linear_extrude(height=block_height, center=true)cradle_outline();

            // take the difference with an extruded negative space from the depth to infinity
            translate([0, 0, -board_clearance_height + through_all_height/2])linear_extrude(height=through_all_height, center=true)board_support_outline();
        };
        //  Remove the board clearance from z=0 to infinity
        translate([0, 0, through_all_height/2])linear_extrude(height=through_all_height, center=true)board_clearance_outline();
    };
};

//  FIXME add support for different probe and alignment pins
function get_alignment_pin_hole_dimensions(type) = get_GP_2S_hole_dimensions();

/*
    Relies on:
        alignment_pin_hole
        socket_hole
*/
function get_alignment_pin_position(pin) = [pin.x, pin.y];
function get_alignment_pin_depth(pin) = pin[3];
function get_alignment_pin_type(pin) = pin[2];

function get_probe_position(pin) = [pin.x, pin.y, pin[3]];
function get_probe_socket(pin) = pin[2];

module make_cradle(probes, pins, base_height, board_clearance_height, board_support_height, mounting_holes){
    //  Drill holes through everything
    difference() {
        //  Generate plate and set the top face at z=0
        make_cradle_base(
            base_height=base_height, 
            board_clearance_height=board_clearance_height, 
            board_support_height=board_support_height);
        
        //  holes as a series of cylinders
        for(pin=pins){
            translate(get_alignment_pin_position(pin))
                alignment_pin_hole(pin=get_alignment_pin_hole_dimensions());
        };
        for(probe = probes){
            translate(get_probe_position(probe))
            socket_hole(socket=get_probe_socket(probe));
        };

        cradle_holes = fastener_positions_to_holes(get_cradle_mounting_holes(), "wide clearance");

        for(hole=get_cradle_mounting_holes())make_mounting_hole(hole);
    }
};

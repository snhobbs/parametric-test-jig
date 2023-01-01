use<openscad-testjig-components/alignment-pins/GP-2S.scad>;
use<openscad-testjig-components/test_probes/P100-R100_2W.scad>;
use<openscad-testjig-components/testprobe.scad>;
use<openscad-testjig-components/sockets.scad>;
use<openscad-testjig-components/alignment_pins.scad>;
use<openscad-testjig-components/alignment-pins/GP-2S.scad>

use<openscad-utilities/tools.scad>;

module make_mounting_hole(mounting_hole, through_all_height=1000) {
    through_hole(mounting_hole, through_all_height=through_all_height);
};

module make_board_clearance_outline(gap, board_size) {
    length = board_size.y + gap.y;
    width = board_size.x + gap.x;
    square([width, length], center=true);
    
    // corner reliefs
    board_outline_relief_diameter = 2;
    for(pos=[[1,1], [-1,1], [1,-1], [-1,-1]]){
        translate([width/2*pos[0], length/2*pos[1], 0])circle(d=    board_outline_relief_diameter);
    };
}

//  Take the outline and add supports
module make_board_support_outline(gap, board_size) {
    length = board_size.y + gap.y;
    width = board_size.x + gap.x;

    support_size = [18, 25];
    difference() {
        make_board_clearance_outline(gap, board_size);
        mid_supports = [
            [[board_size.x/2, 0], support_size],
            [[-board_size.x/2, (board_size.y)/6], [16, 6]],
        ];
        corner_supports = [for( p = [[1,1], [-1,1], [1,-1], [-1,-1]]) [[board_size.x/2*p[0], board_size.y/2*p[1]], support_size]];
        for(support=mid_supports) {
            translate([support[0][0], support[0][1]])square(support[1], center=true);
        };
        for(support=corner_supports) {
            translate([support[0][0], support[0][1]])square(support[1], center=true);
        };
    };
};

module make_cradle_outline(size) {
  square([size.x, size.y], center=true);
};


/*
    Make base relies on a function:
        + cradle_outline() -> shape
        + get_cradle_height() -> height to extrude outline
        + get_board_support_outline() -> negative space between inside of cradle and DUT.
        + get_board_support_height() -> clearance space required
        + get_board_clearance_outline() -> frame around PCB to allow putting in and pulling out
        + get_board_clearance_height() -> lip around pcb height
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


/*
    Relies on:
        + make_base
        + alignment_pin_hole
            + get_GP_2S_hole_dimensions
        + socket_hole
        + mounting_holes
*/
module make_cradle(probes, pins, base_height, board_clearance_height, board_support_height, mounting_holes){
    //  Drill holes through everything
    difference() {
        //  Generate plate and set the top face at z=0
        make_cradle_base(base_height=base_height, board_clearance_height=board_clearance_height, board_support_height=board_support_height);
        
        //  holes as a series of cylinders
        //for(pin = pins)G2_positioning_pin(pin[0], pin[1], pin[2]);
        for(pin=pins)translate(pin)alignment_pin_hole(pin=get_GP_2S_hole_dimensions());
        for(probe = probes)translate(probe[0])socket_hole(socket=probe[1][0]);
        for(hole=get_cradle_mounting_holes())make_mounting_hole(hole);
    }
};

//  FIXME we could use the umbrella heads and remove the need for corner turrets


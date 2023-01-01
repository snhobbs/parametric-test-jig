use<design.scad>
include<cradle.scad>

use<press-jig-type-a/pressure-plate.scad>;
use<press-jig-type-a/support-plate.scad>;


module board_support_outline() {
    make_board_support_outline(get_board_gap(), get_board_size());
};

module board_clearance_outline() {
    make_board_clearance_outline(get_board_gap(), get_board_size());
};

module cradle_outline() {
    make_cradle_outline(size=[get_cradle_width(), get_cradle_length()]);
};

// FIXME these functions calls should be moved here
module cradle() {
    make_cradle(
        pins=design_pins(),
        probes=design_probes(),
        board_support_height = get_cradle_pcb_support_height(),
        board_clearance_height = get_cradle_board_clearance_height(),
        base_height = get_cradle_base_height()
    );
};


/*
    cradle assembly is its own unit seperate from the 
    assembly so the assembly is included here
*/
module cradle_assembly() {
    // cradle w/ hardware
    pins=design_pins();
    probes=design_probes();

    color("grey")cradle();
    for(pin=pins){
        translate([0,0,get_alignment_pin_depth(pin)])  
        translate(get_alignment_pin_position(pin))  
            make_GP_2S(total_length=36);
    };
    for(probe=probes){
      translate(get_probe_position(probe))rotate(180,[0,1,0])P100_R100_2W();
    };
};

cradle_assembly();

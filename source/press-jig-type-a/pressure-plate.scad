/*
    Template for a certain jig.
    Take a type of pin and an array of x,y hole positions
*/
use<press-jig-type-a/test-jig-press-type-a.scad>;


/* [Options] */


module make_pressure_plate_outline(holes) {
    through_all_height = 1000;
    difference(){
        //rotate(90, [0,0,1])
            press_pressure_plate_type_a_base_outline();
        
        for(hole=holes) {
            translate([hole[1].x, hole[1].y])circle(d=hole[0]);
        };
    };
};

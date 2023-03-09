use<press-jig-type-a/test-jig-press-type-a.scad>;

/* 
  Requires:
            support_base_plate_outline

*/
module make_support_plate_outline(hole_size, holes=[]) {
    difference() {
        difference(){
            support_base_plate_outline();
            square(hole_size, center=true);
        }

        for(hole = holes)translate([hole[1][0], hole[1][1]])circle(d=[hole[0]]);
    };
};

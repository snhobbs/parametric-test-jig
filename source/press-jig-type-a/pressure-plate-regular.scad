use<press-jig-type-a/test-jig-press-type-a.scad>;

module make_plate(size, spacing, d) {
    difference() {
        rotate(90, [0,0,1])
            press_pressure_plate_type_a_base_outline();
        for(x=[-size.x/2:spacing:size.x/2]) {
            for(y=[-size.y/2:spacing:size.y/2]) {
                in_range = (x > (-size.y/2 + d/2)) &&
                    (y > (-size.y/2 + d/2)) &&
                    (x < (size.x/2-d/2)) &&
                    (y < (size.y/2-d/2));
                if (in_range) {
                translate([x,y])circle(d=d);
                };
            }
        }
    };
};

make_plate(size=[100, 120], spacing=10, d=3.2);

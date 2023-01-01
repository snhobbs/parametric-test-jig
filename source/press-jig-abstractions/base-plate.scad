module make_base_plate_outline(size, holes) {
    difference() {
        square([size.x, size.y], center=true);
        for(hole=holes)translate([hole[1][0], hole[1][1], 0])circle(d=hole[0]);
    };
};


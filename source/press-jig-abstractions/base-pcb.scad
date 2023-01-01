module make_base_pcb_outline(size, holes) {
    difference() {
        square(size, center=true);
        for(hole=holes) {
            translate(hole[1])circle(d=hole[0]);
        };
    };
};

base_pcb_outline();

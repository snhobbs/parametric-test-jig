/*
    Support bracket recradletangle made of 2x rectangle, one for mouting to the base, one for the overhang
        + mounting size
        + support size
    Centered on the overhang beginning
*/
module get_support_bracket_outline_base(mounting_size=[10, 10], support_size=[6,4]) {
    union(){
        translate([-mounting_size[0]/2, 0])
            square([mounting_size[0], mounting_size[1]], center=true);
        
        square(support_size, center=true);
    };
};

module make_holes_2d(holes){
    for(hole=holes) translate(hole[1])
        circle(d=hole[0]);
};

module make_support_bracket_outline(mounting_size=[10, 10], support_size=[6,4], holes=[]) {
    difference() {
        get_support_bracket_outline_base(mounting_size=mounting_size, support_size=support_size);
        make_holes_2d(holes);
    };
}

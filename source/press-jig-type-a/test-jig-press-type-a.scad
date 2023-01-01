/*
    The base plate is square with a width, length, and height.
    There are mounting holes that go through all
*/
use<openscad-utilities/abstract-types.scad>
use<openscad-utilities/tools.scad>
    

function get_test_jig_plate_size() = [170, 150];

function get_support_plate_holes() = let(d1=5, d2=3) concat(
        [for(pt=make_four_corners(160/2, 140/2)) [d1, pt]],
        [for(pt=make_four_corners(160/2, 80/2)) [d2, pt]]
);


module support_base_plate_outline() {
    square_with_holes(size=get_test_jig_plate_size(),
    holes=get_support_plate_holes());
};


/* Return the hole pattern for a type A press */
function get_press_pressure_plate_holes(width=170, length=150) = let(d=2.5, x=width/2-5, y1=length/2-55, y2=length/2-35, y3=2.5) concat(
        [for(pt=make_four_corners(x, y1)) [d, pt]],
        [for(pt=make_four_corners(x, y2)) [d, pt]],
        [for(pt=make_four_corners(x, y3)) [d, pt]],
        [[11, [0,0]]] //  # M10
    );


//  Mounting hole at dead center
        
module press_pressure_plate_type_a_base_outline() {
    size = get_test_jig_plate_size();
    holes = get_press_pressure_plate_holes(width=size[0], length=size[1]);
    square_with_holes([size[0], size[1]], holes);
}

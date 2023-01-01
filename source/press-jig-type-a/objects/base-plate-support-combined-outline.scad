use<press-jig-type-a/assembly.scad>;
$fs=0.1;

size = get_base_plate_size();
square_size = [2, 4];
translate([(size.x/2-square_size.x/2), size.y/2])square(square_size, center=true);
translate([-(size.x/2-square_size.x/2), size.y/2])square(square_size, center=true);
translate([(size.x/2-square_size.x/2), -size.y/2])square(square_size, center=true);
translate([-(size.x/2-square_size.x/2), -size.y/2])square(square_size, center=true);

support_plate_outline();
base_plate_outline();


module dut_pcb(size=[5,5,1.6]) {
    // Test PCB
    color("green")translate([0,0,size[2]/2])cube(size, center=true);
};

dut_pcb();
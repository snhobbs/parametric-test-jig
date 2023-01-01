/* x, y, socket/base, class*/
function get_design_probes(ground_height = -1, signal_height_dz = -0.5, power_height_dz = -1) = [
    [19.75, 24.25, "R100-2W", ground_height+power_height_dz],  //  +VINF 
    [5.0, 21.0, "R100-2W", ground_height+power_height_dz],  //  +13 
    [-9.25, 18.5, "R100-2W", ground_height+power_height_dz],  //  +5 
    [2.7, 35.7, "R100-2W", ground_height],  //  GND 
    [-16.25, 7.25, "R100-2W", ground_height+power_height_dz],  //  +3.3 
    [-9.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  RX+ 
    [-12.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  RX- 
    [-15.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  TX+ 
    [-18.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  TX- 
    [1.5, -13.25, "R100-2W", ground_height+signal_height_dz],  //  MW0 
    [-10.25, -11.5, "R100-2W", ground_height+signal_height_dz],  //  MW1 
    [-3.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  ANALOG0 
    [-6.3, 35.7, "R100-2W", ground_height+signal_height_dz],  //  ANALOG1 
    [-0.3, 35.7, "R100-2W", ground_height+power_height_dz],  //  +VIn 
    [24.25, -2.75, "R100-2W", ground_height+power_height_dz],  //  +3.3 
    [24.25, -0.21, "R100-2W", ground_height+signal_height_dz],  //  ~{ISP}{slash}RTS0 
    [24.25, 2.33, "R100-2W", ground_height+signal_height_dz],  //  ~{RESET1} 
    [24.25, 4.87, "R100-2W", ground_height+signal_height_dz],  //  ~{RESET0} 
    [24.25, 7.41, "R100-2W", ground_height+signal_height_dz],  //  RXD0 
    [24.25, 9.95, "R100-2W", ground_height],  //  GND 
    [24.25, 12.49, "R100-2W", ground_height+signal_height_dz],  //  TXD0 
    [24.25, 15.03, "R100-2W", ground_height+power_height_dz],  //  +VIn 
    [-21.44, -8.45, "R100-2W", ground_height+signal_height_dz],  //  SWDIO1 
    [-20.17, -12.35, "R100-2W", ground_height],  //  GND 
    [-20.17, -8.45, "R100-2W", ground_height+signal_height_dz],  //  SWCLK1 
    [18.2, -8.5, "R100-2W", ground_height+signal_height_dz],  //  MCLK 
    [19.725, -7.025, "R100-2W", ground_height],  //  GND 
    ];
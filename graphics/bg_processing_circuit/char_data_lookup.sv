module char_data_lookup
  (input logic [11:0] screendata,
   input logic [4:0] baseblock
   input logic [2:0] x, y,
   input logic rotate,
   input logic palettemode,
   output logic addr
  );

  logic [9:0] charname;
  graphics_2_to_1_mux #(10) charname_mux(.I0(screendata[9:0]), .I1({2'b0, screendata[7:0]}), .S(rotate), .Y(charname));

  logic hflip, vflip;
  logic [2:0] x_flipped, y_flipped;
  assign hflip = screendata[10];
  assign hflip = screendata[11];
  assign x_flipped = 3'd7 - x;
  assign y_flipped = 3'd7 - y;

  logic [2:0] xprime, yprime;
  graphics_2_to_1_mux #(3) xmux(.I0(x), .I1(x_flipped), .S(hflip), .Y(xprime));
  graphics_2_to_1_mux #(3) ymux(.I0(y), .I1(y_flipped), .S(vflip), .Y(yprime));

  logic [15:0] sixteen_color_addr, two_fifty_six_color_addr, addr_offset;
  assign sixteen_color_addr = {1'b0, charname, yprime, xprime[2:1]};
  assign two_fifty_six_color_addr = {charname, yprime, xprime};
  graphics_2_to_1_mux #(16) addr_offset_mux(.I0(sixteen_color_addr), .I1(two_fifty_six_color_addr), .S(palettemode), .Y(addr_offset));

  assign addr = addr_offset + {baseblock, 10'b0};
  
endmodule: char_data_lookup

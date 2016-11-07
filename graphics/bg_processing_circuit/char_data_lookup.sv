module char_data_lookup
  (input logic [11:0] screendata,
   input logic [1:0] baseblock,
   input logic [2:0] x, y,
   input logic rotate,
   input logic palettemode,
   output logic [15:0] addr
  );

  logic [9:0] charname;
  bg_mux_2_to_1 #(10) charname_mux(.i0(screendata[9:0]), .i1({2'b0, screendata[7:0]}), .s(rotate), .y(charname));

  logic hflip, vflip;
  logic [2:0] x_flipped, y_flipped;
  assign hflip = screendata[10];
  assign vflip = screendata[11];
  assign x_flipped = 3'd7 - x;
  assign y_flipped = 3'd7 - y;

  logic [2:0] xprime, yprime;
  bg_mux_2_to_1 #(3) xmux(.i0(x), .i1(x_flipped), .s(hflip), .y(xprime));
  bg_mux_2_to_1 #(3) ymux(.i0(y), .i1(y_flipped), .s(vflip), .y(yprime));

  logic [15:0] sixteen_color_addr, two_fifty_six_color_addr, addr_offset;
  assign sixteen_color_addr = {1'b0, charname, yprime, xprime[2:1]};
  assign two_fifty_six_color_addr = {charname, yprime, xprime};
  bg_mux_2_to_1 #(16) addr_offset_mux(.i0(sixteen_color_addr), .i1(two_fifty_six_color_addr), .s(palettemode), .y(addr_offset));

  assign addr = addr_offset + {baseblock, 14'b0};
  
endmodule: char_data_lookup

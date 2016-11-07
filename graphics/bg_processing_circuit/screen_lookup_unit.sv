module row_offsetter
  (input logic [6:0] max,
   input logic [6:0] row,
  output logic [13:0] offset);

  always_comb begin
    if(max[6])
      offset = {row, 7'b0};
    else if(max[5])
      offset = {1'b0, row, 6'b0};
    else if(max[4])
      offset = {2'b0, row, 5'b0};
    else if(max[3])
      offset = {3'b0, row, 4'b0};
    else if(max[2])
      offset = {4'b0, row, 3'b0};
    else if(max[1])
      offset = {5'b0, row, 2'b0};
    else if(max[0])
      offset = {6'b0, row, 1'b0};
    else
      offset = {7'b0, row};
  end

endmodule: row_offsetter

module screen_lookup_unit
  (input logic [9:0] hmax, vmax,
   input logic [9:0] x, y,
   input logic [1:0] screen_base_block_no,
   input logic rotate,
   output logic [15:0] addr);

  logic [6:0] xprime, yprime;
  assign xprime = x[9:3] & hmax[9:3];
  assign yprime = y[9:3] & vmax[9:3];

  logic [13:0] row_offset;
  row_offsetter (.max(hmax[9:3]), .row(yprime), .offset(row_offset));

  logic [13:0] rotation_offset;
  assign rotation_offset = row_offset | {7'b0, xprime};

  logic [13:0] text_offset;
  assign text_offset = {1'b0, yprime[5], xprime[5], yprime[4:0], xprime[4:0], 1'b0};

  logic [13:0] screen_offset;
  bg_mux_2_to_1 #(14) offset_mux(.i0(text_offset), .i1(rotation_offset), .s(rotate), .y(screen_offset));

  assign addr = {screen_base_block_no, 14'b0} | {2'b0, screen_offset};
  //addr calculation assumes 0 <= x <= hmax.
  //otherwise output is don't care since coordinate overflos the virtual screen

endmodule: screen_lookup_unit

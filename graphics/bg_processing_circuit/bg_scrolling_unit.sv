module bg_scrolling_unit
  (input logic [9:0] hofs, vofs,
   input logic [7:0] row, col,
   output logic [9:0] x, y);

  assign x = hofs + col;
  assign y = vofs + row;

endmodule: bg_scrolling_unit

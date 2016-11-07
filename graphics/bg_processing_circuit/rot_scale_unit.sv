module bg_rot_scale_unit
  (input logic [15:0] A, B, C, D, //signed, 7 integer bits, 8 fractional bits
   input logic [27:0] bgx, bgy, //signed, 19 integer bits, 8 fractional bits
    //bgx and bgy are the (x,y) coordinates of the upper left of the ROTATED screen
    //they come from MMIO registers BG2X/BG3X and BG2Y/BG3Y
   input logic step, steprow,
    //step should be asserted on the last clock cycle before col is incremented
    //steprow should be asserted on the last clock cycle of processing a given row
   input logic newframe,
    //newframe should be asserted on the first clock cycle of the first pixel of the first row of each frame
    //AKA col == 0 && vcount == 0 && bgno == 0
   input logic clock, rst_b,
   output logic [9:0] x, y,
   output logic overflow);

  //Detect if reference point changed during hblank
  logic [27:0] prev_bgx, prev_bgy;

  //sign-extend parameters
  logic [27:0] dx, dy, dmx, dmy;
  assign dx = {{12{A[15]}}, A};
  assign dmx = {{12{B[15]}}, B};
  assign dy = {{12{C[15]}}, C};
  assign dmy = {{12{D[15]}}, D};

  logic [27:0] col_x_offset, col_y_offset;
  logic [27:0] row_x_offset, row_y_offset;
  logic [27:0] next_col_x_offset, next_col_y_offset;
  logic [27:0] next_row_x_offset, next_row_y_offset;

  logic update_col_offsets, update_row_offsets;

  assign update_col_offsets = step || steprow || newframe;
  assign update_row_offsets = steprow || newframe;

  always_comb begin
    if(newframe) begin
      next_col_x_offset = 28'b0;
      next_col_y_offset = 28'b0;
      next_row_x_offset = 28'b0;
      next_row_y_offset = 28'b0;
    end
    else if(steprow) begin
      next_col_x_offset = 28'b0;
      next_col_y_offset = 28'b0;
      if(bgx == prev_bgx && bgy == prev_bgy) begin
        next_row_x_offset = row_x_offset + dmx;
        next_row_y_offset = row_y_offset + dmy;
      end
      //Discard y-direction summation if reference point changed during hblank
      else begin
        next_row_x_offset = 28'b0;
        next_row_y_offset = 28'b0;
      end
    end
    else begin
      next_col_x_offset = col_x_offset + dx;
      next_col_y_offset = col_x_offset + dy;
      next_row_x_offset = row_x_offset;
      next_row_y_offset = row_y_offset;
    end
  end

  bg_register #(28) col_x_offset_reg(.q(col_x_offset), .d(next_col_x_offset), .clk(clock), .clear(1'b0), .enable(update_col_offsets), .rst_b); 
  bg_register #(28) col_y_offset_reg(.q(col_y_offset), .d(next_col_y_offset), .clk(clock), .clear(1'b0), .enable(update_col_offsets), .rst_b); 
  bg_register #(28) row_x_offset_reg(.q(row_x_offset), .d(next_row_x_offset), .clk(clock), .clear(1'b0), .enable(update_row_offsets), .rst_b); 
  bg_register #(28) row_y_offset_reg(.q(row_y_offset), .d(next_row_y_offset), .clk(clock), .clear(1'b0), .enable(update_row_offsets), .rst_b); 

  //intermediate summation
  logic [27:0] actual_x, actual_y;
  assign actual_x = bgx + col_x_offset + row_x_offset;
  assign actual_y = bgy + col_y_offset + row_y_offset;

  //output logic
  assign overflow = |actual_x[27:18] || |actual_y[27:18]; //bitwise reduction of most-significant bits
  assign x = actual_x[17:8];
  assign y = actual_y[17:8];

  //Detect if reference point changed during hblank
  bg_register #(28) bgx_reg(.q(prev_bgx), .d(bgx), .clk(clock), .clear(1'b0), .enable(steprow), .rst_b); 
  bg_register #(28) bgy_reg(.q(prev_bgy), .d(bgy), .clk(clock), .clear(1'b0), .enable(steprow), .rst_b); 

endmodule: bg_rot_scale_unit

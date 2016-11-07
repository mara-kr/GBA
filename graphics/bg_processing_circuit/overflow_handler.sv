module overflow_handler
  (input logic [9:0] hmax, vmax,
   input logic [9:0] x, y,
   input logic bitmapped, rotate, overflow,
   output logic transparent);

  logic h_overflow, v_overflow;
  bg_mag_comp #(10) horiz_overflow(.a(x), .b(hmax), .agtb(h_overflow), .aeqb(), .altb());
  bg_mag_comp #(10) vert_overflow(.a(y), .b(vmax), .agtb(v_overflow), .aeqb(), .altb());

  logic overflow_occurred;
  assign overflow_occured = h_overflow | v_overflow;

  logic transparent_overflow;
  assign transparent_overflow = bitmapped | (rotate & ~overflow);
  bg_mux_2_to_1 #(1) transparency_mux(.i0(1'b0), .i1(transparent_overflow), .s(overflow_occured), .y(transparent));

endmodule: overflow_handler

module overflow_handler
  (input logic [9:0] hmax, vmax,
   input logic [9:0] x, y,
   input logic bitmapped, rotate, overflow,
   output logic transparent);

  logic h_overflow, v_overflow;
  graphics_mag_comp #(10) horiz_overflow(.A(x), .B(hmax), .AgtB(h_overflow));
  graphics_mag_comp #(10) vert_overflow(.A(y), .B(vmax), .AgtB(v_overflow));

  logic overflow_occurred;
  assign overflow_occured = h_overflow | v_overflow;

  logic transparent_overflow;
  assign transparent_overflow = bitmapped | (rotate & ~overflow);
  graphics_mux_2_to_1 #(1) transparency_mux(.I0(1'b0), .I1(transparent_overflow), .S(overflow_occured), .Y(transparent));

endmodule: overflow_handler

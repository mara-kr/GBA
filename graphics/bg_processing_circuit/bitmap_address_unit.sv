module bitmap_address_unit
  (input logic [7:0] x, y,
   input logic [9:0] hmax,
   input logic bitmap_color,
   input logic frame,
   output logic [16:0] addr);

  logic [7:0] row_offset;
  assign row_offset = y * (hmax+8'b1); //TODO Does vivado infer multiplication onto a DSP?

  logic [15:0] pixelno;
  assign pixelno = row_offset + x;

  logic [16:0] addr_offset;
  graphics_mux_2_to_1 #(17) bitmap_addr_offset_mux(.I0({1'b0, pixelno}), .I1({pixelno, 1'b0}), .S(bitmap_color), .Y(addr_offset));

  logic use_second_frame;
  assign use_second_frame = frame & ~bitmap_color;

  logic [16:0] base_addr;
  graphics_mux_2_to_1 #(17) bitmap_addr_base_mux(.I0(17'b0), .I1(17'h0A000), .S(use_second_frame), .Y(base_addr));

  assign addr = base_addr + addr_offset;

endmodule: bitmap_address_unit

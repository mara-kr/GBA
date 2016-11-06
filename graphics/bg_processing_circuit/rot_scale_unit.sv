module rot_scale_unit
  (input logic [15:0] A, B, C, D
   input logic [27:0] x0, y0,
   input logic [7:0] x2, y2,
   output logic x1, y1);

  logic [27:0] origin_x2, origin_y2;

  rot_scale_origin origin_rotater(.A, .B, .C, .D, .x2(origin_x2), .y2(origin_y2), .x1(origin_x1), .y1(origin_y1));

endmodule: rot_scale_unit

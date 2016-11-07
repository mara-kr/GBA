module obj_rot_scale_unit
  (input logic  [7:0] row, col.
   input logic [15:0] A, B, C, D,
   input logic  [8:0] objx,
   input logic  [7:0] objy,
   input logic  [7:0] hsize, vsize,
   input logic        dblsize,
   output logic [6:0] x, y);

  //distances from reference point of rotation (obj center)
  logic [6:0] dx;
  logic [6:0] dy;

  assign dx = col - objx;
  assign dy = col - objy;

  //justify results into the range [0, 64)
  logic [5:0] x_bias;
  logic [5:0] y_bias;

  assign x_bias = dblsize ? hsize[7:2] : hsize[6:1];
  assign y_bias = dblsize ? vsize[7:2] : vsize[6:1];

  //math
  assign x = A * dx + B * dy + x_bias;
  assign y = C * dx + D * dy + y_bias;

endmodule: obj_rot_scale_unit

module obj_rot_scale_unit
  (input logic [7:0] row, col,
   input logic [15:0] a, b, c, d,
   input logic [8:0] objx,
   input logic [7:0] objy,
   input logic [7:0] hsize, vsize,
   input logic dblsize,
   output logic [5:0] x, y,
   output logic transparent);

  //distances from reference point of rotation (obj center)
  logic [6:0] dx;
  logic [6:0] dy;

  assign dx = col - objx;
  assign dy = row - objy;

  //justify results into the range [0, 64)
  logic [5:0] x_bias;
  logic [5:0] y_bias;

  assign x_bias = dblsize ? hsize[7:2] : hsize[6:1];
  assign y_bias = dblsize ? vsize[7:2] : vsize[6:1];

  //math
  logic [22:0] product_x, product_y;
  assign product_x = a * dx + b * dy + {x_bias, 8'b0};
  assign product_y = c * dx + d * dy + {y_bias, 8'b0};

  assign x = product_x[13:8]; //truncate the 8 fractional bits
  assign y = product_y[13:8];

  assign transparent = |product_x[22:14] | |product_y[22:14];

endmodule: obj_rot_scale_unit

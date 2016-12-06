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

  logic negx, negy;
  
  assign negx = col < objx;
  assign negy = row < objy;

  assign dx = negx ? objx - col : col - objx;
  assign dy = negy ? objy - row : row - objy;

  //justify results into the range [0, 64)
  logic [5:0] x_bias;
  logic [5:0] y_bias;

  assign x_bias = dblsize ? hsize[6:0] : hsize[5:0];
  assign y_bias = dblsize ? vsize[6:0] : vsize[5:0];

  //math
  logic [22:0] product_x, product_y;
  assign product_x = a * dx + b * dy + {x_bias, 8'b0};
  assign product_y = c * dx + d * dy + {y_bias, 8'b0};

  assign x = negx ? ~product_x[13:8] + 6'b1 : product_x[13:8]; //truncate the 8 fractional bits
  assign y = negy ? ~product_y[13:8] + 6'b1 : product_y[13:8];

  assign transparent = |product_x[22:14] | |product_y[22:14];

endmodule: obj_rot_scale_unit

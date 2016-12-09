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
  (* mark_debug="true" *) logic [14:0] dx;
  (* mark_debug="true" *) logic [14:0] dy;

  logic negx, negy;

  assign negx = col < objx;
  assign negy = row < objy;

  //assign dx = negx ? objx - col : col - objx;
  //assign dy = negy ? objy - row : row - objy;
  assign dx = col - (objx + hsize[7:1]);
  assign dy = row - (objy + vsize[7:1]);
  
  logic [14:0] sa, sb, sc, sd;
  
  assign sa = a[15] ? ~a[14:0] + 15'b1 : a[14:0];
  assign sb = b[15] ? ~b[14:0] + 15'b1 : b[14:0];
  assign sc = c[15] ? ~c[14:0] + 15'b1 : c[14:0];
  assign sd = d[15] ? ~d[14:0] + 15'b1 : d[14:0];

  //justify results into the range [0, 64)
  logic [5:0] x_bias;
  logic [5:0] y_bias;

  assign x_bias = dblsize ? hsize[7:2] : hsize[7:1];
  assign y_bias = dblsize ? vsize[7:2] : vsize[7:1];

  //math
  logic [29:0] product_x, product_y;
  assign product_x = sa * dx + sb * dy + {x_bias, 8'b0};
  assign product_y = sc * dx + sd * dy + {y_bias, 8'b0};

  assign x = product_x[13:8]; //truncate the 8 fractional bits
  assign y = product_y[13:8];

  assign transparent = |product_x[29:14] | |product_y[29:14];

endmodule: obj_rot_scale_unit

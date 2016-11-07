module obj_rot_scale_unit
  (input logic [7:0] row, col.
   input logic [15:0] a, b, c, d,
   input logic [8:0] obj_x,
   input logic [7:0] obj_y,
   input logic [7:0] hsize, vsize,
   input logic double_size,
   output logic [5:0] x, y);

  //distances from reference point of rotation (obj center)
  logic [6:0] dx;
  logic [6:0] dy;

  assign dx = col - obj_x;
  assign dy = col - obj_y;

  //justify results into the range [0, 64)
  logic [5:0] x_bias;
  logic [5:0] y_bias;
  
  assign x_bias = double_size ? hsize[7:2] : hsize[6:1]; 
  assign y_bias = double_size ? vsize[7:2] : vsize[6:1]; 

  //math
  assign x = a * dx + b * dy + x_bias; 
  assign y = c * dx + d * dy + y_bias;

endmodule: obj_rot_scale_unit

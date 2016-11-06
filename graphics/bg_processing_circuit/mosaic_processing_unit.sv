module mosaic_processing_unit
  (input logic [3:0] hscale, vscale,
   input logic mosaic,
   input logic [9:0] row, col,
   output logic x, y);

   logic [3:0] hmosaic, vmosaic;
   graphics_2_to_1_mux #(4) hmosaic_mux(.I0(4'b0), .I1(hscale), .S(mosaic), .Y(hmosaic));
   graphics_2_to_1_mux #(4) vmosaic_mux(.I0(4'b0), .I1(vscale), .S(mosaic), .Y(vmosaic));

   logic [4:0] hmod, vmod;
   assign hmod = {1'b0, hmosaic} + 5'b1;
   assign vmod = {1'b0, vmosaic} + 5'b1;

   assign y = row - (row % vmod);
   assign x = col - (col % hmod);

endmodule: mosaic_processing_unit

module mosaic_processing_unit
  (input logic [3:0] hscale, vscale,
   input logic mosaic,
   input logic [9:0] row, col,
   output logic x, y);

   logic [3:0] hmosaic, vmosaic;
   bg_mux_2_to_1 #(4) hmosaic_mux(.i0(4'b0), .i1(hscale), .s(mosaic), .y(hmosaic));
   bg_mux_2_to_1 #(4) vmosaic_mux(.i0(4'b0), .i1(vscale), .s(mosaic), .y(vmosaic));

   logic [4:0] hmod, vmod;
   assign hmod = {1'b0, hmosaic} + 5'b1;
   assign vmod = {1'b0, vmosaic} + 5'b1;

   assign y = row - (row % vmod);
   assign x = col - (col % hmod);

endmodule: mosaic_processing_unit

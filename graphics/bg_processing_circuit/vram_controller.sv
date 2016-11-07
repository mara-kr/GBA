module vram_controller
  (input logic [16:0] bg_addr,
   input logic [14:0] obj_addr,
   output logic [15:0] bg_data, obj_data,
   output logic [15:0] graphics_VRAM_A_addr,
   output logic [13:0] graphics_VRAM_B_addr,
   output logic [13:0] graphics_VRAM_C_addr,
   input logic [31:0] graphics_VRAM_A_data,
   input logic [31:0] graphics_VRAM_B_data,
   input logic [31:0] graphics_VRAM_C_data,
   input logic [2:0] bg_mode
  );

  always_comb begin
    graphics_VRAM_A_addr = bg_addr[15:0];
    graphics_VRAM_C_addr = obj_addr[13:0];
    graphics_VRAM_B_addr = bg_mode > 2 ? bg_addr[13:0] : obj_addr[13:0];
    
    obj_data = bg_mode > 2 || obj_addr[14] ? graphics_VRAM_C_data : graphics_VRAM_B_data;
    bg_data = bg_mode > 2 && bg_addr[16] ? graphics_VRAM_B_data : graphics_VRAM_C_data;
  end

endmodule: vram_controller

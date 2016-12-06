module vram_controller
  (input logic [16:0] bg_addr,
   input logic [15:0] bg_screen_addr,
   input logic [14:0] obj_addr,
   output logic [15:0] bg_data, obj_data, bg_screen_data,
   output logic [15:0] graphics_VRAM_A_addr,
   output logic [13:0] graphics_VRAM_B_addr,
   output logic [13:0] graphics_VRAM_C_addr,
   output logic [15:0] graphics_VRAM_A_addr2,
   input logic [31:0] graphics_VRAM_A_data,
   input logic [31:0] graphics_VRAM_B_data,
   input logic [31:0] graphics_VRAM_C_data,
   input logic [31:0] graphics_VRAM_A_data2,
   input logic [2:0] bgmode,
   input logic clock
  );

  logic [16:0] saved_bg_addr;
  logic [15:0] saved_bg_screen_addr;
  logic [14:0] saved_obj_addr;

  always_comb begin
    graphics_VRAM_A_addr = bg_addr[15:0];
    graphics_VRAM_C_addr = obj_addr[13:0];
    graphics_VRAM_B_addr = bgmode > 2 ? bg_addr[13:0] : obj_addr[13:0];
    graphics_VRAM_A_addr2 = bg_screen_addr;
    
    if(bgmode > 2) begin
      obj_data = saved_obj_addr[1] ? graphics_VRAM_C_data[31:16] : graphics_VRAM_C_data[15:0];
      if(saved_bg_addr[16]) begin
        bg_data = saved_bg_addr[1] ? graphics_VRAM_B_data[31:16] : graphics_VRAM_B_data[15:0];
      end
      else begin
        bg_data = saved_bg_addr[1] ? graphics_VRAM_A_data[31:16] : graphics_VRAM_A_data[15:0];
      end
    end
    else begin
      //bg_data = saved_bg_addr[1] ? graphics_VRAM_A_data[31:16] : graphics_VRAM_A_data[15:0];
      case(saved_bg_addr[1:0])
        2'b00: bg_data = {graphics_VRAM_A_data[15:0]};
        2'b01: bg_data = {graphics_VRAM_A_data[15:8], graphics_VRAM_A_data[15:8]};
        2'b10: bg_data = {graphics_VRAM_A_data[31:16]};
        2'b11: bg_data = {graphics_VRAM_A_data[31:24], graphics_VRAM_A_data[31:24]};
      endcase
      if(saved_obj_addr[14]) begin
        obj_data = saved_obj_addr[1] ? graphics_VRAM_C_data[31:16] : graphics_VRAM_C_data[15:0];
      end
      else begin
        obj_data = saved_obj_addr[1] ? graphics_VRAM_B_data[31:16] : graphics_VRAM_B_data[15:0];
      end
    end

    bg_screen_data = saved_bg_screen_addr[1] ? graphics_VRAM_A_data2[31:16] : graphics_VRAM_A_data2[15:0];
  end

  bg_register #(17) bg_addr_reg(.q(saved_bg_addr), .d(bg_addr), .clk(clock), .clear(1'b0), .enable(1'b1), .rst_b(1'b1));
  bg_register #(16) bg_screen_addr_reg(.q(saved_bg_screen_addr), .d(bg_screen_addr), .clk(clock), .clear(1'b0), .enable(1'b1), .rst_b(1'b1));
  bg_register #(15) obj_addr_reg(.q(saved_obj_addr), .d(obj_addr), .clk(clock), .clear(1'b0), .enable(1'b1), .rst_b(1'b1));
endmodule: vram_controller

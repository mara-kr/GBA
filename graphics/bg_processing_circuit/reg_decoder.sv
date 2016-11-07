module reg_decoder
  (input logic [15:0] bg0cnt, bg1cnt, bg2cnt, bg3cnt,
   input logic [15:0] bg0hofs, bg1hofs, bg2hofs, bg3hofs,
   input logic [15:0] bg0vofs, bg1vofs, bg2vofs, bg3vofs,
   input logic [27:0] bg2x, bg3x,
   input logic [27:0] bg2y, bg3y,
   input logic [15:0] bg2pa, bg2pb, bg2pc, bg2pd,
   input logic [15:0] bg3pa, bg3pb, bg3pc, bg3pd,
   input logic [1:0] bgno,
   input logic [2:0] bgmode,
   output logic [15:0] dx, dy, dmx, dmy,
   output logic [27:0] bgx, bgy,
   output logic [4:0] screen_base_block_no,
   output logic palettemode,
   output logic overflow,
   output logic bitmapped,
   output logic [1:0] char_base_block_no,
   output logic [9:0] hmax, vmax
  );

  logic [15:0] bgcnt, bghofs, bgvofs;

  bg_mux_4_to_1 #(16) cnt_mux(.y(bgcnt), .i0(bg0cnt), .i1(bg1cnt), .i2(bg2cnt), .i3(bg3cnt), .s(bgno)); 
  bg_mux_4_to_1 #(16) hofs_mux(.y(bghofs), .i0(bg0hofs), .i1(bg1hofs), .i2(bg2hofs), .i3(bg3hofs), .s(bgno)); 
  bg_mux_4_to_1 #(16) vofs_mux(.y(bgvofs), .i0(bg0vofs), .i1(bg1vofs), .i2(bg2vofs), .i3(bg3vofs), .s(bgno)); 

  //rotation parameters are don't cares for BGs 0 and 3
  bg_mux_2_to_1 #(16) dx_mux(.y(dx), .i0(bg2pa), .i1(bg3pa), .s(bgno[0])); 
  bg_mux_2_to_1 #(16) dmx_mux(.y(dmx), .i0(bg2pb), .i1(bg3pb), .s(bgno[0])); 
  bg_mux_2_to_1 #(16) dy_mux(.y(dy), .i0(bg2pc), .i1(bg3pc), .s(bgno[0])); 
  bg_mux_2_to_1 #(16) dmy_mux(.y(dmy), .i0(bg2pd), .i1(bg3pd), .s(bgno[0])); 
  bg_mux_2_to_1 #(28) bgx_mux(.y(bgx), .i0(bg2x), .i1(bg3x), .s(bgno[0])); 
  bg_mux_2_to_1 #(28) bgy_mux(.y(bgy), .i0(bg2y), .i1(bg3y), .s(bgno[0])); 

  assign screen_base_block_no = bgcnt[12:8];
  assign palettemode = bgcnt[7];
  assign overflow = bgcnt[13];
  assign char_base_block_no = bgcnt[3:2];
  assign bitmapped = bgmode > 3'd2;

  logic [1:0] screen_size;
  assign screen_size = bgcnt[15:14];

  logic is_rotation_bg;
  always_comb begin
    case(bgmode)
      3'd0: is_rotation_bg = 1'b0;
      3'd1: is_rotation_bg = 1'b0;
      3'd2: is_rotation_bg = 1'b0;
      3'd3: is_rotation_bg = 1'b0;
      3'd4: is_rotation_bg = 1'b0;
      3'd5: is_rotation_bg = 1'b0;
    endcase
  end

  logic [9:0] bitmap_hmax, bitmap_vmax;
  logic [9:0] text_rot_hmax, text_rot_vmax;
  assign bitmap_hmax = (bgmode == 3'd5) ? 10'd160 : 10'd240;
  assign bitmap_vmax = (bgmode == 3'd5) ? 10'd128 : 10'd160;

  always_comb begin
    case(screen_size)
      2'b00: begin
        if(is_rotation_bg) begin
          text_rot_hmax = 10'd127;
          text_rot_vmax = 10'd127;
        end
        else begin
          text_rot_hmax = 10'd255;
          text_rot_vmax = 10'd255;
        end
      end
      2'b01: begin
        if(is_rotation_bg) begin
          text_rot_hmax = 10'd255;
          text_rot_vmax = 10'd255;
        end
        else begin
          text_rot_hmax = 10'd511;
          text_rot_vmax = 10'd255;
        end
      end
      2'b10: begin
        if(is_rotation_bg) begin
          text_rot_hmax = 10'd511;
          text_rot_vmax = 10'd511;
        end
        else begin
          text_rot_hmax = 10'd255;
          text_rot_vmax = 10'd511;
        end
      end
      2'b11: begin
        if(is_rotation_bg) begin
          text_rot_hmax = 10'd1023;
          text_rot_vmax = 10'd1023;
        end
        else begin
          text_rot_hmax = 10'd511;
          text_rot_vmax = 10'd511;
        end
      end
    endcase
  end

  assign hmax = bitmapped ? bitmap_hmax : text_rot_hmax;
  assign vmax = bitmapped ? bitmap_vmax : text_rot_vmax;

endmodule: reg_decoder

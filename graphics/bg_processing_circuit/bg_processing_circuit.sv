`default_nettype none

module bg_processing_circuit
  (input logic [15:0] bg0cnt, bg1cnt, bg2cnt, bg3cnt,
   input logic [15:0] bg0hofs, bg1hofs, bg2hofs, bg3hofs,
   input logic [15:0] bg0vofs, bg1vofs, bg2vofs, bg3vofs,
   input logic [27:0] bg2x, bg3x,
   input logic [27:0] bg2y, bg3y,
   input logic [15:0] bg2pa, bg2pb, bg2pc, bg2pd,
   input logic [15:0] bg3pa, bg3pb, bg3pc, bg3pd,
   input logic [15:0] dispcnt,
   input logic [15:0] mosaic, //MOSAIC MMIO register

   output logic [7:0] hcount, //BG processing circuit will tell OBJ circuit which column to output to 
   output logic [2:0] bgmode,
   output logic [16:0] bg_addr, //Used to lookup palette/color info
   output logic [15:0] bg_screen_addr, //used to lookup screen data
   input logic [15:0] bg_VRAM_data, bg_screen_data, //VRAMA/B and VRAM A data connections

   output logic [19:0] bg_packet, //stage output

   input logic clock, rst_b
  );

  //control signals
  logic start_row;
  logic new_frame;
  logic frame;
  logic [7:0] vcount, row;

  //datapath signals 
  logic [8:0] col, col_INTERMEDIATE, col_OUTPUT;
  logic [1:0] bgno, bgno_INTERMEDIATE, bgno_OUTPUT;

  logic [15:0] dx, dmx, dy, dmy;
  logic [27:0] bgx, bgy;

  logic [4:0] screen_base_block_no;
  logic [1:0] char_base_block_no, char_base_block_no_INTERMEDIATE;

  logic [9:0] hmax, vmax;
  logic [9:0] hofs, vofs;

  logic palettemode, palettemode_INTERMEDIATE, palettemode_OUTPUT;
  logic overflow;
  logic bitmapped, bitmapped_INTERMEDIATE, bitmapped_OUTPUT;
  logic [1:0] bg_priority, bg_priority_INTERMEDIATE, bg_priority_OUTPUT;
  logic bgused, bgused_INTERMEDIATE, bgused_OUTPUT;
  logic transparent, transparent_INTERMEDIATE, transparent_OUTPUT;
  logic rotate, rotate_INTERMEDIATE;
  logic bitmap_color;

  logic [9:0] scroll_x, scroll_y;
  logic [9:0] rot_scale_x, rot_scale_y;
  logic rot_scale_overflowed;

  logic [9:0] selected_x, selected_y; //Filtered by scroll/rotation mux

  logic [3:0] vscale, hscale;
  logic enable_mosaic;

  logic [9:0] x, y; //(x,y) coordinates of pixel data
  logic [2:0] x_INTERMEDIATE, y_INTERMEDIATE; //3 least significant bits
  logic sixteen_color_dot_select, sixteen_color_dot_select_OUTPUT;

  logic [3:0] paletteno, paletteno_OUTPUT;

  logic [15:0] char_addr;
  logic [16:0] bitmap_addr, bitmap_addr_INTERMEDIATE;

  //control logic
  assign bgmode = dispcnt[2:0];
  assign hcount = col_OUTPUT[7:0];

  assign start_row = (col == 9'd307) & (&bgno);
  assign new_frame = start_row && (vcount == 8'd227);
  bg_counter #(8) row_counter(.q(vcount), .d(), .enable(start_row), 
                              .clear(new_frame), 
                              .load(1'b0), .up(1'b1), .rst_b, .clk(clock));
  assign row = vcount;

  assign vscale = mosaic[7:4];
  assign hscale = mosaic[3:0];

  bg_counter #(1) frame_toggle(.q(frame), .d(), .enable(new_frame), .clear(start_row), .load(1'b0), .up(1'b1), .rst_b, .clk(clock));
  always_comb begin
    case(bgno)
      2'd0: bgused = bgmode < 3'd2;
      2'd1: bgused = bgmode < 3'd2;
      2'd2: bgused = 1'b1;
      2'd3: bgused = ((bgmode == 3'd0) || (bgmode == 3'd2));
    endcase
  end

  //datapath logic
  bg_counter #(11) col_bgno_counter(.q({col, bgno}), .d(), .enable(1'b1), .clear(start_row), .load(1'b0), .up(1'b1), .rst_b, .clk(clock));

/*
  reg_decoder bg_decode
             (.bg0cnt, .bg1cnt, .bg2cnt, .bg3cnt,
              .bg0hofs, .bg1hofs, .bg2hofs, .bg3hofs,
              .bg0vofs, .bg1vofs, .bg2vofs, .bg3vofs,
              .bg2x, .bg3x, .bg2y, .bg3y,
              .bg2pa, .bg2pb, .bg2pc, .bg2pd, .bg3pa, .bg3pb, .bg3pc, .bg3pd,
              .hofs, .vofs, .bgno, .bgmode, .rotate,
              .dx, .dy, .dmx, .dmy, .bgx, .bgy,
              .screen_base_block_no, .char_base_block_no,
              .palettemode, .overflow, .bitmapped, .bitmap_color,
              .hmax, .vmax, .bg_priority, .mosaic(enable_mosaic));


  bg_scrolling_unit bsu(.hofs, .vofs, .row, .col(col[7:0]), .x(scroll_x), .y(scroll_y));
/*
//KEEP THIS COMMENTED
/*  bg_rot_scale_unit rsu(.A(dx), .B(dmx), .C(dy), .D(dmy), .bgx, .bgy,
                        .step(&bgno), .steprow(start_row), .newframe(new_frame),
                        .clock, .rst_b,
                        .x(rot_scale_x), .y(rot_scale_y),
                        .overflow(rot_scale_overflowed));
*/
/*
  bg_rot_scale_top rsu(.bg2x, .bg2y, .bg3x, .bg3y,
                        .bg2pa, .bg2pb, .bg2pc, .bg2pd,
                        .bg3pa, .bg3pb, .bg3pc, .bg3pd,
                        .bgno, .steprow(start_row), .newframe(new_frame),
                        .clock, .rst_b,
                        .x(rot_scale_x), .y(rot_scale_y),
                        .overflow(rot_scale_overflowed));

  bg_mux_2_to_1 #(10) rotation_scroll_x_mux(.i0(scroll_x), .i1(rot_scale_x), .s(rotate), .y(selected_x));
  bg_mux_2_to_1 #(10) rotation_scroll_y_mux(.i0(scroll_y), .i1(rot_scale_y), .s(rotate), .y(selected_y));

  mosaic_processing_unit mpu(.hscale, .vscale, .mosaic(enable_mosaic),
                             .col(selected_x), .row(selected_y), .x, .y);

  screen_lookup_unit slu(.hmax, .vmax, .x, .y, .screen_base_block_no, .rotate, .addr(bg_screen_addr));

  assign paletteno = bg_screen_data[15:12];

  char_data_lookup cdl(.screendata(bg_screen_data[11:0]),
                       .baseblock(char_base_block_no_INTERMEDIATE),
                       .rotate(rotate_INTERMEDIATE),
                       .x(x_INTERMEDIATE), .y(y_INTERMEDIATE),
                       .palettemode(palettemode_INTERMEDIATE),
                       .addr(char_addr), .sixteen_color_dot_select);

  bitmap_address_unit bmau(.x(x[7:0]), .y(y[7:0]), .hmax, .bitmap_color, .frame, .addr(bitmap_addr));
  
  bg_mux_2_to_1 #(17) bg_addr_mux(.i0({1'b0, char_addr}), .i1(bitmap_addr_INTERMEDIATE), .s(bitmapped_INTERMEDIATE), .y(bg_addr));

  overflow_handler ovrflw_hndlr(.hmax, .vmax, .x, .y, .rot_scale_overflowed,
                                .bitmapped, .rotate, .overflow, .transparent);

  //mux on x input shown on diagram is redundant, both inputs are identical
  data_formatter formatter(.data(bg_VRAM_data[14:0]),
                           .sixteen_color_dot_select(sixteen_color_dot_select_OUTPUT),
                           .paletteno(paletteno_OUTPUT),
                           .palettemode(palettemode_OUTPUT),
                           .transparent(transparent_OUTPUT),
                           .bitmapped(bitmapped_OUTPUT), .bgno(bgno_OUTPUT),
                           .bg_priority(bg_priority_OUTPUT),
                           .bgused(bgused_OUTPUT), .formatted(bg_packet));
*/
  assign bg_packet = 20'b0;
  //Here be registers.
  bg_pipeline #(3) x_int(.q(x_INTERMEDIATE), .d(x[2:0]), .clock);
  bg_pipeline #(3) y_int(.q(y_INTERMEDIATE), .d(y[2:0]), .clock);
  bg_pipeline #(1) dot_select_out(.q(sixteen_color_dot_select_OUTPUT), .d(sixteen_color_dot_select), .clock);

  bg_pipeline #(4) pno_out(.q(paletteno_OUTPUT), .d(paletteno), .clock);

  bg_pipeline #(1) pmode_int(.q(palettemode_INTERMEDIATE), .d(palettemode), .clock);
  bg_pipeline #(1) pmode_out(.q(palettemode_OUTPUT), .d(palettemode_INTERMEDIATE), .clock);

  bg_pipeline #(1) xparent_int(.q(transparent_INTERMEDIATE), .d(transparent), .clock);
  bg_pipeline #(1) xparent_out(.q(transparent_OUTPUT), .d(transparent_INTERMEDIATE), .clock);

  bg_pipeline #(1) bmap_int(.q(bitmapped_INTERMEDIATE), .d(bitmapped), .clock);
  bg_pipeline #(1) bmap_out(.q(bitmapped_OUTPUT), .d(bitmapped_INTERMEDIATE), .clock);

  bg_pipeline #(2) priority_int(.q(bg_priority_INTERMEDIATE), .d(bg_priority), .clock);
  bg_pipeline #(2) priority_out(.q(bg_priority_OUTPUT), .d(bg_priority_INTERMEDIATE), .clock);

  bg_pipeline #(1) used_int(.q(bgused_INTERMEDIATE), .d(bgused), .clock);
  bg_pipeline #(1) used_out(.q(bgused_OUTPUT), .d(bgused_INTERMEDIATE), .clock);

  bg_pipeline #(2) charblock_int(.q(char_base_block_no_INTERMEDIATE), .d(char_base_block_no), .clock);

  bg_pipeline #(1) rotate_int(.q(rotate_INTERMEDIATE), .d(rotate), .clock);

  bg_pipeline #(17) bmap_addr_int(.q(bitmap_addr_INTERMEDIATE), .d(bitmap_addr), .clock);

  bg_pipeline #(2) bgno_int(.q(bgno_INTERMEDIATE), .d(bgno), .clock);
  bg_pipeline #(2) bgno_out(.q(bgno_OUTPUT), .d(bgno_INTERMEDIATE), .clock);

  bg_pipeline #(9) col_int(.q(col_INTERMEDIATE), .d(col), .clock);
  bg_pipeline #(9) col_out(.q(col_OUTPUT), .d(col_INTERMEDIATE), .clock);

endmodule: bg_processing_circuit

`default_nettype wire

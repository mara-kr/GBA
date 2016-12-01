module data_formatter
  (input logic [14:0] data,
   input logic sixteen_color_dot_select,
   input logic palettemode,
   input logic bitmapped, transparent,
   input logic [3:0] paletteno,
   input logic [1:0] bgno,
   input logic [1:0] bg_priority,
   input logic bgused,
   output logic [19:0] formatted);

  logic [7:0] palette_index;
  logic visible;
  logic [7:0] pinfo;

  logic [7:0] palette_byte;

  assign palette_byte[7:4] = 4'b0;
  bg_mux_2_to_1 #(4) small_palette_mux(.i0(data[3:0]), .i1(data[7:4]), .s(sixteen_color_dot_select), .y(palette_byte[3:0]));
  bg_mux_2_to_1 #(8) palette_mux(.i0(palette_byte), .i1(data[7:0]), .s(palettemode), .y(palette_index));

  assign visible = (|palette_index | bitmapped) & bgused & ~transparent;

  bg_mux_2_to_1 #(8) pinfo_mux(.i0({paletteno, palette_index[3:0]}), .i1(palette_index), .s(palettemode), .y(pinfo));

  logic [14:0] bitmapped_data, char_data, payload;
  assign char_data = {4'b0, bgno, 1'b0, pinfo};
  assign bitmapped_data = data;
  bg_mux_2_to_1 #(15) payload_mux(.i0(char_data), .i1(bitmapped_data), .s(bitmapped), .y(payload));

  assign formatted = {bg_priority, 1'b0, bitmapped, visible, payload};

endmodule: data_formatter

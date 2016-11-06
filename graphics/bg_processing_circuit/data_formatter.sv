module data_formatter
  (input logic [14:0] data,
   input logic x,
   input logic palettemode, bitmapped,
   input logic bitmapped, transparent,
   input logic [3:0] paletteno,
   input logic [1:0] bgno,
   input logic [1:0] bg_priority,
   output logic [19:0] formatted);

  logic [7:0] palette_index;
  logic visible;
  logic [7:0] pinfo;

  logic [7:0] palette_byte;

  assign palette_byte[7:4] = 4'b0;
  graphics_mux_2_to_1 #(4) small_palette_mux(.I0(data[3:0]), .I1(data[7:4]), .S(x), .Y(palette_byte[3:0]));
  graphics_mux_2_to_1 #(8) palette_mux(.I0(palette_byte), .I1(data[7:0]), .S(palettemode), .Y(palette_index));

  assign visible = (|palette_index | bitmapped) & bgused & ~transparent;

  graphics_mux_2_to_1 #(8) pinfo_mux(.IO({paletteno, paletteindex[3:0]}), .I1(paletteindex), .S(palettemode), .Y(pinfo));

  logic [14:0] bitmapped_data, char_data, payload;
  assign char_data = {4'b0, bgno, 1'b0, pinfo};
  assign bitmapped_data = data;
  graphics_mux_2_to_1 #(15) payload_mux(.I0(char_data), .I1(bitmapped_data), .S(bitmapped), .Y(payload));

  assign formatted = {bg_priority, 1'b0, bitmapped, visible, payload};

endmodule: data_formatter

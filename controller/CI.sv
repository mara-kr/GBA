/* Color coding:
 * Red => VDD
 * Yellow => Data Clock (JA3)
 * Green => Data Latch (JA2)
 * Blue => Serial Data (JA1)
 * Black => Ground */

module ChipInterface (
    input  logic JA7, GCLK, BTND,
    output logic JA8, JA9,
    output logic [7:0] LD);

    logic [15:0] buttons;

    controller cont (.data_latch(JA8), .data_clock(JA9),
                     .serial_data(JA7), .buttons, .clock(GCLK),
                     .reset_n(~BTND));

    assign LD = buttons[15:8];

endmodule: ChipInterface

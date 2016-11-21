/* Chip Interface for a simple test of the controller
 *
 * See interface.txt for what "buttons" should be given the controller state
 *
 * Wire Color coding:
 *      Red => VDD (PMOD VDD for low side, 5V zedboard pin for high side)
 *      Yellow => Data Clock (JA3)
 *      Green => Data Latch (JA2)
 *      Blue => Serial Data (JA1)
 *      Black => Ground (Ground on PMOD connector)
 *      JA{1-3} is the top row on the PMOD connector
 */

module ChipInterface (
    input  logic JA1, GCLK, BTND,
    input  logic [7:0] SW,
    output logic JA2, JA3,
    output logic [7:0] LD);

    logic [15:0] buttons;

    controller cont (.data_latch(JA2), .data_clock(JA3),
                     .serial_data(JA1), .buttons, .clock(GCLK),
                     .reset(BTND));

    assign LD = (SW[0]) ? buttons[15:8] : buttons[7:0];

endmodule: ChipInterface

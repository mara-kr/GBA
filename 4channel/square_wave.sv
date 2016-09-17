module square_wave (
    input logic system_clock,
    input logic [7:0] NRx1,
    input logic [7:0] NRx3,
    input logic [7:0] NRx4,
    output logic [27:0] wave;

    //clocked at frequeny*4
    logic [2:0] num_cycles;
    logic [3:0] max_cycles_high;
    logic [1:0] duty_cycle;
    logic frequency_timer_period;
    logic [10:0]frequency;

    assign frequency = {NRx4[2:0], NRx3[7:0]};
    assign frequency_timer_period = frequency*4;
    assign duty_cycle = NRx1 [7:6]A

    frequency_timer ft(system_clock, frequency_timer_period, frequency_timer_clock);
    always_comb begin
        case (duty_cycle)
            2'b00: max_cycles_high = 1; //12.5%
            2'b01: max_cycles_high = 2; //25%
            2'b10: max_cycles_high = 4; //50%
            2'b11: max_cycles_high = 6; //75%
        endcase
    end

    always_ff (@posedge frequency_timer_clock) begin
        if (num_cycles < max_cycles_high) begin
            wave = 27'0000_1000_0000_0000_0000_0000_0000; //equivalent to a 1
        end
        else begin
            wave = 27'1111_1000_0000_0000_0000_0000_0000; //equivalent to a -1
        end
    end

endmodule: square_wave

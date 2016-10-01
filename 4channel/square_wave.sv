`default_nettype none
module square_wave (
    input logic system_clock,
    input logic reset,
    input logic [7:0] NRx1,
    input logic [7:0] NRx3,
    input logic [7:0] NRx4,
    output logic [3:0] wave);

    //clocked at frequeny*4
    logic [2:0] num_cycles;
    logic [3:0] max_cycles_high;
    logic [1:0] duty_cycle;
    logic [12:0] frequency_timer_period;
    logic [10:0]frequency;
    logic frequency_timer_clock;

    assign frequency = {NRx4[2:0], NRx3[7:0]};
    assign frequency_timer_period = (2048-frequency)*4;
    assign duty_cycle = NRx1 [7:6];

    frequency_timer ft(system_clock, reset, frequency_timer_period, frequency_timer_clock);
    always_comb begin
        case (duty_cycle)
            2'b00: max_cycles_high = 1; //12.5%
            2'b01: max_cycles_high = 2; //25%
            2'b10: max_cycles_high = 4; //50%
            2'b11: max_cycles_high = 6; //75%
        endcase
    end

    always_ff @(posedge frequency_timer_clock, posedge reset) begin
        if (reset) begin
            num_cycles <= 0;
        end
        else if (num_cycles < max_cycles_high) begin
            num_cycles <= num_cycles + 1;
           // wave = 28'b0000_1000_0000_0000_0000_0000_0000; //equivalent to a 1
            wave = 4'b1;
        end
        else begin
            num_cycles <= num_cycles + 1;
            //wave = 28'b1111_1000_0000_0000_0000_0000_0000; //equivalent to a -1
            wave = 4'b0;
        end
    end

endmodule: square_wave

/*module square_wave_test();
    logic clock;
    logic reset;
    logic [7:0] NRx1;
    logic [7:0] NRx3;
    logic [7:0] NRx4;
    logic [3:0] wave;

    square_wave dut(clock, reset, NRx1, NRx3, NRx4, wave);
    initial begin
        $monitor("freq_clock=%b, reset=%b, duty_cycle:%b, freq_bits;%b, output:%b, num_cycles=%d",
             dut.frequency_timer_clock, reset, NRx1[7:6], {NRx4[2:0], NRx3[7:0]}, wave, dut.num_cycles);

        clock = 0;
        reset = 1;
        #2 reset = 0;
        //test duty -> should be 50%
        $display("check duty cycle is 50 percent");
        NRx1[7:6] = 2'b10;
        NRx4 = 3'b111;
        NRx3 = 8'b11111111;
        //TODO: add asserts here
        
        #320
        //test duty -> should be 12.5%
        $display("check duty cycle is 12.5 percent");
        NRx1[7:6] = 2'b00;
        NRx4 = 3'b111;
        NRx3 = 8'b11111111;
        
        
        #320
        $display("check duty cycle is 25 percent");
        NRx1[7:6] = 2'b01;
        
        #320
        $display("check duty cycle is 75 percent");
        NRx1[7:6] = 2'b11;
        #320 $finish;

    end
    always
        #1 clock = !clock;
endmodule: square_wave_test*/

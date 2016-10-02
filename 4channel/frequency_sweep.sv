//`default_nettype none
module frequency_sweep (
        input logic clock_128,
        input logic reset,
        input logic [7:0] NR10,
        input logic [7:0] NR13,
        input logic [7:0] NR14,
        output logic [7:0] internal_NR13_reg,
        output logic [7:0] internal_NR14_reg,
        output logic enable_square_wave);
        
        logic enable_flag;
        logic [10:0] freq_shadow;
        logic [10:0] new_frequency;
        logic [2:0] sweep_shift;
        logic decrease;
        logic [2:0] sweep_period;
        logic [2:0] sweep_timer;
        logic [11:0] calc_freq;
        logic initialization;
        logic overflow;

        logic update_regs;
        logic [7:0] NR13_old;
        logic [7:0] NR14_old;
        
        assign sweep_shift = NR10[2:0];
        assign decrease = NR10[3];
        assign sweep_period = NR10[6:4];

        assign calc_freq = (decrease) ? -(freq_shadow >> sweep_shift) + freq_shadow : 
                                        (freq_shadow >> sweep_shift) + freq_shadow;
        assign overflow = (calc_freq > 2047) ? 1 : 0;
        assign enable_square_wave = ~overflow;
        assign initialization = NR14[7];

        assign new_frequency = {internal_NR14_reg[2:0], internal_NR13_reg};
        assign update_regs = (NR13 != NR13_old || NR14 != NR14_old) ? 1 : 0;
        
        
        always_ff @(posedge clock_128, posedge reset) begin
            if (reset) begin
                sweep_timer <= sweep_period;
                freq_shadow <= {NR14[2:0], NR13};
                enable_flag <= 0;
            end
            else if (sweep_timer == 0) begin
                sweep_timer <= sweep_period;
                if (sweep_period != 0  && sweep_shift != 0) begin
                    enable_flag <= 1;
                end
                else begin
                    enable_flag <= 0;
                end
            end
            else begin
                enable_flag <= 0;
                sweep_timer <= sweep_timer - 1;
            end
            freq_shadow <= new_frequency;
            NR13_old <= NR13;
            NR14_old <= NR14;
        end
        
        always_ff @(posedge clock_128, posedge reset) begin
            if (update_regs || reset) begin
                internal_NR13_reg <= NR13;
                internal_NR14_reg <= NR14;
            end
            else if (!overflow && enable_flag) begin
                internal_NR13_reg <= calc_freq[7:0];
                internal_NR14_reg <= {5'b0, calc_freq[10:8]};
            end
            else begin
                internal_NR13_reg <= internal_NR13_reg;
                internal_NR14_reg <= internal_NR14_reg;
            end
         end

endmodule: frequency_sweep

//This is a cursory test to make sure things are changing
//didn't want to deal with the inout port
/**
module frequency_sweep_test();
    logic clock;
    logic reset;
    logic [7:0] NR10;
    logic [7:0] NR13;
    logic [7:0] NR14;
    logic [10:0]new_frequency;
    logic enable_square_wave;

    frequency_sweep dut(clock, reset, NR10, NR13, NR14, new_frequency, enable_square_wave);

    initial begin
        $monitor("clock=%b, reset %b, freq_data=%b, sweep_time=%b, decrease=%b, sweep shift=%b, new freq=%b, enable=%b, sweep_timer=%b",
            clock, reset, {NR14[2:0], NR13}, NR10[6:4], NR10[3], NR10[2:0], new_frequency, enable_square_wave,
            dut.sweep_timer);

        clock <= 0;
        reset <= 1;
        #1;

        #2 reset <= 0;
            NR10 = 8'b11111001;
            {NR14[2:0], NR13} = 11'b111111;

        #20 $finish;
    end


    always
        #1 clock = !clock;

endmodule: frequency_sweep_test
*/

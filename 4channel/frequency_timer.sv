
module frequency_timer (
    input logic clock, 
    input logic reset,
    input logic [16:0]frequency_timer_period, 
    output logic frequency_timer_clock);
    
    logic [16:0] counter;
    logic update_regs;
    
    logic [16:0]frequency_timer_period_old;

    assign update_regs = (frequency_timer_period != frequency_timer_period_old)
                         ? 1 : 0;
    always_ff @(posedge clock, posedge reset) begin
        if(reset) begin
            counter = 0;
            frequency_timer_clock <= 0;
            frequency_timer_clock <= 0;
        end
        else if(counter == (frequency_timer_period - 1'b1) || update_regs) begin
            counter <= 0;
            frequency_timer_clock <= ~frequency_timer_clock;

        end
        else begin
            counter <= counter + 1;
        end
        frequency_timer_period_old <= frequency_timer_period;
    end
    
endmodule: frequency_timer


//just going to test that the output clock for is slower for higher period
/*
module frequency_timer_test;
    logic clock, reset;
    logic [12:0] frequency_timer_period;
    logic frequency_timer_clock;


    frequency_timer dut(clock, reset, frequency_timer_period, frequency_timer_clock);

    initial begin
        $monitor("clock=%b, reset=%b, period=%b, output_clock=%b",
                  clock, reset, frequency_timer_period, frequency_timer_clock);

        clock <= 1;
        reset <= 1;

        #2 reset <= 0;
        frequency_timer_period = 1;
        #10
        frequency_timer_period = 5;
        #20 $finish;
    end

    always
        #1 clock = !clock;

endmodule: frequency_timer_test */

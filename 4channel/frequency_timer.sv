
module frequency_timer (
    input logic clock, 
    input logic reset,
    input logic [10:0]frequency_timer_period, 
    output logic frequency_timer_clock);
    
    logic period;
    logic counter;

    assign period = 4194304/frequency_timer_period;

    always_ff (@posedge clock, @posedge reset) begin
        if(reset) begin
            counter = 0;
            frequency_timer_clock <= 0;
        end
        else if(counter == 0) begin
            counter <= period;
            frequency_timer_clock <= ~frequency_timer_clock;

        end
        else begin
            counter <= counter -1;
        end
    end
    
endmodule: frequency_timer


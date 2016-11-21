module clock_divider (
    input logic clock_256,
    input logic reset,
    output logic clock_128,
    output logic clock_64);

    logic [2:0] counter;

    always_ff @(posedge clock_256, posedge reset) begin
        if (reset) counter <= 0;
        else counter <= counter + 1;

        clock_128 <= counter[1];
        clock_64 <= counter[2];
    end

endmodule: clock_divider


/*module clock_divider_test ();
    logic clock_512;
    logic clock_256;
    logic clock_128;
    logic clock_64;
    logic reset;
    clock_divider dut(clock_512, reset, clock_256, clock_128, clock_64);
    initial begin 
        $monitor($time, "reset=%b, clock_512=%b, clock_256=%b, clock_128=%b, clock_64=%b, counter=%b",
                reset, clock_512, clock_256, clock_128, clock_64, dut.counter);
        #1 reset = 1;
           clock_512 = 0;
        #1 reset = 0;
        #40 $finish;
    end
    always    
         #1 clock_512 = !clock_512;
endmodule: clock_divider_test*/
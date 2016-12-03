`default_nettype none
//Assumptions: processor can only update the timer setting (TMxCNT_L) when
// the timer is paused when the timer is running it will internally update its setting

module timer (
    input logic clock_16,
    input logic reset,
    input logic [15:0] TMxCNT_L,
    input logic [15:0] TMxCNT_H,
    input logic [15:0] prev_timer,
    output logic [15:0] internal_TMxCNT_L,
    output logic genIRQ);

    //every control point from control registers
    logic start_timer;
    logic prev_start_timer;
    logic enable_irq;
    logic count_up_timing;
    logic [1:0] prescaler;
    logic count_up;
    logic prev_timer_finished;

    logic cycles_64;
    logic cycles_256;
    logic cycles_1024;


    assign start_timer = TMxCNT_H[7];
    assign enable_irq = TMxCNT_H[6];
    assign count_up_timing = TMxCNT_H[2];
    assign prescaler = TMxCNT_H[1:0];
    assign count_up = (count_up_timing) ? start_timer: (start_timer && prev_timer_finished);

    logic [15:0] timer_register;
    assign internal_TMxCNT_L = timer_register;

    logic start_from_0_to_1;
    assign start_from_0_to_1 = (prev_start_timer == 1'b0 && start_timer == 1'b1) ? 1'b1 : 1'b0;

    //logic from prescaler clock to run at
    timer_clock_divider tcd (.clock_16, .reset(reset), .cycles_64, .cycles_256, .cycles_1024);
    logic internal_clock;
    always_comb begin
        case (prescaler) //based on prescaler
            2'b00: internal_clock = clock_16;
            2'b01: internal_clock = cycles_64;
            2'b10: internal_clock = cycles_256;
            2'b11: internal_clock = cycles_1024;
            default: internal_clock = clock_16;
        endcase
    end

    always_ff @(posedge clock_16) begin
        if (reset || start_timer == 0)begin
            prev_timer_finished <= 0;
            prev_start_timer <= 0;
        end
        else if (prev_timer == 16'hFF) begin
            prev_timer_finished <=1;
        end
        else begin
            prev_timer_finished <= prev_timer_finished;
        end
        prev_start_timer <= start_timer;
    end

    always_ff @(posedge internal_clock) begin
        if (start_from_0_to_1) begin
            timer_register <= TMxCNT_L;
        end
        if (timer_register == 16'hFF) begin
            if (enable_irq) begin
                genIRQ <= 1;
            end
            else begin
                genIRQ <= 0;
            end
            timer_register <= TMxCNT_L;
        end
        else if (~count_up_timing) begin
            timer_register <= timer_register + 1;
        end
    end

endmodule: timer

module timer_clock_divider (
    input logic clock_16,
    input logic reset,
    output logic cycles_64,
    output logic cycles_256,
    output logic cycles_1024);

    logic [9:0] count;

    assign cycles_64 = count[5];
    assign cycles_256 = count[7];
    assign cycles_1024 = count[9];

    always_ff @(posedge clock_16, posedge reset) begin
        if(reset == 1) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end
 endmodule: timer_clock_divider


/*module timer_test ();
    logic clock_16;
    logic reset;
    wire [15:0] TMxCNT_L;
    logic [15:0] TMxCNT_H;
    logic genIRQ;

    timer dut(.clock_16, .reset, .TMxCNT_L, .TMxCNT_H, .genIRQ);

    logic start_timing;

    assign TMxCNT_L = (start_timing) ? 16'bZ : 16'b0;

    initial begin
        $monitor ("clock=%b, reset=%b, TMxCNT_L=%b, genIRQ=%b, start_timing=%b start_timer=%b",
                    clock_16, reset, TMxCNT_L, genIRQ, start_timing, dut.start_timer);
        clock_16 <= 0;
        reset <= 1;
        start_timing <= 0;
        TMxCNT_H <= 16'b0;
        #2
        reset <= 0;
        TMxCNT_H <= 16'b00000000_1_0_000_0_00;
        start_timing <= 1;
        #16 $finish;
    end
    always
        #1 clock_16 = !clock_16;
endmodule: timer_test*/

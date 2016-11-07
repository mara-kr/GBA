module fsm(
    input logic clock,
    input logic reset,
    output logic clear,
    output logic [7:0] col);

    logic incr_col;
    logic [1:0] cycle_delay_3;
    
    enum logic [7:0] {START, P0, P1, P2, P3} cs, ns;

    always_comb begin
        clear = 0;
        incr_col = 0;
        case (cs)
            START: begin
                clear = 1;
                if (cycle_delay_3 == 3) begin 
                    ns = P0;
                end
                else begin
                    ns = START;
                end
            end
            P0: begin
                ns = P1;
            end
            P1: begin
                ns = P2;
            end
            P2: begin
                ns = P3;
            end
            P3: begin
                clear = 1;
                incr_col = 1;
                ns = P0;
            end
        endcase
    end
    always_ff @(posedge clock, posedge reset) begin
        if (reset)
            cs <= START;
        else
            cs <= ns;
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            cycle_delay_3 <= 1;
        end
        else begin
            cycle_delay_3 <= cycle_delay_3 + 1;
        end
    end

    always_ff @(posedge clock, posedge reset) begin
        if (reset) begin
            col <= 0;
        end
        else if (incr_col == 1) begin
            col <= col + 1;
        end
        else if (col == 8'd159) 
            col <= 0;
        else begin
            col <= col;
        end
    end

endmodule: fsm


/**module fsm_tb ();
    
    logic clock;
    logic reset;
    logic clear;
    logic [7:0] col;

    fsm dut (clock, reset, clear, col);

    initial begin
        $monitor ("clock %b, reset %b, clear %b, col %d, state=%s", clock, reset, clear, col, dut.cs);
        reset <= 1;
        clock <= 0;
        #2 reset <= 0;
        #30 $finish;
    end

    always 
        #1 clock = !clock;
endmodule: fsm_tb */

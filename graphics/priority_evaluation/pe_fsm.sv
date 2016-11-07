module fsm(
    input logic clock,
    input logic reset,
    output logic clear,
    output logic [7:0] col,
    output logic send_address_1,
    output logic send_address_2,
    output logic read_data_1,
    output logic read_data_2);

    logic incr_col;
    logic [1:0] cycle_delay_3;
    
    enum logic [7:0] {START, P0, P1, P2, P3} cs, ns;

    always_comb begin
        clear = 0;
        incr_col = 0;
        send_address_1 = 0;
        send_address_2 = 0;
        read_data_1 = 0;
        read_data_2 = 0;
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
                read_data_2 = 1;
            end
            P1: begin
                ns = P2;
            end
            P2: begin
                ns = P3;
                send_address_1 = 1;
            end
            P3: begin
                clear = 1;
                incr_col = 1;
                send_address_2 = 1;
                ns = P0;
                read_data_1 = 1;
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
    logic send_address_1;
    logic send_address_2;

    fsm dut (clock, reset, clear, col, send_address_1, send_address_2);

    initial begin
        $monitor ("clock %b, reset %b, clear %b, col %d, send addr1 %b, send addr2 %b, state=%s", 
            clock, reset, clear, col, send_address_1, send_address_2, dut.cs);
        reset <= 1;
        clock <= 0;
        #2 reset <= 0;
        #30 $finish;
    end

    always 
        #1 clock = !clock;
endmodule: fsm_tb */

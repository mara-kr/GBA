`default_nettype none
module attribute_lookup_unit (
    input  logic        clock, reset,
    output logic [15:0] A, B, C, D,
    output logic  [7:0] OAMaddr,
    output logic        readOAM, done,
    input  logic [31:0] OAMdata,
    input  logic  [4:0] attrno,
    input  logic        start);

    logic [7:0] reg_out;
    logic       writeA, writeB, writeC, writeD;
    logic       loadAttrNo;
    enum logic [2:0] {IDLE, WRITE_A, WRITE_B, WRITE_C, WRITE_D, FINISH} cs, ns;

    always_ff @(posedge clock, posedge reset) begin
        if (reset) cs <= IDLE;
        else cs <= ns;
    end

    obj_register #(8) addr_reg (.clock, .reset, .q(reg_out), .d(OAMaddr + 8'd4),
                                .clear(1'b0), .en(1'b1));
    // Increment to read every other word
    assign OAMaddr = (loadAttrNo) ? {attrno[4:0], 3'b0} : reg_out[7:0];

    obj_register #(16) regA (.clock, .reset, .q(A), .d(OAMdata[31:16]),
                             .clear(1'b0), .en(writeA));
    obj_register #(16) regB (.clock, .reset, .q(B), .d(OAMdata[31:16]),
                             .clear(1'b0), .en(writeB));
    obj_register #(16) regC (.clock, .reset, .q(C), .d(OAMdata[31:16]),
                             .clear(1'b0), .en(writeC));
    obj_register #(16) regD (.clock, .reset, .q(D), .d(OAMdata[31:16]),
                             .clear(1'b0), .en(writeD));

    // State machine
    always_comb begin
        loadAttrNo = 1'b0;
        readOAM = 1'b0;
        writeA = 1'b0;
        writeB = 1'b0;
        writeC = 1'b0;
        writeD = 1'b0;
        done = 1'b0;
        ns = IDLE;
        case (cs)
            IDLE: begin
                loadAttrNo = start;
                readOAM = start;
                ns = (start) ? WRITE_A : IDLE;
            end
            WRITE_A: begin
                writeA = 1'b1;
                readOAM = 1'b1;
                ns = WRITE_B;
            end
            WRITE_B: begin
                writeB = 1'b1;
                readOAM = 1'b1;
                ns = WRITE_C;
            end
            WRITE_C: begin
                writeC = 1'b1;
                readOAM = 1'b1;
                ns = WRITE_D;
            end
            WRITE_D: begin
                writeD = 1'b1;
                ns = FINISH;
            end
            FINISH: begin
                done = 1'b1;
                ns = IDLE;
            end
        endcase
    end
endmodule: attribute_lookup_unit

`default_nettype wire

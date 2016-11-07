`default_nettype none
module attribute_lookup_unit (
    input  logic        clock, reset,
    output logic [15:0] A, B, C, D,
    output logic  [6:0] OAMaddr,
    output logic        readOAM, done,
    input  logic [63:0] OAMdata,
    input  logic  [4:0] attr_no,
    input  logic        loadAttrNo, start);

    logic [6:0] reg_out;
    logic       writeA, writeB, writeC, writeD;
    enum logic [2:0] {IDLE, WRITE_A, WRITE_B, WRITE_C, WRITE_D, FINISH} cs, ns;

    always_ff @(posedge clock, posedge reset) begin
        if (reset) cs <= IDLE;
        else cs <= ns;
    end

    obj_register #(7) addr_reg (.clock, .reset, .q(reg_out), .d(OAMaddr + 1),
                                .clear(1'b0), .en(1'b1));
    assign OAMaddr = (loadAttrNo) ? {attr_no, 2'b0} : reg_out;

    obj_register #(16) regA (.clock, .reset, .q(A), .d(OAMdata[63:48]),
                             .clear(1'b0), .en(writeA));
    obj_register #(16) regB (.clock, .reset, .q(B), .d(OAMdata[63:48]),
                             .clear(1'b0), .en(writeB));
    obj_register #(16) regC (.clock, .reset, .q(C), .d(OAMdata[63:48]),
                             .clear(1'b0), .en(writeC));
    obj_register #(16) regD (.clock, .reset, .q(D), .d(OAMdata[63:48]),
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

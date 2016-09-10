`default_nettype none

module alu_sv_tb;
    logic [31:0] ADATAIN, BDataIn, DataOut;
    logic        InvA, InvB, PassA, PassB;
    logic        AND_Op, ORR_Op, EOR_Op; // Logic Operations
    logic        CFlagIn, CFlagUse; // Flag inputs
    logic        CFlagOut, VFlagOut, NFlagOut, ZFlagOut; // Flag outputs

    logic nRESET, CLK;

    ALU alu (.ADATAIN(ADATAIN), .BDATAIN(BDataIn), .DATAOUT(DataOut),
             .INVA(InvA), .INVB(InvB), .PASSA(PassA), .PASSB(PassB),
             .AND_OP(AND_Op), .ORR_OP(ORR_Op), .EOR_OP(EOR_Op),
             .CFLAGIN(CFlagIn), .CFLAGUSE(CFlagUse),
             .CFLAGOUT(CFlagOut), .VFLAGOUT(VFlagOut), .NFLAGOUT(NFlagOut),
             .ZFLAGOUT(ZFlagOut));

    initial begin
        CLK = 1'b0;
        nRESET = 1'b1;
        #1 nRESET <= 1'b0;
        #1 nRESET <= 1'b1;
        forever #5 CLK <= ~CLK;
    end

    initial begin
        $monitor("DataOut=%d\tA=%d\tB=%d", DataOut, ADATAIN, BDataIn);
        @(posedge CLK);
        @(posedge CLK);
        ADATAIN <= 32'd123;
        BDataIn <= 32'd234;
        InvA <= 1'b0;
        InvB <= 1'b0;
        PassA <= 1'b0;
        PassB <= 1'b0;
        AND_Op <= 1'b0;
        ORR_Op <= 1'b0;
        EOR_Op <= 1'b0;
        CFlagUse <= 1'b0;
        @(posedge CLK);
        @(posedge CLK);
        $finish;
    end
endmodule: alu_sv_tb

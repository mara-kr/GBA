// Simulate ARMCoreSimTop so that it actually stops at some point
//  (what a concept)

module CoreSimTimer;

    ARMCoreSimTop ();

    initial begin
        #100 $finish;
    end

endmodule: CoreSimTimer

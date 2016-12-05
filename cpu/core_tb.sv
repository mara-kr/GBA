`default_nettype none

/* Testbench system for ARM7TDMI-S Core
 * Author: Neil Ryan, nryan@andrew.cmu.edu
 *
 * Reads BIOS ROM from $(GBA_CPU_BIOS_FILE)
 * Reads GamePak ROM from $(GBA_CPU_ROM_FILE)
 * Logs bus interactions to $(GBA_CPU_BUS_LOG) if `BUS_LOG_EN is defined
 *
 * TODO Add IRQ (Interrupt Request) generator module
 */

module core_tb;
    logic clk, pause;
    logic rst_n;
    logic irq_n; // Interrupt Request
    // Memory interface
    logic [31:0] addr, wdata;
    wire  [31:0] rdata;
    logic [4:0] mode;
    logic [1:0] size;
    logic abort, write, preemptable;


    ARM7TDMIS_Top DUT (.CLK(clk), .PAUSE(pause), .NRESET(rst_n),
                       .NIRQ(irq_n), .ADDR(addr), .WDATA(wdata),
                       .RDATA(rdata), .SIZE(size), .ABORT(abort),
                       .WRITE(write), .MODE(mode), .NFIQ(1'b1),
                       .PREEMPTABLE(preemptable));

    bus_monitor #("GBA_CPU_BUS_LOG") busMon (.clk, .rst_n, .pause, .addr,
                                             .wdata, .rdata, .size, .abort,
                                             .write);

    sim_memory sim_mem (.clk, .rst_n, .addr, .wdata, .size, .write,
                         .rdata, .abort, .pause);

    /* Clock and Reset Generation */
    initial begin
        $display("Start"); // Start of SIM for diff script
        clk = 0;
        rst_n = 1'b1;
        irq_n = 1'b1;
        #1 rst_n <= 1'b0;
        #1 rst_n <= 1'b1;
        forever #1 clk <= ~clk;
    end

    integer cyc_count, inst_count;
    logic [31:0] inst_pc;
    logic inst_ex;
    /* So the simulation stops */
    initial begin
        #20001 irq_n <= 1'b0;
        #14 irq_n <= 1'b1;
        #10000 $finish;
    end

    assign inst_pc = (DUT.ThDC_ThumbDecoderEn) ?
                      DUT.RegFile_Inst.RegFileAOut[15] - 4 :
                      DUT.RegFile_Inst.RegFileAOut[15] - 8;

    assign inst_ex = ~DUT.ControlLogic_Inst.Branch_St1 &&
                     ~DUT.ControlLogic_Inst.Branch_St2 &&
                     ~DUT.IPDR_StagnatePipeline;

    always_ff @(posedge clk) begin
        if (rst_n) begin
            if (DUT.ControlLogic_Inst.IDR_Branch &&
               ~DUT.ControlLogic_Inst.Branch_St1 &&
               ~DUT.ControlLogic_Inst.Branch_St2)
               $display("%h -> %h (%b)",
               DUT.RegFile_Inst.PCOut, addr, DUT.ControlLogic_Inst.CPSROut[5]);
            /*
            $display("r0\t\t%h", DUT.RegFile_Inst.RegFileAOut[0]);
            $display("r1\t\t%h", DUT.RegFile_Inst.RegFileAOut[1]);
            $display("r2\t\t%h", DUT.RegFile_Inst.RegFileAOut[2]);
            $display("r3\t\t%h", DUT.RegFile_Inst.RegFileAOut[3]);
            $display("r4\t\t%h", DUT.RegFile_Inst.RegFileAOut[4]);
            $display("r5\t\t%h", DUT.RegFile_Inst.RegFileAOut[5]);
            $display("r6\t\t%h", DUT.RegFile_Inst.RegFileAOut[6]);
            $display("r7\t\t%h", DUT.RegFile_Inst.RegFileAOut[7]);
            $display("r8\t\t%h", DUT.RegFile_Inst.RegFileAOut[8]);
            $display("r9\t\t%h", DUT.RegFile_Inst.RegFileAOut[9]);
            $display("r10\t\t%h", DUT.RegFile_Inst.RegFileAOut[10]);
            $display("r11\t\t%h", DUT.RegFile_Inst.RegFileAOut[11]);
            $display("r12\t\t%h", DUT.RegFile_Inst.RegFileAOut[12]);
            $display("sp\t\t%h", DUT.RegFile_Inst.RegFileAOut[13]);
            $display("lr\t\t%h", DUT.RegFile_Inst.RegFileAOut[14]);
            $display("pc\t\t%h", DUT.RegFile_Inst.RegFileAOut[15]);
            $display("cpsr\t%h\n", DUT.PSR_Inst.CPSR);
            */
            //if (inst_ex)
            //    $display("Inst #:\t%d\nPC:\t%h\nInst:\t%h\n\n",
            //                  inst_count, inst_pc,
            //                  DUT.ControlLogic_Inst.InstForDecodeLatched);
        end
    end

    /* Clock cycle counter */
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            cyc_count <= 0;
            inst_count <= 0;
        end else begin
            cyc_count <= cyc_count + 1;
            if (inst_ex)
                inst_count <= inst_count + 1;

        end
    end

endmodule: core_tb

module sim_memory
   (input  logic clk, rst_n,
    input  logic [31:0] addr, wdata,
    input  logic [1:0]  size,
    input  logic        write,
    output wire  [31:0] rdata,
    output logic        abort, pause);

    logic [3:0] byte_we;
    mem_decoder mdecode (.addr, .size, .write, .byte_we);

    logic [2:0] num_cycles;
    logic       pause_en;
    pause_generator pause_gen (.clk, .rst_n, .pause,
                               .en(pause_en), .num_cycles(num_cycles));

    /* GBA RAMs */
    memory #(`EXTERN_RAM_START, `EXTERN_RAM_SIZE)
        extern_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`INTERN_RAM_START, `INTERN_RAM_SIZE)
        intern_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`IO_REG_RAM_START, `IO_REG_RAM_SIZE)
        io_reg_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`PALLET_RAM_START, `PALLET_RAM_SIZE)
        pallet_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`VRAM_START, `VRAM_SIZE)
        vram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`OAM_START, `OAM_SIZE)
        oam (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`PAK_RAM_START, `PAK_RAM_SIZE)
        pak_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    /* ROMs */
    // Pak 1-3 should map to the same memory
    rom_memory #(`PAK_ROM_1_START, `PAK_ROM_1_SIZE, "GBA_CPU_ROM_FILE")
        pak1_rom (.clk, .rst_n, .addr, .rdata);

    rom_memory #(`PAK_ROM_2_START, `PAK_ROM_2_SIZE, "GBA_CPU_ROM_FILE")
        pak2_rom (.clk, .rst_n, .addr, .rdata);

    rom_memory #(`PAK_ROM_3_START, `PAK_ROM_3_SIZE, "GBA_CPU_ROM_FILE")
        pak3_rom (.clk, .rst_n, .addr, .rdata);

    rom_memory #(`PAK_INIT_1_START, `PAK_INIT_1_SIZE, "GBA_PAK_INIT_1_FILE")
        pak_init1 (.clk, .rst_n, .addr, .rdata);

    rom_memory #(`SYSTEM_ROM_START, `SYSTEM_ROM_SIZE,"GBA_CPU_BIOS_FILE")
        sys_rom (.clk, .rst_n, .addr, .rdata);

    /* Mapping of memory access to different memories & error handling */
    always_comb begin
        abort = 1'b0;
        pause_en = 1'b0;
        num_cycles = 3'd0;
        // TODO Rework abort logic with new system
        /*
        if (prev_addr <= `SYSTEM_ROM_END) begin
            abort = write; // Write to ROM illegal
        end else if (`PAK_ROM_1_START <= prev_addr &&
            prev_addr <= `PAK_ROM_1_END) begin
            // Handles VCS max bit vector size
            abort = write; // Write to ROM illegal
            pause_en = 1'b1; // Approximate "wait state" logic
            num_cycles = 3'd1;
        end else if (`PAK_ROM_2_START <= prev_addr &&
            prev_addr <= `PAK_ROM_2_END) begin
            abort = write; // Write to ROM illegal
            pause_en = 1'b1; // Approximate "wait state" logic
            num_cycles = 3'd2;
        end else if (`PAK_ROM_3_START <= prev_addr &&
            prev_addr <= `PAK_ROM_3_END) begin
            abort = write; // Write to ROM illegal
            pause_en = 1'b1; // Approximate "wait state" logic
            num_cycles = 3'd3;
        end else if (~$isunknown(prev_addr) && write) begin
            $display("Addr %h does not map to memory region!", prev_addr);
        end
        */
    end

endmodule: sim_memory

/* Simulation memory for RAM units, synchronous read/write
 * Read data output in bus-style - High impedence if not in range
 */
module memory
    #(parameter BASE_ADDR=32'h0,
      parameter SIZE=32'h10)
    (input  logic clk, rst_n, pause,
     input  logic [31:0] addr, wdata,
     input  logic [3:0] byte_we,
     output logic [31:0] rdata);

     logic [7:0] mem [SIZE:0];

     logic [31:0] align_addr, prev_addr;
     logic [7:0] b_rdata [3:0]; // Byte rdata
     logic [3:0] we;
     logic curr_in_range, prev_in_range;

     assign align_addr = (addr - BASE_ADDR) & 32'hFFFF_FFFC;

     assign curr_in_range = (BASE_ADDR[31:24] == addr[31:24]);

     assign rdata = (prev_in_range) ?
                    {b_rdata[3], b_rdata[2], b_rdata[1], b_rdata[0]} : 32'bz;

     always_ff @(posedge clk, negedge rst_n) begin
         if (~rst_n) begin
             for (int i = 0; i <= SIZE; i++) mem[i] <= 32'd0;
             b_rdata <= {8'b0, 8'b0, 8'b0, 8'b0};
             prev_addr <= 32'd0;
             prev_in_range <= 1'b0;
             we <= 4'd0;
         end else if (~pause) begin
             prev_in_range <= curr_in_range;
             /* Write data presented 1 cycle after address & WE */
             prev_addr <= align_addr;
             we <= (curr_in_range) ? byte_we : 4'd0;
             if (we[3]) mem[prev_addr[$clog2(SIZE)-1:0]+3] <= wdata[31:24];
             if (we[2]) mem[prev_addr[$clog2(SIZE)-1:0]+2] <= wdata[23:16];
             if (we[1]) mem[prev_addr[$clog2(SIZE)-1:0]+1] <= wdata[15:8];
             if (we[0]) mem[prev_addr[$clog2(SIZE)-1:0]] <= wdata[7:0];
             b_rdata[3] <= mem[align_addr[$clog2(SIZE)-1:0]+3];
             b_rdata[2] <= mem[align_addr[$clog2(SIZE)-1:0]+2];
             b_rdata[1] <= mem[align_addr[$clog2(SIZE)-1:0]+1];
             b_rdata[0] <= mem[align_addr[$clog2(SIZE)-1:0]+0];
         end
     end

endmodule: memory

/* Same as memory module, only initalizes memory to values in
 * `GBA_ROM_FILE (also no writes, since it's rom */
module rom_memory
    #(parameter START_ADDR=32'h0,
      parameter SIZE=32'h10,
      parameter MEM_FILE="ENV_VAR_VALUE")
    (input  logic clk, rst_n,
     input  logic [31:0] addr,
     output logic [31:0] rdata);

     logic [7:0] mem [SIZE:0];

     logic [31:0] align_addr, prev_addr;
     logic [7:0] b_rdata [3:0]; // Byte rdata
     logic [3:0] we;
     logic curr_in_range, prev_in_range;

     assign align_addr = (addr - START_ADDR) & 32'hFFFF_FFFC;

     assign curr_in_range = (START_ADDR <= addr &&
                             align_addr < SIZE);

     assign rdata = (prev_in_range) ?
                    {b_rdata[3], b_rdata[2], b_rdata[1], b_rdata[0]} : 32'bz;

     always_ff @(posedge clk, negedge rst_n) begin
         if (~rst_n) begin
             b_rdata <= {8'b0, 8'b0, 8'b0, 8'b0};
             prev_in_range <= 1'b0;
         end else begin
             prev_in_range <= curr_in_range;
             if (align_addr <= SIZE) begin
                 b_rdata[3] <= mem[align_addr+3];
                 b_rdata[2] <= mem[align_addr+2];
                 b_rdata[1] <= mem[align_addr+1];
                 b_rdata[0] <= mem[align_addr+0];
             end
         end
     end

    /* Initalize ROM */
    string filename;
    initial begin
        filename = getenv(MEM_FILE);
        $readmemh(filename, mem);
    end

endmodule: rom_memory

/* Setup byte write enables for memory (assumes that CPU deals with
 * endianness!) */
module mem_decoder
    (input  logic [31:0] addr,
     input  logic [1:0]  size,
     input  logic        write,
     output logic [3:0]  byte_we);

     always_comb begin
         byte_we = 4'd0;
         if (write) begin
             byte_we[3] = (addr[1:0] == 2'd3 && size == `MEM_SIZE_BYTE) ||
                          (addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[2] = (addr[1:0] == 2'd2 && size == `MEM_SIZE_BYTE) ||
                          (addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[1] = (addr[1:0] == 2'd1 && size == `MEM_SIZE_BYTE) ||
                          (~addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);

             byte_we[0] = (addr[1:0] == 2'd0 && size == `MEM_SIZE_BYTE) ||
                          (~addr[1] && size == `MEM_SIZE_HALF) ||
                          (size == `MEM_SIZE_WORD);
         end
     end

endmodule: mem_decoder

/* Module to generate PAUSE signal based on number of wait cycles.
 * After en->1, pause will be held for num_cycles */
module pause_generator
   (input logic clk, rst_n,
    input logic en,
    input logic [2:0] num_cycles,
    output logic pause);

    logic [2:0] curr_cycles;
    logic en_set_low;

    assign pause = (curr_cycles > 0);

    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            en_set_low <= 1'b1;
            curr_cycles <= 3'd0;
        end else begin
            /* Check en_set_low, since en will be held */
            if (en && en_set_low) begin
                en_set_low <= 1'b0;
                curr_cycles <= num_cycles;
            end else begin
                if (curr_cycles > 0)
                    curr_cycles <= curr_cycles - 1;
                if (~en)
                    en_set_low <= 1'b1;
            end
        end
    end
endmodule: pause_generator

/* Monitor bus events and print them to `BUS_LOG_FILE if
 * `BUS_LOG_EN is defined */
module bus_monitor
   #(parameter LOG_FILE="foo.txt")
   (input  logic        clk, rst_n, pause,
    input  logic [31:0] addr, wdata, rdata,
    input  logic [1:0]  size,
    input  logic        abort, write);

    string mem_size;
    logic [31:0] waddr;
    logic [1:0] wsize;

`ifdef BUS_LOG_EN
    integer f;
    string filename;
    initial begin
        filename = getenv(LOG_FILE);
        f = $fopen(filename, "w");
    end

    final begin
        $fclose(f);
        $display("Bus Log in %s", filename);
    end
`endif

    always_comb begin
        case (wsize)
            `MEM_SIZE_BYTE: mem_size = "1";
            `MEM_SIZE_HALF: mem_size = "2";
            `MEM_SIZE_WORD: mem_size = "4";
            `MEM_SIZE_RESR: begin
                mem_size = "reserved";
                $display("ERROR: Reserved memory size!");
                $finish;
            end
        endcase
    end

    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            wsize <= 2'b0;
            waddr <= 32'b0;
        end else begin
            wsize <= size;
            waddr <= addr;
        end
    end

`ifdef BUS_LOG_EN

    logic writing;
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            writing <= 1'b0;
        end else if (rst_n & ~pause) begin // Maybe don't need pause,
            if (write) begin
                writing <= 1'b1;
            end else if (writing) begin
                $fwrite(f, "Wrote %x @ %x, size %s\n", wdata, waddr, mem_size);
                writing <= 1'b0;
            end
            if (abort) begin
                $fwrite(f, "Got ABORT from write to %x", waddr);
            end
        end
    end
`endif

endmodule: bus_monitor

/* Testbench for memory system */
module mem_tb;
    logic clk, rst_n, pause;
    logic [31:0] wdata, rdata, addr;
    logic [3:0] byte_we;

    memory DUT (.*);
    initial begin
        addr = 32'd0;
        wdata = 32'd0;
        pause = 1'b0;
        byte_we = 4'd0;
        rst_n = 1'b1;
        clk = 1'b0;
        #1 rst_n <= 1'b0;
        #1 rst_n <= 1'b1;
        forever #1 clk <= ~clk;
    end

    initial begin
        @(posedge clk);
        addr <= 32'd1;
        @(posedge clk);
        addr <= 32'd2;
        byte_we <= 4'hf;
        @(posedge clk);
        byte_we <= 4'h0;
        wdata <= 32'hdeadbeef;
        addr <= 32'd5;
        @(posedge clk);
        byte_we <= 4'hf;
        wdata <= 32'hbabef00d;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        $finish;
    end
endmodule: mem_tb


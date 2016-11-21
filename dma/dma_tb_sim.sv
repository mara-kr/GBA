`default_nettype none
`include "../gba_core_defines.vh"

module core_tb;
    logic clk, pause;
    logic rst_n;
    logic irq_n; // Interrupt Request
    // Memory interface
    wire [31:0] addr, wdata;
    wire  [31:0] rdata;
    wire [1:0] size;
    wire abort, write;

    logic [15:0] controlL0, controlH0;
    logic [15:0] srcAddrL0, srcAddrH0;
    logic [15:0] destAddrL0, destAddrH0;
    
    logic [15:0] controlL1, controlH1;
    logic [15:0] srcAddrL1, srcAddrH1;
    logic [15:0] destAddrL1, destAddrH1;
    
    logic [15:0] controlL2, controlH2;
    logic [15:0] srcAddrL2, srcAddrH2;
    logic [15:0] destAddrL2, destAddrH2;

    logic [15:0] controlL3, controlH3;
    logic [15:0] srcAddrL3, srcAddrH3;
    logic [15:0] destAddrL3, destAddrH3;

    logic [31:0] registers [`NUM_IO_REGS-1:0];

    assign registers[`DMA0CNT_L_IDX][15:0] = controlL0;
    assign registers[`DMA0CNT_H_IDX][31:16] = controlH0;
    assign registers[`DMA0SAD_L_IDX][15:0] = srcAddrL0;
    assign registers[`DMA0SAD_H_IDX][31:16] = srcAddrH0;
    assign registers[`DMA0DAD_L_IDX][15:0] = destAddrL0;
    assign registers[`DMA0DAD_H_IDX][31:16] = destAddrH0;

    assign registers[`DMA1CNT_L_IDX][15:0] = controlL1;
    assign registers[`DMA1CNT_H_IDX][31:16] = controlH1;
    assign registers[`DMA1SAD_L_IDX][15:0] = srcAddrL1;
    assign registers[`DMA1SAD_H_IDX][31:16] = srcAddrH1;
    assign registers[`DMA1DAD_L_IDX][15:0] = destAddrL1;
    assign registers[`DMA1DAD_H_IDX][31:16] = destAddrH1;

    assign registers[`DMA2CNT_L_IDX][15:0] = controlL2;
    assign registers[`DMA2CNT_H_IDX][31:16] = controlH2;
    assign registers[`DMA2SAD_L_IDX][15:0] = srcAddrL2;
    assign registers[`DMA2SAD_H_IDX][31:16] = srcAddrH2;
    assign registers[`DMA2DAD_L_IDX][15:0] = destAddrL2;
    assign registers[`DMA2DAD_H_IDX][31:16] = destAddrH2;

    assign registers[`DMA3CNT_L_IDX][15:0] = controlL3;
    assign registers[`DMA3CNT_H_IDX][31:16] = controlH3;
    assign registers[`DMA3SAD_L_IDX][15:0] = srcAddrL3;
    assign registers[`DMA3SAD_H_IDX][31:16] = srcAddrH3;
    assign registers[`DMA3DAD_L_IDX][15:0] = destAddrL3;
    assign registers[`DMA3DAD_H_IDX][31:16] = destAddrH3;

    logic [3:0] disable_dma;
    logic active;
    logic irq0, irq1, irq2, irq3;

    logic [15:0] hcount, vcount;
    logic sound_req;

    wire [31:0] dma_addr;
    wire [1:0]  dma_size;
    wire dma_write;
    logic[31:0] test_addr;
    logic check_correctness;
    logic passed, all_passed;
    logic [10:0] count_time;

    dma_top dut (
        .registers,
        .vcount, .hcount,
        .sound_req,

        .mem_wait(pause),

        .addr(dma_addr),
        .rdata, .wdata,
        .size (dma_size),
        .wen(dma_write),

        .disable_dma,
        .active,
        .irq0, .irq1, .irq2, .irq3,

        .clk, .rst_b(rst_n));

    bus_monitor #("GBA_CPU_BUS_LOG") busMon (.clk, .rst_n, .pause, .addr,
                                             .wdata, .rdata, .size, .abort,
                                             .write);

    sim_memory sim_mem (.clk, .rst_n, .addr, .wdata, .size, .write,
                         .rdata, .abort, .pause);

    test_fsm fsm(.clk, .rst_n, 
        .controlL0, .controlH0,
        .srcAddrL0, .srcAddrH0,
        .destAddrL0, .destAddrH0,

        .controlL1, .controlH1,
        .srcAddrL1, .srcAddrH1,
        .destAddrL1, .destAddrH1,

        .controlL2, .controlH2,
        .srcAddrL2, .srcAddrH2,
        .destAddrL2, .destAddrH2,

        .controlL3, .controlH3,
        .srcAddrL3, .srcAddrH3,
        .destAddrL3, .destAddrH3,
        .check_correctness,
        .count_time, .passed,
        .test_addr, .rdata,
        .pause,
        .hcount);
    
    always_ff @(posedge clk, negedge rst_n) begin
        if (rst_n == 0) begin
            count_time <= 0;
            all_passed <= 1;
        end
        else if (~pause)begin
            count_time <= count_time + 1;
            all_passed <= all_passed && passed;
        end
        else begin
            count_time <= count_time;
            all_passed <= all_passed;
        end
    end

    assign addr = (check_correctness) ? test_addr : dma_addr;
    assign size = (check_correctness) ? 2'b10 : dma_size;
    assign write = (check_correctness) ? 1'b0 : dma_write;
    /* Clock and Reset Generation */
    initial begin
        $monitor ("Passed:%b, rdata:%h, addr:%h, cs:%s, xfer_count:%d, rest=%b, irq0=%b, irq1=%b irq2=%b, irq3=%b", 
                    all_passed, rdata, addr, fsm.cs, fsm.xfer_count, rst_n, irq0, irq1, irq2, irq3);
        $display("Start"); // Start of SIM for diff script
        clk = 0;
        rst_n = 1'b1;
        irq_n = 1'b1;
        #1 rst_n <= 1'b0;
        #1 rst_n <= 1'b1;
        #100 rst_n <= 1'b0;
        #100 rst_n <= 1'b1;
        #400 $finish;
    end

    /* So the simulation stops */
    initial begin
        forever #1 clk <= ~clk;
        //#200 $finish;
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

     //randomly generate pauses to see if DMA acts accordingly
     logic [2:0] count_random;
     always_ff @(posedge clk, negedge rst_n) begin
         if (~rst_n) count_random <= 3'b0;
         else count_random <= count_random + 1;
     end
             
      assign pause_en = count_random[2];
      assign num_cycles = 1'b1;
    
      pause_generator pause_gen (.clk, .rst_n, .pause,
                               .en(pause_en), .num_cycles(num_cycles));
    /* GBA RAMs */
    memory #(`EXTERN_RAM_START, `EXTERN_RAM_SIZE)
        extern_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`INTERN_RAM_START, `INTERN_RAM_SIZE)
        intern_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`IO_REG_RAM_START, `IO_REG_RAM_SIZE)
        io_reg_ram (.clk, .rst_n, .pause, .wdata, .rdata, .addr, .byte_we);

    memory #(`PALETTE_RAM_START, `PALETTE_RAM_SIZE)
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

    rom_memory #(`SYSTEM_ROM_START, `SYSTEM_ROM_SIZE,"GBA_CPU_BIOS_FILE")
        sys_rom (.clk, .rst_n, .addr, .rdata);

    /* Mapping of memory access to different memories & error handling */
    /*always_comb begin
        abort = 1'b0;
        pause_en = 1'b0;
        num_cycles = 3'd0;
        // TODO Rework abort logic with new system
        
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
        
    end*/

endmodule: sim_memory

/* Simulation memory for RAM units, synchronous read/write
 * Read data output in bus-style - High impedence if not in range
 */
module memory
    #(parameter START_ADDR=32'h0,
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

     assign align_addr = (addr - START_ADDR) & 32'hFFFF_FFFC;

     assign curr_in_range = (START_ADDR <= addr &&
                             align_addr < SIZE);

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
             we <= (align_addr <= SIZE) ? byte_we : 4'd0;
             if (prev_addr <= SIZE) begin
                 if (we[3]) mem[prev_addr+3] <= wdata[31:24];
                 if (we[2]) mem[prev_addr+2] <= wdata[23:16];
                 if (we[1]) mem[prev_addr+1] <= wdata[15:8];
                 if (we[0]) mem[prev_addr] <= wdata[7:0];
             end
             if (align_addr <= SIZE) begin
                 b_rdata[3] <= mem[align_addr+3];
                 b_rdata[2] <= mem[align_addr+2];
                 b_rdata[1] <= mem[align_addr+1];
                 b_rdata[0] <= mem[align_addr+0];
             end
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
        $readmemh("test.hex", mem);
        #500 $writememh("output.hex", mem);
        $finish;
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
        //filename = getenv(LOG_FILE);
        f = $fopen("LOG_FILE.txt", "w");
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
/*module mem_tb;
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
endmodule: mem_tb*/

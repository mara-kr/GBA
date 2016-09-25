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
    logic [31:0] addr, wdata, rdata;
    logic [1:0] size;
    logic abort, write;


    ARM7TDMIS_Top DUT (.CLK(clk), .PAUSE(pause), .NRESET(rst_n),
                       .NIRQ(irq_n), .ADDR(addr), .WDATA(wdata),
                       .RDATA(rdata), .SIZE(size), .ABORT(abort),
                       .WRITE(write), .NFIQ(1'b1));

    bus_monitor #("GBA_CPU_BUS_LOG") busMon (.clk, .rst_n, .pause, .addr,
                                             .wdata, .rdata, .size, .abort,
                                             .write);

    sim_memory sim_mem (.clk, .rst_n, .addr, .wdata, .size, .write,
                         .rdata, .abort, .pause);

    /* Clock and Reset Generation */
    initial begin
        clk = 0;
        rst_n = 1'b1;
        irq_n = 1'b1;
        #1 rst_n <= 1'b0;
        #1 rst_n <= 1'b1;
        forever #1 clk <= ~clk;
    end

    integer i;
    integer cyc_count;
    /* So the simulation stops */
    initial begin
        $monitor("r0\t%h\nr1\t%h\nr2\t%h\nr3\t%h\nr4\t%h\nr5\t%h\nr6\t%h\n\
r7\t%h\nr8\t%h\nr9\t%h\nr10\t%h\nr11\t%h\nr12\t%h\n\
sp\t%h\nlr\t%h\n",
                 DUT.RegFile_Inst.UMRegisterFile[0],
                 DUT.RegFile_Inst.UMRegisterFile[1],
                 DUT.RegFile_Inst.UMRegisterFile[2],
                 DUT.RegFile_Inst.UMRegisterFile[3],
                 DUT.RegFile_Inst.UMRegisterFile[4],
                 DUT.RegFile_Inst.UMRegisterFile[5],
                 DUT.RegFile_Inst.UMRegisterFile[6],
                 DUT.RegFile_Inst.UMRegisterFile[7],
                 DUT.RegFile_Inst.UMRegisterFile[8],
                 DUT.RegFile_Inst.UMRegisterFile[9],
                 DUT.RegFile_Inst.UMRegisterFile[10],
                 DUT.RegFile_Inst.UMRegisterFile[11],
                 DUT.RegFile_Inst.UMRegisterFile[12],
                 DUT.RegFile_Inst.UMRegisterFile[13],
                 DUT.RegFile_Inst.UMRegisterFile[14],
                 );
        #200 $finish;
    end

    /* Clock cycle counter */
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n)
            cyc_count <= 0;
        else
            cyc_count <= cyc_count + 1;
    end

    final begin
        $display("Simulation finished at cycle %d", cyc_count);
        $display("CPSR: %h \tNZCV = %b \tCPSR_Ctrl = %b",
                 DUT.PSR_Inst.CPSR, DUT.PSR_Inst.CPSR[31:28], DUT.PSR_Inst.CPSR[7:0]);
        for (i = 0; i <= 15; i++)
            $display("UserModeReg \t%2d: %h",i, DUT.RegFile_Inst.UMRegisterFile[i]);
        $display("\n");
        for (i = 13; i <= 14; i++)
            $display("SuperModeReg \t%2d: %h", i, DUT.RegFile_Inst.SVCMRegisterFile[i]);
        $display("Super_SPSR\t    %h\n", DUT.PSR_Inst.SPSR_SVC);
        for (i = 13; i <= 14; i++)
            $display("IRQModeReg \t%2d: %h", i, DUT.RegFile_Inst.IRQMRegisterFile[i]);
        $display("IRQ_SPSR\t    %h\n", DUT.PSR_Inst.SPSR_IRQ);
        for (i = 13; i <= 14; i++)
            $display("UndefModeReg \t%2d: %h", i, DUT.RegFile_Inst.UndMRegisterFile[i]);
        $display("Undef_SPSR\t    %h\n", DUT.PSR_Inst.SPSR_Undef);
    end

endmodule: core_tb

module sim_memory
   (input  logic clk, rst_n,
    input  logic [31:0] addr, wdata,
    input  logic [1:0]  size,
    input  logic        write,
    output logic [31:0] rdata,
    output logic        abort, pause);

    /* Memory read data signals*/
    logic [31:0] sys_rom_data, extern_ram_data, intern_ram_data;
    logic [31:0] io_reg_ram_data, pallet_ram_data, vram_data;
    logic [31:0] oam_data, pak_ram_data, pak_rom_data;

    /* Memory Byte Write Enable signals */
    logic [3:0] extern_ram_we, intern_ram_we;
    logic [3:0] io_reg_ram_we, pallet_ram_we;
    logic [3:0] vram_we, oam_we, pak_ram_we;

    logic [31:0] sys_rom_addr, extern_ram_addr, intern_ram_addr;
    logic [31:0] io_reg_ram_addr, pallet_ram_addr, vram_addr;
    logic [31:0] oam_addr, pak_ram_addr, pak_rom_addr;

    /* Pak Rom set in always comb */
    assign sys_rom_addr = addr;
    assign extern_ram_addr = addr - `EXTERN_RAM_START;
    assign intern_ram_addr = addr - `INTERN_RAM_START;
    assign io_reg_ram_addr = addr - `IO_REG_RAM_START;
    assign pallet_ram_addr = addr - `PALLET_RAM_START;
    assign vram_addr = addr - `VRAM_START;
    assign oam_addr = addr - `OAM_START;
    assign pak_ram_addr = addr - `PAK_RAM_START;


    /* GBA RAMs */
    memory #(`EXTERN_RAM_SIZE) extern_ram (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(extern_ram_addr),
                                           .byte_we(extern_ram_we),
                                           .rdata(extern_ram_data));
    memory #(`INTERN_RAM_SIZE) intern_ram (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(intern_ram_addr),
                                           .byte_we(intern_ram_we),
                                           .rdata(intern_ram_data));
    memory #(`IO_REG_RAM_SIZE) io_reg_ram (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(io_reg_ram_addr),
                                           .byte_we(io_reg_ram_we),
                                           .rdata(io_reg_ram_data));
    memory #(`PALLET_RAM_SIZE) pallet_ram (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(pallet_ram_addr),
                                           .byte_we(pallet_ram_we),
                                           .rdata(pallet_ram_data));
    memory #(`VRAM_SIZE)       vram       (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(vram_addr),
                                           .byte_we(vram_we),
                                           .rdata(vram_data));
    memory #(`OAM_SIZE)        oam        (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(oam_addr),
                                           .byte_we(oam_we),
                                           .rdata(oam_data));
    memory #(`PAK_RAM_SIZE)    pak_ram    (.clk, .pause, .wdata,
                                           .rst_n,
                                           .addr(pak_ram_addr),
                                           .byte_we(pak_ram_we),
                                           .rdata(pak_ram_data));
    /* ROMs */
    rom_memory #(`PAK_ROM_1_SIZE,"GBA_CPU_ROM_FILE")
        pak_rom (.clk, .rst_n, .addr(pak_rom_addr), .rdata(pak_rom_data));
    rom_memory #(`SYSTEM_ROM_SIZE,"GBA_CPU_BIOS_FILE")
        sys_rom (.clk, .rst_n, .addr(sys_rom_addr), .rdata(sys_rom_data));

    logic [3:0] byte_we;
    mem_decoder mdecode (.addr, .size, .write, .byte_we);

    logic [2:0] num_cycles;
    logic       pause_en;
    pause_generator pause_gen (.clk, .rst_n, .pause,
                               .en(pause_en), .num_cycles(num_cycles));

    logic [31:0] prev_addr;
    /* Data Mux should match last address presetned to memory
     * (since reads are sequential)
     */
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) prev_addr <= 32'd0;
        else prev_addr <= addr;
    end

    /* Mapping of memory access to different memories & error handling */
    always_comb begin
        extern_ram_we = 4'd0;
        intern_ram_we = 4'd0;
        io_reg_ram_we = 4'd0;
        pallet_ram_we = 4'd0;
        vram_we = 4'd0;
        oam_we = 4'd0;
        pak_ram_we = 4'd0;
        abort = 1'b0;
        pause_en = 1'b0;
        num_cycles = 3'd0;
        pak_rom_addr = 0;
        if (prev_addr <= `SYSTEM_ROM_END) begin
            rdata = sys_rom_data;
            abort = write; /* Write to ROM illegal */
        end else if (`EXTERN_RAM_START <= prev_addr && prev_addr <= `EXTERN_RAM_END) begin
            rdata = extern_ram_data;
            extern_ram_we = byte_we;
        end else if (`INTERN_RAM_START <= prev_addr && prev_addr <= `INTERN_RAM_END) begin
            rdata = intern_ram_data;
            intern_ram_we = byte_we;
        end else if (`IO_REG_RAM_START <= prev_addr && prev_addr <= `IO_REG_RAM_END) begin
            rdata = io_reg_ram_data;
            io_reg_ram_we = byte_we;
        end else if (`PALLET_RAM_START <= prev_addr && prev_addr <= `PALLET_RAM_END) begin
            rdata = pallet_ram_data;
            pallet_ram_we = byte_we;
        end else if (`VRAM_START <= prev_addr && prev_addr <= `VRAM_END) begin
            rdata = vram_data;
            vram_we = byte_we;
        end else if (`OAM_START <= prev_addr && prev_addr <= `OAM_END) begin
            rdata = oam_data;
            oam_we = byte_we;
        end else if (`PAK_RAM_START <= prev_addr && prev_addr <= `PAK_RAM_END) begin
            rdata = pak_ram_data;
            pak_ram_we = byte_we;
        end else if (`PAK_ROM_1_START <= prev_addr && prev_addr <= `PAK_ROM_1_END) begin
            /* Handles VCS max bit vector size */
            if (`PAK_ROM_1_START + `PAK_ROM_1_SIZE < prev_addr)
                $display("Address %h maps outisde of PAK_ROM_1 unit!", prev_addr);
            rdata = pak_rom_data;
            pak_rom_addr = prev_addr - `PAK_ROM_1_START;
            abort = write; /* Write to ROM illegal */
            pause_en = 1'b1; /* Approximate "wait state" logic */
            num_cycles = 3'd1;
        end else if (`PAK_ROM_2_START <= prev_addr && prev_addr <= `PAK_ROM_2_END) begin
            if (`PAK_ROM_2_START + `PAK_ROM_2_SIZE < prev_addr)
                $display("Address %h maps outisde of PAK_ROM_2 unit!", prev_addr);
            rdata = pak_rom_data;
            pak_rom_addr = prev_addr - `PAK_ROM_2_START;
            abort = write; /* Write to ROM illegal */
            pause_en = 1'b1; /* Approximate "wait state" logic */
            num_cycles = 3'd2;
        end else if (`PAK_ROM_3_START <= prev_addr && prev_addr <= `PAK_ROM_3_END) begin
            if (`PAK_ROM_3_START + `PAK_ROM_3_SIZE < prev_addr)
                $display("Address %h maps outisde of PAK_ROM_3 unit!", prev_addr);
            rdata = pak_rom_data;
            pak_rom_addr = prev_addr - `PAK_ROM_3_START;
            abort = write; /* Write to ROM illegal */
            pause_en = 1'b1; /* Approximate "wait state" logic */
            num_cycles = 3'd3;
        end else if (~$isunknown(prev_addr) && write) begin
            $display("Addr %h does not map to memory region!", prev_addr);
        end
    end

endmodule: sim_memory

/* Simulation memory for RAM units, synchronous read/write */
module memory
    #(parameter SIZE=10)
    (input  logic clk, rst_n, pause,
     input  logic [31:0] addr, wdata,
     input  logic [3:0] byte_we,
     output logic [31:0] rdata);

     logic [7:0] mem [SIZE:0];

     logic [31:0] align_addr, write_addr;
     assign align_addr = {addr[31:2], 2'b0};
     logic [3:0] we;

     logic [7:0] b_rdata [3:0]; // Byte rdata
     assign rdata = {b_rdata[3], b_rdata[2], b_rdata[1], b_rdata[0]};

     integer i;
     always_ff @(posedge clk, negedge rst_n) begin
         if (~rst_n) begin
             for (i = 0; i <= SIZE; i++) mem[i] = 8'd0;
             b_rdata = {8'b0, 8'b0, 8'b0, 8'b0};
             write_addr <= 32'd0;
             we <= 4'd0;
         end else if (~pause) begin
             /* Write data presented 1 cycle after address & WE */
             write_addr <= align_addr;
             we <= byte_we;
             if (we[3]) mem[write_addr+3] <= wdata[31:24];
             if (we[2]) mem[write_addr+2] <= wdata[23:16];
             if (we[1]) mem[write_addr+1] <= wdata[15:8];
             if (we[0]) mem[write_addr] <= wdata[7:0];
             b_rdata[3] <= mem[align_addr+3];
             b_rdata[2] <= mem[align_addr+2];
             b_rdata[1] <= mem[align_addr+1];
             b_rdata[0] <= mem[align_addr+0];
         end
     end

endmodule: memory

/* Same as memory module, only initalizes memory to values in
 * `GBA_ROM_FILE (also no writes, since it's rom */
module rom_memory
    #(parameter SIZE=10,
      parameter MEM_FILE="foo.txt")
    (input  logic clk, rst_n,
     input  logic [31:0] addr,
     output logic [31:0] rdata);

     logic [7:0] mem [SIZE:0];

     logic [31:0] align_addr;
     assign align_addr = {addr[31:2], 2'd0};

     logic [7:0] b_rdata [3:0]; // Byte rdata
     assign rdata = {b_rdata[3], b_rdata[2], b_rdata[1], b_rdata[0]};

     always_ff @(posedge clk, negedge rst_n) begin
         if (~rst_n) begin
             b_rdata = {8'b0, 8'b0, 8'b0, 8'b0};
         end else begin
             b_rdata[3] <= mem[align_addr+3];
             b_rdata[2] <= mem[align_addr+2];
             b_rdata[1] <= mem[align_addr+1];
             b_rdata[0] <= mem[align_addr+0];
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

    string mem_size, mem_op;
    logic [31:0] data;
    assign data = (write) ? wdata : rdata;

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
        case (size)
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

    always_comb begin
        case(write)
            1'b0: mem_op = "Read";
            1'b1: mem_op = "Write";
        endcase
    end

`ifdef BUS_LOG_EN

    logic [31:0] last_read_addr;
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) last_read_addr <= 32'hFFFF_FFFF;
        else if (rst_n & ~pause) begin // Maybe don't need pause,
            if ((last_read_addr != addr && ~$isunknown(rdata)) || write) begin
                $fwrite(f, "%s %x @ %x, size %s\n", mem_op, data, addr, mem_size);
                last_read_addr <= addr;
            end
            if (abort) begin
                $fwrite(f, "Got ABORT from %s to %x", mem_op, addr);
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

    memory #(10) DUT (.*);
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


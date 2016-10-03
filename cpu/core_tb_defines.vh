/* Signal definitions for ARM7TDMI-S Core test */
import "DPI-C" function string getenv(input string env_name);

/* Uncomment for logging */
`define BUS_LOG_EN

/* Memory access sizes */
`define MEM_SIZE_BYTE 2'b00
`define MEM_SIZE_HALF 2'b01
`define MEM_SIZE_WORD 2'b10
`define MEM_SIZE_RESR 2'b11

`define SYSTEM_ROM_START 32'h0000_0000
`define SYSTEM_ROM_END   32'h0000_3FFF
`define SYSTEM_ROM_SIZE (`SYSTEM_ROM_END-`SYSTEM_ROM_START)
`define EXTERN_RAM_START 32'h0200_0000
`define EXTERN_RAM_END   32'h0203_FFFF
`define EXTERN_RAM_SIZE (`EXTERN_RAM_END-`EXTERN_RAM_START)
`define INTERN_RAM_START 32'h0300_0000
`define INTERN_RAM_END   32'h0300_7FFF
`define INTERN_RAM_SIZE (`INTERN_RAM_END-`INTERN_RAM_START)
`define IO_REG_RAM_START 32'h0400_0000
`define IO_REG_RAM_END   32'h0400_0807 // From GBATEK
`define IO_REG_RAM_SIZE (`IO_REG_RAM_END-`IO_REG_RAM_START)
`define PALLET_RAM_START 32'h0500_0000
`define PALLET_RAM_END   32'h0500_03FF
`define PALLET_RAM_SIZE (`PALLET_RAM_END-`PALLET_RAM_START)
`define VRAM_START       32'h0600_0000
`define VRAM_END         32'h0601_7FFF
`define VRAM_SIZE       (`VRAM_END-`VRAM_START)
`define OAM_START        32'h0700_0000
`define OAM_END          32'h0700_03FF
`define OAM_SIZE        (`OAM_END-`OAM_START)
`define PAK_RAM_START    32'h0E00_0000
`define PAK_RAM_END      32'h0E00_FFFF
`define PAK_RAM_SIZE    (`PAK_RAM_END-`PAK_RAM_START)

/* VCS Max bit vector size is 16M */
`define PAK_ROM_1_START  32'h0800_0000 // Wait State 0
`define PAK_ROM_1_END    32'h09FF_FFFF
`define PAK_ROM_1_SIZE   (1 << 14)
`define PAK_ROM_2_START  32'h0A00_0000 // Wait State 1
`define PAK_ROM_2_END    32'h0BFF_FFFF
`define PAK_ROM_2_SIZE   (1 << 14)
`define PAK_ROM_3_START  32'h0C00_0000 // Wait State 2
`define PAK_ROM_3_END    32'h0DFF_FFFF
`define PAK_ROM_3_SIZE   (1 << 14)

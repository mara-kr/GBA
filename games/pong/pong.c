typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;
typedef uint16 rgb15;
typedef uint32 tile4bpp[8];
typedef tile4bpp tile_block[512];

#define SCREEN_WIDTH  240
#define SCREEN_HEIGHT 160

#define MEM_IO   0x04000000
#define MEM_PAL  0x05000000
#define MEM_VRAM 0x06000000

#define REG_DISPLAY        (*((volatile uint32 *)(MEM_IO)))
#define REG_DISPLAY_VCOUNT (*((volatile uint32 *)(MEM_IO + 0x0006)))
#define REG_KEY_INPUT      (*((volatile uint32 *)(MEM_IO + 0x0130)))

#define KEY_UP     0x0040
#define KEY_DOWN   0x0080
#define KEY_ANY    0x03FF

#define bg_palette_memory ((volatile rgb15 *)MEM_PAL)
//register definitions
#define dispcnt ((volatile uint16 *)MEM_IO)

#define bg0cnt ((volatile uint16 *)(MEM_IO + 0x08))
#define bg1cnt ((volatile uint16 *)(MEM_IO + 0x0A))
#define bg2cnt ((volatile uint16 *)(MEM_IO + 0x0C))

#define bg0hofs ((volatile uint16 *)(MEM_IO + 0x10))
#define bg0vofs ((volatile uint16 *)(MEM_IO + 0x12))
#define bg1hofs ((volatile uint16 *)(MEM_IO + 0x14))
#define bg1vofs ((volatile uint16 *)(MEM_IO + 0x16))
#define bg2hofs ((volatile uint16 *)(MEM_IO + 0x18))
#define bg2vofs ((volatile uint16 *)(MEM_IO + 0x1A))

// Form a 16-bit BGR GBA colour from three component values (hopefully, in range).
static inline rgb15 RGB15(int r, int g, int b) { return r | (g << 5) | (b << 10); }

// Clamp 'value' in the range 'min' to 'max' (inclusive).
static inline int clamp(int value, int min, int max) { return (value < min ? min : (value > max ? max : value)); }

int main(void) {
	//set DISPCNT
	*dispcnt = 0x0700; //bg mode0, display window 0 and 1, turn on bg2, bg1, bg0

	*bg0cnt = 0x0801;
	*bg1cnt = 0x0902;
	*bg2cnt = 0x0A00;
	
	//set colors in PRAM
	bg_palette_memory[0] = 0x0000;//RGB15(0x00, 0x00, 0x00); //black
	bg_palette_memory[1] = 0x7C00; //blue
	bg_palette_memory[17] = 0x03E0;// green
	bg_palette_memory[33] = 0x001F; //red

	//set screen data format for paddle 1
	//tile 1 is paddle 1
	*(volatile unsigned short *)(MEM_VRAM + 0x4000) = 0x0001;
	*(volatile unsigned short *)(MEM_VRAM + 0x4040) = 0x0801;
	*bg0hofs = ~(0xDF) + 1;
	*bg0vofs = ~(0x3F) + 1;

	//paddle 2 is paddle 1 right shifted in a different color
	*(volatile unsigned short *)(MEM_VRAM + 0x4800) = 0x1001;
	*(volatile unsigned short *)(MEM_VRAM + 0x4840) = 0x1801;
	*bg1hofs = ~(0x0B) + 1;
	*bg1vofs = ~(0x3F) + 1;
	
	//ball is tile 3
	*(volatile unsigned short *)(MEM_VRAM + 0x5000) = 0x2003;
	*bg2hofs = ~(0x6F) + 1;
	*bg2vofs = ~(0x3F) + 1;
	
	//set screen data format for paddle 1
	*(unsigned short *)(MEM_VRAM + 0x20) = 0x1100;
	*(unsigned short *)(MEM_VRAM + 0x22) = 0x0011;
	*(unsigned short *)(MEM_VRAM + 0x24) = 0x1110;
	*(unsigned short *)(MEM_VRAM + 0x26) = 0x0111;
	*(unsigned short *)(MEM_VRAM + 0x28) = 0x1111;
	for (short i = 0x0028; i <= 0x003E; i += 0x02) {
		*(unsigned short *)(MEM_VRAM + i) = 0x1111;
	}
	
	//set screen data format for ball
	for (short i = 0x0060; i <= 0x008E; i += 0x02) {
		*(unsigned short *)(MEM_VRAM + i) = 0x1111;
	}
      while (1);	
    return 0;
}

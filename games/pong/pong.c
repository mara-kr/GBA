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
#define KEY_START  0x0008
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

#define MIN_H_SCREEN 0x0000
#define MAX_H_SCREEN 0xFF10
#define MIN_V_SCREEN 0x0000
#define MAX_V_SCREEN 0xFF10

#define PADDLE_WIDTH 0x08
#define PADDLE_HEIGHT 0x0F
#define BALL_HEIGHT 0x08
#define BALL_WIDTH 0x08

// Form a 16-bit BGR GBA colour from three component values (hopefully, in range).
static inline rgb15 RGB15(int r, int g, int b) { return r | (g << 5) | (b << 10); }

// Clamp 'value' in the range 'min' to 'max' (inclusive).
static inline int clamp(int value, int min, int max) { return (value < min ? min : (value > max ? max : value)); }

int main(void) {
	char restart = 0;
	//set DISPCNT
	*dispcnt = 0x0700; //bg mode0, display window 0 and 1, turn on bg2, bg1, bg0

	*bg0cnt = 0x0801;
	*bg1cnt = 0x0902;
	*bg2cnt = 0x0A00;

	//set colors in PRAM
	bg_palette_memory[0] = 0x0000;//RGB15(0x00, 0x00, 0x00); //black
	bg_palette_memory[1] = 0x7C00; //blue
	bg_palette_memory[17] = 0x03E0;// green
	bg_palette_memory[33] = RGB15(0x1F, 0x00, 0x00); //red = 1
	bg_palette_memory[34] = RGB15(0x1F, 0x1F, 0x1F); //white = 2
	bg_palette_memory[36] = RGB15(0x10, 0x10, 0x10); //gray = 3

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
	*(unsigned short *)(MEM_VRAM + 0x60) = 0x0000;
	*(unsigned short *)(MEM_VRAM + 0x62) = 0x0000;
	*(unsigned short *)(MEM_VRAM + 0x64) = 0x1100;
	*(unsigned short *)(MEM_VRAM + 0x66) = 0x0011;
	*(unsigned short *)(MEM_VRAM + 0x68) = 0x3113;
	*(unsigned short *)(MEM_VRAM + 0x6A) = 0x3113;
	*(unsigned short *)(MEM_VRAM + 0x6C) = 0x2333;
	*(unsigned short *)(MEM_VRAM + 0x6E) = 0x3332;
	*(unsigned short *)(MEM_VRAM + 0x70) = 0x2333;
	*(unsigned short *)(MEM_VRAM + 0x72) = 0x3332;
	*(unsigned short *)(MEM_VRAM + 0x74) = 0x3220;
	*(unsigned short *)(MEM_VRAM + 0x76) = 0x0223;
	*(unsigned short *)(MEM_VRAM + 0x78) = 0x2200;
	*(unsigned short *)(MEM_VRAM + 0x7A) = 0x0022;
	*(unsigned short *)(MEM_VRAM + 0x7C) = 0x2000;
	*(unsigned short *)(MEM_VRAM + 0x7E) = 0x0002;

	uint32 key_states = 0;
	int x_dir = 2;
	int y_dir = -1;
	while (1);
	/*while (1) {
		while(REG_DISPLAY_VCOUNT >= 160);
		while(REG_DISPLAY_VCOUNT < 160);
		//update location
		bg2hofs = bg2hofs + x_dir;
		bg2vofs = bg2hofs + y_dir;

		key_states = ~REG_KEY_INPUT & KEY_ANY;
		//game over
		if (bg2hofs == MIN_H_SCREEN || bg2hofs == MAX_H_SCREEN) {
			while (~key_states & KEY_START) {
				restart = 1;
			}
		}
		//bounce off vertical edges
		else if (bg2hofs == MIN_V_SCREEN || bg2vofs == MAX_V_SCREEN) {
			y_dir = -y_dir;
		}
		//bounce off paddle
		else if (bg2hofs == bg1hofs + PADDLE_WIDTH) && 
				 (bgvofs >= bg1 )  
				|| bg2vofs == MAX_V_SCREEN) {
			x_dir = -x_dir;
		}

		if (restart == 1) {
			*bg0hofs = ~(0xDF) + 1;
			*bg0vofs = ~(0x3F) + 1;
			*bg1hofs = ~(0x0B) + 1;
			*bg1vofs = ~(0x3F) + 1;
			*bg2hofs = ~(0x6F) + 1;
			*bg2vofs = ~(0x3F) + 1;
			restart = 0;
		}
		bg2hofs
	}*/
	return 0;
}

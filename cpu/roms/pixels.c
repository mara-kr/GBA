int main(void) {
    volatile unsigned char *ioram = (unsigned char *) 0x040000000;
    ioram[0] = 0x03;
    ioram[1] = 0x04;

    volatile unsigned short *vram = (unsigned short *) 0x06000000;
    vram[80*240 + 115] = 0x001F;
    vram[80*240 + 120] = 0x03E0;
    vram[80*240 + 125] = 0x7C00;

    while(1);
    return 0;
}

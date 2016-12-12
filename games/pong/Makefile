hellomake: pong.c
	arm-none-eabi-gcc -c pong.c -mthumb-interwork -mthumb -fno-strict-aliasing -O0 -o pong.o
	arm-none-eabi-gcc pong.o -mthumb-interwork -mthumb -specs=gba.specs -o pong.elf
	arm-none-eabi-objcopy -v -O binary pong.elf pong.gba
	gbafix pong.gba
	mgba-qt
clean :
	$(RM) pong.gba
	$(RM) pong.elf
	$(RM) pong.sav
	$(RM) pong.o


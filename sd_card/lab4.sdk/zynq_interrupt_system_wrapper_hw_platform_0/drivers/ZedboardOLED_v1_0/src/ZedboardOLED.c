/*Copyright (c) 2015, EmbeddedCentric.com
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

//////////////////////////////////////////////////////////////////////////////////
// Company: EmbeddedCentric.com
// Author:  Ali Aljaani
// Create Date:    08/12/2015
// Description: Simple driver for the 128x32 OLED on the Zedboard
// Note: The presence of the ZedboardOLED_v1_0 IP code in the PL-side of the Zynq chip
//	is required for this driver to work.
//////////////////////////////////////////////////////////////////////////////////



#include "xparameters.h"
#include "xil_io.h"
#include <string.h>
#define DELAY 10000

/* 	Define the base memory address of the ZedboardOLED IP core */
#define OLED_BASE XPAR_ZEDBOARDOLED_0_S00_AXI_BASEADDR

/*  driver functions for ZedboardOLED IP core */
/*****************************************************************************/
/**
*
* prints a character on the OLED at the page and the position specified by the second
* and third arguments,example print_char('A',0,0);
*
* @param	char char_seq : The character to be printed.
*
* @param	unsigned int page(0-3) : The OLED is divided into 4 pages. 0 is the top,
*			3 is the bottom.
* @param	unsigned int position(0-15) : Each page can hold 16 characters
* 			0 is the leftmost, 15 is the rightmost
*
* @return	int , 1 on success , 0 on failure.

******************************************************************************/
int print_char( char char_seq, unsigned int page ,unsigned int position);

/*****************************************************************************/
/**
*
* prints a string of characters on the OLED at the page specified by the second
* argument, maximum string per page =16,example: print_char("EmbeddedCentric",0);
*
* @param	char *start : The string message to be printed.  Maximum 16 characters.
*
* @param	unsigned int page(0-3) : The OLED is divided into 4 pages : 0 is the top,
*			3 is the bottom.
*
* @return	int , 1 on success , 0 on failure.
*
******************************************************************************/
int print_message(char *start , unsigned int page);

/*****************************************************************************/
/**
*
* clears the screen, example: clear_OLED();
*
*
* @param	none.
*
* @return	none.
******************************************************************************/
void clear_OLED(void);

static int int_seq [64];


void clear_OLED(void){

	int i=0;
	for (i=0;i<=63 ;i++) {
		int_seq[i] = 0x00000000;
	}

	for (i=0;i<=60; i=i+4) {

		Xil_Out32(OLED_BASE+(i),int_seq[i]);
							}
	for (i=0;i<=DELAY ;i++)
		Xil_Out32(OLED_BASE+(64), 1);
	for (i=0;i<=DELAY ;i++)
		Xil_Out32(OLED_BASE+(64), 0);
}

int print_char( char char_seq , unsigned int page, unsigned int position)
{
	unsigned int i=0;
	unsigned int offset;
	unsigned int ascii_value;
	unsigned  int shifter;

	if (position > 15)
		{
			xil_printf(" Wrong position, position should be between (0-15).\r\n");
			return (0);
		}


		switch (page){

			case 0 :
				offset=0;
				break;
			case 1 :
				offset=16;
				break;
			case 2 :
				offset=32;
				break;
			case 3 :
				offset=48;
				break;
			default :
				xil_printf(" Wrong page, page should be between (0-3).\r\n");
				return (0);
				break;

				}


		ascii_value=(int)char_seq;

		switch (position%4){

				case 0 :
					shifter=0;
					break;
				case 1 :
					shifter=8;
					break;
				case 2 :
					shifter=16;
					break;
				case 3 :
					shifter=24;
					break;
				default :
					shifter=0;
					break;

						   }

		ascii_value = ascii_value << shifter;
		int_seq[(position-(position%4))+offset] = int_seq[(position-(position%4))+offset] | ascii_value;

		for (i=0;i<=60; i=i+4) {
			Xil_Out32(OLED_BASE+(i),int_seq[i]);
							   }

		for (i=0;i<=DELAY ;i++)
			Xil_Out32(OLED_BASE+(64), 1);
		for (i=0;i<=DELAY ;i++)
			Xil_Out32(OLED_BASE+(64), 0);

		return (1);

}

int print_message(char *start , unsigned int page) {


unsigned int ln,i;
char *char_pointer;

	char_pointer=start;
	ln=strlen(start);

	for (i=0;i<ln;i++){

		print_char(*char_pointer,page,i);
		char_pointer++;
					  }

	return (1);
}

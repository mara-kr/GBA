#ifndef ZEDBOARDOLED_H
#define ZEDBOARDOLED_H
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
// Description: Header file for ZedboardOLED driver
// Note: The presence of the ZedboardOLED_v1_0 IP code in the PL-side of the Zynq chip
//	is required for this driver to work.
//////////////////////////////////////////////////////////////////////////////////
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


#endif // ZEDBOARDOLED_H

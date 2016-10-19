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
// Create Date:    08/21/2015
// Description: Zynq SoC Training-lab7
//////////////////////////////////////////////////////////////////////////////////

// Include Files
#include "xparameters.h"
#include "xgpio.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xtmrctr.h"
//Lab7 addition start
#include "xsdps.h"
#include "xil_printf.h"
#include "ff.h"
#include "xil_cache.h"
//Lab7 addition end

// Parameter Definitions
#define INTC_DEVICE_ID 			XPAR_PS7_SCUGIC_0_DEVICE_ID
#define BTNS_DEVICE_ID			XPAR_AXI_GPIO_0_DEVICE_ID
#define INTC_GPIO_INTERRUPT_ID  XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
#define BTN_INT 				XGPIO_IR_CH1_MASK // This is the interrupt mask for channel one
#define TMR_DEVICE_ID			XPAR_TMRCTR_0_DEVICE_ID
#define INTC_TMR_INTERRUPT_ID 	XPAR_FABRIC_AXI_TIMER_0_INTERRUPT_INTR
/* IMPORTANT NOTE: The AXI timer frequency is set to 50Mhz
 * the timer is set up to be counting UP, these two facts affect the value selected for
 * the load register to generate 1 Hz interrupts
 */
#define TMR_LOAD				0xFD050F7F


//Global variables

char buffer [9];
unsigned int options;
static int btn_value;

//Lab7 addition start
static FATFS FS_instance; // File System instance
static FIL file1;		// File instance
FRESULT result;			// FRESULT variable
static char FileName[32] = "RECORDS.txt"; // name of the log
static char *Log_File; // pointer to the log
char *Path = "0:/";  //  string pointer to the logical drive number
int counter_logger=0; // Counter for the push button
unsigned int BytesWr = 64; // Bytes written initialize to 64
int len=0;			// length of the string
int accum=0;		//  variable holding the EOF
u8 Buffer_logger[64] __attribute__ ((aligned(32))); // Buffer should be word aligned (multiple of 4)
u32 Buffer_size = 64;
//Lab7 addition end

//----------------------------------------------------
// MAIN FUNCTION
//----------------------------------------------------
int main (void)
{
  int status;
  char c;

  // Lab7 addition start
  // Mount SD Card and initialize device
	result = f_mount(&FS_instance,Path, 1);
		if (result != 0) {
			return XST_FAILURE;
		}
  // Creating new file with read/write permissions
	Log_File = (char *)FileName;
	result = f_open(&file1, Log_File, FA_OPEN_EXISTING | FA_WRITE | FA_READ);
		if (result!= 0) {
			return XST_FAILURE;
		}
		Log_File = (char *)FileName;
		result = f_open(&file1, Log_File,FA_READ);
		if (result!=0) {
			return XST_FAILURE;
		}

		int memory_counter = 0;
		// Read to log
		while (BytesWr == 64) {
			result = f_read(&file1, (const void*)Buffer_logger, 64,&BytesWr);
			if (result!=0) {
				return XST_FAILURE;
			}
			strncpy((char *)(0x40000000 + memory_counter), (const char *)Buffer_logger, 64);
			memory_counter += 64;
		}
		 //Close file.
		result = f_close(&file1);
		if (result!=0) {
			return XST_FAILURE;
		}
		return (0);
  }



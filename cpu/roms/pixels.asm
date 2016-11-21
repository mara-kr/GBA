

; ===========================================================================

; Segment type:	Pure code
		AREA ROM, CODE,	READWRITE, ALIGN=0
; START	OF FUNCTION CHUNK FOR sub_21C
		CODE32

loc_0					; CODE XREF: sub_21C:loc_2ECj
					; DATA XREF: sub_21C+Eo ...
		B		loc_C0
; END OF FUNCTION CHUNK	FOR sub_21C
; ---------------------------------------------------------------------------
		DCD 0x51AEFF24,	0x21A29A69, 0xA82843D, 0xAD09E484, 0x988B2411
		DCD 0x217F81C0,	0x19BE52A3, 0x20CE0993,	0x4A4A4610, 0xEC3127F8
		DCD 0x33E8C758,	0xBFCEE382, 0x94DFF485,	0xC1094BCE, 0xC08A5694
		DCD 0xFCA77213,	0x734D849F, 0x619ACAA3,	0x27A39758, 0x769803FC
		DCD 0x61C71D23,	0x56AE0403, 0x8438BF, 0xFD0EA740, 0x3FE52FF
		DCD 0xF130956F,	0x85C0FB97, 0x2580D660,	0x3BE63A9, 0xE2384E01
		DCD 0xFF34A2F9,	0x44033EBB, 0xCB900078,	0x943A1188, 0x637CC065
		DCD 0xAF3CF087,	0x8BE425D6, 0x72AC0A38,	0x7F8D421, 0, 0
		DCD 0, 0
		DCD 0x963130, 0x80, 0
		DCD 0x7000
; ---------------------------------------------------------------------------
; START	OF FUNCTION CHUNK FOR sub_21C

loc_C0					; CODE XREF: sub_21C:loc_0j
		B		loc_E0
; END OF FUNCTION CHUNK	FOR sub_21C
; ---------------------------------------------------------------------------
		ALIGN 0x20
; START	OF FUNCTION CHUNK FOR sub_21C

loc_E0					; CODE XREF: sub_21C:loc_C0j
		MOV		R0, #0x4000000
		STR		R0, [R0,#0x208]
		MOV		R0, #0x12
		MSR		CPSR_cf, R0
		LDR		SP, =0x3007FA0
		MOV		R0, #0x1F
		MSR		CPSR_cf, R0
		LDR		SP, =0x3007F00
		ADR		R0, (loc_108+1)
		BX		R0 ; loc_108
; ---------------------------------------------------------------------------
		CODE16

loc_108					; CODE XREF: sub_21C-118j
					; DATA XREF: sub_21C-11Co
		LDR		R0, =0x8000000
		LSLS		R0, R0,	#5
		BCS		loc_126
		MOV		R0, PC
		LSLS		R0, R0,	#5
		BCC		loc_130
		MOVS		R2, #0x2000000
		LDR		R3, =0x2000000
		SUBS		R3, R3,	R2
		MOVS		R6, R2
		LSLS		R1, R2,	#2
		BL		sub_19C
		BX		R6
; ---------------------------------------------------------------------------

loc_126					; CODE XREF: sub_21C-110j
		MOVS		R1, #0x40000
		LSLS		R0, R1,	#7
		BL		sub_186

loc_130					; CODE XREF: sub_21C-10Aj
		LDR		R0, =0x3000000
		LDR		R1, =0x3000024
		SUBS		R1, R1,	R0
		BL		sub_186
		LDR		R0, =0x2000000
		LDR		R1, =0x2000000
		SUBS		R1, R1,	R0
		BL		sub_186
		LDR		R1, =0x8000390
		LDR		R2, =0x3000024
		LDR		R4, =0x3000030
		BL		sub_19A
		LDR		R1, =0x8000390
		LDR		R2, =0x3000000
		LDR		R4, =0x3000000
		BL		sub_19A
		LDR		R2, =0x800039C
		LDR		R1, =0x800039C
		SUBS		R3, R2,	R1
		BEQ		loc_166
		LDR		R2, =0x3000030
		BL		sub_19C

loc_166					; CODE XREF: sub_21C-BEj
		LDR		R1, =0x800039C
		LDR		R2, =0x2000000
		LDR		R4, =0x2000000
		BL		sub_19A
		LDR		R1, =0x3000020
		LDR		R0, =0x2040000
		STR		R0, [R1]
		LDR		R3, =0x8000329
		BL		nullsub_1
		MOVS		R0, #0
		MOVS		R1, #0
		LDR		R3, =0x80002F1
		BL		nullsub_1
; END OF FUNCTION CHUNK	FOR sub_21C

; =============== S U B	R O U T	I N E =======================================


sub_186					; CODE XREF: sub_21C-F0p sub_21C-E6p ...
		MOVS		R2, #3
		ADDS		R1, R1,	R2
		BICS		R1, R2
		BEQ		locret_196
		MOVS		R2, #0

loc_190					; CODE XREF: sub_186+Ej
		STMIA		R0!, {R2}
		SUBS		R1, #4
		BNE		loc_190

locret_196				; CODE XREF: sub_186+6j
		BX		LR
; End of function sub_186

; [00000002 BYTES: COLLAPSED FUNCTION nullsub_1. PRESS KEYPAD CTRL-"+" TO EXPAND]

; =============== S U B	R O U T	I N E =======================================


sub_19A					; CODE XREF: sub_21C-D2p sub_21C-C8p ...
		SUBS		R3, R4,	R2
; End of function sub_19A


; =============== S U B	R O U T	I N E =======================================


sub_19C					; CODE XREF: sub_21C-FCp sub_21C-BAp
		MOVS		R0, #3
		ADDS		R3, R3,	R0
		BICS		R3, R0
		BEQ		locret_1AC

loc_1A4					; CODE XREF: sub_19C+Ej
		LDMIA		R1!, {R0}
		STMIA		R2!, {R0}
		SUBS		R3, #4
		BNE		loc_1A4

locret_1AC				; CODE XREF: sub_19C+6j
		BX		LR
; End of function sub_19C

; ---------------------------------------------------------------------------
		ALIGN 0x10
dword_1B0	DCD 0x3007FA0		; DATA XREF: sub_21C-12Cr
dword_1B4	DCD 0x3007F00		; DATA XREF: sub_21C-120r
dword_1B8	DCD 0x8000000		; DATA XREF: sub_21C:loc_108r
dword_1BC	DCD 0x2000000		; DATA XREF: sub_21C-104r
dword_1C0	DCD 0x3000000		; DATA XREF: sub_21C:loc_130r
dword_1C4	DCD 0x3000024		; DATA XREF: sub_21C-EAr
dword_1C8	DCD 0x2000000		; DATA XREF: sub_21C-E2r
dword_1CC	DCD 0x2000000		; DATA XREF: sub_21C-E0r
dword_1D0	DCD 0x8000390		; DATA XREF: sub_21C-D8r
dword_1D4	DCD 0x3000024		; DATA XREF: sub_21C-D6r
dword_1D8	DCD 0x3000030		; DATA XREF: sub_21C-D4r
dword_1DC	DCD 0x8000390		; DATA XREF: sub_21C-CEr
dword_1E0	DCD 0x3000000		; DATA XREF: sub_21C-CCr
dword_1E4	DCD 0x3000000		; DATA XREF: sub_21C-CAr
dword_1E8	DCD 0x800039C		; DATA XREF: sub_21C-C4r
dword_1EC	DCD 0x800039C		; DATA XREF: sub_21C-C2r
dword_1F0	DCD 0x3000030		; DATA XREF: sub_21C-BCr
dword_1F4	DCD 0x800039C		; DATA XREF: sub_21C:loc_166r
dword_1F8	DCD 0x2000000		; DATA XREF: sub_21C-B4r
dword_1FC	DCD 0x2000000		; DATA XREF: sub_21C-B2r
dword_200	DCD 0x3000020		; DATA XREF: sub_21C-ACr
dword_204	DCD 0x2040000		; DATA XREF: sub_21C-AAr
dword_208	DCD 0x8000329		; DATA XREF: sub_21C-A6r
dword_20C	DCD 0x80002F1		; DATA XREF: sub_21C-9Cr

; =============== S U B	R O U T	I N E =======================================


sub_210					; CODE XREF: ROM:loc_346p
		PUSH		{R3-R7,LR}
		NOP
		POP		{R3-R7}
		POP		{R3}
		MOV		LR, R3
		BX		LR
; End of function sub_210


; =============== S U B	R O U T	I N E =======================================


sub_21C					; CODE XREF: sub_21C+66p

; FUNCTION CHUNK AT 00000000 SIZE 00000004 BYTES
; FUNCTION CHUNK AT 000000C0 SIZE 00000004 BYTES
; FUNCTION CHUNK AT 000000E0 SIZE 000000A6 BYTES

		LDR		R3, =0x3000000
		LDR		R0, =0x3000000
		ADDS		R3, #3
		PUSH		{R4,LR}
		SUBS		R3, R3,	R0
		CMP		R3, #6
		BLS		loc_234
		LDR		R3, =loc_0
		CMP		R3, #0
		BEQ		loc_234
		BL		loc_2EC
; ---------------------------------------------------------------------------

loc_234					; CODE XREF: sub_21C+Cj sub_21C+12j
		POP		{R4}
		POP		{R0}
		BX		R0
; ---------------------------------------------------------------------------
		ALIGN 4
dword_23C	DCD 0x3000000		; DATA XREF: sub_21Cr
dword_240	DCD 0x3000000		; DATA XREF: sub_21C+2r
off_244		DCD loc_0		; DATA XREF: sub_21C+Er
; ---------------------------------------------------------------------------

loc_248					; CODE XREF: sub_21C:loc_2C0p
		LDR		R0, =0x3000000
		LDR		R1, =0x3000000
		SUBS		R1, R1,	R0
		ASRS		R1, R1,	#2
		LSRS		R3, R1,	#0x1F
		ADDS		R1, R3,	R1
		PUSH		{R4,LR}
		ASRS		R1, R1,	#1
		BEQ		loc_264
		LDR		R3, =0
		CMP		R3, #0
		BEQ		loc_264
		BL		loc_2EC
; ---------------------------------------------------------------------------

loc_264					; CODE XREF: sub_21C+3Cj sub_21C+42j
		POP		{R4}
		POP		{R0}
		BX		R0
; ---------------------------------------------------------------------------
		ALIGN 4
dword_26C	DCD 0x3000000		; DATA XREF: sub_21C:loc_248r
dword_270	DCD 0x3000000		; DATA XREF: sub_21C+2Er
dword_274	DCD 0			; DATA XREF: sub_21C+3Er
; ---------------------------------------------------------------------------
		PUSH		{R4,LR}
		LDR		R4, =0x3000000
		LDRB		R3, [R4]
		CMP		R3, #0
		BNE		loc_296
		BL		sub_21C
		LDR		R3, =0
		CMP		R3, #0
		BEQ		loc_292
		LDR		R0, =0x800038C
		B		loc_292
; ---------------------------------------------------------------------------
		NOP

loc_292					; CODE XREF: sub_21C+6Ej sub_21C+72j
		MOVS		R3, #1
		STRB		R3, [R4]

loc_296					; CODE XREF: sub_21C+64j
		POP		{R4}
		POP		{R0}
		BX		R0
; ---------------------------------------------------------------------------
dword_29C	DCD 0x3000000		; DATA XREF: sub_21C+5Er
dword_2A0	DCD 0			; DATA XREF: sub_21C+6Ar
dword_2A4	DCD 0x800038C		; DATA XREF: sub_21C+70r
; ---------------------------------------------------------------------------
		LDR		R3, =0
		PUSH		{R4,LR}
		CMP		R3, #0
		BEQ		loc_2B8
		LDR		R1, =0x3000004
		LDR		R0, =0x800038C
		B		loc_2B8
; ---------------------------------------------------------------------------
		ALIGN 4

loc_2B8					; CODE XREF: sub_21C+92j sub_21C+98j
		LDR		R0, =0x300002C
		LDR		R3, [R0]
		CMP		R3, #0
		BNE		loc_2CA

loc_2C0					; CODE XREF: sub_21C+B2j sub_21C+B8j
		BL		loc_248
		POP		{R4}
		POP		{R0}
		BX		R0
; ---------------------------------------------------------------------------

loc_2CA					; CODE XREF: sub_21C+A2j
		LDR		R3, =0
		CMP		R3, #0
		BEQ		loc_2C0
		BL		loc_2EC
; ---------------------------------------------------------------------------
		B		loc_2C0
; ---------------------------------------------------------------------------
		ALIGN 4
dword_2D8	DCD 0			; DATA XREF: sub_21C+8Cr
dword_2DC	DCD 0x3000004		; DATA XREF: sub_21C+94r
dword_2E0	DCD 0x800038C		; DATA XREF: sub_21C+96r
dword_2E4	DCD 0x300002C		; DATA XREF: sub_21C:loc_2B8r
dword_2E8	DCD 0			; DATA XREF: sub_21C:loc_2CAr
; ---------------------------------------------------------------------------

loc_2EC					; CODE XREF: sub_21C+14j sub_21C+44j ...
		BX		R3 ; loc_0
; End of function sub_21C

; ---------------------------------------------------------------------------
		ALIGN 0x10
		MOVS		R3, #0x80 ; '€'
		MOVS		R2, #3
		LSLS		R3, R3,	#0x17
		STRB		R2, [R3]
		LDR		R3, =0x40000001
		ADDS		R2, #1
		STRB		R2, [R3]
		LDR		R3, =0x60096E6
		ADDS		R2, #0x1B
		STRH		R2, [R3]
		MOVS		R2, #0xF8 ; 'ø'
		LDR		R3, =0x60096F0
		LSLS		R2, R2,	#2
		STRH		R2, [R3]
		MOVS		R2, #0xF8 ; 'ø'
		LDR		R3, =0x60096FA
		LSLS		R2, R2,	#7
		STRH		R2, [R3]

loc_314					; CODE XREF: ROM:loc_314j
		B		loc_314
; ---------------------------------------------------------------------------
		ALIGN 4
dword_318	DCD 0x40000001		; DATA XREF: ROM:000002F8r
dword_31C	DCD 0x60096E6		; DATA XREF: ROM:000002FEr
dword_320	DCD 0x60096F0		; DATA XREF: ROM:00000306r
dword_324	DCD 0x60096FA		; DATA XREF: ROM:0000030Er
; ---------------------------------------------------------------------------
		PUSH		{R4-R6,LR}
		LDR		R6, =0x3000024
		LDR		R5, =0x3000024
		SUBS		R5, R5,	R6
		ASRS		R5, R5,	#2
		MOVS		R4, #0
		CMP		R5, #0
		BEQ		loc_346

loc_338					; CODE XREF: ROM:00000344j
		LSLS		R3, R4,	#2
		LDR		R3, [R6,R3]
		ADDS		R4, #1
		BL		sub_37C
		CMP		R5, R4
		BNE		loc_338

loc_346					; CODE XREF: ROM:00000336j
		BL		sub_210
		LDR		R6, =0x3000024
		LDR		R5, =0x3000028
		SUBS		R5, R5,	R6
		ASRS		R5, R5,	#2
		MOVS		R4, #0
		CMP		R5, #0
		BEQ		loc_366

loc_358					; CODE XREF: ROM:00000364j
		LSLS		R3, R4,	#2
		LDR		R3, [R6,R3]
		ADDS		R4, #1
		BL		sub_37C
		CMP		R5, R4
		BNE		loc_358

loc_366					; CODE XREF: ROM:00000356j
		POP		{R4-R6}
		POP		{R0}
		BX		R0
; ---------------------------------------------------------------------------
dword_36C	DCD 0x3000024		; DATA XREF: ROM:0000032Ar
dword_370	DCD 0x3000024		; DATA XREF: ROM:0000032Cr
dword_374	DCD 0x3000024		; DATA XREF: ROM:0000034Ar
dword_378	DCD 0x3000028		; DATA XREF: ROM:0000034Cr

; =============== S U B	R O U T	I N E =======================================

; Attributes: thunk

sub_37C					; CODE XREF: ROM:0000033Ep
					; ROM:0000035Ep
		BX		R3
; End of function sub_37C

; ---------------------------------------------------------------------------
		ALIGN 0x10
		PUSH		{R3-R7,LR}
		NOP
		POP		{R3-R7}
		POP		{R3}
		MOV		LR, R3
		BX		LR
; ---------------------------------------------------------------------------
		ALIGN 0x10
		DCB 0xA9 ; ©
		DCB 2, 0, 8
		DCD 0x8000279, 0
		DCB 0x64 ; d
aKarm		DCB "kARM",0
		ALIGN 4
; ROM		ends

		END

_InitTimer1:
;ekg_firmware.c,4 :: 		void InitTimer1(){
;ekg_firmware.c,5 :: 		T1CON                 = 0x8010;
ORI	R2, R0, 32784
SW	R2, Offset(T1CON+0)(GP)
;ekg_firmware.c,6 :: 		T1IP0_bit         = 1;
LUI	R2, BitMask(T1IP0_bit+0)
ORI	R2, R2, BitMask(T1IP0_bit+0)
_SX	
;ekg_firmware.c,7 :: 		T1IP1_bit         = 1;
LUI	R2, BitMask(T1IP1_bit+0)
ORI	R2, R2, BitMask(T1IP1_bit+0)
_SX	
;ekg_firmware.c,8 :: 		T1IP2_bit         = 1;
LUI	R2, BitMask(T1IP2_bit+0)
ORI	R2, R2, BitMask(T1IP2_bit+0)
_SX	
;ekg_firmware.c,9 :: 		T1IF_bit         = 0;
LUI	R2, BitMask(T1IF_bit+0)
ORI	R2, R2, BitMask(T1IF_bit+0)
_SX	
;ekg_firmware.c,10 :: 		T1IE_bit         = 1;
LUI	R2, BitMask(T1IE_bit+0)
ORI	R2, R2, BitMask(T1IE_bit+0)
_SX	
;ekg_firmware.c,11 :: 		PR1                 = 39000;
ORI	R2, R0, 39000
SW	R2, Offset(PR1+0)(GP)
;ekg_firmware.c,12 :: 		TMR1                 = 0;
SW	R0, Offset(TMR1+0)(GP)
;ekg_firmware.c,13 :: 		}
L_end_InitTimer1:
JR	RA
NOP	
; end of _InitTimer1
_main:
;ekg_firmware.c,21 :: 		void main()
ADDIU	SP, SP, -32
;ekg_firmware.c,23 :: 		uint32_t i = 0;
;ekg_firmware.c,27 :: 		TRISB8_bit =  1;              // Set A15 and B8 pins as input
LUI	R2, BitMask(TRISB8_bit+0)
ORI	R2, R2, BitMask(TRISB8_bit+0)
_SX	
;ekg_firmware.c,28 :: 		TRISA15_bit = 1;
LUI	R2, BitMask(TRISA15_bit+0)
ORI	R2, R2, BitMask(TRISA15_bit+0)
_SX	
;ekg_firmware.c,29 :: 		ad1pcfg = 0x0100;
ORI	R2, R0, 256
SW	R2, Offset(AD1PCFG+0)(GP)
;ekg_firmware.c,30 :: 		ADC1_Init();
JAL	_ADC1_Init+0
NOP	
;ekg_firmware.c,32 :: 		UART5_Init(57600);
ORI	R25, R0, 57600
JAL	_UART5_Init+0
NOP	
;ekg_firmware.c,33 :: 		delay_ms(500);
LUI	R24, 203
ORI	R24, R24, 29524
L_main0:
ADDIU	R24, R24, -1
BNE	R24, R0, L_main0
NOP	
NOP	
NOP	
;ekg_firmware.c,35 :: 		while(1)
L_main2:
;ekg_firmware.c,38 :: 		if (Button(&PORTA, 15, 10, 1))
ORI	R28, R0, 1
ORI	R27, R0, 10
ORI	R26, R0, 15
LUI	R25, hi_addr(PORTA+0)
ORI	R25, R25, lo_addr(PORTA+0)
JAL	_Button+0
NOP	
BNE	R2, R0, L__main15
NOP	
J	L_main4
NOP	
L__main15:
;ekg_firmware.c,40 :: 		Uart5_Write_Text("START\r\n");
LUI	R25, hi_addr(?lstr1_ekg_firmware+0)
ORI	R25, R25, lo_addr(?lstr1_ekg_firmware+0)
JAL	_UART5_Write_Text+0
NOP	
;ekg_firmware.c,41 :: 		delay_ms(500);
LUI	R24, 203
ORI	R24, R24, 29524
L_main5:
ADDIU	R24, R24, -1
BNE	R24, R0, L_main5
NOP	
NOP	
NOP	
;ekg_firmware.c,42 :: 		InitTimer1();
JAL	_InitTimer1+0
NOP	
;ekg_firmware.c,43 :: 		EnableInterrupts();
EI	R30
;ekg_firmware.c,44 :: 		}
L_main4:
;ekg_firmware.c,46 :: 		if (read_flag == true)
LBU	R3, Offset(ekg_firmware_read_flag+0)(GP)
ORI	R2, R0, 1
BEQ	R3, R2, L__main16
NOP	
J	L_main7
NOP	
L__main16:
;ekg_firmware.c,48 :: 		T1IE_bit         = 0;
LUI	R2, BitMask(T1IE_bit+0)
ORI	R2, R2, BitMask(T1IE_bit+0)
_SX	
;ekg_firmware.c,49 :: 		adc_reads    =  ADC1_Get_Sample(8);
ORI	R25, R0, 8
JAL	_ADC1_Get_Sample+0
NOP	
ANDI	R2, R2, 65535
SW	R2, Offset(_adc_reads+0)(GP)
;ekg_firmware.c,50 :: 		timer_reads  =  ((double)interrupt_ctr)*3.9;
LW	R4, Offset(ekg_firmware_interrupt_ctr+0)(GP)
JAL	__Unsigned32IntToFloat+0
NOP	
LUI	R4, 16505
ORI	R4, R4, 39322
MOVZ	R6, R2, R0
JAL	__Mul_FP+0
NOP	
SW	R2, Offset(_timer_reads+0)(GP)
;ekg_firmware.c,51 :: 		inttostr(adc_reads, final_string);
ADDIU	R2, SP, 10
MOVZ	R26, R2, R0
LW	R25, Offset(_adc_reads+0)(GP)
JAL	_IntToStr+0
NOP	
;ekg_firmware.c,52 :: 		floattostr(timer_reads, timer_read_string);
ADDIU	R2, SP, 0
MOVZ	R26, R2, R0
LW	R25, Offset(_timer_reads+0)(GP)
JAL	_FloatToStr+0
NOP	
;ekg_firmware.c,53 :: 		strcat(final_string, ",");
ADDIU	R2, SP, 10
LUI	R26, hi_addr(?lstr2_ekg_firmware+0)
ORI	R26, R26, lo_addr(?lstr2_ekg_firmware+0)
MOVZ	R25, R2, R0
JAL	_strcat+0
NOP	
;ekg_firmware.c,54 :: 		strcat(final_string, timer_read_string);
ADDIU	R3, SP, 0
ADDIU	R2, SP, 10
MOVZ	R26, R3, R0
MOVZ	R25, R2, R0
JAL	_strcat+0
NOP	
;ekg_firmware.c,55 :: 		ltrim(final_string);
ADDIU	R2, SP, 10
MOVZ	R25, R2, R0
JAL	_Ltrim+0
NOP	
;ekg_firmware.c,56 :: 		Uart_Write_Text(final_string);
ADDIU	R2, SP, 10
MOVZ	R25, R2, R0
JAL	_UART_Write_Text+0
NOP	
;ekg_firmware.c,57 :: 		Uart_Write_Text("\r\n");
LUI	R25, hi_addr(?lstr3_ekg_firmware+0)
ORI	R25, R25, lo_addr(?lstr3_ekg_firmware+0)
JAL	_UART_Write_Text+0
NOP	
;ekg_firmware.c,58 :: 		read_flag = false;
SB	R0, Offset(ekg_firmware_read_flag+0)(GP)
;ekg_firmware.c,59 :: 		T1IE_bit  = 1;
LUI	R2, BitMask(T1IE_bit+0)
ORI	R2, R2, BitMask(T1IE_bit+0)
_SX	
;ekg_firmware.c,60 :: 		}
L_main7:
;ekg_firmware.c,62 :: 		if (seconds_counter == 15)
LW	R3, Offset(ekg_firmware_seconds_counter+0)(GP)
ORI	R2, R0, 15
BEQ	R3, R2, L__main17
NOP	
J	L_main8
NOP	
L__main17:
;ekg_firmware.c,64 :: 		T1IE_bit = 0; // disable global interrupts
LUI	R2, BitMask(T1IE_bit+0)
ORI	R2, R2, BitMask(T1IE_bit+0)
_SX	
;ekg_firmware.c,65 :: 		Uart_Write_Text("END\r\n");
LUI	R25, hi_addr(?lstr4_ekg_firmware+0)
ORI	R25, R25, lo_addr(?lstr4_ekg_firmware+0)
JAL	_UART_Write_Text+0
NOP	
;ekg_firmware.c,66 :: 		while(1);
L_main9:
J	L_main9
NOP	
;ekg_firmware.c,67 :: 		}
L_main8:
;ekg_firmware.c,69 :: 		}
J	L_main2
NOP	
;ekg_firmware.c,71 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
_Timer1Interrupt:
;ekg_firmware.c,74 :: 		void Timer1Interrupt() iv IVT_TIMER_1 ilevel 7 ics ICS_SRS
RDPGPR	SP, SP
ADDIU	SP, SP, -12
MFC0	R30, 12, 2
SW	R30, 8(SP)
MFC0	R30, 14, 0
SW	R30, 4(SP)
MFC0	R30, 12, 0
SW	R30, 0(SP)
INS	R30, R0, 1, 15
ORI	R30, R0, 7168
MTC0	R30, 12, 0
;ekg_firmware.c,76 :: 		read_flag = true;
ORI	R2, R0, 1
SB	R2, Offset(ekg_firmware_read_flag+0)(GP)
;ekg_firmware.c,78 :: 		interrupt_ctr++;
LW	R2, Offset(ekg_firmware_interrupt_ctr+0)(GP)
ADDIU	R2, R2, 1
SW	R2, Offset(ekg_firmware_interrupt_ctr+0)(GP)
;ekg_firmware.c,79 :: 		if (interrupt_ctr % 256 == 0)
LW	R2, Offset(ekg_firmware_interrupt_ctr+0)(GP)
ANDI	R2, R2, 255
BEQ	R2, R0, L__Timer1Interrupt20
NOP	
J	L_Timer1Interrupt11
NOP	
L__Timer1Interrupt20:
;ekg_firmware.c,80 :: 		seconds_counter++;
LW	R2, Offset(ekg_firmware_seconds_counter+0)(GP)
ADDIU	R2, R2, 1
SW	R2, Offset(ekg_firmware_seconds_counter+0)(GP)
L_Timer1Interrupt11:
;ekg_firmware.c,82 :: 		T1IF_bit = 0;
LUI	R2, BitMask(T1IF_bit+0)
ORI	R2, R2, BitMask(T1IF_bit+0)
_SX	
;ekg_firmware.c,83 :: 		}
L_end_Timer1Interrupt:
DI	
EHB	
LW	R30, 8(SP)
MTC0	R30, 12, 2
LW	R30, 4(SP)
MTC0	R30, 14, 0
LW	R30, 0(SP)
MTC0	R30, 12, 0
ADDIU	SP, SP, 12
WRPGPR	SP, SP
ERET	
; end of _Timer1Interrupt

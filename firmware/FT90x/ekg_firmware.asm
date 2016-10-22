_InitTimerA:
LDK.L	R0, #2
STA.B	TIMER_CONTROL_0+0, R0
LDK.L	R1, #0
STA.B	TIMER_SELECT+0, R1
LDK.L	R0, #232
STA.B	TIMER_PRESC_LS+0, R0
LDK.L	R0, #253
STA.B	TIMER_PRESC_MS+0, R0
LDK.L	R0, #5
STA.B	TIMER_WRITE_LS+0, R0
STA.B	TIMER_WRITE_MS+0, R1
STA.B	TIMER_CONTROL_3+0, R1
LDK.L	R0, #17
STA.B	TIMER_CONTROL_4+0, R0
LDK.L	R0, #16
STA.B	TIMER_CONTROL_2+0, R0
LDA.x	R0, #AlignedAddress(TIMER_INT+0)
BINS.L	R0, R0, #545
STI.x	TIMER_INT+0, #AlignedAddress(R0)
LDA.x	R0, #AlignedAddress(IRQ_CTRL+0)
BINS.L	R0, R0, #63
STI.x	IRQ_CTRL+0, #AlignedAddress(R0)
LDK.L	R0, #1
STA.B	TIMER_CONTROL_1+0, R0
L_end_InitTimerA:
RETURN	
; end of _InitTimerA
_main:
LDK.L	SP, #43605
LINK	LR, #32
LDK.L	R0, #57600
CALL	_UART1_Init+0
LPM.L	R28, #16666665
NOP	
L_main0:
SUB.L	R28, R28, #1
CMP.L	R28, #0
JMPC	R30, Z, #0, L_main0
JMP	$+8
	#16666665
LDK.L	R0, #1
CALL	_ADC_Init_Advanced+0
LDK.L	R0, #4
CALL	_ADC_Set_Input_Channel+0
LPM.L	R28, #3333331
NOP	
L_main2:
SUB.L	R28, R28, #1
CMP.L	R28, #0
JMPC	R30, Z, #0, L_main2
JMP	$+8
	#3333331
NOP	
NOP	
LDK.L	R1, #1
LDK.L	R0, #GPIO_PORT_08_15+0
CALL	_GPIO_Digital_Input+0
L_main4:
LDK.L	R3, #1
LDK.L	R2, #10
LDK.L	R1, #0
LDK.L	R0, #GPIO_PORT_08_15+0
CALL	_Button+0
CMP.B	R0, #0
JMPC	R30, Z, #1, L_main6
LDK.L	R0, #?lstr1_ekg_firmware+0
CALL	_UART1_Write_Text+0
LPM.L	R28, #16666665
NOP	
L_main7:
SUB.L	R28, R28, #1
CMP.L	R28, #0
JMPC	R30, Z, #0, L_main7
JMP	$+8
	#16666665
CALL	_InitTimerA+0
L_main6:
LDA.B	R0, ekg_firmware_read_flag+0
CMP.B	R0, #1
JMPC	R30, Z, #0, L_main9
LDK.L	R0, #4
CALL	_ADC_Get_Sample+0
STA.L	_temp_adc_read+0, R0
LDA.L	R4, ekg_firmware_interrupt_ctr+0
CALL	__Unsigned32IntToFloat+0
MOVE.L	R4, R0
LDK.L	R6, #1081711002
LDL.L	R6, R6, #1081711002
CALL	__Mul_FP+0
STA.L	_temp_timer_read+0, R0
ADD.L	R1, SP, #10
LDA.S	R0, _temp_adc_read+0
BEXTS.L	R0, R0, #0
CALL	_IntToStr+0
LDA.L	R2, _temp_timer_read+0
LDK.L	R1, #?lstr_2_ekg_firmware+0
ADD.L	R0, SP, #0
PUSH.L	R2
PUSH.L	R1
PUSH.L	R0
CALL	_sprintf+0
ADD.L	SP, SP, #12
LDK.L	R1, #?lstr3_ekg_firmware+0
ADD.L	R0, SP, #10
CALL	_strcat+0
ADD.L	R1, SP, #0
ADD.L	R0, SP, #10
CALL	_strcat+0
ADD.L	R0, SP, #10
CALL	_Ltrim+0
ADD.L	R0, SP, #10
CALL	_UART_Write_Text+0
LDK.L	R0, #?lstr4_ekg_firmware+0
CALL	_UART_Write_Text+0
LDK.L	R0, #0
STA.B	ekg_firmware_read_flag+0, R0
L_main9:
LDA.L	R0, ekg_firmware_seconds_counter+0
CMP.L	R0, #15
JMPC	R30, Z, #0, L_main10
LDA.x	R0, #AlignedAddress(IRQ_CTRL+0)
BINS.L	R0, R0, #575
STI.x	IRQ_CTRL+0, #AlignedAddress(R0)
LDK.L	R0, #?lstr5_ekg_firmware+0
CALL	_UART_Write_Text+0
L_main11:
JMP	L_main11
L_main10:
JMP	L_main4
L_end_main:
L__main_end_loop:
JMP	L__main_end_loop
; end of _main
_TimerInterrupt:
LDA.x	R0, #AlignedAddress(TIMER_INT_A_bit+0)
BEXTU.L	R0, R0, #BitPos(TIMER_INT_A_bit+0)
CMP.L	R0, #0
JMPC	R30, Z, #1, L_TimerInterrupt13
LDK.L	R0, #1
STA.B	ekg_firmware_read_flag+0, R0
LDA.L	R0, ekg_firmware_interrupt_ctr+0
ADD.L	R0, R0, #1
STA.L	ekg_firmware_interrupt_ctr+0, R0
LDA.L	R0, ekg_firmware_interrupt_ctr+0
AND.L	R0, R0, #255
CMP.L	R0, #0
JMPC	R30, Z, #0, L_TimerInterrupt14
LDA.L	R0, ekg_firmware_seconds_counter+0
ADD.L	R0, R0, #1
STA.L	ekg_firmware_seconds_counter+0, R0
L_TimerInterrupt14:
LDA.B	R0, TIMER_INT+0
AND.L	R0, R0, #170
BEXTU.L	R0, R0, #256
OR.L	R0, R0, #1
STA.B	TIMER_INT+0, R0
L_TimerInterrupt13:
L_end_TimerInterrupt:
RETI	
; end of _TimerInterrupt

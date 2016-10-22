_InitTimer2:
;ekg_firmware.c,5 :: 		void InitTimer2(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ekg_firmware.c,6 :: 		RCC_APB1ENR.TIM2EN = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(RCC_APB1ENR+0)
MOVT	R0, #hi_addr(RCC_APB1ENR+0)
STR	R1, [R0, #0]
;ekg_firmware.c,7 :: 		TIM2_CR1.CEN = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;ekg_firmware.c,8 :: 		TIM2_PSC = 5;
MOVS	R1, #5
MOVW	R0, #lo_addr(TIM2_PSC+0)
MOVT	R0, #hi_addr(TIM2_PSC+0)
STR	R1, [R0, #0]
;ekg_firmware.c,9 :: 		TIM2_ARR = 54599;
MOVW	R1, #54599
MOVW	R0, #lo_addr(TIM2_ARR+0)
MOVT	R0, #hi_addr(TIM2_ARR+0)
STR	R1, [R0, #0]
;ekg_firmware.c,10 :: 		NVIC_IntEnable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntEnable+0
;ekg_firmware.c,11 :: 		TIM2_DIER.UIE = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_DIER+0)
MOVT	R0, #hi_addr(TIM2_DIER+0)
STR	R1, [R0, #0]
;ekg_firmware.c,12 :: 		TIM2_CR1.CEN = 1;
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
STR	R1, [R0, #0]
;ekg_firmware.c,13 :: 		}
L_end_InitTimer2:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _InitTimer2
_main:
;ekg_firmware.c,22 :: 		void main()
SUB	SP, SP, #32
;ekg_firmware.c,24 :: 		uint16_t adc_read = 0;
;ekg_firmware.c,26 :: 		uint32_t i = 0;
;ekg_firmware.c,30 :: 		temp_adc_read = temp_timer_read = 0;
MOV	R0, #0
VMOV	S0, R0
MOVW	R0, #lo_addr(_temp_timer_read+0)
MOVT	R0, #hi_addr(_temp_timer_read+0)
VSTR	#1, S0, [R0, #0]
MOV	R1, #0
MOVW	R0, #lo_addr(_temp_adc_read+0)
MOVT	R0, #hi_addr(_temp_adc_read+0)
STR	R1, [R0, #0]
;ekg_firmware.c,32 :: 		GPIO_Analog_Input( &GPIOA_BASE, _GPIO_PINMASK_4 );        // PA4 is analog input
MOVW	R1, #16
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Analog_Input+0
;ekg_firmware.c,33 :: 		GPIO_Digital_Input( &GPIOD_BASE, _GPIO_PINMASK_10 );     // PD10 is input for button
MOVW	R1, #1024
MOVW	R0, #lo_addr(GPIOD_BASE+0)
MOVT	R0, #hi_addr(GPIOD_BASE+0)
BL	_GPIO_Digital_Input+0
;ekg_firmware.c,35 :: 		UART1_Init(57600);
MOVW	R0, #57600
BL	_UART1_Init+0
;ekg_firmware.c,37 :: 		delay_ms(500);
MOVW	R7, #2515
MOVT	R7, #356
NOP
NOP
L_main0:
SUBS	R7, R7, #1
BNE	L_main0
NOP
NOP
NOP
NOP
;ekg_firmware.c,41 :: 		ADC_Set_Input_Channel(_ADC_CHANNEL_4);
MOVW	R0, #16
BL	_ADC_Set_Input_Channel+0
;ekg_firmware.c,42 :: 		ADC1_Init();
BL	_ADC1_Init+0
;ekg_firmware.c,43 :: 		Delay_ms(100);
MOVW	R7, #13609
MOVT	R7, #71
NOP
NOP
L_main2:
SUBS	R7, R7, #1
BNE	L_main2
NOP
NOP
;ekg_firmware.c,45 :: 		while(1)
L_main4:
;ekg_firmware.c,47 :: 		if (Button(&GPIOD_IDR, 10, 10, 1))                 // if button on PD10 is pressed, interrupts are activated and the measuring begins
MOVS	R3, #1
MOVS	R2, #10
MOVS	R1, #10
MOVW	R0, #lo_addr(GPIOD_IDR+0)
MOVT	R0, #hi_addr(GPIOD_IDR+0)
BL	_Button+0
CMP	R0, #0
IT	EQ
BEQ	L_main6
;ekg_firmware.c,49 :: 		Uart1_Write_Text("START\r\n");
MOVW	R0, #lo_addr(?lstr1_ekg_firmware+0)
MOVT	R0, #hi_addr(?lstr1_ekg_firmware+0)
BL	_UART1_Write_Text+0
;ekg_firmware.c,50 :: 		InitTimer2();
BL	_InitTimer2+0
;ekg_firmware.c,51 :: 		EnableInterrupts();
BL	_EnableInterrupts+0
;ekg_firmware.c,52 :: 		delay_ms(500);
MOVW	R7, #2515
MOVT	R7, #356
NOP
NOP
L_main7:
SUBS	R7, R7, #1
BNE	L_main7
NOP
NOP
NOP
NOP
;ekg_firmware.c,53 :: 		}
L_main6:
;ekg_firmware.c,56 :: 		if (read_flag == true)                           // every 3.9ms, measure data, measure time, and send them to the PC
MOVW	R0, #lo_addr(ekg_firmware_read_flag+0)
MOVT	R0, #hi_addr(ekg_firmware_read_flag+0)
LDRB	R0, [R0, #0]
CMP	R0, #1
IT	NE
BNE	L_main9
;ekg_firmware.c,58 :: 		DisableInterrupts();
BL	_DisableInterrupts+0
;ekg_firmware.c,59 :: 		temp_adc_read = ADC1_Get_Sample(4);
MOVS	R0, #4
BL	_ADC1_Get_Sample+0
MOVW	R2, #lo_addr(_temp_adc_read+0)
MOVT	R2, #hi_addr(_temp_adc_read+0)
STR	R0, [R2, #0]
;ekg_firmware.c,60 :: 		temp_timer_read = interrupt_ctr*3.9;
MOVW	R0, #lo_addr(ekg_firmware_interrupt_ctr+0)
MOVT	R0, #hi_addr(ekg_firmware_interrupt_ctr+0)
VLDR	#1, S0, [R0, #0]
VCVT.F32	#0, S1, S0
MOVW	R0, #39322
MOVT	R0, #16505
VMOV	S0, R0
VMUL.F32	S0, S1, S0
MOVW	R0, #lo_addr(_temp_timer_read+0)
MOVT	R0, #hi_addr(_temp_timer_read+0)
VSTR	#1, S0, [R0, #0]
;ekg_firmware.c,61 :: 		inttostr(temp_adc_read, final_string);
ADD	R1, SP, #10
MOV	R0, R2
LDR	R0, [R0, #0]
BL	_IntToStr+0
;ekg_firmware.c,62 :: 		sprintf(timer_read_string,"%.2f", temp_timer_read);
MOVW	R0, #lo_addr(_temp_timer_read+0)
MOVT	R0, #hi_addr(_temp_timer_read+0)
VLDR	#1, S0, [R0, #0]
MOVW	R1, #lo_addr(?lstr_2_ekg_firmware+0)
MOVT	R1, #hi_addr(?lstr_2_ekg_firmware+0)
ADD	R0, SP, #0
VPUSH	#0, (S0)
PUSH	(R1)
PUSH	(R0)
BL	_sprintf+0
ADD	SP, SP, #12
;ekg_firmware.c,63 :: 		strcat(final_string, ",");
MOVW	R1, #lo_addr(?lstr3_ekg_firmware+0)
MOVT	R1, #hi_addr(?lstr3_ekg_firmware+0)
ADD	R0, SP, #10
BL	_strcat+0
;ekg_firmware.c,64 :: 		strcat(final_string, timer_read_string);
ADD	R1, SP, #0
ADD	R0, SP, #10
BL	_strcat+0
;ekg_firmware.c,65 :: 		ltrim(final_string);
ADD	R0, SP, #10
BL	_Ltrim+0
;ekg_firmware.c,66 :: 		Uart_Write_Text(final_string);
ADD	R0, SP, #10
BL	_UART_Write_Text+0
;ekg_firmware.c,67 :: 		Uart_Write_Text("\r\n");
MOVW	R0, #lo_addr(?lstr4_ekg_firmware+0)
MOVT	R0, #hi_addr(?lstr4_ekg_firmware+0)
BL	_UART_Write_Text+0
;ekg_firmware.c,68 :: 		read_flag = false;
MOVS	R1, #0
MOVW	R0, #lo_addr(ekg_firmware_read_flag+0)
MOVT	R0, #hi_addr(ekg_firmware_read_flag+0)
STRB	R1, [R0, #0]
;ekg_firmware.c,69 :: 		EnableInterrupts();
BL	_EnableInterrupts+0
;ekg_firmware.c,70 :: 		}
L_main9:
;ekg_firmware.c,72 :: 		if (seconds_counter == 15)           // after 15 seconds of measuring is done, send the END string and finish
MOVW	R0, #lo_addr(ekg_firmware_seconds_counter+0)
MOVT	R0, #hi_addr(ekg_firmware_seconds_counter+0)
LDR	R0, [R0, #0]
CMP	R0, #15
IT	NE
BNE	L_main10
;ekg_firmware.c,74 :: 		DisableInterrupts();
BL	_DisableInterrupts+0
;ekg_firmware.c,76 :: 		Uart1_Write_Text("END\r\n");
MOVW	R0, #lo_addr(?lstr5_ekg_firmware+0)
MOVT	R0, #hi_addr(?lstr5_ekg_firmware+0)
BL	_UART1_Write_Text+0
;ekg_firmware.c,77 :: 		while(1);
L_main11:
IT	AL
BAL	L_main11
;ekg_firmware.c,78 :: 		}
L_main10:
;ekg_firmware.c,80 :: 		}
IT	AL
BAL	L_main4
;ekg_firmware.c,83 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
_Timer2_interrupt:
;ekg_firmware.c,85 :: 		void Timer2_interrupt() iv IVT_INT_TIM2
;ekg_firmware.c,88 :: 		TIM2_SR.UIF = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
STR	R1, [R0, #0]
;ekg_firmware.c,89 :: 		interrupt_ctr++;
MOVW	R0, #lo_addr(ekg_firmware_interrupt_ctr+0)
MOVT	R0, #hi_addr(ekg_firmware_interrupt_ctr+0)
LDR	R0, [R0, #0]
ADDS	R1, R0, #1
MOVW	R0, #lo_addr(ekg_firmware_interrupt_ctr+0)
MOVT	R0, #hi_addr(ekg_firmware_interrupt_ctr+0)
STR	R1, [R0, #0]
;ekg_firmware.c,90 :: 		if (interrupt_ctr % 256 == 0)
MOVW	R0, #lo_addr(ekg_firmware_interrupt_ctr+0)
MOVT	R0, #hi_addr(ekg_firmware_interrupt_ctr+0)
LDR	R0, [R0, #0]
AND	R0, R0, #255
CMP	R0, #0
IT	NE
BNE	L_Timer2_interrupt13
;ekg_firmware.c,91 :: 		seconds_counter++;
MOVW	R0, #lo_addr(ekg_firmware_seconds_counter+0)
MOVT	R0, #hi_addr(ekg_firmware_seconds_counter+0)
LDR	R0, [R0, #0]
ADDS	R1, R0, #1
MOVW	R0, #lo_addr(ekg_firmware_seconds_counter+0)
MOVT	R0, #hi_addr(ekg_firmware_seconds_counter+0)
STR	R1, [R0, #0]
L_Timer2_interrupt13:
;ekg_firmware.c,92 :: 		read_flag = true;
MOVS	R1, #1
MOVW	R0, #lo_addr(ekg_firmware_read_flag+0)
MOVT	R0, #hi_addr(ekg_firmware_read_flag+0)
STRB	R1, [R0, #0]
;ekg_firmware.c,94 :: 		}
L_end_Timer2_interrupt:
BX	LR
; end of _Timer2_interrupt

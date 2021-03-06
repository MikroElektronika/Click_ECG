#line 1 "C:/Users/Viktor/Desktop/EKG_PROJECT/Firmware/PIC32/ekg_firmware.c"
#line 1 "c:/c4w/mikroelektronika/mikroc pro for pic32/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;
typedef signed long long int64_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;
typedef unsigned long long uint64_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;
typedef signed long long int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;
typedef unsigned long long uint_least64_t;



typedef signed long int int_fast8_t;
typedef signed long int int_fast16_t;
typedef signed long int int_fast32_t;
typedef signed long long int_fast64_t;


typedef unsigned long int uint_fast8_t;
typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long long uint_fast64_t;


typedef signed long int intptr_t;
typedef unsigned long int uintptr_t;


typedef signed long long intmax_t;
typedef unsigned long long uintmax_t;
#line 1 "c:/c4w/mikroelektronika/mikroc pro for pic32/include/stdbool.h"



 typedef char _Bool;
#line 4 "C:/Users/Viktor/Desktop/EKG_PROJECT/Firmware/PIC32/ekg_firmware.c"
void InitTimer1(){
 T1CON = 0x8010;
 T1IP0_bit = 1;
 T1IP1_bit = 1;
 T1IP2_bit = 1;
 T1IF_bit = 0;
 T1IE_bit = 1;
 PR1 = 39000;
 TMR1 = 0;
}

static  _Bool  read_flag =  0 ;
static volatile uint32_t interrupt_ctr = 0;
static volatile uint32_t seconds_counter = 0;
uint32_t adc_reads;
double timer_reads;

void main()
{
 uint32_t i = 0;
 char timer_read_string[10];
 char final_string [20];

 TRISB8_bit = 1;
 TRISA15_bit = 1;
 ad1pcfg = 0x0100;
 ADC1_Init();

 UART5_Init(57600);
 delay_ms(500);

 while(1)
 {

 if (Button(&PORTA, 15, 10, 1))
 {
 Uart5_Write_Text("START\r\n");
 delay_ms(500);
 InitTimer1();
 EnableInterrupts();
 }

 if (read_flag ==  1 )
 {
 T1IE_bit = 0;
 adc_reads = ADC1_Get_Sample(8);
 timer_reads = ((double)interrupt_ctr)*3.9;
 inttostr(adc_reads, final_string);
 floattostr(timer_reads, timer_read_string);
 strcat(final_string, ",");
 strcat(final_string, timer_read_string);
 ltrim(final_string);
 Uart_Write_Text(final_string);
 Uart_Write_Text("\r\n");
 read_flag =  0 ;
 T1IE_bit = 1;
 }

 if (seconds_counter == 15)
 {
 T1IE_bit = 0;
 Uart_Write_Text("END\r\n");
 while(1);
 }

 }

}


void Timer1Interrupt() iv IVT_TIMER_1 ilevel 7 ics ICS_SRS
{
 read_flag =  1 ;

 interrupt_ctr++;
 if (interrupt_ctr % 256 == 0)
 seconds_counter++;

 T1IF_bit = 0;
}

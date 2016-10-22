#line 1 "C:/Users/Viktor/Desktop/EKG_PROJECT/Firmware/FT90x/ekg_firmware.c"
#line 1 "c:/users/viktor/desktop/new_compiler/mikroc pro for ft90x/include/stdint.h"





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
#line 1 "c:/users/viktor/desktop/new_compiler/mikroc pro for ft90x/include/stdbool.h"



 typedef char _Bool;
#line 4 "C:/Users/Viktor/Desktop/EKG_PROJECT/Firmware/FT90x/ekg_firmware.c"
void InitTimerA() {
 TIMER_CONTROL_0 = 2;

 TIMER_SELECT = 0;

 TIMER_PRESC_LS = 232;
 TIMER_PRESC_MS = 253;

 TIMER_WRITE_LS = 5;
 TIMER_WRITE_MS = 0;

 TIMER_CONTROL_3 = 0;

 TIMER_CONTROL_4 = 0x11;

 TIMER_CONTROL_2 = 0x10;

 TIMER_INT.B1 = 1;

 IRQ_CTRL.B31 = 0;

 TIMER_CONTROL_1 = 1;
}

static  _Bool  read_flag =  0 ;
static volatile uint32_t interrupt_ctr = 0;
uint32_t adc_reads_ctr = 0;
uint32_t timer_reads_ctr = 0;
static volatile uint32_t seconds_counter = 0;
uint32_t temp_adc_read;
double temp_timer_read;

void main()
{
 uint32_t i = 0;
 char timer_read_string[10];
 char final_string [20];

 UART1_Init(57600);

 delay_ms(500);




 ADC_Init_Advanced(_ADC_MODE_CONTINUOUS);
 ADC_Set_Input_Channel(_ADC_CHANNEL_3);
 Delay_ms(100);
 GPIO_Digital_Input(&GPIO_PORT_08_15, _GPIO_PINMASK_0);




 while(1)
 {
 if (Button(&GPIO_PORT_08_15, 0, 10, 1))
 {
 Uart1_Write_Text("START\r\n");
 delay_ms(500);
 InitTimerA();
 }


 if (read_flag ==  1 )
 {
 temp_adc_read = ADC_Get_Sample(4);
 temp_timer_read = ((double)interrupt_ctr)*3.9;
 inttostr(temp_adc_read, final_string);
 sprintf(timer_read_string,"%.2f", temp_timer_read);
 strcat(final_string, ",");
 strcat(final_string, timer_read_string);
 ltrim(final_string);
 Uart_Write_Text(final_string);
 Uart_Write_Text("\r\n");
 read_flag =  0 ;
 }

 if (seconds_counter == 15)
 {
 IRQ_CTRL.B31 = 1;
 Uart_Write_Text("END\r\n");
 while(1);
 }

 }

}


void TimerInterrupt() iv IVT_TIMERS_IRQ
{

 if (TIMER_INT_A_bit)
 {

 read_flag =  1 ;

 interrupt_ctr++;
 if (interrupt_ctr % 256 == 0)
 seconds_counter++;

 TIMER_INT = (TIMER_INT & 0xAA) | (1 << 0);

 }
}

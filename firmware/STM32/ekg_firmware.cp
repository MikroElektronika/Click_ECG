#line 1 "C:/Users/Viktor/Desktop/EKG_PROJECT/novi_firmware/STM32/ekg_firmware.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for arm/include/stdint.h"





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
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for arm/include/stdbool.h"



 typedef char _Bool;
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for arm/include/built_in.h"
#line 5 "C:/Users/Viktor/Desktop/EKG_PROJECT/novi_firmware/STM32/ekg_firmware.c"
void InitTimer2(){
 RCC_APB1ENR.TIM2EN = 1;
 TIM2_CR1.CEN = 0;
 TIM2_PSC = 5;
 TIM2_ARR = 54599;
 NVIC_IntEnable(IVT_INT_TIM2);
 TIM2_DIER.UIE = 1;
 TIM2_CR1.CEN = 1;
}


static  _Bool  read_flag =  0 ;
static volatile uint32_t interrupt_ctr = 0;
static volatile uint32_t seconds_counter = 0;
uint32_t temp_adc_read;
double temp_timer_read;

void main()
{
 uint16_t adc_read = 0;

 uint32_t i = 0;
 char timer_read_string[10];
 char final_string [20];

 temp_adc_read = temp_timer_read = 0;

 GPIO_Analog_Input( &GPIOA_BASE, _GPIO_PINMASK_4 );
 GPIO_Digital_Input( &GPIOD_BASE, _GPIO_PINMASK_10 );

 UART1_Init(57600);

 delay_ms(500);



 ADC_Set_Input_Channel(_ADC_CHANNEL_4);
 ADC1_Init();
 Delay_ms(100);

 while(1)
 {
 if (Button(&GPIOD_IDR, 10, 10, 1))
 {
 Uart1_Write_Text("START\r\n");
 InitTimer2();
 EnableInterrupts();
 delay_ms(500);
 }


 if (read_flag ==  1 )
 {
 DisableInterrupts();
 temp_adc_read = ADC1_Get_Sample(4);
 temp_timer_read = interrupt_ctr*3.9;
 inttostr(temp_adc_read, final_string);
 sprintf(timer_read_string,"%.2f", temp_timer_read);
 strcat(final_string, ",");
 strcat(final_string, timer_read_string);
 ltrim(final_string);
 Uart_Write_Text(final_string);
 Uart_Write_Text("\r\n");
 read_flag =  0 ;
 EnableInterrupts();
 }

 if (seconds_counter == 15)
 {
 DisableInterrupts();



 while(1);
 }

 }


}

void Timer2_interrupt() iv IVT_INT_TIM2
{

 TIM2_SR.UIF = 0;
 interrupt_ctr++;
 if (interrupt_ctr % 256 == 0)
 seconds_counter++;
 read_flag =  1 ;

}

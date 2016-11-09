#include <stdint.h>
#include <stdbool.h>
#include <built_in.h>

void InitTimer2(){
  RCC_APB1ENR.TIM2EN = 1;
  TIM2_CR1.CEN = 0;
  TIM2_PSC = 5;
  TIM2_ARR = 54599;
  NVIC_IntEnable(IVT_INT_TIM2);
  TIM2_DIER.UIE = 1;
  TIM2_CR1.CEN = 1;
}


static bool read_flag = false;
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

     GPIO_Analog_Input( &GPIOA_BASE, _GPIO_PINMASK_4 );        // PA4 is analog input
     GPIO_Digital_Input( &GPIOD_BASE, _GPIO_PINMASK_10 );     // PD10 is input for button
     
     UART1_Init(57600);

     delay_ms(500);

//     Uart1_Write_Text("Uart initialized \r\n");               // this is for testing only, it should stay commented when implementing ECG reading

     ADC_Set_Input_Channel(_ADC_CHANNEL_4);
     ADC1_Init();
     Delay_ms(100);

     while(1)
     {
             if (Button(&GPIOD_IDR, 10, 10, 1))                 // if button on PD10 is pressed, interrupts are activated and the measuring begins
             {
                   Uart1_Write_Text("START\r\n");
                   InitTimer2();
                   EnableInterrupts();
                   delay_ms(500);
             }


             if (read_flag == true)                           // every 3.9ms, measure data, measure time, and send them to the PC
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
                    read_flag = false;
                    EnableInterrupts();
             }

             if (seconds_counter == 15)           // after 15 seconds of measuring is done, send the END string and finish
             {
                DisableInterrupts();

//                Uart1_Write_Text("END\r\n");   // this line is no longer needed for the application, it can be used for debugging purposes
                                                 // if the data is being monitored on a serial terminal
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
  read_flag = true;

}
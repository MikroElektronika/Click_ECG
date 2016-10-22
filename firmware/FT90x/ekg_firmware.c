#include <stdint.h>
#include <stdbool.h>

void InitTimerA() {
  TIMER_CONTROL_0 = 2;
  // Select Timer A
  TIMER_SELECT = 0;
  // Write prescaler for Timer A
  TIMER_PRESC_LS = 232;
  TIMER_PRESC_MS = 253;
  // Write start value
  TIMER_WRITE_LS = 5;
  TIMER_WRITE_MS = 0;
  // Set continuous mode and direction down
  TIMER_CONTROL_3 = 0;
  // Trigger clearing timer A and prescaler
  TIMER_CONTROL_4 = 0x11;
  // Enable prescaler for Timer A
  TIMER_CONTROL_2 = 0x10;
  // Enable Timer A interrupt
  TIMER_INT.B1 = 1;
  // Enable global interrupts
  IRQ_CTRL.B31 = 0;
  // Start timer A
  TIMER_CONTROL_1 = 1;
}

static bool read_flag = false;
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

//     Uart_Write_Text("Uart initialized \r\n");              // this is for testing only, it should stay commented when implementing ECG reading

     ADC_Init_Advanced(_ADC_MODE_CONTINUOUS);
     ADC_Set_Input_Channel(_ADC_CHANNEL_3);
     Delay_ms(100);
     GPIO_Digital_Input(&GPIO_PORT_08_15, _GPIO_PINMASK_0);         // set PIN 8 input for button press

     while(1)
     {
             if (Button(&GPIO_PORT_08_15, 0, 10, 1))        // if the button on PIN8 is pressed, interrupts are activated and the measuring begins
             {
                Uart1_Write_Text("START\r\n");
                delay_ms(500);
                InitTimerA();
             }

             if (read_flag == true)                        // every 3.9ms, measure data, measure time, and send them to the PC
             {
                    temp_adc_read      =  ADC_Get_Sample(4);
                    temp_timer_read  =  ((double)interrupt_ctr)*3.9;
                    inttostr(temp_adc_read, final_string);
                    sprintf(timer_read_string,"%.2f", temp_timer_read);
                    strcat(final_string, ",");
                    strcat(final_string, timer_read_string);
                    ltrim(final_string);
                    Uart_Write_Text(final_string);
                    Uart_Write_Text("\r\n");
                    read_flag = false;
             }

             if (seconds_counter == 15)       // after 15 seconds of measuring is done, send the END string and finish
             {
                IRQ_CTRL.B31 = 1; // disable global interrupts
                Uart_Write_Text("END\r\n");
                while(1);
             }

     }

}


void TimerInterrupt() iv IVT_TIMERS_IRQ
{

  if (TIMER_INT_A_bit)
  {
    read_flag = true;
    interrupt_ctr++;
    if (interrupt_ctr % 256 == 0)
           seconds_counter++;
 
    TIMER_INT = (TIMER_INT & 0xAA) | (1 << 0);
  }
}
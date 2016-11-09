#include <stdint.h>
#include <stdbool.h>

void InitTimer1(){
  T1CON                 = 0x8010;
  T1IP0_bit         = 1;
  T1IP1_bit         = 1;
  T1IP2_bit         = 1;
  T1IF_bit         = 0;
  T1IE_bit         = 1;
  PR1                 = 39000;
  TMR1                 = 0;
}

static bool read_flag = false;
static volatile uint32_t interrupt_ctr = 0;
static volatile uint32_t seconds_counter = 0;
uint32_t adc_reads;
double timer_reads;

void main()
{
     uint32_t i = 0;
     char timer_read_string[10];
     char final_string [20];

     TRISB8_bit =  1;              // Set A15 and B8 pins as input
     TRISA15_bit = 1;
     ad1pcfg = 0x0100;
     ADC1_Init();

     UART5_Init(57600);
     delay_ms(500);

     while(1)
     {
     
             if (Button(&PORTA, 15, 10, 1))          // if the button on A15 is pressed, interrupts are activated and the measuring begins
             {
                    Uart5_Write_Text("START\r\n");
                    delay_ms(500);
                    InitTimer1();
                    EnableInterrupts();
             }

             if (read_flag == true)                   // every 3.9ms, measure data, measure time, and send them to the PC
             {
                    T1IE_bit         = 0;
                    adc_reads    =  ADC1_Get_Sample(8);
                    timer_reads  =  ((double)interrupt_ctr)*3.9;
                    inttostr(adc_reads, final_string);
                    floattostr(timer_reads, timer_read_string);
                    strcat(final_string, ",");
                    strcat(final_string, timer_read_string);
                    ltrim(final_string);
                    Uart_Write_Text(final_string);
                    Uart_Write_Text("\r\n");
                    read_flag = false;
                    T1IE_bit  = 1;
             }

             if (seconds_counter == 15)                  // after 15 seconds of measuring is done, send the END string and finish
             {
                T1IE_bit = 0;                            // disable global interrupts
                
//                Uart_Write_Text("END\r\n");            // this line is no longer needed for the application, it can be used for debugging purposes,
                                                         // if the data is being monitored on a serial terminal
                while(1);
             }

     }

}


void Timer1Interrupt() iv IVT_TIMER_1 ilevel 7 ics ICS_SRS
{
    read_flag = true;

    interrupt_ctr++;
    if (interrupt_ctr % 256 == 0)
       seconds_counter++;

    T1IF_bit = 0;
}
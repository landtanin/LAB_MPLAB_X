extern void __delay_us(unsigned long); // to avoid getting MPLAB X warning
#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V
// Fclk = 4 MHz specified in the configuration bits
// This definition is required to calibrate __delay_us() and __delay_ms()
#define _XTAL_FREQ 4000000

void main()
{

// initialisation
	TRISA = 1;   // setting the direction for all the pins of PORTA - 1 - in
 	TRISD = 0;   // setting the direction for all the pins of PORTD - 0 - out
	// init the ADC
	ADCON1=0;
	ANSEL=0xFF;
	ADCON0=0x41;

// superloop - do forever
	while (1) {
		__delay_us(5);		// delay for charging the input capacitor
		GO_DONE =1;			// start conversion
		while (GO_DONE);	// wait util the conversion is completed
		PORTD = ADRESH;		// copy the ADC output to the LEDs
	}

} 
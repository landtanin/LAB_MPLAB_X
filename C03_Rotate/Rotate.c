extern void __delay_ms(unsigned long); // to avoid getting MPLAB X warning
#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V

// Fclk = 4 MHz specified in the configuration bits
// This definition is required to calibrate __delay_us() and __delay_ms()
#define _XTAL_FREQ 4000000

void main()
{
	unsigned char display;

// initialisation
 	TRISD = 0;          //  direction for all the pins of PORTD - 0 - out
	display = 0x80;     //  at the start switch LED 7 ON

// superloop - do forever
	while (1) {
		PORTD = display;	// display the variable
		__delay_ms(197);   	// wait - Hi-Tech compiler subroutine
		display >>= 1;
		if (!display) display=0x80;		
	}

} 
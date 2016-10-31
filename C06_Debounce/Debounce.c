#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V
// Fclk = 4 MHz specified in the configuration bits
// This definition is required to calibrate __delay_us() and __delay_ms()
#define _XTAL_FREQ 4000000

void main()
{
	unsigned char display, LastStableState, ctr;

// initialisation
	TRISA = 0xFF;   	// setting the direction for all the pins of PORTA - 1 - in
 	TRISD = 0;   	// setting the direction for all the pins of PORTD - 0 - out
	TRISB = 0xFF;   // setting the direction for all the pins of PORTA - 1 - in

	// init the analogue inputs
	ANSEL=0x1F;	 // PORTA are analogue, PORTD are digital
	ANSELH=0;	 // PORTB are digital

	// init the variables
	LastStableState = 1;
	PORTD=0;

// superloop - do forever
	while (1) {

		if (LastStableState) 
			if (RB0) ctr=0; else ctr++;
		else
			if (!RB0) ctr=0; else ctr++;

		if (ctr==5) {
			if (LastStableState) 
				LastStableState=0; 
			else {LastStableState=1; PORTD++;}
			ctr=0;
		}
		__delay_ms(1);
	}

} 
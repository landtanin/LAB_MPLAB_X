#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V

void main()
{
	unsigned char LastState;

// initialisation
	TRISA = 0xFF;   	// setting the direction for all the pins of PORTA - 1 - in
 	TRISD = 0;   	// setting the direction for all the pins of PORTD - 0 - out
	TRISB = 0xFF;   // setting the direction for all the pins of PORTA - 1 - in

	// init the analogue inputs
	ANSEL=0x1F;	 // PORTA are analogue, PORTD are digital
	ANSELH=0;	 // PORTB are digital

	// init the variables
	LastState = 1;
	PORTD=0;

// superloop - do forever
	while (1) {
		if (!RB0) LastState = 0;
		else if (!LastState) {PORTD++; LastState=1;}
	}

} 
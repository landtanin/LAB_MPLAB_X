#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V

unsigned char ctr;

void interrupt MyISR(void)	{
	if (T0IF)	{  	// could not check here as only one interrupt is enabled ...
		T0IF=0;		// you should not forget this in your code. But you can try it here - comment it out
		ctr++;		// variable to use in the main loop
	}
}

void main()
{

// initialisation
 	TRISD = 0;   // setting the direction for all the pins of PORTD - 0 - out
	PORTD=0;
	OPTION_REG = 0b00000111;
	// interrupt setup
	T0IE=1; GIE=1;

// superloop - do forever
	while (1) {
		PORTD=ctr; // would be useless without the interrupt
	}

} 
#include <xc.h>
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V

void main()
{

// initialisation
 	TRISD = 0;   // setting the direction for all the pins of PORTD - 0 - out
	PORTD=0;
	OPTION_REG = 0b00000111;

// superloop - do forever
	while (1) {
		while (!T0IF);
		T0IF=0;
		PORTD++;
	}

} 
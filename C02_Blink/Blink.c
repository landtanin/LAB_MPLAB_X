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
// initialisation
 	TRISD0 = 0;   // setting the direction for the pin D0 - 0 - out

// superloop - do forever
	while (1) {
		RD0 = 1;		// LED ON
		__delay_ms(300);   	// wait - subroutine provided by 
                                        //      the XC8 (Hi-Tech) compiler
		RD0=0;			// LED OFF
		__delay_ms(300);	// wait again
	}

} 
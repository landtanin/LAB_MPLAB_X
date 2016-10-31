#include <xc.h>
// old style MPLAB CONFIG bit setting still works in XC8 but not recommended
//__CONFIG (FOSC_INTRC_NOCLKOUT & WDTE_OFF & PWRTE_ON & MCLRE_ON & CP_OFF &
//        CPD_OFF & BOREN_OFF & IESO_OFF & FCMEN_OFF & LVP_OFF & DEBUG_ON &
//        WRT_OFF & BOR4V_BOR21V);

// use pragmas (consult "5.3.5 Configuration Bit Access" of the XC8 user guide)
#pragma config WDTE = OFF, FOSC = INTRC_NOCLKOUT, PWRTE = ON, MCLRE = ON
#pragma config CP = OFF, CPD = OFF, BOREN = OFF, IESO = OFF, FCMEN = OFF
#pragma config LVP = OFF, DEBUG = ON, WRT = OFF, BOR4V = BOR21V

void main()
{

 	TRISD0=0;       // setting the direction for the pin D0 - 0 - out
	RD0=1;   	// setting D0 pin to high level: ON -> LED lit

} 
      



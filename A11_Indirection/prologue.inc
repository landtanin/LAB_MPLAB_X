; enables use of register and bit names from the datasheet
; consistes of 
; SymbolicName EQU NumericalValue   ; equates symbolic names to appropriate bit patterns
#include <p16F887.inc>
; ! the name of the file should match the PIC microcontroller part name

; setting the configuration bits - required, explained at the end of the lecture course
	__CONFIG 	_CONFIG1, _INTOSCIO & _WDT_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF & _DEBUG_ON
;	configuration bits from the original Microchip code
;	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_OFF & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
;	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V
;
; _INTOSCIO - use internal 4 MHz oscillator, RA6 and RA7 pins are used for I/O
; _WDT_OFF - the watchdog timer is disabled
; _PWRTE_ON - power up timer enable - ENABLED
; _MCLRE_ON - master clear pin function - ENABLED
; _CP_OFF - code protection - OFF
; _CPD_OFF - data code protection - OFF
; _BOR_OFF - brown out reset - OFF
; _IESO_OFF - internal external oscillator switchover - DISABLED
; _FCMEN_OFF - fail safe clock monitor - DISABLED
; _LVP_OFF - low voltage programming - DISABLED
; _DEBUG_ON - in circuit debugger - ENABLED, pins RB6 and RB7 are used by it
; (these and all the other available options are specified in the p16F887.inc file
; ! the best practice is to ALWAYS specify all the bits in the code

; starting address in the program memory for the following code
     org 0
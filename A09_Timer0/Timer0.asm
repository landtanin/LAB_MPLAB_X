; *******************************************************************
; PICkit 2 Lesson 9 - Timer 0
;
; Lesson 9 shows how to configure and use the Timer0 peripheral to
; implement the delay function used in earlier lessons.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock     0x20
Display
     endc

;------------------------------------------------------------------------------
;* initialisation
     bsf       STATUS,RP0     ; Bank 1
     movlw     b'00000111'    ; configure Timer0.  Sourced from the Processor clock
     movwf     OPTION_REG     ; Maximum Prescaler
     clrf      TRISD          ; Make PortD all output
     bcf       STATUS,RP0     ; Bank 0
     clrf      Display

;------------------------------------------------------------------------------
;* superloop     
ForeverLoop:
     btfss     INTCON,T0IF    ; wait here until Timer0 rolls over
     goto      ForeverLoop
     bcf       INTCON,T0IF    ; flag must be cleared in software
     incf      Display,f      ; increment display variable
     movf      Display,w      ; send to the LEDs
     movwf     PORTD
     goto      ForeverLoop

;* end of the superloop
;------------------------------------------------------------------------------
     
     end

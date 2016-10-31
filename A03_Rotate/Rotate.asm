; *******************************************************************
; PICkit 2 Lesson 3 - "Rotate"
;
; Extends Lesson 2 to sequence through the display LEDs.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock 0x20
Delay1           ; Assign an address to label Delay1
Delay2
Display          ; define a variable to hold the diplay
     endc
     
Start:

;------------------------------------------------------------
;* initialisation
     bsf       STATUS,RP0     ; select Register Bank 1
     clrf      TRISD          ; make IO PortD all output
     bcf       STATUS,RP0     ; back to Register Bank 0
     movlw     0x80
     movwf     Display		  ; switch on LD7 at the start

;------------------------------------------------------------
;* superloop - do forever
MainLoop:

     movf      Display,w      ; Copy the display to the LEDs
     movwf     PORTD

; delay
OndelayLoop:
     decfsz    Delay1,f       ; Waste time.  
     goto      OndelayLoop    ; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
     decfsz    Delay2,f       ; The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      OndelayLoop    ; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
                              ; call it two-tenths of a second.

; switch on the next LED on the right     
     bcf       STATUS,C       ; ensure the carry bit is clear
     rrf       Display,f

; if it was the rightmost LED (LD0), switch on LD7
     btfsc     STATUS,C       ; Did the bit rotate into the carry?
     bsf       Display,RD7    ; yes, put it into bit 7.

     goto      MainLoop
;* end of the superloop
;------------------------------------------------------------
     end
     

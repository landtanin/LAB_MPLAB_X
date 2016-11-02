; *******************************************************************
; PICkit 2 Lesson 2 - "Blink"
;
; First lesson showed how to make an LED turn on,
; Now we'll look at how to make it blink.  Delay loops are necessary
; to slow down the on and off commands so they are visible to humans.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

; declaration of register variables (unsigned char)
     cblock 0x20     ; since the first 32 bits of data memory is for SFR, to allocate bit for memory it need to start from 32 (0x20)
Delay1               ; these variables are used as counters to provide delays
Delay2
     
; try for fun
;Delay3
     endc


Start:

;-------------------------------------------------------
;* initialisation section
; set pin RD0 to output
     bsf       STATUS,RP0     ; select Register Bank 1
     bcf       TRISD,TRISD0   ; make IO Pin RD0 an output
     bcf       STATUS,RP0     ; back to Register Bank 0

;-------------------------------------------------------
;* superloop
MainLoop:
     bsf       PORTD,RD0        ; turn on LED RD0
     
     ; try for fun
;     movlw     0xff
;     movwf     Delay1
     
;      exercise 1
     movlw     0x7f
     movwf     Delay2  ; why don't assign to Delay1??????????????

; delay for displaying the LED ON
OndelayLoop:
     decfsz    Delay1,f       ; Waste time.  
     goto      OndelayLoop    ; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
     decfsz    Delay2,f       ; The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      OndelayLoop    ; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
                              ; call it two-tenths of a second.
			
     ; try for fun
;     decfsz    Delay3, f
;     goto      OndelayLoop    ; (197376+3) * 256 = 50,529,024 instructions / 1M instructions per second ~ 50 sec
     
     bcf       PORTD,RD0      ; Turn off LED RD0

; delay for displaying the LED OFF
OffDelayLoop:
     decfsz    Delay1,f       ; same delay as above
     goto      OffDelayLoop
     decfsz    Delay2,f
     goto      OffDelayLoop

     goto      MainLoop       ; Do it again...
;* end of the superloop
;-------------------------------------------------------

; required by the end of file
     end
     

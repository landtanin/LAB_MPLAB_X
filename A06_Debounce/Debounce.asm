; *******************************************************************
; PICkit 2 Lesson 6 - Switch Debounce
;
; This shows one method to debounce switches.  
; Samples the line every 1mS, and waits for 5 in a row before
; acting on the change of state.  The LEDs are updated with a
; count incremented on each switch press.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock     0x20
Delay               ; Assign an address to label Delay1
Display             ; define a variable to hold the diplay
LastStableState     ; keep track of switch state (open-1; closed-0)
Counter				; how many times the same switch state occured in a row
     endc

;---------------------------------------------------------------------
;* initialisation     
Start:
     bsf       STATUS,RP0          ; select Register Bank 1
     movlw     0xFF
     movwf     TRISA               ; Make PortA all input

     clrf      TRISD               ; Make PortD all output

     movlw     0x01     
     movwf     TRISB               ; Make RBO pin input (switch)

     bsf       STATUS,RP1          ; select Register Bank 3
     movlw     0x1F                
     movwf     ANSEL               ; PortA pins are all analog, PortE pins are digital
     movlw     0x00
     movwf     ANSELH              ; PortB pins are digitial (important as RB0 is switch)
     
     bcf       STATUS,RP0          ; address Register Bank 0
     bcf       STATUS,RP1

; button released - RB0 reads 1
; button pressed  - RB0 reads 0
     
     clrf      Display
     movlw     1		   ; same as addlw 1
     movwf     LastStableState     ; Assume the Switch is up.
     
     clrf      Counter
	 clrf	   PORTD

;---------------------------------------------------------------------
;* superloop - do forever 
MainLoop:

     btfsc     LastStableState,0	   ; if release (reads 1), not skip, goto LookingForUp
     goto      LookingForUp		   ; two different pieces of code for two switch states

LookingForDown:
     ; clrw - clear W
     clrw                          ; assume it's not, so clear
     btfss     PORTB,RB0             ; wait for switch to go up
     incf      Counter,w           ; if it's low, bump the counter
     movwf     Counter             ; store either the 0 or incremented value
     goto      EndDebounce
     
LookingForUp:
     clrw                          ; assume it's not, so clear
     btfsc     PORTB,RB0             ; wait for switch to go low(pressed)
     incf      Counter,w
     movwf     Counter

EndDebounce:
     movf      Counter,w           ; have we seen 5 in a row?
     ; xorlw - Exclusive OR literal with W
     ; xor - same, 0, diff, 1
     xorlw     5
     btfss     STATUS,Z     
     goto      Delay1mS
     
     ; comf - Complement f
     comf      LastStableState,f   ; after 5 straight, reverse the direction
     clrf      Counter		   ; reset counter
     btfsc     LastStableState,0   ; Was it a key-down press?
     goto      Delay1mS            ; no: take no action
     
     incf      Display,f           ; if it's the down direction, 
     movf      Display,w           ; take action on the switch
     movwf     PORTD               ; (increment counter and put on display)
     
Delay1mS:
     movlw     .71                 ; delay ~1000uS
     movwf     Delay
     decfsz    Delay,f             ; this loop does 215 cycles
     goto      $-1          
     decfsz    Delay,f             ; This loop does 786 cycles
     goto      $-1

     goto      MainLoop
;* end of the superloop 
;---------------------------------------------------------------------

     end

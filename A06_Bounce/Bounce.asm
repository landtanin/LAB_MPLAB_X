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
;Delay               ; Assign an address to label Delay1
;Display             ; define a variable to hold the diplay
LastState			; what was the state before this pressing
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
     movwf     ANSEL               ; PortA pins are all analog(0-4), PortE pins are digital(5-7)
     movlw     0x00
     movwf     ANSELH              ; PortB pins are digitial (important as RB0 is switch)
     
     bcf       STATUS,RP0          ; address Register Bank 0
     bcf       STATUS,RP1
 
;    initialise the internal variables
	 clrf	   PORTD
	 bsf       LastState,0			; assume the button released at the start


; button released - RB0 reads 1
; button pressed  - RB0 reads 0
;---------------------------------------------------------------------
;* superloop - do forever 
MainLoop:
    ; btfsc bit test skip if clear
     btfsc     PORTB,RB0			; switch is pressed(reads 0)? If it's release(reads 1), it'll goto Released
	 goto	   Released				; no - it is released
	 
	 ; switch is pressed now (reads 0, skip goto Realeased) 
	 bcf	   LastState,0			; set 0 (pressed) to the LastState, assign state from RB0 to "LastState"
	 goto	   MainLoop
	 
Released
	 btfsc	   LastState,0			; what was the state before the release?	
	 goto	   MainLoop				; released - nothing changed - continue the superloop
	 
; was pressed before - increment the display
; 2 ways to do this
; 1 - smart way, incf - increment file register
	 incf	   PORTD				
; 2 - simple way
;	 addlw	    1
;	 movwf	    PORTD
; ----choose 1 from 2---------
	 
	 bsf	   LastState,0			; set 1 (released) to the LastState, assign state from RB0 to "LastState"

	 goto      MainLoop
;* end of the superloop 
;---------------------------------------------------------------------

     end

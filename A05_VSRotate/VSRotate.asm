; *******************************************************************
; PICkit 2 Lesson 5 - Chasing LEDs
;
; This shows how to read the A2D converter and use the
; results to change the rotation rate the LEDs.
; The pot on the 44-pin Demo Board varies the voltage 
; coming in on in A0.
;
; The A2D is referenced to the same Vdd as the device, which 
; is provided by the USB cable and nominally is 5V.  The A2D
; returns the ratio of the voltage on Pin RA0 to 5V.  The A2D
; has a resolution of 10 bits, with 1023 representing 5V and
; 0 representing 0V.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock     0x20
Delay1           ; Assign an address to label Delay1
Delay2
Display          ; define a variable to hold the diplay
     endc

;-------------------------------------------------------------------
;* initialisation
Start:
     bsf       STATUS,RP0     ; select Register Bank 1
     movlw     0xFF
     movwf     TRISA          ; Make PortA all input
     clrf      TRISD          ; Make PortD all output

;	init the ADC
     movlw     0x00           ; Left Justified, Vdd-Vss referenced
     movwf     ADCON1
     
     bsf       STATUS,RP1     ; select Register Bank 3
     movlw     0xFF           ; we want all Port A pins Analoga
     movwf     ANSEL
     
     bcf       STATUS,RP0     ; back to Register Bank 0
     bcf       STATUS,RP1
     
     movlw     0x41
     movwf     ADCON0         ; configure A2D for Fosc/8, Channel 0 (RA0), and turn on the A2D module

;    start from LED7
     movlw     0x80
     movwf     Display


;-------------------------------------------------------------------
;* superloop - do forever
MainLoop:

     movf      Display,w           ; Copy the display to the LEDs
     movwf     PORTD
     
     nop                           ; wait 5uS for A2D amp to settle and capacitor to charge.
     nop                           ; wait 1uS
     nop                           ; wait 1uS
     nop                           ; wait 1uS
     nop                           ; wait 1uS
     bsf       ADCON0,GO_DONE      ; start conversion
     btfss     ADCON0,GO_DONE      ; this bit will change to zero when the conversion is complete
     goto      $-1
     
     ; Copy the display to the LEDs
     movf      ADRESH,w            
;     addlw     1		   ; add literal and W 
     movwf     Delay2		   ; *** this is how the potentiometer take control of the delay 

; delay before rotate
A2DDelayLoop:
     decfsz    Delay1,f            ; Waste time.  
     goto      A2DDelayLoop        ; This is the case of highest voltage value, The Inner loop takes 3 instructions per loop * 256 loops = 768 instructions
     decfsz    Delay2,f            ; The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      A2DDelayLoop        ; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec or 197 ms
                                   ; call it two-tenths of a second.
				   
     ; Delay another 10mS plus whatever was above				   
     movlw     .13                 
     movwf     Delay2
TenmSdelay:     
     decfsz    Delay1,f
     goto      TenmSdelay	   ; The Inner loop takes 3 instructions per loop * 256 loops = 768 instructions
     decfsz    Delay2,f		   ; The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      TenmSdelay	   ; (768+3) * 13 = 10023 instructions / 1M instructions per second = 0.01 sec or 10 ms
     
Rotate:
     bcf       STATUS, C           ; Ensure we don't rotate a 1 from the carry into bit 7.
     rrf       Display,f
     btfsc     STATUS,C            ; Did the bit rotate into the carry?
     bsf       Display,7           ; yes, put it into bit 7.

     goto      MainLoop
;* end of the superloop
;-------------------------------------------------------------------
     
     end
     

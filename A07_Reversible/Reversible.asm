; *******************************************************************
; PICkit 2 Lesson 7 - Reversible LEDs
;
; This shows how to read the A2D converter and rotate
; a bit on the 8 bit LED display.
; The pot on the 44-pin Demo board varies the voltage 
; coming in on in pin RA0.
;
; The switch is used to reverse the direction of rotation
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
Delay1         ; Assign an address to label Delay1
Delay2
Display        ; define a variable to hold the diplay
Direction	   ; direction of movement
LookingFor
     endc

;-------------------------------------------------------------
;* initialisation
Start:
     bsf       STATUS,RP0     ; select Register Bank 1

     movlw     0xFF
     movwf     TRISA          ; Make PortA all input

     movlw     0x01
     movwf     TRISB          ; Make RB0 input, only set the RB0 bit

     clrf      TRISD          ; Make PortD all output

;	init the ADC
     movlw     0x00           ; Left Justified, Vdd-Vss referenced
     movwf     ADCON1
     
     bsf       STATUS,RP1     ; select Register Bank 3
     movlw     0xFF           ; we want all Port A pins Analog
     movwf     ANSEL
     
     movlw     0x00
     movwf     ANSELH         ; PortB pins are digitial (important as RB0 is switch)
     
     bcf       STATUS,RP0     ; back to Register Bank 0
     bcf       STATUS,RP1
     
     movlw     0x41
     movwf     ADCON0         ; configure A2D for Fosc/8, Channel 0 (RA0), and turn on the A2D module
 
;	init display
     movlw     0x80
     movwf     Display

;	init variables
     clrf      Direction
     clrf      LookingFor     ; Looking for a 0 on the button

;-------------------------------------------------------------
;* superloop - do forever
MainLoop:

     movf      Display,w      ; Copy the display to the LEDs
     movwf     PORTD

     nop                      ; wait 5uS for A2D amp to settle and capacitor to charge.
     nop                      ; wait 1uS
     nop                      ; wait 1uS
     nop                      ; wait 1uS
     nop                      ; wait 1uS

     bsf       ADCON0,GO_DONE ; start conversion
     btfss     ADCON0,GO_DONE ; this bit will change to zero when the conversion is complete ????? shouldn't it be btfsc??? exit the loop when it is zero
     goto      $-1

     movf      ADRESH,w       
     movwf     Delay2	      ; *** this is how the potentiometer take control of the delay 

A2DDelayLoop:
     incfsz    Delay1,f       ; Waste time.  
     goto      A2DDelayLoop   ; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
     incfsz    Delay2,f       ; Depend on potentiometer input values. For the maximum case : The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      A2DDelayLoop   ; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
                              ; call it a two-tenths of a second.

     movlw     .13            ; Delay another 10mS plus whatever was above
     movwf     Delay2
TenmSdelay:
     decfsz    Delay1,f
     goto      TenmSdelay
     decfsz    Delay2,f
     goto      TenmSdelay
; end TenmS

; start rotate process
     btfsc     LookingFor,0
     goto      LookingFor1

LookingFor0:
     btfsc     PORTB,0        ; is the switch pressed 
     goto      Rotate
     bsf       LookingFor,0   ; yes  Next we'll be looking for a 1
     movlw     0xFF           ; load the W register incase we need it
     xorwf     Direction,f    ; yes, flip the direction bit
     goto      Rotate

LookingFor1:
     btfsc     PORTB,0        ; is the switch pressed
     bcf       LookingFor,0
     
; it normally rotate right (->01234567->)
Rotate:
     bcf       STATUS,C       ; ensure the carry bit is clear
     btfss     Direction,0
     goto      RotateLeft

RotateRight:
     rrf       Display,f
     btfsc     STATUS,C       ; Did the bit rotate into the carry?
     bsf       Display,7      ; yes, put it into bit 7.
     goto      MainLoop

RotateLeft:
     rlf       Display,f
     btfsc     STATUS,C       ; did it rotate out of the display
     bsf       Display,0      ; yes, put it into bit 0
     goto      MainLoop

;* end of the superloop 
;-------------------------------------------------------------
    
     end
     

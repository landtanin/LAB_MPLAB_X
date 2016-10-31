; *******************************************************************
; PICkit 2 Lesson 4 - "A2D"
;
; This shows how to read the A2D converter and display the
; High order parts on the 4 bit LED display.
; The pot on the Low Pin Count Demo board varies the voltage 
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

;------------------------------------------------------------
;* initialisation         
Start:
     bsf       STATUS,RP0     ; select Register Bank 1

;	 direction for PORTA - 1 - inputs
     movlw     0xFF
     movwf     TRISA          ; Make PortA all input

;	 direction for PORTD - 0 - outpiuts
     clrf      TRISD          ; Make PortD all output

; 	 initialising the ADC 
;		init ADCON1
     movlw     0x00           ; Left Justified, Vdd-Vss referenced
     movwf     ADCON1
;		init ANSEL
     bsf       STATUS,RP1     ; select Register Bank 3
     movlw     0xFF           ; we want all Port A pins Analog
     movwf     ANSEL
;		init ADCON0
     bcf       STATUS,RP0     ; back to Register Bank 0
     bcf       STATUS,RP1
     movlw     0x41			  ; configure A2D for Fosc/8, Channel 0 (RA0), and turn on the A2D module
     movwf     ADCON0         


;------------------------------------------------------------
;* superloop - do forever
MainLoop:

     nop                      ; wait 5uS for A2D amp to settle and capacitor to charge.
     nop                      ; wait 1uS
     nop                      ; wait 1uS
     nop                      ; wait 1uS 
     nop                      ; wait 1uS
     bsf       ADCON0,GO_DONE ; start conversion
;	 until conversion is complete
     btfss     ADCON0,GO_DONE ; this bit will change to zero when the conversion is complete
     goto      $-1

     movf      ADRESH,w       ; Copy the display to the LEDs

     movwf     PORTD

     goto      MainLoop
;* end of the superloop
;------------------------------------------------------------

     end
     

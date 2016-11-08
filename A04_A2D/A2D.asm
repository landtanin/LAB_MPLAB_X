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

;	 direction for PORTD - 0 - outputs
; -----------there're 2 ways to do this-----------
; 1. a hard way
;     movlw     0x00
;     movwf     TRISD          ; Make PortA all input
; 2. a faster way, clear the whole register
     clrf      TRISD          ; Make PortD all output
; -----------choose 1 from 2-----------------------------
     
; 	 initialising the ADC 
;		init ADCON1
     movlw     0x00           ; Left Justified, Vdd-Vss referenced
     movwf     ADCON1	      ; Setting the result to Left Justified (bit 7, ADFM = 0) means the 8 Most Significant bits 
			      ; and read from ADRESH and the 2 Least Significant bits 
			      ; are read from bits 7 and 6 of ADRESL.
			      
			      ; bit<4:5>, VCFG0:VCFG1, to 0 means we choose Vdd-Vss
			      ; if it's 1 means we chhose Vref+ - Vref-
     
; -----------------end Bank1--------------------

			      
; -----------------start Bank3--------------------
;		init ANSEL
     
     bsf       STATUS,RP1     ; select Register Bank 3
     movlw     0xFF           ; we want all Port A pins Analog
     movwf     ANSEL	      ; The ANSEL register (Register 3-3) is used to configure the Input mode of an I/O pin to analog. 
			      ; Setting the appropriate ANSEL bit high will cause all digital reads on the pin to be read as ?0? 
			      ; and allow analog functions on the pin to operate correctly.
			      
; -----------------end Bank3--------------------
			     
; -----------------start Bank0--------------------

     bcf       STATUS,RP0     ; back to Register Bank 0
     bcf       STATUS,RP1
     
;   init ADCON0
     movlw     0x41			  ; configure A2D for Fosc/8 (bit7=0, bit6=1), 
					  ; Channel 0 (RA0) (bit<5:2> = 0000) , 
					  ; and turn on the A2D module (bit 0 = 0)
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
     btfss     ADCON0,GO_DONE ; this bit will change to zero when the conversion is complete - IF STATEMENT!!!
			      ; BTFSS = Bit Test f, Skip if Set
     goto      $-1	      ; ?????

     ; Copy the display to the LEDs
     movf      ADRESH,w       
     movwf     PORTD

     goto      MainLoop
;* end of the superloop
;------------------------------------------------------------

     end
     

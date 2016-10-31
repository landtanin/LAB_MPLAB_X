; *******************************************************************

; PICkit 2 Lesson 12 - Table lookup
;
; This shows using a table lookup function to implement a 
; binary to gray code conversion.  The Pot is read by the A2D, 
; then the high order 4 bits are converted to Gray Code and
; displayed on LEDs 0 to 3.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock 0x20
temp
     endc

;------------------------------------------------------------------
;* initialisation
Start:
     bsf       STATUS,RP0     ; select Register Bank 1

     movlw     0xFF
     movwf     TRISA          ; Make PortA all input

     clrf      TRISD          ; Make PortD all output

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

;------------------------------------------------------------------
;* superloop - do forever
MainLoop:

     bsf       ADCON0,GO_DONE      ; start A2D conversion
     btfss     ADCON0,GO_DONE      ; wait until the conversion is complete
     goto      $-1

     swapf     ADRESH,w            ; read the A2D, move the high nybble to the low part
     call      BinaryToGrayCode    ; Convert to Gray Code
     movwf     PORTD               ; into the low order nybble on Port D

     goto      MainLoop
;* end of the superloop    
;------------------------------------------------------------------
 
     
; Convert 4 bit binary to 4 bit Gray code
; 
     org     0xf7                  ; force table to cross a 256 instruction boundary
BinaryToGrayCode:
     andlw     0x0F                ; mask off invalid entries
     movwf     temp
     movlw     high TableStart     ; get high order part of the beginning of the table
     movwf     PCLATH
     movlw     low TableStart      ; load starting address of table
     addwf     temp,w              ; add offset
     btfsc     STATUS,C            ; did it overflow?
     incf      PCLATH,f            ; yes: increment PCLATH
     movwf     PCL                 ; modify PCL

TableStart:
     retlw     b'0000'             ; 0
     retlw     b'0001'             ; 1
     retlw     b'0011'             ; 2
     retlw     b'0010'             ; 3
     retlw     b'0110'             ; 4
     retlw     b'0111'             ; 5
     retlw     b'0101'             ; 6
     retlw     b'0100'             ; 7
     retlw     b'1100'             ; 8
     retlw     b'1101'             ; 9
     retlw     b'1111'             ; 10
     retlw     b'1110'             ; 11
     retlw     b'1010'             ; 12
     retlw     b'1011'             ; 13
     retlw     b'1001'             ; 14
     retlw     b'1000'             ; 15

     end

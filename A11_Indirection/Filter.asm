; *******************************************************************

; PICkit 2 Lesson 11 - Indirection Register
;
; This shows using the FSR to implement a Moving Average Filter.
; The pot value is read via the A2D converter, then the result is
; averaged with the last 7 readings.  The High order bits are shown
; on the 8 bit LED display. 
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock 0x20
Display          ; define a variable to hold the diplay
Queue:8          ; 8 bytes to hold last 8 entries
Delay:2          ; counter to limit delay
RunningSum:2     ; sum of last 8 entries
Round:2          ; divide by 8 and round.
temp
     endc

;---------------------------------------------------------------
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
     call      FilterInit     ; initialize the moving average filter

;---------------------------------------------------------------
;* superloop - do forever  
MainLoop:

     call      Delay200mS
     bsf       ADCON0,GO_DONE ; start A2D conversion
     btfss     ADCON0,GO_DONE ; this bit will change to zero when the conversion is complete
     goto      $-1

     movf      ADRESH,w       ; read the A2D
     call      Filter         ; send it to the filter
     movwf     Display        ; save the filtered value
     movwf     PORTD          ; display

     goto      MainLoop
;* end of the superloop
;---------------------------------------------------------------


; This code example shows a more efficient way to maintaint the average
; than that discussed in the lesson.  Instead of re-summing all 8 queue
; values each time a new value is ready, it keeps a running sum.
; Before inserting a new value into the queue, the oldest is subtracted
; from the running sum.  Then the new value is inserted into the array
; and added to the running sum.
; Assumes the FSR is not corrupted elsewhere in the program.  If the FSR
; may be used elsewhere, this module should maintain a copy for it's
; own use and reload the FSR before use.
FilterInit:
     movlw     Queue
     movwf     FSR
     clrf      RunningSum
     clrf      RunningSum+1
     clrf      Queue
     clrf      Queue+1
     clrf      Queue+2
     clrf      Queue+3
     clrf      Queue+4
     clrf      Queue+5
     clrf      Queue+6
     clrf      Queue+7
     return
     
Filter:
     movwf     temp           ; save 
     
     movf      INDF,w         ; subtract the current out of the sum
     subwf     RunningSum,f
     btfss     STATUS,C       ; was there a borrow?
     decf      RunningSum+1,f ; yes, take it from the high order byte
     
     movf      temp,w
     movwf     INDF           ; store in table
     addwf     RunningSum,f   ; Add into the sum
     btfsc     STATUS,C
     incf      RunningSum+1,f
     
     incf      FSR,f
     movf      FSR,w
     xorlw     Queue+8        ; did it overflow?
     movlw     Queue          ; preload Queue base address (Does not affect the flags)
     btfsc     STATUS,Z
     movwf     FSR            ; yes: reset the pointer

;MAStraightline  ; 53 instructions, 55 cycles including call and & return
     bcf       STATUS,C       ; clear the carry
     rrf       RunningSum+1,w
     movwf     Round+1
     rrf       RunningSum,w   ; divide by 2 and copy to a version we can corrupt
     movwf     Round
     
     bcf       STATUS,C       ; clear the carry
     rrf       Round+1,f
     rrf       Round,f        ; divide by 4

     bcf       STATUS,C       ; clear the carry
     rrf       Round+1,f
     rrf       Round,f        ; divide by 8
     
     btfsc     STATUS,C       ; use the carry bit to round
     incf      Round,f          
     movf      Round,w        ; load Wreg with the answer
     return     
     
; It's actually 197380uS including the Call and return.
Delay200mS:
     decfsz    Delay,f        ; delay 
     goto      $-1
     decfsz    Delay+1,f      ; delay 768uS
     goto      $-3
     return
          
     end

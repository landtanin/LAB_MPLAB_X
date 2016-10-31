; *******************************************************************
; PICkit 2 Lesson 10 - Interrupts
;
; This shows how to configure and use the Timer 0 interrupt to 
; trigger reading the A2D every time Timer 0 overflows.
;
; *******************************************************************
; *    See 44-pin Demo Board User's Guide for Lesson Information    *
; *******************************************************************

#include "prologue.inc"

     cblock     0x20
Delay1               ; Assign an address to label Delay1
Delay2     
Display              ; define a variable to hold the diplay
Direction 
LookingFor
T0Semaphore
     endc
     
; Flag Definitions
     cblock 0x70     ; put these up in unbanked RAM
W_Save
STATUS_Save
     endc
     
     goto      Start

     org 4
ISR:   
     movwf     W_Save              ; Save context
     movf      STATUS,w
     movwf     STATUS_Save
     
;     btfsc     PIR1,T1IF           ; Uncomment to check Timer 1 (routine needed)
;     goto      ServiceTimer1
     btfsc     INTCON,T0IF
     goto      ServiceTimer0
;     btfsc     PIC1,ADIF           ; Uncomment to check the ADC (routine needed)
;     goto      ServiceADC
     goto      ExitISR          
     
ServiceTimer0:
     bcf       STATUS,RP0          ; Ensure ISR executes in Register Bank 0
     bcf       STATUS,RP1
     bcf       INTCON,T0IF         ; clear the interrupt flag. (must be done in software)
     bsf       T0Semaphore,0       ; signal the main routine that the Timer has expired
     bsf       ADCON0,GO_DONE      ; start conversion
     btfss     ADCON0,GO_DONE      ; this bit will change to zero when the conversion is complete
     goto      $-1
     comf      ADRESH,w            ; Form the 1's complement of ADresult
     movwf     TMR0                ; Also clears the prescaler
     goto      ExitISR
               
ExitISR:
     movf      STATUS_Save,w       ; Restore context
     movwf     STATUS
     swapf     W_Save,f            ; swapf doesn't affect Status bits, but MOVF would
     swapf     W_Save,w
     retfie
     
     
Start:
     bsf       STATUS,RP0          ; select Register Bank 1
     movlw     0xFF
     movwf     TRISA               ; Make PortA all input
     movlw     0x01
     movwf     TRISB               ; Make RB0 pin input (switch)
     clrf      TRISD               ; Make PortD all output

     movlw     0x00                ; Left Justified, Vdd-Vss referenced
     movwf     ADCON1

     movlw     B'10000111'         ; configure Prescaler on Timer0, max prescale (/256)
     movwf     OPTION_REG          ; configure

     bsf       STATUS,RP1          ; select Register Bank 3
     movlw     0xFF                ; we want all Port A pins Analog
     movwf     ANSEL
     movlw     0x00
     movwf     ANSELH              ; PortB pins are digitial (important as RB0 is switch)
     bcf       STATUS,RP0          ; back to Register Bank 0
     bcf       STATUS,RP1
     
     movlw     0x41
     movwf     ADCON0         ; configure A2D for Fosc/8, Channel 0 (RA0), and turn on the A2D module
     movlw     0x08
     movwf     Display
     clrf      Direction
     clrf      LookingFor          ; Looking for a 0 on the button
     
     
     movlw     B'10100000'         ; enable Timer 0 and global interrupts
     movwf     INTCON
MainLoop:
     btfss     T0Semaphore,0       ; did the Timer0 overflow?
     goto      CheckButton         ; no - go monitor the button
     bcf       T0Semaphore,0       ; clear the flag     
     movf      Display,w           ; Copy the display to the LEDs
     movwf     PORTD
     
Rotate:
     bcf       STATUS,C            ; ensure the carry bit is clear
     btfss     Direction,0
     goto      RotateLeft
RotateRight:
     rrf       Display,f
     btfsc     STATUS,C            ; Did the bit rotate into the carry?
     bsf       Display,7           ; yes, put it into bit 7.

     goto      CheckButton
RotateLeft:
     rlf       Display,f           ; rotate in place
     btfsc     STATUS,C            ; did it rotate out of the display
     bsf       Display,0           ; yes, put it into bit 0

CheckButton:
     btfsc     LookingFor,0        ; which direction are we looking for
     goto      LookingFor1
LookingFor0:
     btfsc     PORTB,0             ; is the switch pressed (0)
     goto      EndMainLoop
     bsf       LookingFor,0        ; yes  Next we'll be looking for a 1
     movlw     0xFF                ; load the W register incase we need it
     xorwf     Direction,f         ; yes, flip the direction bit
     goto      EndMainLoop

LookingFor1:
     btfsc     PORTB,0             ; is the switch pressed (0)
     bcf       LookingFor,0

EndMainLoop:
     movlw     .13
     call      Delay               ; delay ~10mS (13 * 775uS)
     goto      MainLoop

; Delay Subroutine.  Enter delays Wreg * 771uS + 5 uS including call and return
Delay:
     movwf     Delay2              ;
DelayLoop:
     decfsz    Delay1,f            ; Waste time.  
     goto      DelayLoop           ; The Inner loop takes 3 instructions per loop * 256 loopss = 768 instructions
     decfsz    Delay2,f            ; The outer loop takes and additional 3 instructions per lap * 256 loops
     goto      DelayLoop           ; (768+3) * 256 = 197376 instructions / 1M instructions per second = 0.197 sec.
                                   ; call it two-tenths of a second.
     return
     
     end
     

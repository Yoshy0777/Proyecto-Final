 ;===========================================
; Semáforo 4 vías
; Josias Arturo Puga C.
;===========================================
PROCESSOR   16F887
        #include    <xc.inc>
        CONFIG  FOSC   = INTRC_NOCLKOUT
        CONFIG  WDTE   = OFF
        CONFIG  PWRTE  = ON
        CONFIG  MCLRE  = ON
        CONFIG  CP     = OFF
        CONFIG  CPD    = OFF
        CONFIG  BOREN  = ON
        CONFIG  BOR4V  = BOR40V
        CONFIG  FCMEN  = OFF
        CONFIG  IESO   = OFF
        CONFIG  LVP    = OFF
        CONFIG  WRT    = OFF
        CONFIG  DEBUG  = OFF
        PSECT   resetVec, class=CODE, delta=2
        ORG     0x0000
        GOTO    INIT

        PSECT   intVec, class=CODE, delta=2
        ORG     0x0004
        RETFIE

        PSECT   udata_bank0
R0:     DS 1
R1:     DS 1
R2:     DS 1
R3:     DS 1

        PSECT   code, class=CODE, delta=2

INIT:
        BANKSEL OSCCON
        MOVLW   0b01110000
        MOVWF   OSCCON

        BANKSEL ANSEL
        CLRF    ANSEL
        CLRF    ANSELH

        BANKSEL TRISB
        CLRF    TRISB
        BANKSEL PORTB
        CLRF    PORTB

        BANKSEL TRISC
        CLRF    TRISC
        BANKSEL PORTC
        CLRF    PORTC

loop:
        
        BCF PORTB,2
        BCF PORTB,5
        BSF PORTC,0
        BSF PORTC,3

        BSF PORTB,0
        BSF PORTB,3
        CALL delay_4s

        MOVLW 3
        MOVWF R2
blink_ns:
        BCF PORTB,0
        BCF PORTB,3
        CALL delay_500ms
        BSF PORTB,0
        BSF PORTB,3
        CALL delay_500ms
        DECFSZ R2,F
        GOTO blink_ns

        BCF PORTB,0
        BCF PORTB,3
        BSF PORTB,1
        BSF PORTB,4
        CALL delay_3s
        BCF PORTB,1
        BCF PORTB,4

        BSF PORTB,2
        BSF PORTB,5
        BCF PORTC,0
        BCF PORTC,3
        BSF PORTB,6
        BSF PORTC,1
        CALL delay_4s

        MOVLW 3
        MOVWF R2
blink_eo:
        BCF PORTB,6
        BCF PORTC,1
        CALL delay_500ms
        BSF PORTB,6
        BSF PORTC,1
        CALL delay_500ms
        DECFSZ R2,F
        GOTO blink_eo

        BCF PORTB,6
        BCF PORTC,1
        BSF PORTB,7
        BSF PORTC,2
        CALL delay_3s
        BCF PORTB,7
        BCF PORTC,2

        BSF PORTC,0
        BSF PORTC,3
        BCF PORTB,2
        BCF PORTB,5
        BSF PORTB,0
        BSF PORTB,3
        CALL delay_4s

        MOVLW 3
        MOVWF R2
blink_ns2:
        BCF PORTB,0
        BCF PORTB,3
        CALL delay_500ms
        BSF PORTB,0
        BSF PORTB,3
        CALL delay_500ms
        DECFSZ R2,F
        GOTO blink_ns2

        BCF PORTB,0
        BCF PORTB,3
        BSF PORTB,1
        BSF PORTB,4
        CALL delay_3s
        BCF PORTB,1
        BCF PORTB,4

        GOTO loop

delay_500ms:
        MOVLW 2
        MOVWF R3
d500_outer:
        MOVLW 250
        MOVWF R0
d500_mid:
        MOVLW 250
        MOVWF R1
d500_inner:
        DECFSZ R1,F
        GOTO d500_inner
        DECFSZ R0,F
        GOTO d500_mid
        DECFSZ R3,F
        GOTO d500_outer
        RETURN

delay_4s:
        MOVLW 8
        MOVWF R2
d4_loop:
        CALL delay_500ms
        DECFSZ R2,F
        GOTO d4_loop
        RETURN

delay_3s:
        MOVLW 6
        MOVWF R2
d3_loop:
        CALL delay_500ms
        DECFSZ R2,F
        GOTO d3_loop
        RETURN

END

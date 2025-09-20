 ;===========================================
; Semáforo 4 vías
; Josias Arturo Puga C.
;===========================================

    PROCESSOR 16F887
    #include <xc.inc>

;Configuracion de bits
    CONFIG FOSC = INTRC_NOCLKOUT
    CONFIG WDTE = OFF
    CONFIG PWRTE = ON
    CONFIG MCLRE = ON
    CONFIG CP = OFF
    CONFIG CPD = OFF
    CONFIG BOREN = ON
    CONFIG IESO = OFF
    CONFIG FCMEN = OFF
    CONFIG LVP = OFF
    CONFIG DEBUG = OFF

;Variables
    PSECT udata_bank0
COUNT1: DS 1
COUNT2: DS 1
COUNT3: DS 1

;Reset Vector
    PSECT resetVec, class=CODE, delta=2
    ORG 0x00
    GOTO MAIN

;Retardos
    PSECT code

DELAY1S:                ; Retardo 1 segundo a 4MHz
    MOVLW 250
    MOVWF COUNT1
D1: MOVLW 250
    MOVWF COUNT2
D2: MOVLW 250
    MOVWF COUNT3
D3: DECFSZ COUNT3, f
    GOTO D3
    DECFSZ COUNT2, f
    GOTO D2
    DECFSZ COUNT1, f
    GOTO D1
    RETURN

DELAY10S:               ; Retardo de 10 segundos
    MOVLW 10
    MOVWF COUNT1
DL10: CALL DELAY1S
    DECFSZ COUNT1, f
    GOTO DL10
    RETURN

DELAY3S:                ; Retardo de 3 segundos
    MOVLW 3
    MOVWF COUNT1
DL3: CALL DELAY1S
    DECFSZ COUNT1, f
    GOTO DL3
    RETURN

;--------------------------
; PROGRAMA PRINCIPAL
;--------------------------
MAIN:
    ; Configuración de puertos como salida
    banksel TRISB
    CLRF TRISB

    banksel TRISC
    CLRF TRISC

    ; Apagar LEDs al inicio
    banksel PORTB
    CLRF PORTB

    banksel PORTC
    CLRF PORTC

CICLO:
    ; Paso 1: Norte-Sur Verde, Este-Oeste Rojo
    banksel PORTB
    BSF PORTB,2      ; Verde Norte
    BSF PORTB,5      ; Verde Sur
    banksel PORTC
    BSF PORTC,0      ; Rojo Este
    BSF PORTC,3      ; Rojo Oeste
    CALL DELAY10S
    banksel PORTB
    CLRF PORTB
    banksel PORTC
    CLRF PORTC

    ; Paso 2: Norte-Sur Amarillo parpadeante (3s)
    MOVLW 3
    MOVWF COUNT1
P2:
    banksel PORTB
    BSF PORTB,1      ; Amarillo Norte
    BSF PORTB,4      ; Amarillo Sur
    CALL DELAY1S
    CLRF PORTB
    CLRF PORTC
    CALL DELAY1S
    DECFSZ COUNT1,f
    GOTO P2

    ; Paso 3: Este-Oeste Verde
    banksel PORTC
    BSF PORTC,2      ; Verde Este
    BSF PORTC,5      ; Verde Oeste
    banksel PORTB
    BSF PORTB,0      ; Rojo Norte
    BSF PORTB,3      ; Rojo Sur
    CALL DELAY10S
    banksel PORTB
    CLRF PORTB
    banksel PORTC
    CLRF PORTC

    ; Paso 4: Este-Oeste Amarillo parpadeante (3s)
    MOVLW 3
    MOVWF COUNT1
P4:
    banksel PORTC
    BSF PORTC,1      ; Amarillo Este
    BSF PORTC,4      ; Amarillo Oeste
    CALL DELAY1S
    CLRF PORTB
    CLRF PORTC
    CALL DELAY1S
    DECFSZ COUNT1,f
    GOTO P4

    GOTO CICLO

    END



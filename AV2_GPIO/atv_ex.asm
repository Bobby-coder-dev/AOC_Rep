;---------------------------------------
; DEFINIÇÕES
;---------------------------------------
.equ BOTAO1 = PD2 ; Botão 1 → tempo rápido
.equ BOTAO2 = PD3 ; Botão 2 → tempo lento

.equ LED = PB0

.def AUX = R16
.def TEMPO = R17


;---------------------------------------
; SETUP
;---------------------------------------
setup:
    SBI DDRB, LED

    CBI DDRD, BOTAO1
    CBI DDRD, BOTAO2

    SBI PORTD, BOTAO1
    SBI PORTD, BOTAO2

    LDI TEMPO, 0x20 ; tempo padrão


;---------------------------------------
; LOOP
;---------------------------------------
loop:
     ; Pisca LED com tempo atual
     SBI PORTB, LED
     RCALL delay

    CBI PORTB, LED
    RCALL delay


    ;--------------------------
    ; TESTA BOTÃO1
    ;--------------------------
    SBIS PIND, BOTAO1
    RJMP set_rapido

    ;--------------------------
    ; TESTA BOTÃO2
    ;--------------------------
    SBIS PIND, BOTAO2
    RJMP set_lento

    RJMP loop


;---------------------------------------
; DEFINIÇÃO DOS TEMPOS
;---------------------------------------
set_rapido:
    LDI TEMPO, 0x10
    RJMP loop

set_lento:
    LDI TEMPO, 0x40
    RJMP loop


;---------------------------------------
; DELAY CONTROLADO
;---------------------------------------
delay:
    MOV AUX, TEMPO
delay_loop:
    NOP
    DEC AUX
    BRNE delay_loop
    RET
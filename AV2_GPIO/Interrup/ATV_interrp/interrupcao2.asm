;DEFINIÇÕES
.equ ON  = PD2
.equ OFF = PD3
.equ L0  = PB0
.equ L1  = PB1

.ORG 0x000
    RJMP setup

.ORG 0x002
    RJMP isr_int0  

.ORG 0x004
    RJMP isr_int1

.ORG 0x0034
setup:
    ;Configurar pinos leds como saida
    SBI DDRB, L0
    SBI DDRB, L1

    ;Configurar pinos botoes como entrada e ativar pullup
    CBI DDRD, ON
    CBI DDRD, OFF
    SBI PORTD, ON
    SBI PORTD, OFF

    ;configura int0 e int1
    LDI R16, 0b0000_1010
    STS EICRA, R16
    
    ;habilita int0 e int1
    SBI EIMSK, INT0
    SBI EIMSK, INT1

    ;habilitar a interrupcao global
    SEI
main:
    sbi  PORTB,L0    ; desliga L0
    ldi r19, 80 
    rcall delay      ; delay 1s
    cbi  PORTB,L0    ; liga L0
    ldi r19, 80 
    rcall delay      ; delay 1s
    rjmp main


;====================================
; Rotina que atende o botão ON
;====================================
isr_int0:
    CBI PORTB, L1
    reti
;====================================
; Rotina que atende o botão OFF
;====================================
isr_int1:
    SBI PORTB, L2
    reti
    
;------------------------------------------------------------
;SUB-ROTINA DE ATRASO Programável
;Depende do valor de R19 carregado antes da chamada.
;Exemplos: 
; - R19 = 16 --> 200ms 
; - R19 = 80 --> 1s 
;------------------------------------------------------------
delay:           
  push r17	     ; Salva os valores de r17,
  push r18	     ; ... r18,
  in r17,SREG    ; ...
  push r17       ; ... e SREG na pilha.

  ; Executa sub-rotina :
  clr r17
  clr r18
loop:            
  dec  R17       ;decrementa R17, começa com 0x00
  brne loop      ;enquanto R17 > 0 fica decrementando R17
  dec  R18       ;decrementa R18, começa com 0x00
  brne loop      ;enquanto R18 > 0 volta decrementar R18
  dec  R19       ;decrementa R19
  brne loop      ;enquanto R19 > 0 vai para volta

  pop r17         
  out SREG, r17  ; Restaura os valores de SREG,
  pop r18        ; ... r18
  pop r17        ; ... r17 da pilha

  ret    
.equ AJUSTE = PD2
.equ LED = PB5
.DSEG
.ORG SRAM_START
    INTERVALO: .BYTE 1
    CONTAGEM:  .BYTE 1 
.CSEG
.ORG 0x0000 ;endereço 0
    rjmp setup

.ORG 0x0002 ;endereço para int0 (botao)
    rjmp isr_int0

.ORG 0x0020 ;endereço para tc0b
    RJMP isr_tc0b 
.ORG 0X0034

setup:
    ;definindo pino de saida
    SBI DDRB, LED 
    CBI PORTB, LED
    ;definindo pino de entrada (botao)
    CBI DDRD, AJUSTE
    SBI PORTD, AJUSTE

    ;configurando int0
    LDI R16, 0b0000_0010
    STS EICRA, R16
    SBI EIMSK, INT0
    
    ;configurando tc0b
    LDI R16, 0b00000101
    OUT TCCR0B, R16
    LDI R16, 1
    STS TIMSK0, R16

    ;inicializar intervalo
    LDI R16, 62
    STS intervalo, R16
    
    SEI
    
main:
    rjmp main

isr_tc0b:
    ;SALVA CONTEXTO
    PUSH R16
    PUSH R17
    IN R16, SREG
    PUSH R16

    LDS R16, contagem
    INC R16
    
    LDS R17, intervalo
    
    cp R16, R17
    BRNE fim
    SBI PINB, LED
    
    LDI R16, 0
fim:
    STS contagem, R16
    
    ;RESTAURA CONTEXTO
    POP R16
    OUT SREG, R16
    POP R17
    POP R16
    RETI

isr_int0:
    ;SALVA CONTEXTO
    PUSH R16
    IN R16, SREG
    PUSH R16

    cpi intervalo, 14 ; minimo 200ms [62 (1s)->50(800ms)->38(600ms)->26(400ms)->14(200ms)]
    breq rst_valor
    subi intervalo, 12 ; diminuição de 12 aproximadamente 200ms sendo 62 1seg
    rjmp fim_int0
    rst_valor:
    ldi intervalo, 62
    fim_int0:
    ldi contador, 0

    POP R16
    OUT SREG, R16
    POP R16
    RETI
.equ AJUSTE = PD2
.equ LED = PB5
.def contador = R20
.def intervalo = R21

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
    ;definindo pino de entrada (botao)
    CBI DDRD, AJUSTE
    SBI PORTD, AJUSTE

    ;configurando tc0b
    LDI R16, 0b00000101
    OUT TCCR0B, R16
    LDI R16, 1
    STS TIMSK0, R16

    ;configurando int0
    LDI R16, 0b00000010
    STS EICRA, R16
    SBI EIMSK, INT0

    LDI intervalo, 62 ;definindo valor inicial de intervalo

    SEI
main:
    rjmp main

isr_tc0b:
    PUSH R16
    IN R16, SREG
    PUSH R16

    inc contador
    cp contador, intervalo
    brne fim_tcb
    sbi pinb, LED

    ldi contador, 0
    fim_tcb:
    POP R16
    OUT SREG R16
    POP R16
    RETI

isr_int0:
    PUSH R16
    IN R16, SREG
    PUSH R16

    cpi intervalo, 14 ; minimo 200ms [62 (1s)->50(800ms)->38(600ms)->26(400ms)->14(200ms)]
    brne fim_int0
    subi intervalo, 12
    ldi contador, 0

    fim_int0:
    POP R16
    OUT SREG R16
    POP R16
    RETI

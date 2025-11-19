.equ SEL = PB1
.equ AJU = PB2
start:
    ;Configura botoes como entrada
    CBI DDRB, SEL
    CBI DDRB, AJU
    ; seta pull up
    SBI PORTB, SEL 
    SBI PORTB, AJU 
    
    SER 16; LDI R16, 0xFF
    OUT DDRD, R16
    
loop:
    sbic PINB, SEL
    rjmp on_high
off_high:
    SBI PORTD, 7
    SBI PORTD, 6
    SBI PORTD, 5
    SBI PORTD, 4
    rjmp cont
on_high:    
    CBI PORTD, 7
    CBI PORTD, 6
    CBI PORTD, 5
    CBI PORTD, 4
cont:    
    SBIC PINB, AJU
    rjmp on_low
off_low:
    SBI PORTD, 3
    SBI PORTD, 2
    SBI PORTD, 1
    SBI PORTD, 0
    rjmp fim
on_low:    
    CBI PORTD, 3
    CBI PORTD, 2
    CBI PORTD, 1
    CBI PORTD, 0
fim:
    rjmp loop
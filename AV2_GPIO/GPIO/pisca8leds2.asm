;========================================
; DEFINIÇÕES
;========================================
.equ SEL = PB1       ; SEL = pino PB1 (botão / controle dos bits mais significativos)
.equ AJU = PB0       ; AJU = pino PB0 (botão / controle dos bits menos significativos)


;========================================
; SETUP / INICIALIZAÇÃO
;========================================
setup:
    ; configura SEL e AJU como ENTRADA (clear em DDRB)
    CBI DDRB, SEL       ; DDRB.bit1 = 0 -> PB1 como entrada
    CBI DDRB, AJU       ; DDRB.bit0 = 0 -> PB0 como entrada

    ; ativa pull-up interno nos pinos SEL e AJU
    SBI PORTB, SEL      ; PORTB.bit1 = 1 -> pull-up em PB1
    SBI PORTB, AJU      ; PORTB.bit0 = 1 -> pull-up em PB0

    ; configura todos os pinos de PORTD como saída
    LDI R16, 0xFF       ; carrega R16 com 0xFF (1111 1111)
    OUT DDRD, R16       ; DDRD = 0xFF -> PD0..PD7 como saída


;========================================
; LOOP PRINCIPAL
;========================================
loop:

    ;--- Verifica SEL (bits mais significativos: PD7..PD4) ---
    ; Se PINB.bit(SEL) estiver limpo (0), a instrução sbic pula a próxima instrução.
    ; sbic PINB, SEL -> se PB1 == 0 (botão pressionado com pull-up) -> pula a instrução seguinte.
    sbic PINB, SEL
    rjmp on_high        ; se não foi pulado, pula aqui: significa PB1 != 0 (não pressionado) -> rjmp on_high

    ; Se caiu aqui, significa que sbic pulou o rjmp (PB1 == 0), então executa desliga parte alta:
off_high:
    ; desliga os LEDs da parte alta (PD7..PD4 = 1 -> desligado segundo sua convenção)
    sbi PORTD, 7       ; seta PD7 = 1
    sbi PORTD, 6       ; seta PD6 = 1
    sbi PORTD, 5       ; seta PD5 = 1
    sbi PORTD, 4       ; seta PD4 = 1
    rjmp cont          ; após tratar a parte alta, vai para checar a parte baixa


    ; Se o sbic não pulou o rjmp, ele executa este rjmp on_high:
on_high:
    ; liga os LEDs da parte alta (PD7..PD4 = 0 -> ligado)
    cbi PORTD, 7       ; limpa PD7 = 0
    cbi PORTD, 6       ; limpa PD6 = 0
    cbi PORTD, 5       ; limpa PD5 = 0
    cbi PORTD, 4       ; limpa PD4 = 0


cont: 
    ;--- Agora trata os menos significativos (PD3..PD0) usando AJU ---
    ; Verifica AJU (PB0). sbic pula a próxima instrução se PB0 == 0.
    sbic PINB, AJU
    rjmp on_low        ; se não pulou => PB0 != 0 => rjmp on_low

    ; Se caiu aqui, significa PB0 == 0 (pressionado) -> desliga parte baixa:
off_low:
    ; desliga os LEDs da parte baixa (PD3..PD0 = 1)
    sbi PORTD, 3       ; seta PD3 = 1
    sbi PORTD, 2       ; seta PD2 = 1
    sbi PORTD, 1       ; seta PD1 = 1
    sbi PORTD, 0       ; seta PD0 = 1
    rjmp fim           ; depois de desligar, vai para fim (volta ao loop)


on_low:
    ; liga os LEDs da parte baixa (PD3..PD0 = 0)
    cbi PORTD, 3       ; limpa PD3 = 0
    cbi PORTD, 2       ; limpa PD2 = 0
    cbi PORTD, 1       ; limpa PD1 = 0
    cbi PORTD, 0       ; limpa PD0 = 0


fim:
    rjmp loop          ; repete o loop eternamente


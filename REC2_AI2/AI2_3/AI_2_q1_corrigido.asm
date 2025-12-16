; DEFINIÇÕES
.equ RST = PD2      ; Botão Reset
.equ INC_DEC = PD3  ; Botão Incrementa/Decrementa

.DSEG
.ORG SRAM_START
    count_b: .BYTE 1
    count_c: .BYTE 1

.CSEG
start:
    ; Configura botões como ENTRADA
    CBI DDRD, RST
    CBI DDRD, INC_DEC
    ; Habilita resistores de PULL-UP
    SBI PORTD, RST
    SBI PORTD, INC_DEC 
    
    ; Configura LEDs (Saídas)
    SBI DDRB, 3
    SBI DDRB, 2
    SBI DDRB, 1
    SBI DDRB, 0
    
    SBI DDRC, 3
    SBI DDRC, 2
    SBI DDRC, 1
    SBI DDRC, 0
    
    ; Inicializa Ponteiros X e Y
    LDI XL, LOW(count_b)
    LDI XH, HIGH(count_b)
    LDI YL, LOW(count_c)
    LDI YH, HIGH(count_c)
    
rst_leds:
    ; Inicializa valores: Count B = 15, Count C = 0
    LDI R16, 15
    OUT PORTB, R16
    ST X, R16
    
    LDI R16, 0
    OUT PORTC, R16
    ST Y, R16
    
loop_principal:
    ; --- VERIFICAÇÃO DO BOTÃO INC/DEC ---
    SBIC PIND, INC_DEC   ; Se o botão estiver SOLTO (1), pula a instrução
    RJMP acao_inc_dec    ; Se estiver PRESSIONADO (0), pula para a ação
    
    ; --- VERIFICAÇÃO DO BOTÃO RST ---
    SBIC PIND, RST       ; Se o botão estiver SOLTO (1), pula
    RJMP rst_leds        ; Se estiver PRESSIONADO (0), reseta
    
    RJMP loop_principal  ; Volta para o início do loop

acao_inc_dec:
    ; --- CONTROLE DE INTERVALO E AÇÃO ---
    
    ; 1. Decrementar Count B (Não pode ser menor que 0)
    LD R16, X
    CPI R16, 0           ; Compara com 0
    BREQ pular_dec_b     ; Se for igual a 0, pula o decremento
    DEC R16
    OUT PORTB, R16
    ST X, R16
pular_dec_b:

    ; 2. Incrementar Count C (Não pode ser maior que 15)
    LD R17, Y
    CPI R17, 15          ; Compara com 15
    BREQ pular_inc_c     ; Se for igual a 15, pula o incremento
    INC R17
    OUT PORTC, R17
    ST Y, R17
pular_inc_c:

    ; O código fica preso aqui enquanto o botão ainda estiver pressionado
espera_soltar:
    SBIS PIND, INC_DEC   ; Se o bit estiver SETADO (Solto), pula o loop
    RJMP espera_soltar   ; Se continuar LIMPO (Pressionado), volta e espera
    
    ; Pequeno delay para debounce poderia ser adicionado aqui
    RJMP loop_principal
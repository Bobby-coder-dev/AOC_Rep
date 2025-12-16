; DEFINIÇÕES
.equ RST = PD2      ; Ligado à INT0
.equ INC_DEC = PD3  ; Ligado à INT1

.DSEG
.ORG SRAM_START
    count_b: .BYTE 1
    count_c: .BYTE 1

.CSEG
.ORG 0x0000
    RJMP setup
    
.ORG 0x0002 ; Vetor da INT0 (Pino PD2 - Reset)
    RJMP isr_rst_int0  
    
.ORG 0x0004 ; Vetor da INT1 (Pino PD3 - Inc/Dec)
    RJMP isr_inc_dec_int1   
    
.ORG 0x0034
setup:
    ; Configura Portas
    CBI DDRD, RST
    CBI DDRD, INC_DEC
    SBI PORTD, RST
    SBI PORTD, INC_DEC 
    
    SBI DDRB, 3
    SBI DDRB, 2
    SBI DDRB, 1
    SBI DDRB, 0
    
    SBI DDRC, 3
    SBI DDRC, 2
    SBI DDRC, 1
    SBI DDRC, 0
    
    ; Configura Interrupções (EICRA)
    ; INT1 (Bits 3:2) = 10 (Falling Edge -> Borda de descida para INC/DEC)
    ; INT0 (Bits 1:0) = 10 (Falling Edge -> Borda de descida para RST)
    ; Usar borda de descida evita ter que analisar nível lógico dentro da ISR
    LDI R16, 0b00001010 
    STS EICRA, R16
    
    ; Habilita INT0 e INT1
    SBI EIMSK, INT0
    SBI EIMSK, INT1
    
    ; Inicializa Ponteiros
    LDI XL, LOW(count_b)
    LDI XH, HIGH(count_b)
    LDI YL, LOW(count_c)
    LDI YH, HIGH(count_c)
    
    ; Inicializa valores iniciais (reset) manualmente uma vez
    CALL reset_logica

    SEI ; Habilita globalmente
    
loop:
    RJMP loop ; Loop vazio, tudo acontece nas interrupções
    
;-------------------------------------------------
; Rotina Auxiliar de Reset (Chamada no inicio e na INT0)
;-------------------------------------------------
reset_logica:
    LDI R16, 15
    OUT PORTB, R16
    ST X, R16
    
    LDI R16, 0
    OUT PORTC, R16
    ST Y, R16
    RET

;-------------------------------------------------
; ISR INT0 -> Executa o RESET (Pino PD2)
;-------------------------------------------------
isr_rst_int0:
    PUSH R16
    IN R16, SREG
    PUSH R16
    
    CALL reset_logica ; Chama a rotina que zera tudo
    
    POP R16
    OUT SREG, R16
    POP R16
    RETI

;-------------------------------------------------
; ISR INT1 -> Executa INC/DEC (Pino PD3)
;-------------------------------------------------
isr_inc_dec_int1:
    PUSH R16
    IN R16, SREG
    PUSH R16
    PUSH R17 ; Salvando R17 também pois vamos usá-lo
    
    ; --- Ação no Count B (Decrementa) ---
    LD R16, X
    CPI R16, 0       ; Verifica limite inferior
    BREQ skip_dec_isr
    DEC R16
    OUT PORTB, R16
    ST X, R16
skip_dec_isr:

    ; --- Ação no Count C (Incrementa) ---
    LD R17, Y
    CPI R17, 15      ; Verifica limite superior
    BREQ skip_inc_isr
    INC R17
    OUT PORTC, R17
    ST Y, R17
skip_inc_isr:

    POP R17
    POP R16
    OUT SREG, R16
    POP R16
    RETI
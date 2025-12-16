.DSEG
.ORG SRAM_START
    A: .BYTE 4
    B: .BYTE 4
.CSEG
start:
    LDI XH, HIGH(A)
    LDI XL, LOW(A)
    
    rcall inc_32bits
    
    LDI XH, HIGH(A)
    LDI XL, LOW(A)
    LDI YH, HIGH(B)
    LDI YL, LOW(B)

    rcall mov_32bits

    LDI XH, HIGH(A)
    LDI XL, LOW(A)
    
    rcall dec_32bits
    
    rjmp start
    
;incrementação var 32 bits
inc_32bits:
    ;salva contexto
    PUSH R0
    PUSH R16        ; <--- R16 é usado na conta, deve ser salvo
    PUSH R17        ; <--- R17 é usado na conta, deve ser salvo
    PUSH XL
    PUSH XH
    IN R0, SREG    ; Usa R16 para salvar SREG
    PUSH R0
    
    ; Byte 0 (LSB)
    LD R16, X
    LDI R17, 1
    ADD R16, R17    ; Soma 1. Gera Carry se R16 for 255.
    ST X+, R16

    ; Byte 1
    LD R16, X
    LDI R17, 0
    ADC R16, R17    ; Soma 0 + Carry anterior
    ST X+, R16

    ; Byte 2
    LD R16, X
    ADC R16, R17    ; Soma 0 + Carry
    ST X+, R16

    ; Byte 3 (MSB)
    LD R16, X
    ADC R16, R17    ; Soma 0 + Carry
    ST X, R16       ; Não precisa avançar mais

    ;recupera contexto
    POP R0
    OUT SREG, R0
    POP XH
    POP XL
    POP R17
    POP R16
    POP R0
    RET
    
;decrementação var 32 bits
dec_32bits:
    ;salva contexto
    PUSH R0
    PUSH R16
    PUSH R17
    PUSH XL
    PUSH XH
    IN R0, SREG
    PUSH 0
    
    ; Byte 0
    LD R16, X
    LDI R17, 1
    SUB R16, R17    ; Subtrai 1. Seta Carry se houve "emprestimo".
    ST X+, R16

    ; Byte 1
    LD R16, X
    LDI R17, 0
    SBC R16, R17    ; Subtrai 0 - Carry anterior
    ST X+, R16

    ; Byte 2
    LD R16, X
    SBC R16, R17
    ST X+, R16

    ; Byte 3
    LD R16, X
    SBC R16, R17
    ST X, R16
    ;recupera contexto
    POP R16
    OUT SREG, R16
    POP XH
    POP XL
    POP R17
    POP R16
    POP R0
    
    RET
    
;mover bytes da variavel A para B
mov_32bits:
    ;salva contexto
    PUSH R0
    PUSH R16        ; Só usamos R16 aqui
    PUSH XL
    PUSH XH
    PUSH YL
    PUSH YH
    IN R0, SREG
    PUSH R0
    
   ; Copia Byte 0
    LD R16, X+
    ST Y+, R16

    ; Copia Byte 1
    LD R16, X+
    ST Y+, R16

    ; Copia Byte 2
    LD R16, X+
    ST Y+, R16

    ; Copia Byte 3
    LD R16, X
    ST Y, R16
    
    ;recupera contexto
    POP R0
    OUT SREG, R0
    POP YH
    POP YL
    POP XH
    POP XL
    POP R16
    POP R0
    
    RET



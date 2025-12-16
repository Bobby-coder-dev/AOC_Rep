.DSEG
.ORG SRAM_START
    V0: .BYTE 8
    V1: .BYTE 8
    V2: .BYTE 4
.CSEG
start:
;inicializar v0 com 8 a 14
    LDI R16, 8
    LDI XH, HIGH(V0)
    LDI XL, LOW(V0)
    
;loop de inicialização da variavel v0 de 8 a 14

loop_initV0:
    ST X+, R16 ;Guarda o valor atual de r16
    INC R16
    CPI R16, 16 ;Verifica se for 15 para não refazer o loop, guardando o 15
    BRNE loop_initV0

;copiando valores de v0 de tras pra frente em v1
;inicializando v0 deslocado para ler de tras pra frente
    LDI XH, HIGH(V0+8) ;inicia-se deslocado para copiar de tras para frente, 1 a mais já que x começa decrementando
    LDI XL, LOW(V0+8)
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)
    LDI R16, 7

loop_copV1:
    LD R17, -X
    ST Y+, R17
    DEC R16
    BRNE loop_copV1
    
;soma pares v0 com impares v1    
    
    LDI ZH, HIGH(V0)
    LDI ZL, LOW(V0)
    LDI YH, HIGH(V1)
    LDI YL, LOW(V1)
    LDI XH, HIGH(V2)
    LDI XL, LOW(V2)
    
    ;v2(0) = v0(0) + v1(1)
    LD   R16, Z
    LDD  R17, Y+1
    ADD  R16, R17
    ST X+, R16
    
    ;v2(1) = v0(2) + v1(3)
    LDD R16, Z+2
    LDD R17, Y+3
    ADD R16, R17
    ST X+, R16
    
    ;v2(2) = v0(4) + v1(5)
    LDD R16, Z+4
    LDD R17, Y+5
    ADD R16, R17
    ST X+, R16
    
    ;v2(3) = v0(6) + v1(7)
    LDD R16, Z+6
    LDD R17, Y+7
    ADD R16, R17
    ST X+, R16
     
    



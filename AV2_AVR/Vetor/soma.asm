.CSEG
start:
; ---------------------------
; Soma direta (endereçamento direto)
; ---------------------------
    LDS r16, 0x0060
    LDS r17, 0x0061
    ADD r16, r17
    STS 0x0062, r16


; ---------------------------
; Modo indireto (endereçamento indireto com X)
; ---------------------------
    LDI r26, LOW(0x0060)
    LDI r27, HIGH(0x0060)
    LD r16, X          ; carrega dado de 0x0060

    LDI r26, LOW(0x0061)
    LDI r27, HIGH(0x0061)
    LD r17, X          ; carrega dado de 0x0061

    ADD r16, r17

    LDI r26, LOW(0x0062)
    LDI r27, HIGH(0x0062)
    ST X, r16          ; armazena resultado em 0x0062


; ---------------------------
; Modo indireto com pós-incremento
; ---------------------------
    LDI r26, LOW(0x0060)
    LDI r27, HIGH(0x0060)

    LD r16, X+         ; lê 0x0060 e incrementa X -> agora X = 0x0061
    LD r17, X+         ; lê 0x0061 e incrementa X -> agora X = 0x0062

    ADD r16, r17
    ST X, r16          ; X = 0x0062, armazena resultado em 0x0062


; ---------------------------
; Modo indireto com deslocamento (usando Y)
; ---------------------------
    LDI r28, LOW(0x0060)
    LDI r29, HIGH(0x0060)

    LD  r16, Y         ; carrega byte de 0x0060
    LDD r17, Y+1       ; deslocamento +1 → 0x0061
    ADD r16, r17
    STD Y+2, r16       ; deslocamento +2 → 0x0062

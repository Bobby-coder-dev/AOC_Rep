;Faça um código assembly que execute as seguintes operações:

;Declare três vetores com 8 posições de 8 bits (A1, A2 e A3) e um vetor de 3 posições de 8 bits (A4).
;Dica: utilize .DSEG e ".BYTE 8"

;-----Inicialize os vetores A2 e A3 com os valores de 1 até 8.
;Dica: utilize endereçamento indireto com pós incremento.
;Dica: Utilize um loop com 8 iterações.


.DSEG
.ORG SRAM_START

  A1: .BYTE 8
  A2: .BYTE 8
  A3: .BYTE 8
  A4: .BYTE 3

.CSEG

start:
; INICIALIZAR A2 e A3
  LDI R16, 1

  LDI XL, LOW(A2)
  LDI XH, HIGH(A2)
  LDI YL, LOW(A3)
  LDI YH, HIGH(A3)
loop:
  ST X+, R16
  ST Y+, R16
  INC R16
  CPI R16, 9
  BRNE loop

; SOMA 2

;-----Some a primeira posição do A2 com a última do A3 e armazene na primeira do A1. Faça isso sucessivamente até que todas as posições sejam operadas.
;Dica: utilize endereçamento indireto com pós incremento para acessar o A1 e o A2 e endereçamento indireto com pré decremento para acessar o A3.
;Dica: Utilize um loop com 8 iterações.

  LDI XL, LOW(A1)
  LDI XH, HIGH(A1)
  LDI YL, LOW(A2)
  LDI YH, HIGH(A2)
  LDI ZL, LOW(A3+8)
  LDI ZH, HIGH(A3+8)
  
  LDI R17, 8 
loop2:
  LD R18, Y+
  LD R19, -Z
  ADD R18, R19
  ST X+, R18
  DEC R17
  BRNE loop2

; SOMA 3
;----Some A2(1) e A3(4), A2(2) e A3(3), A2(6) e A3(7) e salve consecutivamente no A4.
;Dica: utilize endereçamento indireto com deslocamento para acessar o A2 e o A3 e endereçamento indireto com pós incremento para acessar o A4.
;Dica: Não utilize loop.

  LDI XL, LOW(A4)
  LDI XH, HIGH(A4)
  LDI YL, LOW(A2)
  LDI YH, HIGH(A2)
  LDI ZL, LOW(A3)
  LDI ZH, HIGH(A3)

  LD  R20, Y
  LDD R21, Z+3
  ADD R20, R21
  ST  X+, R20

  LDD R22, Y+1
  LDD R23, Z+2
  ADD R22, R23
  ST  X+, R22

  LDD R24, Y+5
  LDD R25, Z+6
  ADD R24, R25
  ST  X+, R24
  RJUMP start
	



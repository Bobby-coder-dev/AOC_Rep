# 2025.2 - ARQUITETURA E ORGANIZAÇÃO DE COMPUTADORES - Turma 01


## Questão 1
Os 10 bits que representam a operação ``ACC <- 36`` do Rudi são:
- Resposta: ``0100100100``

Explicação: 
Esta instrução carrega o valor 36 diretamente no acumulador (ACC). No processador Rudi, as instruções têm 10 bits organizados da seguinte forma:
- **Bits 9-6 (4 bits)**: Código da operação (opcode)
- **Bits 5-0 (6 bits)**: Operando/endereço

Para a operação `ACC <- valor`, o opcode é `0100` .
O valor 36 em binário de 6 bits é `100100`.
Portanto: `0100` + `100100` = `0100100100` 

## Questão 2
Os 10 bits que representam a operação ``ACC <- ACC + 86`` do Rudi são:
- Resposta: ``1001010110``

Explicação:
Esta instrução realiza uma soma entre o valor atual do acumulador (ACC) e o valor 86, armazenando o resultado no próprio acumulador.
- **Opcode**: `1001` representa a operação de adição com valor imediato (ADD immediate)
- **Operando**: O valor 94 em binário de 6 bits é `010110`
Portanto: `1001` + `010110` = `1001010110`
  
## Questão 3
Os 10 bits que representam a operação ``ACC <- ACC - 6`` do Rudi são:
- Resposta: ``1100000110``

Explicação:
Esta instrução realiza uma subtração entre o valor atual do acumulador (ACC) e o valor 6, armazenando o resultado no próprio acumulador.
- **Opcode**: `1100` representa a operação de subtração com valor imediato (SUB immediate)
- **Operando**: O valor 6 em binário de 6 bits é `000110`
Portanto: `1100` + `000110` = `1100000110`
# Conjunto de Instruções do BIP

O **BIP (Basic Instructional Processor)** possui um conjunto de instruções simples para manipulação de dados e controle de fluxo. Ele utiliza o acumulador (ACC) e registradores de status (como `Z` e `N`) para determinar condições lógicas.

---

## Instruções Aritméticas e de Dados

| Código | Instrução          | Operação                                                                    |
| ------ | ------------------ | --------------------------------------------------------------------------- |
| 00000  | **HLT**            | Paralisa a execução do programa                                             |
| 00001  | **STO endereço**   | (endereço) ← ACC  <br> Armazena o valor do acumulador na memória            |
| 00010  | **LD endereço**    | ACC ← (endereço)  <br> Carrega o valor da memória para o acumulador         |
| 00011  | **LDI constante**  | ACC ← constante  <br> Carrega uma constante diretamente no acumulador       |
| 00100  | **ADD endereço**   | ACC ← ACC + (endereço)  <br> Soma o valor da memória ao acumulador          |
| 00101  | **ADDI constante** | ACC ← ACC + constante  <br> Soma uma constante diretamente ao acumulador    |
| 00110  | **SUB endereço**   | ACC ← ACC – (endereço)  <br> Subtrai o valor da memória do acumulador       |
| 00111  | **SUBI constante** | ACC ← ACC – constante  <br> Subtrai uma constante diretamente do acumulador |

---

## Instruções de Desvio Condicional e Incondicional

| Código | Instrução        | Operação                                                                                                                                         |
| ------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| 01000  | **BEQ endereço** | Se `(STATUS.Z = 1)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado anterior foi **zero**                                 |
| 01001  | **BNE endereço** | Se `(STATUS.Z = 0)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado anterior **não foi zero**                             |
| 01010  | **BGT endereço** | Se `(STATUS.Z = 0)` **e** `(STATUS.N = 0)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado foi **maior que zero**         |
| 01011  | **BGE endereço** | Se `(STATUS.N = 0)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado foi **maior ou igual a zero**                         |
| 01100  | **BLT endereço** | Se `(STATUS.N = 1)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado foi **menor que zero**                                |
| 01101  | **BLE endereço** | Se `(STATUS.Z = 1)` **ou** `(STATUS.N = 1)` então `PC ← endereço`, senão `PC ← PC + 1`  <br> Desvia se o resultado foi **menor ou igual a zero** |
| 01110  | **JMP endereço** | `PC ← endereço`  <br> Desvio incondicional                                                                                                       |

---

## Observações

* **ACC (Acumulador):** registrador principal onde ocorrem as operações aritméticas.
* **PC (Program Counter):** registrador que aponta para a próxima instrução.
* **STATUS (Z, N):** flags que indicam o resultado da última operação:

  * `Z = 1` → resultado foi zero
  * `N = 1` → resultado foi negativo

Esse conjunto de instruções é suficiente para implementar programas básicos de cálculo e controle de fluxo.

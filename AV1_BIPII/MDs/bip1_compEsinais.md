# Processador BIP – Visão Geral

Este documento resume os principais **componentes** e **sinais de controle** do processador **BIP (Basic Instructional Processor)**.  

---

## Componentes principais do BIP

### 1. **PC (Program Counter / Apontador de Instrução)**
- Armazena o endereço da **próxima instrução** a ser executada.
- Normalmente é incrementado em 1 a cada ciclo de instrução.
- Pode ser alterado por instruções de **salto** (`JMP`, `BEQ`, etc.).

---

### 2. **IR (Instruction Register / Registrador de Instrução)**
- Armazena a **instrução atual** que está sendo executada.
- A instrução é lida da memória de programa e carregada no IR.

---

### 3. **ACC (Acumulador)**
- Registrador central usado para armazenar resultados de operações aritméticas e lógicas.
- Todas as operações da ULA envolvem o ACC de alguma forma.
- Exemplo:  
  - `ADD X` → `ACC ← ACC + (X)`

---

### 4. **ULA (Unidade Lógica e Aritmética)**
- Executa operações como soma, subtração e comparação.
- Trabalha com operandos vindos de **multiplexadores** (SelA, SelB).
- Atualiza **flags de estado**:  
  - **Z (Zero)** → resultado foi zero.  
  - **N (Negative)** → resultado foi negativo (MSB = 1).  

---

### 5. **Memória**
- **Memória de programa**: guarda instruções.  
- **Memória de dados**: guarda variáveis e constantes.  
- Acesso feito via **barramento de endereço** e **barramento de dados**.

---

## Sinais de Controle do BIP

A **Unidade de Controle (UC)** gera sinais que coordenam a execução das instruções.  

### 1. **WrAcc (Write ACC)**
- Define se o acumulador (**ACC**) será atualizado.
- Ex.:  
  - `ADD`, `LD`, `SUB` → WrAcc = 1  
  - `BEQ`, `JMP` → WrAcc = 0  

---

### 2. **SelA0, SelA1 (Selector A)**
- Selecionam a origem do operando **A** da ULA.
- Possíveis entradas: ACC, imediato, memória.

---

### 3. **SelB**
- Seleciona a origem do operando **B** da ULA.
- Exemplo:  
  - `ADDI` → imediato.  
  - `ADD` → dado da memória.  

---

### 4. **OpSel**
- Define qual **operação** a ULA executará (soma, subtração, comparação, etc.).

---

### 5. **WrRam (Write RAM)**
- Ativa escrita na memória de dados.
- Ex.:  
  - `STO` → WrRam = 1  
  - `LD` → WrRam = 0  

---

### 6. **RdRam (Read RAM)**
- Ativa leitura da memória de dados.
- Ex.:  
  - `LD` → RdRam = 1  

---

### 7. **WrPC (Write PC)**
- Define se o **PC** será atualizado.  
- Atualizações possíveis:  
  - `PC ← PC + 1` (execução normal).  
  - `PC ← endereço` (salto).  

---

### 8. **Branch**
- Indica se a instrução é de **desvio condicional** (`BEQ`, `BNE`, etc.).
- Se ativo, o PC pode receber novo valor dependendo dos flags.

---

### 9. **WrNZ**
- Define se os **flags (N e Z)** serão atualizados.
- Ex.:  
  - Operações aritméticas (`ADD`, `SUB`) → WrNZ = 1.  
  - Saltos ou `HLT` → WrNZ = 0.  

---

## 🔹 Ciclo de Instrução (Resumo)

1. **Busca (Fetch)**  
   - `IR ← Mem[PC]`  
   - `PC ← PC + 1`  

2. **Decodificação (Decode)**  
   - Unidade de Controle interpreta o **opcode**.  

3. **Execução (Execute)**  
   - Unidade de Controle gera sinais de controle (WrAcc, SelA, etc.).  
   - A operação é realizada e resultado armazenado no ACC ou na memória.  



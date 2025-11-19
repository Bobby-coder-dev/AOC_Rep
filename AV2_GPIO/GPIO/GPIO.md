# Guia de GPIO em Assembly AVR (ATmega328P)
## Foco: Lógica Negativa (Sink) e Pull-ups

Este guia cobre a manipulação de portas para um cenário com **8 LEDs (Saídas)** e **2 Botões (Entradas)**, utilizando a lógica "Active Low" (0 ativa).

---

## 1. Lógica do Hardware (A Regra do "Zero")

Neste cenário, tanto os botões quanto os LEDs funcionam com lógica invertida. **O nível lógico 0 (GND) é o estado "Ativo".**

### Botões (Entrada com Pull-up Interno)
O botão conecta o pino ao Terra (GND) quando pressionado.
* **Botão SOLTO (Repouso):** O Pull-up mantém o pino em **1 (5V)**.
* **Botão PRESSIONADO (Ativo):** O pino vai para **0 (GND)**.

### LEDs (Saída em Current Sink)
O anodo (positivo) do LED está ligado direto na fonte. O pino do microcontrolador controla o catodo (negativo).
* **Escrever 1 no pino:** 5V no pino vs 5V na fonte = **LED APAGADO**.
* **Escrever 0 no pino:** 0V no pino vs 5V na fonte = **LED ACESO**.

| Componente | Ação Desejada | Nível Lógico Necessário | Instrução Assembly |
| :--- | :--- | :--- | :--- |
| **Botão** | Verificar se **APERTOU** | **0** (Zero) | `SBIC` (Skip if Clear) |
| **Botão** | Verificar se **SOLTOU** | **1** (Um) | `SBIS` (Skip if Set) |
| **LED** | **LIGAR** a luz | **0** (Zero) | `CBI` (Clear Bit) |
| **LED** | **DESLIGAR** a luz | **1** (Um) | `SBI` (Set Bit) |

---

## 2. Registradores Essenciais

Para cada porta (B, C, D), existem 3 registradores. Substitua `x` pela letra da porta (ex: `DDRB`, `PORTD`).

1.  **`DDRx` (Data Direction Register): Configuração**
    * Define se o pino é Entrada ou Saída.
    * Bit **0** = Entrada (Input).
    * Bit **1** = Saída (Output).

2.  **`PORTx` (Data Register): Escrita / Pull-up**
    * **Se Saída (`DDR=1`):** Define o valor (0 = Liga LED, 1 = Desliga LED).
    * **Se Entrada (`DDR=0`):** 1 = Liga resistor de Pull-up (Essencial para botões).

3.  **`PINx` (Input Pins): Leitura**
    * Usado para ler o estado real do pino.
    * **Regra de Ouro:** Escreva no `PORT`, leia o `PIN`.

---

## 3. Instruções de Manipulação de Bit (Cirúrgicas)

Estas instruções alteram ou testam **apenas um pino**, sem mexer nos vizinhos. Ideais para ligar/desligar LEDs individuais.

### Alterar Estado (Saída)
* **`SBI PORTx, bit` (Set Bit in I/O):** Coloca o bit em **1**.
    * *No seu caso:* **DESLIGA** o LED.
* **`CBI PORTx, bit` (Clear Bit in I/O):** Coloca o bit em **0**.
    * *No seu caso:* **LIGA** o LED.

### Testar Estado (Entrada)
* **`SBIC PINx, bit` (Skip if Bit is Cleared):** Pula a próxima linha se o bit for **0**.
    * *Uso:* "Se o botão for pressionado (0), pule a instrução de 'ignorar' e execute a ação".
* **`SBIS PINx, bit` (Skip if Bit is Set):** Pula a próxima linha se o bit for **1**.
    * *Uso:* "Se o botão estiver solto (1), pule".

---

## 4. Instruções de Manipulação de Byte (Marretadas)

Estas afetam **todos os 8 pinos** da porta simultaneamente. Cuidado para não sobrescrever estados que você queria manter.

* **`OUT PORTx, Rr`:** Escreve o valor do registrador `Rr` (8 bits) na porta `PORTx`.
    * *Uso:* Configuração inicial (`DDR`) ou alterar 8 LEDs de uma vez.
* **`IN Rd, PINx`:** Lê todos os 8 pinos da porta `PINx` e guarda em `Rd`.

---

## 5. "Snippets" (Receitas de Bolo)

### A. Configuração Inicial (Setup)
Configurar 8 LEDs no PORTD e 2 Botões no PORTB (Pinos 1 e 2).

```assembly
; 1. Configurar LEDs (PORTD) como SAÍDA
SER R16             ; R16 = 0xFF (11111111)
OUT DDRD, R16       ; DDRD = 11111111 (Todos saída)

; 2. Configurar Botões (PORTB) como ENTRADA
CBI DDRB, 1         ; PB1 é entrada
CBI DDRB, 2         ; PB2 é entrada

; 3. Habilitar PULL-UP nos Botões
SBI PORTB, 1        ; Escrever 1 na entrada ativa o Pull-up
SBI PORTB, 2        ; Escrever 1 na entrada ativa o Pull-up
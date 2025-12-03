# Guia de Temporizadores em Assembly AVR (Timer0)
## Foco: Modo Normal (Overflow) e Prescaler

O Timer0 é um hardware independente dentro do chip que conta pulsos de relógio. Ele funciona como um **cronômetro de fundo**, permitindo que o processador faça outras coisas enquanto o tempo passa.

---

## 1. O Conceito: "O Balde e a Torneira"

Para visualizar o Timer0 (8 bits):
1.  **O Balde (`TCNT0`):** É o registrador que conta. Ele começa em 0 e aguenta até **255**.
2.  **A Torneira (Clock):** O cristal do sistema (geralmente 16 MHz) pinga gotas no balde.
3.  **O Filtro (Prescaler):** Reduz o fluxo da torneira para o balde encher mais devagar.
4.  **O Transbordo (Overflow):** Quando o balde chega em 255 e recebe mais uma gota, ele vira e volta para 0. Nesse momento, ele grita "INTERRUPÇÃO!".

---

## 2. A Matemática do Tempo (16 MHz)

Para calcular de quanto em quanto tempo o balde transborda (gera interrupção), usamos 3 passos.

**Fórmula Geral:**
$$Tempo = \frac{256 \times Prescaler}{Frequencia CPU}$$

### Tabela Prática (Para Clock de 16 MHz)

| Prescaler | Contas por Segundo (Hz) | Tempo de 1 Tique | Tempo para Estourar (256 tiques) |
| :--- | :--- | :--- | :--- |
| **1** (Sem filtro) | 16.000.000 Hz | 0,0625 µs | **0,016 ms** (Muito rápido!) |
| **8** | 2.000.000 Hz | 0,5 µs | **0,128 ms** |
| **64** | 250.000 Hz | 4 µs | **1,024 ms** (Aprox 1 ms) |
| **256** | 62.500 Hz | 16 µs | **4,096 ms** (Aprox 4 ms) |
| **1024** | 15.625 Hz | 64 µs | **16,384 ms** (Aprox 16 ms) |

> **Dica de Ouro:** Para exercícios de piscar LED (visível ao olho humano), quase sempre usamos o **Prescaler 1024**, pois ele dá o tempo mais longo (16 ms).

---

## 3. Os Registradores (O Painel de Controle)

Para fazer o Timer funcionar, você precisa configurar dois registradores no `setup`.

### A. `TCCR0B` (Timer/Counter Control Register B)
Define a velocidade (Prescaler). Os bits importantes são os 3 últimos (`CS02`, `CS01`, `CS00`).

| CS02 | CS01 | CS00 | Prescaler | Valor Hex para carregar | Valor Binário |
| :---: | :---: | :---: | :--- | :--- | :--- |
| 0 | 0 | 1 | / 1 | `0x01` | `0b00000001` |
| 0 | 1 | 0 | / 8 | `0x02` | `0b00000010` |
| 0 | 1 | 1 | / 64 | `0x03` | `0b00000011` |
| 1 | 0 | 0 | / 256 | `0x04` | `0b00000100` |
| **1** | **0** | **1** | **/ 1024** | **`0x05`** | **`0b00000101`** |

### B. `TIMSK0` (Timer Interrupt Mask Register)
É o interruptor que liga o alarme.
* **Bit 0 (`TOIE0`):** Timer Overflow Interrupt Enable.
* Deve ser colocado em **1** para a interrupção funcionar.

---

## 4. O Problema do Tempo Longo (Contador de Software)

O Timer0 só conta até **16 ms** (com prescaler 1024). E se o exercício pedir **1 segundo (1000 ms)**?

**Solução:** O Hardware conta os 16ms, e o Software conta quantas vezes o hardware apitou.

**A Regra de Três:**
$$\frac{Tempo Desejado}{16,384 ms} = Numero de Interrupções$$

*Exemplo para 1 Segundo:*
$$\frac{1000}{16,384} \approx 61 ou 62$$

*Exemplo para 200 ms:*
$$\frac{200}{16,384} \approx 12$$

---

## 5. Receita de Bolo (Snippets de Código)

### Passo 1: O Vetor
Não esqueça de apontar o endereço `0x0020` para sua função.

```assembly
.ORG 0x0020
    RJMP isr_timer_overflow
setup_timer:
    ; 1. Configurar Prescaler 1024 (TCCR0B = 5)
    LDI R16, 0b00000101
    OUT TCCR0B, R16
    
    ; 2. Habilitar Interrupção de Overflow (TIMSK0 = 1)
    LDI R16, 1
    STS TIMSK0, R16  ; Atenção: TIMSK0 usa STS, não OUT!
    
    ; 3. Ligar Chave Geral
    SEI

    isr_timer_overflow:
    ; --- Salvar Contexto ---
    PUSH R16
    IN R16, SREG
    PUSH R16
    
    ; --- Lógica de Contagem ---
    INC contador_soft      ; Incrementa variável de software (+16ms)
    CPI contador_soft, 62  ; Já deu 62 vezes? (Aprox 1 seg)
    BRNE fim_isr           ; Se não, sai e espera a próxima
    
    ; --- Ação (Acontece a cada 1 seg) ---
    SBI PINB, 5            ; Inverte LED
    LDI contador_soft, 0   ; Reseta contagem
    
fim_isr:
    ; --- Restaurar Contexto ---
    POP R16
    OUT SREG, R16
    POP R16
    RETI
# Guia de Interrupções em Assembly AVR (ATmega328P)
## Foco: INT0 e INT1 (Botões Externos)

Uma interrupção é um evento de hardware que **pausa** o programa principal (`main`), executa uma tarefa urgente (**ISR**) e devolve o processador exatamente onde parou.

---

## 1. A Tabela de Vetores (O Mapa do Hardware)
O microcontrolador tem endereços fixos na memória flash para onde ele salta automaticamente quando uma interrupção ocorre.

| Endereço (Hex) | Nome | Fonte da Interrupção | O que colocar lá? |
| :--- | :--- | :--- | :--- |
| **0x000** | RESET | Ao ligar ou resetar | `RJMP setup` |
| **0x002** | INT0 | Pino PD2 (Pino 4) | `RJMP isr_int0` |
| **0x004** | INT1 | Pino PD3 (Pino 5) | `RJMP isr_int1` |

**Regra:** Se você habilitar a interrupção mas não colocar o `RJMP` no endereço certo, o código vai travar ou resetar.

---

## 2. O Fluxo de Configuração (Checklist)

Para a interrupção funcionar, você precisa alinhar 3 astros: **Gatilho**, **Máscara** e **Chave Geral**.

### A. EICRA (External Interrupt Control Register A)
Define **COMO** o botão ativa a interrupção (Gatilho).
*Este registrador geralmente requer `STS` (Store to SRAM) em vez de `OUT`.*

**Configuração de Bits:**
* **Bits 3 e 2:** Controlam **INT1**
* **Bits 1 e 0:** Controlam **INT0**

| Valor Binário (Par) | Modo | Descrição | Ideal para... |
| :--- | :--- | :--- | :--- |
| `00` | Low Level | Dispara enquanto for 0. | Perigoso para botões. |
| `01` | Change | Dispara ao apertar E ao soltar. | Encoders. |
| `10` | **Falling Edge** | Dispara na **descida** (5V -> 0V). | **Botão com Pull-up.** |
| `11` | Rising Edge | Dispara na subida (0V -> 5V). | Botão com Pull-down. |

*Exemplo (INT0 e INT1 na descida):*
```assembly
LDI R16, 0b00001010  ; 10 para INT1, 10 para INT0
STS EICRA, R16
```

## Instruções que NÃO alteram flags (Seguras)
####   Se sua ISR usar apenas estas, você tecnicamente não precisa salvar o SREG (mas salvar R16 ainda é bom):

- SBI / CBI (Alterar bits individuais).

- LDI / MOV / LDS / STS (Mover dados).

- PUSH / POP.

## Instruções que ALTERAM flags (Perigosas)
#### Se usar estas, OBRIGATÓRIO salvar SREG:

- ADD, SUB, INC, DEC (Matemática).

- AND, OR, EOR (Lógica).

- CPI, CP, TST (Comparação).
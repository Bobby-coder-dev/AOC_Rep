# Arquitetura vs Organização de Computadores

## Arquitetura de Computadores
A **arquitetura** é o nível **lógico e abstrato**, visto pelo programador.  
Ela define **o que o processador faz**, mas não como é implementado.

### Exemplos de aspectos arquiteturais:
- Conjunto de instruções (**ISA** – Instruction Set Architecture).  
- Formato das instruções.  
- Tipos de dados suportados (inteiros, ponto flutuante, etc.).  
- Modos de endereçamento.  
- Número de registradores visíveis ao programador.  
- Sinais de estado (N, Z, etc.).

É o **contrato entre hardware e software**.

---

## Organização de Computadores
A **organização** é o nível **físico e prático** da implementação.  
Ela define **como o processador realiza** o que foi especificado na arquitetura.

### Exemplos de aspectos organizacionais:
- Como a ULA (ALU) é construída.  
- Número de estágios do pipeline.  
- Tamanho real dos barramentos internos.  
- Tipos e tamanhos de caches.  
- Quantos ciclos de clock cada instrução leva.  
- Interconexão entre memória e CPU.

É a **engenharia do hardware** que realiza a arquitetura.

---

## Comparação lado a lado

| **Arquitetura** | **Organização** |
|-----------------|-----------------|
| O que o processador faz | Como o processador faz |
| Vista pelo **programador** | Vista pelo **projetista de hardware** |
| Define o **conjunto de instruções** | Define a **execução física** das instruções |
| Independente de implementação | Depende do projeto e da tecnologia usada |
| Mais abstrato | Mais concreto |

.equ BUTTON = PD2
.equ LED = PB5
    

.DSEG
.ORG SRAM_START
    
    contagem: .BYTE 1
    intervalo: .BYTE 1
     
.CSEG
 
    .ORG 0x0000
	rjmp setup ; Vetor reset

    .ORG 0x0002
	rjmp isr_int0

    .ORG 0x0020 ; Vetor (endereço na Flash) do estouro do T/C0
	RJMP isr_tc0b        
	
    .ORG 0x0034
    
    setup:
	
	sbi DDRB, LED; Configura o PB5 como saída (led)
	cbi PORTB, LED ; desliga led

	cbi DDRD, BUTTON; Configura PD2 como entrada
	sbi PORTD, BUTTON ; Ativa o pull-up do botão de entrada
	
	ldi R16, 31
	sts intervalo, R16 ; Iniciando o valor do intervalo com 31, indicando que o led ficará 500 ms aceso e 500 ms apagado
	
	ldi R16, 0b00000101 ; TC0 com prescaler de 1024, a 16 MHz gera
	out TCCR0B, R16 ; uma interrupção a cada 16,384 ms
	
	LDI R16, 1
	sts TIMSK0, R16 ; habilita int. do TC0B (TIMSK0(0)=TOIE0 <- 1)
	
	ldi R16, 0b00000010
	sts EICRA, R16
	sbi EIMSK, INT0 ; Habilita a interrupção 0
	
	sei  ; Habilita a interrupção global
	
    main:
	
	rjmp main
	
    
    isr_int0:

	; Salvar contexto
	PUSH R16
	IN R16, SREG
	PUSH R16

	; Carrega intervalo
	lds  R16, intervalo

	; Subtrai 6 (próximo estágio)
	subi R16, 6      
	 
	; Os estágios foram cálculados foram 31 (inicial), 25, 19, 13 e 7
	; Cada um deles foram encontrados fazendo uma regra de 3 simples.
	
	; Se passou do limite (ficou menor que 7), volta para 31
	cpi  R16, 7
	BRSH fim1
	ldi  R16, 31

	fim1:
	    ; Atualiza a variável intervalo
	    sts  intervalo, R16
	    
	    ; Zera a contagem
	    ldi R16, 0
	    sts contagem, R16
	    
	    ; Restaurar contexto 
	    pop  R16
	    out  SREG, r16
	    pop  R16

	    reti
    
	
	
    isr_tc0b:
	
	; Salva contexto
	PUSH R16
	PUSH R17
	IN R16, SREG
	PUSH R16
	
	lds R16, contagem
	lds R17, intervalo
	
	inc R16
	cp r16, r17
	BRNE fim
	
	sbi PINB, LED ; INVERTE O ESTADO DO LED DEPOIS DE ENTRAR N VEZES
	
	ldi R16,0 ; Zera o valor da variável de contagem para 
	
	fim:
	sts contagem, R16 
	 ; Restaura contexto
	POP R16
    OUT SREG, R16
    POP R17
    POP R16
	    
    reti
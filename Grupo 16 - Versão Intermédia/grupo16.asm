; *****************************************************************************
; * Projeto realizado no âmbito da disciplina de 
; *			Introdução à Arquitetura de Computadores
; *                   pelo GRUPO 16 constituído por:
; *                                 Diana Goulão 102531
; *                                 Miguel Azevedo Alves 102630
; *                                 Tiago Represas Loureiro 104107
; *
; *                         CHUVA DE METEOROS (versão intermédia)
; *****************************************************************************

; *****************************************************************************
; * Constantes
; *****************************************************************************

; constantes teclado
TEC_LIN    EQU 0C000H 	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA      EQU 8       	; linha a testar (linha 4, 1000b)
MASCARA    EQU 0FH     	; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

; constantes de controlo relacionado com o media center (cenários e sons)
SELECIONA_CENARIO_FUNDO EQU 6042H   ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_AUDIO			EQU 605AH	; endereço do comando para selecionar um som
SELECIONA_VOLUME		EQU 604AH	; endereço do comando para configurar o volume
APAGA_AVISO     		EQU 6040H	; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 			EQU 6002H	; endereço do comando para apagar todos os pixels já desenhados

; constantes auxiliares do desenho de objetos (rover e meteoros) e do controlo do ecrã
DEFINE_LINHA   		EQU 600AH   ; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU 600CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU 6012H   ; endereço do comando para escrever um pixel

MAX_COLUNA			EQU 57	; coluna maxima até onde o rover pode andar
MIN_COLUNA			EQU 0	; coluna minima até onde o rover pode andar
MAX_LINHA			EQU 38	; Linha maxima até onde o rover pode andar

MASCARA_BONECO		EQU 00FFH

; constantes do rover e meteoros (cores e tamanhos)
LARGURA_ROVER       EQU 7		; largura do rover
ALTURA_ROVER		EQU 5		; altura do rover
LARANJA		        EQU 0FF70H	; cor do pixel: Laranja em ARGB (cor usada no rover)
VERMELHO			EQU 0FF00H	; cor do pixel: Vermelho em ARGB (cor usada nos meteoros maus)
AZUL				EQU 0F26FH	; cor do pixel: Azul em ARGB (cor usada em ambos os tipos de meteoros)
CINZA				EQU 07777H	; cor do pixel: Cinzento em ARGB (cor usada nos meteoros que se encontram longe - tamanhos 1x1 e 2x2)

LINHA_ROVER        	EQU 31	; linha do rover
COLUNA_METEORO_1	EQU 25	; coluna do meteoro (versão intermédia)
ALTURA_METEORO_1	EQU 1	; altura dos meteoros de tamanho 1
LARGURA_METEORO_1	EQU 1	; largura dos meteoros de tamanho 1
LARGURA_METEORO_2	EQU 2	; largura dos meteoros de tamanho 2
LARGURA_INIMIGO_3	EQU 3	; largura dos meteoros de tamanho 3
LARGURA_INIMIGO_4_5	EQU 4	; largura dos meteoros de tamanho 4 e 5
ALTURA_INIMIGO_5	EQU 7	; altura dos meteoros de tamanho 5

; outras constantes
DISPLAYS   			EQU 0A000H	; endereço dos displays de 7 segmentos (periférico POUT-1)
EXTODEC_MODULE		EQU 000AH	; variavel auxiliar na conversao de hexadecimal para decimal
DELAY				EQU 9999H	; contante auxiliar para criar atraso entre ações

; *****************************************************************************
; * Dados 
; *****************************************************************************

PLACE       1000H

; definição do rover
COLUNA_ROVER:
	WORD  32	; coluna do rover

DEF_ROVER:	; tabela que define o rover (cor, largura, pixels)
	WORD	LARGURA_ROVER
	WORD	LARANJA, 0, LARANJA, LARANJA, LARANJA, 0, LARANJA
	WORD	LARANJA, LARANJA, LARANJA, LARANJA, LARANJA, LARANJA, LARANJA
	WORD	LARANJA, 0, LARANJA, 0, LARANJA, 0, LARANJA
	WORD	0, 0, LARANJA, LARANJA, LARANJA, 0, 0
	WORD	0, 0, 0, LARANJA, 0,0,0

; definição dos meteoros mais pequenos (tamanho 1 e 2) onde ainda são indestinguiveis
LINHA_METEORO_1:
	WORD  -1

DEF_METEORO_1: ; tabela que define os meteoros de tamanho 1 (cor, largura, pixels)
	WORD	LARGURA_METEORO_1
	WORD	CINZA

LINHA_METEORO_2:
	WORD	3

DEF_METEORO_2:	; tabela que define os meteoros de tamanho 2 (cor, largura, pixels)
	WORD	LARGURA_METEORO_2
	WORD	CINZA, CINZA
	WORD	CINZA, CINZA

; defenição dos meteoros maus
DEF_INIMIGO_3:	; tabela que define os meteoros de tamanho 3 (cor, largura, pixels)
	WORD	LARGURA_INIMIGO_3
	WORD	VERMELHO, VERMELHO,0
	WORD	AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO

DEF_INIMIGO_4:	; tabela que define os meteoros de tamanho 4 (cor, largura, pixels)
	WORD	LARGURA_INIMIGO_4_5
	WORD	VERMELHO, VERMELHO, VERMELHO, 0
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO, VERMELHO, VERMELHO
	WORD	VERMELHO, 0, VERMELHO, 0

DEF_INIMIGO_5:	; tabela que define os meteoros de tamanho 5 (cor, largura, pixels)
	WORD	LARGURA_INIMIGO_4_5
	WORD	VERMELHO, 0, VERMELHO, 0
	WORD	VERMELHO, VERMELHO, VERMELHO, 0
	WORD	VERMELHO, VERMELHO, VERMELHO, VERMELHO
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO, VERMELHO, 0

; defenição de outros dados
pilha:
	STACK 1000H		; espaco reservado para a pilha 

SP_inicial:
	
imagem_hexa:
	BYTE	000H	; imagem em memoria dos displays hexadecimais (inicializada a zero, mas podia ser outro valor qualquer).
; **********************************************************************
; * Código
; **********************************************************************

PLACE      0

inicio:	; inicializações
    MOV SP, SP_inicial	; inicializa SP para a palavra a seguir a ultima da pilha
	
	MOV  R7, 0H			; energia inicial - 64 corresponte a 100 em Hexadecimal
	CALL set_display    ; inicializacao dos displays de energia (energia inicial - 100)

	MOV  [APAGA_AVISO], R1	            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRA], R1	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
    MOV  R1, 0			                ; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo

    MOV  R2, TEC_LIN    ; endereço do periférico das linhas
    MOV  R3, TEC_COL    ; endereço do periférico das colunas
    MOV  R5, MASCARA    ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, LINHA	    ; para poder alterar a linha a ser testada
	MOV  R10, 0		    ; coordenada da tecla
	MOV  R11, 0000H	    ; compara teclas

espera_tecla_a:			; neste ciclo espera-se até uma tecla ser premida
	MOV  R1, 0004H		; testar a linha 4 
	MOVB [R2], R1		; escrever no periférico de saída (linhas)
	MOVB R0, [R3]		; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JZ   espera_tecla_a	; se nenhuma tecla premida, repete

	SHL R1, 4			; coloca linha no nibble high
	OR  R1, R0			; junta coluna (nibble low)
	MOV R11, 0044H		; coloca no registo 11 o valor da tecla A para posterior comparação
	CMP R1, R11			; a tecla premida é a tecla A?
	JNZ espera_tecla_a	; se não for, repete enquanto a tecla A não for premida

inicia_jogo:
	PUSH R10
	PUSH R11
	MOV R1, 1
	MOV [SELECIONA_CENARIO_FUNDO], R1	; muda para o cenário 1 (ecran_jogo)
	
	MOV  R7, 64H			; energia inicial - 64 corresponte a 100 em Hexadecimal
	CALL set_display    ; inicializacao dos displays de energia (energia inicial - 100)
	CALL desenha_rover
	POP  R11
	POP  R10

; corpo principal do programa
; teclado
varre_teclado:	; função que percorre todo o teclado à espera de encontrar uma tecla premida e que executa a ação respetiva à tecla
				; NOTA: na nossa resolução do projeto, o teclado é varrido da última para a primeira linha
	ciclo:
		MOV R6, LINHA		; começa a varrer o teclado na linha LINHA (última linha do teclado (4ª linha)
		MOV R1, 0 
		MOV R10, R1
		JMP espera_tecla	
	
	nova_linha:
		CMP R6, 0	
		JZ  ciclo	; se já foi precorrido o teclado todo e não houver tecla permida reinicia a leitura do teclado
		SHR R6, 1	; se o teclado ainda não foi totalmente precorrido avança agora para a linha anterior 
		
	espera_tecla:           ; este ciclo verifica se há uma tecla a ser premida numa determinada linha do teclado
		MOV  R1, R6         ; testar a linha em R6
		MOVB [R2], R1       ; escrever no periférico de saída (linhas)
		MOVB R0, [R3]       ; ler do periférico de entrada (colunas)
		AND  R0, R5         ; elimina bits para além dos bits 0-3
		CMP  R0, 0          ; há tecla premida?
		JZ   nova_linha     ; se nenhuma tecla estiver premida, na linha R6, avança para a linha anterior
		; se uma tecla estiver premida nesta linha
		SHL  R1, 4          ; coloca linha no nibble high
		OR   R1, R0         ; junta coluna (nibble low)
		MOV  R10, R1        ; guarda a coordenada da tecla permida em R10
		
		CALL ANALISA_TECLA
	CALL ha_tecla
	
    JMP varre_teclado      ; repete ciclo
	
ha_tecla:               ; neste ciclo espera-se até NENHUMA tecla estar premida
	MOV  R1, R6         ; testar a linha
	MOVB [R2], R1       ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]       ; ler do periférico de entrada (colunas)
	AND  R0, R5         ; elimina bits para além dos bits 0-3
	CMP  R0, 0          ; há tecla premida?
	JNZ  ha_tecla       ; se ainda houver uma tecla premida, espera até não haver
	RET

ANALISA_TECLA:	; analiza as coodenadas da tecla premita e efetua as funções especificas dessa tecla
	MOV R11, 0011H
	CMP R10, R11
	JZ  TECLA_0
	MOV R11, 0012H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0014H
	CMP R10, R11
	JZ  TECLA_2
	MOV R11, 0018H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0021H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0022H
	CMP R10, R11
	JZ  TECLA_5
	MOV R11, 0024H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0028H
	CMP R10, R11
	JZ  TECLA_7
	MOV R11, 0041H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0042H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0044H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0048H
	CMP R10, R11
	JZ  TECLA_B
	MOV R11, 0081H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0082H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0084H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	MOV R11, 0088H
	CMP R10, R11
	JZ  TECLA_SEM_ACAO
	RET

; deslocamento do rover (movimento contínuo)
deslocamento_esquerda: ; rover anda para a esquerda
	PUSH R2
	MOV R2, MIN_COLUNA
	CMP R1, R2	
	JLE FALHA				; caso o rover esteja o mais à esquerda possivel no ecrã não anda mais
	CALL apaga_rover		; caso consiga andar, apaga o rover dos pixeis onde este se encontre
	SUB R1, 1				; anda um pixel para o lado esquerdo
	MOV [COLUNA_ROVER], R1
	CALL desenha_rover		; volta a desenhar o rover agora um pixel mais à esquerda
	POP R2
	POP R1
	JMP varre_teclado		; volta a varrer o teclado (para que o rover ande enquanto a tecla estiver permida)

deslocamento_direita:		; rover anda para a direita
	PUSH R2
	MOV R2, MAX_COLUNA
	CMP R2, R1
	JLE FALHA 				; caso o rover esteja o mais à direita possivel no ecrã não anda mais
	CALL apaga_rover		; caso consiga andar, apaga o rover dos pixeis onde este se encontre
	ADD R1, 1				; anda um pixel para o lado direito
	MOV [COLUNA_ROVER], R1
	CALL desenha_rover		; volta a desenhar o rover agora um pixel mais à direita
	POP R2
	POP R1
	JMP varre_teclado		; volta a varrer o teclado (para que o rover ande enquanto a tecla estiver permida)

; deslocamento do meteoro
desce_meteoro:	; desce linha a linha o meteoro
	PUSH R2
	MOV R2, MAX_LINHA
	CALL apaga_inimigo5			; apaga o meteoro dos pixeis onde se encontra
	CMP R1, R2
	JGE FALHA					; caso o meteoro já esteja no fundo do ecrã
	ADD R1, 1					; caso possa andar, anda uma linha para baixo
	MOV [LINHA_METEORO_1], R1
	CALL desenha_inimigo_5		; volta a desenhar o meteoro agora uma linha mais a baixo
	POP R2
	POP R1
	CALL ha_tecla
	JMP varre_teclado			; volta a varrer o taclado (movimento contínuo)

; testa os limites do ecrã (laterais e inferior)
FALHA:	; caso o rover esteja nos limites do ecrã ou que o meteoro chegue ao fundo da tela
	POP R2
	MOV R1, -1
	MOV [LINHA_METEORO_1], R1
	POP R1
	CALL ha_tecla
	JMP varre_teclado

TECLA_SEM_ACAO: ; teclas sem nenhuma ação especifica 
	POP R11
	JMP varre_teclado

TECLA_0:	; rover anda para a esquerda
	POP R11
	PUSH R1
	MOV R1, [COLUNA_ROVER]
	JMP deslocamento_esquerda

TECLA_2:	; rover anda para a direita
	POP R11
	PUSH R1
	MOV R1, [COLUNA_ROVER]
	JMP deslocamento_direita

TECLA_5:	; desce meteoro
	POP R11
	PUSH R1
	PUSH R0
	PUSH R2
	MOV R0, 0
	MOV R2, 100
	MOV [SELECIONA_VOLUME], R2
	MOV [SELECIONA_AUDIO], R0
	POP R2
	POP R0
	MOV R1, [LINHA_METEORO_1]
	JMP desce_meteoro

TECLA_7:	;aumenta o valor da energia
	POP R11
	CALL aumenta_energia
	CALL ha_tecla
	JMP varre_teclado
	
TECLA_B:	;dimunui o valor da energia
	POP R11
	CALL diminui_energia
	CALL ha_tecla
	JMP varre_teclado

erro_display:
	CALL set_display
	POP R1
	JMP varre_teclado

; **********************************************************************
; * ROTINAS
; **********************************************************************

; **********************************************************************
; set_display - escreve nos display o valor da energia
; Argumentos:	R1 - Displays
;			    R4 - valor da energia convertida para decimal
;
; Retorna:	nada
; **********************************************************************

set_display:			
	PUSH R1
	
	MOV R1, DISPLAYS
	CALL hexToDec_Convert
	MOV [R1], R4
	
	POP R1
	RET

; **********************************************************************
; aumenta_energia - Aumenta a energia na memória em 1
; Argumentos:	R7 - valor da energia em hexadecimal
;
; Retorna:	R7 - novo valor de energia (valor atual = valor anterior + 1)
; **********************************************************************

aumenta_energia:		
	ADD	R7, 1			; Aumenta a energia na memória em 1
	CALL set_display 
	CALL delay_loop
	RET

; **********************************************************************
; diminui_energia - Diminui a energia na memória em 1
; Argumentos:	R7 - valor da energia em hexadecimal
;
; Retorna:	R7 - novo valor de energia (valor atual = valor anterior - 1)
; **********************************************************************

diminui_energia:
	PUSH R1
	MOV  R1, 0
	CMP  R1, R7
	JZ   erro_display
	SUB	 R7, 1			; Diminui a energia na memória em 1
	CALL set_display 
	CALL delay_loop
	POP R1
	RET

; **********************************************************************
; delay_loop e delay_aux - Rotinas que permitem ter um atraso entre duas ações
;                           Fazendo sucessivas subtrações
; Argumentos:	R2 - valor de delay (DELAY EQU 9999H)
;
; Retorna:	nada
; **********************************************************************

delay_loop:
	PUSH R2
	MOV  R2, DELAY

delay_aux:
	SUB R2, 1
	CMP R2, 0
	JNZ delay_aux
	POP R2
	RET

; **********************************************************************
; hexToDec_Convert - converte numeros hexadecimais para decimal
;                           converte o numero em R4 e deixa-o em R4
; Argumentos:	R1 - variavel auxiliar na conversao de hexadecimal para decimal
;               R4 - valor da energia em hexadecimal
;               R8 - registo auxiliar para executar a conversão
;               R7 - valor da energia em hexadecimal guardado em memória
;
; Retorna:	R4 - valor da energia em decimal (já convertido)
; **********************************************************************

hexToDec_Convert:
	PUSH R1
	PUSH R8					
	PUSH R2
	
	MOV R4, R7
	MOV R1, EXTODEC_MODULE
	MOV R8, R7
	DIV R4, R1 		; coloca o algarismo das dezenas em decimal em R1
	MOD R8, R1 		; coloca o algarismo das unidades em decimal em R2
	MOV R2, R4
	DIV R4, R1
	
	MOD R2, R1

	SHL R2, 4
	SHL R4, 8
	OR  R8, R2
	OR  R4, R8		; coloca o numero em decimal em R1
	
	POP R2
	POP R8
	POP R1
	RET


; **********************************************************************
; desenha_rover e desenha_r - rotinas para desenhar o rover no ecrã
;										desenha o rover de baixo para cima
;                          
; Argumentos:	R1 - linha do rover
;               R2 - conteúdo em memória da coluna do rover
;				R3 - cor do pixel
;               R4 - endereço da tabela que define o rover
;				R5 - largura do rover
;				R7 - altura do rover
;
; Retorna:	nada
; **********************************************************************

desenha_rover:
	PUSH R1
	PUSH R2

	MOV  R1, LINHA_ROVER		
	MOV  R2, [COLUNA_ROVER]
	
	CALL desenha_r
	
	POP R2
	POP R1
	CALL delay_loop
	CALL delay_loop
	RET

desenha_r:
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7
	MOV  R7, ALTURA_ROVER
	MOV	 R4, DEF_ROVER		    
	ADD	 R4, 2		; endereço da cor do 1º pixel (2 porque a largura é uma word)

	desenha_boneco:		; desenha o boneco a partir da tabela
		MOV	R5, LARGURA_ROVER

	desenha_pixels:       			; desenha os pixels do boneco a partir da tabela
		MOV	R3, [R4]				; obtém a cor do próximo pixel do boneco
		MOV  [DEFINE_LINHA], R1		; seleciona a linha
		MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
		MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
		ADD	R4, 2			    	; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1              	; próxima coluna
		SUB  R5, 1			   		; menos uma coluna para tratar
	JNZ  desenha_pixels         	; continua até percorrer toda a largura do objeto

	SUB R1, 1				; depois de desenhada uma linha do rover passar-se-á para a linha anterior
	MOV R2, [COLUNA_ROVER]	; reseta o valor da coluna (volta à coluna original)
	SUB R7, 1				; diminui a altura do rover em 1, uma vez que uma linha já está desenhada
	JNZ desenha_boneco		; continua até percorrer todo o boneco
	POP R7
	POP R5
	POP R4
	POP R3
	RET

; **********************************************************************
; apaga_rover - rotina para apagar o rover que posteriormente irá ser desenhado em pixeis adjacentes
;                          
; Argumentos:	R1 - linha do rover
;               R2 - conteúdo em memória da coluna do rover
;				R3
;				R5 - largura do rover
;				R7 - altura do rover
;
; Retorna:	nada
; **********************************************************************

apaga_rover:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R7
	
	MOV  R3, 0
	MOV  R1, LINHA_ROVER
	MOV  R2, [COLUNA_ROVER]
	MOV  R7, ALTURA_ROVER

	LOOP2:
		desenha_rover_2:       		; desenha o rover a partir da tabela
			MOV	R5, LARGURA_ROVER	; obtém a largura do rover

		desenha_pixels2:       			; desenha os pixels do rover a partir da tabela
			MOV  [DEFINE_LINHA], R1		; seleciona a linha
			MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
			MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
			ADD  R2, 1              	; próxima coluna
			SUB  R5, 1			    	; menos uma coluna para tratar
		JNZ  desenha_pixels2         	; continua até percorrer toda a largura do objeto

		SUB R1, 1					; menos uma linha para tratar
		MOV R2, [COLUNA_ROVER]		; reseta o valor da coluna (volta à coluna original)
		SUB R7, 1					; diminui a altura do rover em 1, uma vez que uma linha já está apagada
		JNZ desenha_rover_2

	POP R7
	POP R5
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; desenha_inimigo_5 e desenha_i5 - rotinas para desenhar o meteoro mau de tamanho 5 (maior) no ecrã
;										desenha o meteoro de baixo para cima
;                          
; Argumentos:	R1 - conteúdo em memória da linha do meteoro
;               R2 - coluna do meteoro
;				R3 - cor do pixel
;               R4 - endereço da tabela que define o meteoro
;				R5 - largura do meteoro
;				R7 - altura do meteoro
;
; Retorna:	nada
; **********************************************************************

desenha_inimigo_5:
	PUSH R1
	PUSH R2

	MOV  R1, [LINHA_METEORO_1]
	MOV  R2, 15		   				
	
	CALL desenha_i5	

	POP R2
	POP R1
	CALL delay_loop
	CALL delay_loop
	RET
	
desenha_i5:
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7
	
	MOV R7, ALTURA_INIMIGO_5
	MOV	R4, DEF_INIMIGO_5	
	ADD	R4, 2			    ; endereço da cor do 1º pixel (2 porque a largura é uma word)
	
	desenha_boneco5:       			; desenha o meteoro a partir da tabela
		MOV	R5, LARGURA_INIMIGO_4_5	; obtém a largura do meteoro
		
	desenha_pixels5:       			; desenha os pixels do meteoro a partir da tabela
		MOV	R3, [R4]				; obtém a cor do próximo pixel do meteoro
		MOV [DEFINE_LINHA], R1		; seleciona a linha
		MOV [DEFINE_COLUNA], R2		; seleciona a coluna
		MOV [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
		ADD	R4, 2			    	; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD R2, 1             		; próxima coluna
		SUB R5, 1			    	; menos uma coluna para tratar
	JNZ  desenha_pixels5			; continua até percorrer toda a largura do objeto
	
	SUB R1, 1	; depois de desenhada uma linha do meteoro passar-se-á para a linha anterior				
	MOV R2, 15	; reseta a coluna do meteoro
	SUB R7, 1	; diminui um de altura ao meteoro pois uma linha já foi totalmente desenhada
	CMP R1, -1
	JLT sair
	JNZ desenha_boneco5
	
	
	POP R7
	POP R5
	POP R4
	POP R3
	RET
sair:
	POP R7
	POP R5
	POP R4
	POP R3
	RET


; **********************************************************************
; apaga_inimigo5 - rotina para apagar o meteoro que posteriormente irá ser desenhado em pixeis adjacentes
;                          
; Argumentos:	R1 - linha do meteoro
;               R2 - conteúdo em memória da coluna do meteoro
;				R3
;				R5 - largura do meteoro
;				R7 - altura do meteoro
;
; Retorna:	nada
; **********************************************************************

apaga_inimigo5:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R7
	
	MOV R3, 0
	MOV R1, [LINHA_METEORO_1]
	MOV R2, 15		
	MOV R7, ALTURA_INIMIGO_5
	ADD R7, 1

	LOOP55:
		desenha_boneco55:       		; desenha o meteoro a partir da tabela
			MOV	R5, LARGURA_INIMIGO_4_5	; obtém a largura do meteoro

		desenha_pixels55:       		; desenha os pixels do meteoro a partir da tabela
			MOV  [DEFINE_LINHA], R1		; seleciona a linha
			MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
			MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
			ADD  R2, 1              	; próxima coluna
			SUB  R5, 1			    	; menos uma coluna para tratar
		JNZ  desenha_pixels55         	; continua até percorrer toda a largura do objeto

		SUB R1, 1	; depois de apagada uma linha do meteoro passar-se-á para a linha anterior
		MOV R2, 15	; reseta a coluna do meteoro
		SUB R7, 1	; diminui um de altura ao meteoro pois uma linha já foi totalmente apagada
		JNZ desenha_boneco55

	POP R7
	POP R5
	POP R3
	POP R2
	POP R1
	RET

fim:
	JMP fim
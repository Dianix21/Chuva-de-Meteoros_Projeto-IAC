; *****************************************************************************
; * Projeto realizado no âmbito da disciplina de 
; *			Introdução à Arquitetura de Computadores
; *                   pelo GRUPO 16 constituído por:
; *                                 Diana Goulão 102531
; *                                 Miguel Azevedo Alves 102630
; *
; *                      		CHUVA DE METEOROS
; *****************************************************************************

; *****************************************************************************
; * 							Constantes
; *****************************************************************************

; constantes do teclado
TEC_LIN    EQU 0C000H 	; endereço das linhas do teclado
TEC_COL    EQU 0E000H	; endereço das colunas do teclado
LINHA      EQU 8       	; linha a testar (4ª linha, 1000b)
MASCARA    EQU 0FH     	; máscara para isolar os 4 bits de menor peso, ao ler o teclado

; constantes de controlo relacionado com o media center (cenários e sons)
SELECIONA_CENARIO_FUNDO EQU 6042H   ; endereço do comando para selecionar uma imagem de fundo
SELECIONA_AUDIO			EQU 605AH	; endereço do comando para selecionar um som
APAGA_AVISO     		EQU 6040H	; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 			EQU 6002H	; endereço do comando para apagar todos os pixels já desenhados
PARA_SOM 				EQU 6066H	; endereço do comando que termina a reprodução do som/vídeo especificado

; constantes auxiliares do desenho de objetos (rover e meteoros) e do controlo do ecrã
DEFINE_LINHA   		EQU 600AH   ; endereço do comando para definir a linha
DEFINE_COLUNA   	EQU 600CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL    	EQU 6012H   ; endereço do comando para escrever um pixel
PIXEL_COM_COR		EQU 6014H	; endereço que especifica a cor da caneta
COR_PIXEL			EQU 6010H	; endereço que especifica o auto-increment

MAX_COLUNA			EQU 57		; coluna maxima até onde o rover pode andar (não corresponde ao limite do 
										; ecrã pois o pixel de referência do rover é o do canto inferior esquerdo)
MIN_COLUNA			EQU 0		; coluna minima do ecrã
MAX_LINHA			EQU 32		; Linha maxima 

; cores
LARANJA		        EQU 0FF70H		; cor do pixel: Laranja em ARGB (cor usada no rover)
VERMELHO			EQU 0FF00H		; cor do pixel: Vermelho em ARGB (cor usada nos meteoros maus)
AZUL				EQU 0F26FH		; cor do pixel: Azul em ARGB (cor usada em ambos os tipos de meteoros)
CINZA				EQU 0FDDDH		; cor do pixel: Cinzento em ARGB (cor usada nos meteoros que se encontram longe - tamanhos 1x1 e 2x2)
AZUL_MISSIL			EQU 0F37FH		; cor do pixel: Azul em ARGB (cor usada nos mísseis)
VERDE				EQU 0F6D0H		; cor do pixel: Verde em ARGB (cor usada nos meteoros bons)

; constantes do rover, meteoros e missil
LARGURA_ROVER       EQU 7		; largura do rover
ALTURA_ROVER		EQU 5		; altura do rover
LINHA_ROVER        	EQU 31		; linha do rover
COLUNA_INI_ROVER	EQU 29		; Coluna base do rover de forma a ser desenhado no centro do ecrã

ALTURA_METEORO_1	EQU 1		; altura dos meteoros de tamanho 1
LARGURA_METEORO_1	EQU 1		; largura dos meteoros de tamanho 1

LARGURA_METEORO_2	EQU 2		; largura dos meteoros de tamanho 2
ALTURA_METEORO_2	EQU 2		; altura dos meteoros de tamanho 2

LARGURA_METEORO_3	EQU 3		; largura dos meteoros de tamanho 3
ALTURA_METEORO_3	EQU 3		; altura dos meteoros de tamanho 3

LARGURA_MET_4_5		EQU 4		; largura dos meteoros de tamanho 4 e 5
ALTURA_METEORO_4	EQU 4		; altura dos meteoros de tamanho 4
ALTURA_METEORO_5	EQU 6		; altura dos meteoros de tamanho 5

MISSIL_LIN			EQU 0019H	; linha inicial do missil (topo da nave)
MISSIL_LIN_MAX		EQU 000AH	; Alcance máximo do missil (faz no máximo 12 movimentos)

; constantes de estado do programa
EM_JOGO				EQU 0000H 	; estado do programa enquanto está a decorrer o jogo
ESTADO_MENU			EQU 0001H	; estado do programa enquanto se encontra nos menus de inicio, dos créditos e do manual do utilizador
EM_PAUSA			EQU 0002H	; estado do programa enquanto se encontra no ecrã de pausa
GAME_OVER_ENERGIA	EQU 0003H	; estado do programa enquanto se encontra no ecrã de game over sem energia 
GAME_OVER_COLISAO	EQU 0004H	; estado do programa enquanto se encontra no ecrã de game over por colisão

; constantes referentes à energia
ENERGIA_MIN			EQU 0000H	; valor mínimo de energia que o rover pode ter
ENERGIA_MAX			EQU 0064H	; valor inicial de energia do rover (corresponde a 100 em decimal)
PERDA_ENERGIA 		EQU 0005H	; valor do decremento temporal da energia

; outras constantes
DISPLAYS   			EQU 0A000H	; endereço dos displays de 7 segmentos
EXTODEC_MODULE		EQU 000AH	; variavel auxiliar na conversao de hexadecimal para decimal (fator de divisão (10))
DELAY				EQU 3500H	; contante auxiliar para criar atraso entre ações

TRUE            	EQU 0001H 	; Estes EQUs ajudam numa melhor leitura do codigo, em comparacoes e atribuicoes de variaveis
FALSE           	EQU 0000H 	; 


; *********************************************************************************************
; * 										DADOS 
; *********************************************************************************************

PLACE       1000H

DEF_BONECO: WORD	0	;word onde é guardado o endereço da tabela de um boneco
LARGURA_BONECO: WORD	0	;largura, coluna e linha desse boneco
COLUNA_BONECO: WORD	0
LINHA_BONECO: WORD 0

LINHA_METEORO1: WORD  0		;linha dos meteoros respetivos
LINHA_METEORO2: WORD  0
LINHA_METEORO3: WORD  0
LINHA_METEORO4: WORD  0

COLUNA_METEORO1: WORD	1	;coluna dos meteoros
COLUNA_METEORO2: WORD	1
COLUNA_METEORO3: WORD	1
COLUNA_METEORO4: WORD	1

DESENHA_METEORO: WORD 1		;flag para o desenho de meteoros

; *********************************************************
; * definição do rover
; *********************************************************

DEF_ROVER:	; tabela que define o rover (dimensões e desenho (pixeis))
	WORD    LINHA_ROVER
	WORD 	COLUNA_INI_ROVER
	WORD	ALTURA_ROVER
	WORD	LARGURA_ROVER
	WORD	LARANJA, 0, LARANJA, LARANJA, LARANJA, 0, LARANJA
	WORD	LARANJA, LARANJA, LARANJA, LARANJA, LARANJA, LARANJA, LARANJA
	WORD	LARANJA, 0, LARANJA, 0, LARANJA, 0, LARANJA
	WORD	0, 0, LARANJA, LARANJA, LARANJA, 0, 0
	WORD	0, 0, 0, LARANJA, 0,0,0

; ********************************************************
; * definição dos meteoros mais pequenos (tamanho 1 e 2) 
; *                    onde ainda são indestinguiveis
; ********************************************************

DEF_METEORO_1: ; tabela que define os meteoros de tamanho 1 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_1
	WORD	LARGURA_METEORO_1
	WORD	CINZA

DEF_METEORO_2:	; tabela que define os meteoros de tamanho 2 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_2
	WORD	LARGURA_METEORO_2
	WORD	CINZA, CINZA
	WORD	CINZA, CINZA

; ********************************************************
; * defenição dos meteoros maus
; ********************************************************

DEF_INIMIGO_3:	; tabela que define os meteoros maus de tamanho 3 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_3
	WORD	LARGURA_METEORO_3
	WORD	VERMELHO, VERMELHO,0
	WORD	AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO

DEF_INIMIGO_4:	; tabela que define os meteoros maus de tamanho 4 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_4
	WORD	LARGURA_MET_4_5
	WORD	VERMELHO, 0, VERMELHO, 0
	WORD	VERMELHO, VERMELHO, VERMELHO, VERMELHO	
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO, VERMELHO, 0


DEF_INIMIGO_5:	; tabela que define os meteoros maus de tamanho 5 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_5
	WORD	LARGURA_MET_4_5
	WORD	VERMELHO, 0, VERMELHO, 0
	WORD	VERMELHO, VERMELHO, VERMELHO, 0
	WORD	VERMELHO, VERMELHO, VERMELHO, VERMELHO
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	AZUL, AZUL, VERMELHO, VERMELHO
	WORD	VERMELHO, VERMELHO, VERMELHO, 0

; ********************************************************
; * defenição dos meteoros bons
; ********************************************************

DEF_MET_3:	; tabela que define os meteoros bons de tamanho 3 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_3
	WORD	LARGURA_METEORO_3
	WORD	VERDE, VERDE,0
	WORD	AZUL, VERDE, VERDE
	WORD	VERDE, VERDE

DEF_MET_4:	; tabela que define os meteoros bons de tamanho 4 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_4
	WORD	LARGURA_MET_4_5
	WORD	VERDE, 0, VERDE, 0
	WORD	VERDE, VERDE, VERDE, VERDE
	WORD	AZUL, AZUL, VERDE, VERDE
	WORD	VERDE, VERDE, VERDE, 0

DEF_MET_5:	; tabela que define os meteoros bons de tamanho 5 (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_5
	WORD	LARGURA_MET_4_5
	WORD	VERDE, 0, VERDE, 0
	WORD	VERDE, VERDE, VERDE, 0
	WORD	VERDE, VERDE, VERDE, VERDE
	WORD	AZUL, AZUL, VERDE, VERDE
	WORD	AZUL, AZUL, VERDE, VERDE
	WORD	VERDE, VERDE, VERDE, 0

METEORO_1:
	WORD 0	;LINHA
	WORD 0	;COLUNA
	WORD DEF_METEORO_1
	WORD 0000H			; Tipo do meteoro (0 se for mau, 1 se for bom)

METEORO_2:
	WORD 0	;LINHA
	WORD 0	;COLUNA
	WORD DEF_METEORO_1
	WORD 0000H			; Tipo do meteoro (0 se for mau, 1 se for bom)

METEORO_3:
	WORD 0	;LINHA
	WORD 0	;COLUNA
	WORD DEF_METEORO_1
	WORD 0000H			; Tipo do meteoro (0 se for mau, 1 se for bom)

METEORO_4:
	WORD 0	;LINHA
	WORD 0	;COLUNA
	WORD DEF_METEORO_1
	WORD 0000H			; Tipo do meteoro (0 se for mau, 1 se for bom)

METEORO_DESTRUIDO:	; tabela que define o meteoro quando explodido por um missil (dimensões e desenho (pixeis))
	WORD	10
	WORD	10
	WORD	ALTURA_METEORO_4
	WORD	LARGURA_MET_4_5
	WORD	AZUL_MISSIL, 0, AZUL_MISSIL, 0
	WORD	AZUL_MISSIL, AZUL_MISSIL, AZUL_MISSIL, AZUL_MISSIL
	WORD	0, CINZA, 0, 0
	WORD	CINZA, 0, CINZA, 0

; ********************************************************
; * Inicialização do Stack pointer
; ********************************************************

pilha:
	STACK 1000H		; espaco reservado para a pilha 

SP_inicial:

; ********************************************************
; * Inicialização da tabela das rotinas de interrupção
; ********************************************************

tab:
	WORD int_meteoro	; rotina de atendimento da interrupção 0 - responsavel por mover o meteoro
	WORD int_missil		; rotina de atendimento da interrupção 1 - responsavel por mover o míssil
	WORD int_energia	; rotina de atendimento da interrupção 2 - responsavel por descer a energia

; *********************************************************************************************
; * 								DECLARAÇÃO DE VARIÁVEIS
; *********************************************************************************************

COLUNA_MISSIL: WORD 0

ESTADO_PROG: WORD ESTADO_MENU	; variável do estado do programa iniciada no estado do menu

MOVE_METEORO: WORD FALSE	; variável que funciona como flag que permite caso esteja TRUE o movimento do meteoro (ativa pela interrupção)

ATUALIZA_ENERGIA: WORD FALSE	; variável que funciona como flag que permite caso esteja TRUE o decremento da energia (ativa pela interrupção)
ENERGIA_MISSIL:	WORD FALSE		; variável que funciona como flag que permite caso esteja TRUE a alteração da energia (ativa pela colisão de um missil com um meteoro)
ENERGIA: WORD ENERGIA_MAX		; energia do rover ao longo do programa inicializada a 100 (Máximo)

LINHA_MISSIL: WORD MISSIL_LIN	; linha onde se encontra o míssil
MOVE_MISSIL:   WORD FALSE		; variável que funciona como flag que permite caso esteja TRUE o movimento do missil (ativa pela interrupção)
CRIAR_MISSIL: WORD FALSE		; variável que funciona como flag que permite caso esteja TRUE a criação do missil (ativa pela TECLA_1)

NUMERO_ALEATORIO: WORD 15	; número pseudo-aleatório responsável pela coluna dos meteoros

; *********************************************************************************************
; * 										CÓDIGO
; *********************************************************************************************

PLACE      0

inicio:	; inicializações
    MOV SP, SP_inicial	; inicializa SP para a palavra a seguir a ultima da pilha
	MOV BTE, tab		; inicializa BTE (registo de Base da Tabela de Exceções)
	
	CALL reset_display	; reseta a energia dos displays (coloca a energia a zero)
	CALL tela_inicial	; estado do prgrama - Menu inicial - pronto a começar o jogo

    MOV R1, 2
	MOV [SELECIONA_AUDIO], R1	; reproduz o áudio "capa"
	
	EI					; permite interrupções (geral)
	EI0					; permite interrupções 0
	EI1					; permite interrupções 1
	EI2					; permite interrupções 2

    MOV  R2, TEC_LIN    ; endereço do periférico das linhas
    MOV  R3, TEC_COL    ; endereço do periférico das colunas
    MOV  R5, MASCARA    ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, LINHA	    ; para poder alterar a linha a ser testada
	MOV  R10, 0		    ; coordenada da tecla
	MOV  R11, 0000H	    ; compara teclas

espera_tecla_A_3_5:		; neste ciclo espera-se até uma das teclas ser premida
	MOV  R1, 0001H		; testar a linha 1 (para verificar se a tecla 3 pode estar premida)
	MOVB [R2], R1		; escrever no periférico de saída (linhas)
	MOVB R0, [R3]		; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JNZ A_3_OU_5		; se sim vai verificar qual
	
	MOV  R1, 0002H		; testar a linha 2 (para verificar se a tecla 5 pode estar premida)
	MOVB [R2], R1		; escrever no periférico de saída (linhas)
	MOVB R0, [R3]		; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JNZ A_3_OU_5		; se sim vai verificar qual

	MOV R1, 0004H		; testar a linha 3 (para verificar se a tecla A pode estar premida)
	MOVB [R2], R1		; escrever no periférico de saída (linhas)
	MOVB R0, [R3]		; ler do periférico de entrada (colunas)
	AND  R0, R5			; elimina bits para além dos bits 0-3
	CMP  R0, 0			; há tecla premida?
	JNZ A_3_OU_5		; se sim vai verificar qual
	JMP espera_tecla_A_3_5	; se nenhuma tecla premida, repete

	A_3_OU_5:
		SHL R1, 4			; coloca linha no nibble high
		OR  R1, R0			; junta coluna (nibble low)
		MOV R11, 0044H		; coloca no registo 11 o valor da tecla A para posterior comparação
		CMP R1, R11			; a tecla premida é a tecla A?
		JZ inicia_jogo	
		MOV R11, 0018H
		CMP R1, R11			
		JZ ecra_creditos	; a tecla premida é a tecla 3?
		MOV R11, 0022H
		CMP R1, R11
		JZ manual_utilizador	; a tecla premida é a tecla 5?
	JMP espera_tecla_A_3_5

ecra_creditos:	; caso em que a tecla 3 é premida
	MOV R1, 5			                ; cenário de fundo número 5 - "creditos"
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV [SELECIONA_AUDIO], R1
	JMP varre_teclado

manual_utilizador:	; caso em que a tecla 5 é premida
	MOV R1, 6			                ; cenário de fundo número 6 - "manual do utilidador"
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV [SELECIONA_AUDIO], R1
	JMP varre_teclado


inicia_jogo:
	MOV R0, 1 
	MOV [SELECIONA_CENARIO_FUNDO], R0	; muda para o cenário 1 (ecran_jogo)
	
	EI					; permite interrupções (geral)
	EI0					; permite interrupções 0
	EI1					; permite interrupções 1
	EI2					; permite interrupções 2
	
	CALL reset_meteoros			; reseta todas as variáveis dos meteoros
	CALL reset_rover			; reseta todas as variáveis do rover
	CALL update_estado_prog		; atualiza o estado do programa para EM_JOGO
	CALL set_energia			; coloca a energia no seu valor inicial
	CALL desenha_rover			; desenha o rove na posição inicial (centro do ecrã)
	CALL cria_colunas			; gera colunas pseudo-aleatórias para futuramente desenhar meteoros
	

; corpo principal do programa
; teclado
varre_teclado:	; função que percorre todo o teclado à espera de encontrar uma tecla premida e que executa a ação respetiva à tecla
				; NOTA: na nossa resolução do projeto, o teclado é varrido da última para a primeira linha
	ciclo:
		MOV R6, LINHA		; começa a varrer o teclado na linha LINHA (última linha do teclado (4ª linha))
		MOV R1, 0 
		MOV R10, R1
		JMP espera_tecla	
	
	nova_linha:
		CMP R6, 0	
		JZ ciclo	; se já foi precorrido o teclado todo e não houver tecla permida reinicia a leitura do teclado
		SHR R6, 1	; se o teclado ainda não foi totalmente precorrido avança agora para a linha anterior 
		
	espera_tecla:           ; este ciclo verifica se há uma tecla a ser premida numa determinada linha do teclado (acabando por ser o ciclo principla do programa)
		; efetua as ações controladas pelas interrupções
		CALL desce_meteoro		; efetua a ação do meteoro
		CALL diminui_energia	; efetua a ação da energia
		CALL move_missil		; efetua a ação do missil

		MOV  R1, R6         ; testar a linha em R6
		MOVB [R2], R1       ; escrever no periférico de saída (linhas)
		MOVB R0, [R3]       ; ler do periférico de entrada (colunas)
		AND  R0, R5         ; elimina bits para além dos bits 0-3
		CMP  R0, 0          ; há tecla premida?
		JZ nova_linha     	; se nenhuma tecla estiver premida, na linha R6, avança para a linha anterior
		
		; se uma tecla estiver premida nesta linha
		SHL  R1, 4          ; coloca linha no nibble high
		OR   R1, R0         ; junta coluna (nibble low)
		MOV  R10, R1        ; guarda a coordenada da tecla permida em R10
		
		JMP analisa_tecla
	
	analisa_tecla:	; analiza as coodenadas da tecla premita e efetua as funções especificas dessa tecla
		MOV R11, 0011H
		CMP R10, R11
		JZ  TECLA_0
		MOV R11, 0012H
		CMP R10, R11
		JZ  TECLA_1
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
		JZ  TECLA_SEM_ACAO
		MOV R11, 0024H
		CMP R10, R11
		JZ  TECLA_6
		MOV R11, 0028H
		CMP R10, R11
		JZ  TECLA_SEM_ACAO
		MOV R11, 0041H
		CMP R10, R11
		JZ  TECLA_SEM_ACAO
		MOV R11, 0042H
		CMP R10, R11
		JZ  TECLA_SEM_ACAO
		MOV R11, 0044H
		CMP R10, R11
		JZ  TECLA_A
		MOV R11, 0048H
		CMP R10, R11
		JZ  TECLA_B
		MOV R11, 0081H
		CMP R10, R11
		JZ  TECLA_C
		MOV R11, 0082H
		CMP R10, R11
		JZ  TECLA_SEM_ACAO
		MOV R11, 0084H
		CMP R10, R11
		JZ  TECLA_SEM_ACAO
		MOV R11, 0088H
		CMP R10, R11
		JZ  TECLA_F
TECLA_SEM_ACAO: ; teclas sem nenhuma ação especifica 
	JMP varre_teclado

TECLA_0:	; rover anda para a esquerda
	CALL deslocamento_esquerda
	CALL delay_loop
	JMP varre_teclado		; volta a varrer o teclado (para que o rover ande enquanto a tecla estiver permida)

TECLA_2:	; rover anda para a direita
	CALL deslocamento_direita
	CALL delay_loop
	JMP varre_teclado		; volta a varrer o teclado (para que o rover ande enquanto a tecla estiver permida)

TECLA_1:	; ativa a flag da criação do missil ficando este pronto a disparar (disparo controlado pela interrupção)
	CALL cria_missil
	CALL diminui_energia
	JMP varre_teclado

TECLA_6:	; sai dos menus de créditos e manual de utilizador
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, ESTADO_MENU		; verifica se se encontra num menu
	JNZ varre_teclado		; só efetua as ações pretendidas caso esteja num dos menus
	MOV R1, 5
	MOV [PARA_SOM], R1		; pára o som dos créditos
	MOV R1, 6
	MOV [PARA_SOM], R1		; pára o som do manual do utilizador
	JMP inicio

TECLA_A:	; tecla de recomeço do jogo após colisão do rover
	MOV R1, 1
	MOV [DESENHA_METEORO], R1
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, GAME_OVER_COLISAO	; verifica se se encontra no ecrã game_over por colisão
	JNZ varre_teclado			; só efetua as ações pretendidas caso esteja neste ecrã
	CALL RESET_LINHAS
	JMP inicia_jogo

TECLA_B:	; tecla de STOP - Para o jogo e reinicia-o	
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, EM_JOGO		; verifica se se encontra em jogo
	JNZ varre_teclado	; só efetua as ações pretendidas caso esteja neste estado
	CALL RESET_LINHAS
	JMP inicio

TECLA_F:	; tecla de recomeço do jogo após rover ficar sem energia
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, GAME_OVER_ENERGIA	; verifica se se encontra no ecrã game_over por falta de energia
	JNZ varre_teclado			; só efetua as ações pretendidas caso esteja neste estado
	CALL RESET_LINHAS
	JMP inicia_jogo

TECLA_C:	; TECLA DE PAUSA - permite reniciar o jogo ou retomar de onde parou
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, EM_JOGO		; verifica se se encontra em jogo
	JNZ varre_teclado	; só efetua as ações pretendidas caso esteja neste estado

	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R11
	PUSH R6
	PUSH R7

	MOV R1, 0					; reproduz o áudio "pausa"
	MOV [SELECIONA_AUDIO], R1

; desativa as interrupções
	DI0
	DI1
	DI2
	CALL apaga_rover
	CALL apaga_missil
	CALL apaga_todos_inimigos

	MOV R1, 4
	MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário "menu_pausa"
	MOV  R2, TEC_LIN    ; endereço do periférico das linhas
    MOV  R3, TEC_COL    ; endereço do periférico das colunas
    MOV  R5, MASCARA    ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

	espera_tecla_B_D:		; neste ciclo espera-se até uma destas tecla ser premida
		MOV  R1, 0004H		; testar a linha 4 
		MOVB [R2], R1		; escrever no periférico de saída (linhas)
		MOVB R0, [R3]		; ler do periférico de entrada (colunas)
		AND  R0, R5			; elimina bits para além dos bits 0-3
		CMP  R0, 0			; há tecla premida?
		JNZ B_OU_D
		
		MOV R1, 0008H
		MOVB [R2], R1		; escrever no periférico de saída (linhas)
		MOVB R0, [R3]		; ler do periférico de entrada (colunas)
		AND  R0, R5			; elimina bits para além dos bits 0-3
		CMP  R0, 0			; há tecla premida?
		JNZ B_OU_D
		JMP espera_tecla_B_D	; se nenhuma tecla premida, repete

		B_OU_D:
			SHL R1, 4			; coloca linha no nibble high
			OR  R1, R0			; junta coluna (nibble low)
			MOV R11, 0048H	
			CMP R1, R11			; a tecla premida é a tecla B?
			JZ TECLA_B		
			MOV R11, 0082H
			CMP R1, R11			; a tecla premida é a tecla D?
			JZ RECOMECA	
		JMP espera_tecla_B_D
		
	RECOMECA:
		MOV R1, 1		; mostra o cenário "Ecran_jogo"
		MOV [SELECIONA_CENARIO_FUNDO], R1	
		CALL desenha_rover	; volta a desenhar o rover onde estava

	; volta a ligar as interrupções
		EI0
		EI1
		EI2
		
	POP R7
	POP R6	
	POP R11
	POP R5
	POP R3
	POP R2
	POP R1
	POP R0
	JMP varre_teclado

; *********************************************************************************************
; * 										ROTINAS
; *********************************************************************************************

; **********************************************************************
; * ROTINAS - MISSIL
; **********************************************************************

; **********************************************************************
; cria_missil - rotina responsável por ativar a flag para criar um missil, 
;							obtendo também a coluna onde o missil irá ser criado
; Argumentos:	R1 e R0 - registos auxiliares para verificar o estado do programa
;				R3 - endereço da tabela que define o rover
;
; Retorna:	nada
; **********************************************************************

cria_missil:
	PUSH R0
	PUSH R1
	PUSH R3

	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, EM_JOGO	; verifica se se encontra em jogo
	JNZ return		; só ativa a flag caso esteja neste estado
	

	MOV R0, CRIAR_MISSIL
	MOV R1, [R0]
	CMP R1, TRUE	; verifica se a flag ainda se encontra ativa
	JZ return		; se ainda se encontrar ativa não efetua ação - 
					;  - não permite mais que um missil de cada vez

	; se passou em todas as verificações ativa as flags CRIA_MISSIL e ENERGIA_MISSIL
	MOV R0, CRIAR_MISSIL
	MOV R1, TRUE			
	MOV [R0], R1

	MOV R0, ENERGIA_MISSIL
	MOV R1, TRUE
	MOV [R0], R1
	; obtém coluna onde o misil vai ser desenhado
	MOV R3, DEF_ROVER
	ADD R3, 2
	MOV R0, [R3]
	ADD R0, 3
	MOV [COLUNA_MISSIL], R0

	MOV R1, 4	; reproduz o som "som_missil"
	MOV [SELECIONA_AUDIO], R1

return:
	POP R3
	POP R1 
	POP R0
	RET

; **********************************************************************
; move_missil - rotina responsável por todo o processamento do meteoro -
;					- movimento (desenha e apaga), controlando o alcance e colisões
;
; Argumentos:	R0, R1, R2 e R3 - registos auxiliares para verificar o estado do programa e  de flag
;				R8 - coluna_missil
;				R9 - cor do pixel de auxilio para detetar colisões
;
; Retorna:	nada
; **********************************************************************

move_missil:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R8
	PUSH R9
	
	MOV R8, [COLUNA_MISSIL]

	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, EM_JOGO
	JNZ falha_missil	; verifica se o programa se encontra no estado EM_JOGO

	MOV R3, [LINHA_MISSIL]
	MOV R2, MISSIL_LIN_MAX
	CMP R2, R3
	JZ falha_missil		; verifica se o missil ainda se pode mover (este tem alcance controlado)

	MOV R0, MOVE_MISSIL
	MOV R1, [R0]
	CMP R1, TRUE
	JNZ fim_missil 		; Verifica se a interrupão do missil está ativa

	MOV R0, CRIAR_MISSIL
	MOV R1, [R0]
	CMP R1, TRUE
	JNZ fim_missil	; Verifica se a flag do missil está ativa, permitindo a criação do missil

	CALL apaga_missil
	
	desenha_missil:
		MOV [DEFINE_LINHA], R3		; seleciona a linha
		MOV [DEFINE_COLUNA], R8		; seleciona a coluna
		MOV R2, [COR_PIXEL]
		MOV R9, VERMELHO
		CMP R2, R9
		JZ colisao_missil	; verifica se há colisão com meteoro mau (vermelho) - analisando a cor para onde quer desenhar
		MOV R9, VERDE
		CMP R2, R9
		JZ colisao_met_bom	; verifica se há colisão com meteoro bom (verde) - analisando a cor para onde quer desenhar
		;caso não haja colisão desenha o missil uma linha aceima
		MOV R2, AZUL_MISSIL	
		MOV [DEFINE_PIXEL], R2	; altera a cor do pixel
		
		SUB R3, 1				; anda um pixel para cima
		MOV [LINHA_MISSIL], R3
		JMP fim_missil

	falha_missil:	; quando o missil atinge o alcance máximo: 
		CALL apaga_missil
		MOV R1, MISSIL_LIN
		MOV [LINHA_MISSIL], R1	; - renicia o valor da linha 

		MOV R0, CRIAR_MISSIL
		MOV R1, FALSE
		MOV [R0], R1	; desativa a flag do CRIA_MISSIL (não há missil criado)
		JMP fim_missil 

	colisao_missil:	 ; colisão do missil com um meteoro mau
		MOV R1, 3					; reproduz o áudio "meteoro_destruido"
		MOV [SELECIONA_AUDIO], R1
		CALL aumenta_energia
		CALL atualiza_flag_missil
		CALL apaga_missil
		CALL apaga_atingido
		CALL apaga_rover
		CALL desenha_rover
		JMP fim_missil
		
	colisao_met_bom:	; colisão do missil com um meteoro bom
		MOV R1, 3					; reproduz o áudio "meteoro_destruido"
		MOV [SELECIONA_AUDIO], R1
		CALL atualiza_flag_missil
		CALL apaga_missil
		CALL apaga_atingido
		CALL apaga_rover
		CALL desenha_rover
		
	fim_missil:
		MOV R0, MOVE_MISSIL
		MOV R1, FALSE
		MOV [R0], R1		; atualiza a flag MOVE_MISSIL que será ativada pela interrupção

		POP R9
		POP R8
		POP R3
		POP R2
		POP R1
		POP R0
		RET

; **********************************************************************
; apaga_missil - rotina responsável apagar o pixel do missil
;
; Argumentos:	R2 - cor do pixel - 0 pois estamos a apagar
;				R3 - Linha do missil
;				R8 - coluna do missil
;
; Retorna:	nada
; **********************************************************************

apaga_missil:
	MOV R2, 0					; cor do pixel (transoparente - para apagar)
	MOV R3, [LINHA_MISSIL]		; linha onde o missil se encontra
	ADD R3, 1
	MOV [DEFINE_LINHA], R3		; seleciona a linha
	MOV [DEFINE_COLUNA], R8		; seleciona a coluna
	MOV [DEFINE_PIXEL], R2		; altera a cor do pixel na linha e coluna selecionadas
	SUB R3, 1
	RET

; **********************************************************************
; apaga_atingido -  apaga o meteoro atingido pelo missil
;
; Argumentos:	R2 - cor do pixel - 0 pois estamos a apagar
;				R3 - Linha do missil
;				R8 - coluna do missil
;
; Retorna:	nada
; **********************************************************************

apaga_atingido:	; apaga o meteoro atingido pelo missil
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	
	MOV R1, [COLUNA_MISSIL]
	MOV R2, COLUNA_METEORO1
	MOV R3, LARGURA_MET_4_5
	MOV R4, [R2]
	ADD R3, R4
	MOV R5, 1
	MOV R6, DESENHA_METEORO
	MOV R7, LINHA_METEORO1
	
	procura:			; procura o meteoro que atingiu
		CMP R4, R1
		JZ encontrou
		CMP R4, R3
		JGE proximo
		ADD R4, 1
		JMP procura
		
	proximo:		; se não encontrou passa para o próximo 
		ADD R5, 1
		ADD R2, 2
		ADD R7, 2
		MOV R4, [R2]
		MOV R3, LARGURA_MET_4_5
		ADD R3, R4
		JMP procura
		
	encontrou:	; caso o tenha encontrado apaga-o, mostrando um desenho de como foi destruido
		MOV R3, METEORO_DESTRUIDO
		MOV R4, [R2]
		

		MOV R1, DEF_INIMIGO_5
		MOV R8, [R7]
		MOV [R1], R8
		MOV [R3], R8
		
		ADD R1, 2
		ADD R3, 2
		MOV [R1], R4
		MOV [R3], R4
		ADD R1, 2
		MOV R5, [R1]
		ADD R5, 1
		MOV [R1], R5 
		SUB R1, 4
		
		MOV [DEF_BONECO], R1
		CALL apaga
		
		MOV R3, METEORO_DESTRUIDO		
		MOV [DEF_BONECO], R3
		CALL desenha
		
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		CALL delay_loop
		
		CALL apaga
		ADD R1, 4
		MOV R5, [R1]
		SUB R5, 1
		MOV [R1], R5
		CALL gerador_de_numeros
		MOV R1, [NUMERO_ALEATORIO]
		MOV [R2], R1
		MOV R1, 0
		MOV [R7], R1
	
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; atualiza_flag_missil -  atualiza a flag do cria_missil permitindo criação de outro
;					reinicia também a linha do missil
;
; Argumentos:	R2 - linha inicial do missil
;				R0 e R1 - registos auxiliares para atualizar a flag
;
; Retorna:	nada
; **********************************************************************

atualiza_flag_missil:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0, CRIAR_MISSIL
	MOV R1, FALSE
	MOV [R0], R1

	MOV R2, MISSIL_LIN
	MOV [LINHA_MISSIL], R2		; atualiza a linha onde o missil se encontra

	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************
; * ROTINAS - ROVER
; **********************************************************************

; **********************************************************************
; deslocamento_esquerda - deslocamento do rover (movimento contínuo) - 
;							rover anda para a esquerda
; Argumentos:	R1 - coluna do rover
;			    R2 - limite esquerdo do ecrã (coluna mínima)
;
; Retorna:	nada
; **********************************************************************

deslocamento_esquerda:
	PUSH R3
	PUSH R2
	PUSH R1

	MOV R2, ESTADO_PROG
	MOV R1, [R2]
	CMP R1, EM_JOGO
	JNZ falha_rover_esq		; caso o programa não se encontre EM_JOGO
	
	MOV R3, DEF_ROVER
	ADD R3, 2
	MOV R1, [R3]
	MOV R2, MIN_COLUNA
	CMP R1, R2	
	JLE falha_rover_esq		; caso o rover esteja o mais à esquerda possivel no ecrã não anda mais

	CALL apaga_rover		; caso consiga andar, apaga o rover dos pixeis onde este se encontre
	SUB R1, 1				; anda um pixel para o lado esquerdo
	MOV [R3], R1
	CALL desenha_rover		; volta a desenhar o rover agora um pixel mais à esquerda
	
falha_rover_esq:
	POP R1
	POP R2
	POP R3
	RET

; **********************************************************************
; deslocamento_direita - deslocamento do rover (movimento contínuo) - rover anda para a direita
; Argumentos:	R1 - coluna do rover
;			    R2 - limite direito do ecrã (coluna máxima)
;
; Retorna:	nada
; **********************************************************************

deslocamento_direita:
	PUSH R3
	PUSH R2
	PUSH R1

	MOV R2, ESTADO_PROG
	MOV R1, [R2]
	CMP R1, EM_JOGO
	JNZ falha_rover_dir		; caso o programa não se encontre EM_JOGO

	MOV R3, DEF_ROVER
	ADD R3, 2
	MOV R1, [R3]
	MOV R2, MAX_COLUNA
	CMP R2, R1
	JLE falha_rover_dir		; caso o rover esteja o mais à direita possivel no ecrã não anda mais

	CALL apaga_rover		; caso consiga andar, apaga o rover dos pixeis onde este se encontre
	ADD R1, 1				; anda um pixel para o lado direito
	MOV [R3], R1
	CALL desenha_rover		; volta a desenhar o rover agora um pixel mais à direita
	
falha_rover_dir:	
	POP R1
	POP R2
	POP R3
	RET

; **********************************************************************
; * ROTINAS - ENERGIA E DISPLAYS
; **********************************************************************

; **********************************************************************
; reset_display e reset_energia - reseta os display e o valor da energia em memória
; Argumentos:	R0 - Displays e energia em memória
;			    R1 - energia máxima
;
; Retorna:	nada
; **********************************************************************

reset_display:
	PUSH R0
	PUSH R1
	MOV R0, DISPLAYS
	MOV R1, 0
	MOV [R0], R1
	
reset_energia:
	MOV R0, ENERGIA
	MOV R1, ENERGIA_MAX
	MOV [R0], R1
	POP R1
	POP R0
	RET

; **********************************************************************
; set_display - escreve nos display o valor da energia
; Argumentos:	R0 - Displays
;			    R1 - valor da energia convertida para decimal
;
; Retorna:	nada
; **********************************************************************

set_display:			
	MOV R0, DISPLAYS
	CALL hexToDec_Convert
	MOV [R0], R1
	
	RET

; **********************************************************************
; set_energia - escreve nos display o valor da energia inicial (100)
; Argumentos:	R0 - Displays
;			    R1 - valor da energia convertida para decimal
;
; Retorna:	nada
; **********************************************************************

set_energia:
	PUSH R0
	PUSH R1
	MOV R0, ENERGIA
	MOV R1, ENERGIA_MAX
	MOV [R0], R1
	MOV R0, DISPLAYS
	MOV R1, ENERGIA_MAX
	CALL hexToDec_Convert
	MOV [R0], R1
	POP R1
	POP R0
	RET

; **********************************************************************
; aumenta_energia - Aumenta a energia na memória em 5
; Argumentos:	R0 - valor da energia em memória
;				R1 - Valores auxiliares para defenir o som e o incremento da energia
;
; Retorna:	nada
; **********************************************************************

aumenta_energia:
	PUSH R0
	PUSH R1 

	MOV R1, 7		; reproduz o som "1UP"
	MOV [SELECIONA_AUDIO], R1

	MOV R0, ENERGIA
	MOV R1, [R0]
	ADD R1, 5
	MOV [R0], R1

	CALL set_display
	
	POP R1
	POP R0
	RET

; **********************************************************************
; diminui_energia - Diminui a energia na memória em 1
; Argumentos: R1 e R0 - registos auxiliares para verificar o estado do programa e de flag
;			  R0 - Energia do rover em memória	
;			  R7 - valor da energia minima (0)
;
; Retorna:	nada
; **********************************************************************

diminui_energia:
	PUSH R0
	PUSH R1
	PUSH R7
	
	MOV R0, ESTADO_PROG
	MOV R1, [R0]
	CMP R1, EM_JOGO
	JNZ fim_diminui			; verifica o estado do programa

	MOV R0, ENERGIA_MISSIL
	MOV R1, [R0]
	CMP R1, TRUE
	JZ diminui_energia_aux	; Verifica se a flag da energia_missil está ativa - caso tenha sido desparado um missil

	MOV R0, ATUALIZA_ENERGIA
	MOV R1, [R0]
	CMP R1, TRUE
	JNZ fim_diminui 		; Verifica se a interrupão da energia está ativa

	diminui_energia_aux:
		MOV R0, ENERGIA
		MOV R1, [R0]
		MOV R7, ENERGIA_MIN
		CMP R1, R7
		JZ sem_energia		; Verifica se a energia já chegou a zero

		SUB	 R1, PERDA_ENERGIA	; Diminui a energia na memória em 5
		MOV [R0], R1

		CALL set_display

		JMP fim_diminui

	sem_energia:
		DI
		DI0
		DI1
		DI2
		MOV [APAGA_ECRA], R1	            ; apaga todos os pixels já desenhados
		MOV R1, 9
		MOV [SELECIONA_AUDIO], R1	; reproduz o áudio "capa"
		MOV  R1, 2			                ; cenário de fundo número 2 - "sem_bateria"
		MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
		MOV R0, ESTADO_PROG
		MOV R1, GAME_OVER_ENERGIA
		MOV [R0], R1						; altera o estado do programa para game over por ficar sem energia

	fim_diminui: ; atualiza as flag necessárias
		MOV R0, ATUALIZA_ENERGIA
		MOV R1, FALSE
		MOV [R0], R1			

		MOV R0, ENERGIA_MISSIL
		MOV R1, FALSE
		MOV [R0], R1

		POP R7
		POP R1
		POP R0
		RET

; **********************************************************************
; hexToDec_Convert - converte numeros hexadecimais para decimal
;                           converte o numero em R4 e deixa-o em R4
; Argumentos:	R0 - variavel auxiliar na conversao de hexadecimal para decimal (fator (10))
;               R8 - registo auxiliar para executar a conversão (valor do digito das dezenas)
;               R2 - registo auxiliar para executar a conversão (valor do digito das unidades)
;				R1 - valor da energia em memória
;
; Retorna:
; **********************************************************************

hexToDec_Convert:
	PUSH R0
	PUSH R8					
	PUSH R2
	
	MOV R0, EXTODEC_MODULE
	MOV R8, R1		; obtem os digitos das centenas e dezenas
	DIV R1, R0 		; coloca o algarismo das centenas em R1
	MOD R8, R0 		; coloca o algarismo das dezenas R8
	
	MOV R2, R1
	DIV R1, R0
	MOD R2, R0		; coloca o algarismo das unidades em R2

	SHL R2, 4
	SHL R1, 8
	OR  R8, R2		; junta os algarismos das dezenas e unidades
	OR  R1, R8		; coloca o numero completo em decimal em R1
	
	POP R2
	POP R8
	POP R0
	RET

; **********************************************************************
; * ROTINAS - METEOROS
; **********************************************************************

; **********************************************************************
; desce_meteoro - deslocamento do meteoro - desce linha a linha o meteoro
; Argumentos:	R1 - linha do meteoro
;			    R2 - linha máxima do ecrã
;				R3 - valor de linhas auxiliar 
;				R4 e R5 - Registos auxiliares para verificar o estado do programa
;
; Retorna:	nada
; **********************************************************************

desce_meteoro:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7 ;CONTADOR
	PUSH R8
	PUSH R9
	
	MOV R4, ESTADO_PROG
	MOV R5, [R4]
	CMP R5, EM_JOGO		;verifica se o programa está em modo jogo
	JNZ fim_meteoro

	MOV R4, MOVE_METEORO
	MOV R5, [R4]
	CMP R5, FALSE		;verifica se a flag de movimento do meteoro está ativa
	JZ fim_meteoro
	
	MOV R7, 0
	MOV R8, LINHA_METEORO1
	MOV R6, COLUNA_METEORO1
	
	desce:
		ADD R7, 1
		MOV R1, [DESENHA_METEORO]
		CMP R1, 0
		JZ fim_meteoro
		MOV R1, [R6]
		MOV R9, [R8]
		MOV [COLUNA_BONECO], R1
		MOV [LINHA_BONECO], R9
		CALL apaga_inimigo
		CALL configura_inimigo

		MOV R1, [R8]
		CMP R1, 6
		JGE teste
		JMP continua
		teste:
			CMP R7, 4
			JZ desenha_bom
		continua:
		MOV R1, [R8]
		MOV R2, MAX_LINHA
		CMP R1, R2
		JGE FALHA
		; caso o meteoro já esteja no fundo do ecrã
		ADD R1, 1					; caso possa andar, anda uma linha para baixo
		MOV [R8], R1
		MOV R3, 3
		CMP R3, R1
		JGT draw_met_1				;verifica qual o tipo de meteoro que desenha
		MOV R3, 7
		CMP R3, R1
		JGT draw_met_2
		MOV R3, 11
		CMP R3, R1
		JGT draw_met_3
		MOV R3, 18
		CMP R3, R1
		JGT draw_met_4
		JMP draw_met_5


		draw_met_1:		;desenha meteoros do tipo 1 e atualiza a flag
			CALL desenha_met_1
			JMP update_met_flag

		draw_met_2:		;desenha meteoros do tipo 2 e atualiza a flag
			CALL desenha_met_2
			JMP update_met_flag

		draw_met_3:		;desenha meteoros do tipo 3 e atualiza a flag
			CALL desenha_inimigo_3
			JMP update_met_flag

		draw_met_4:		;desenha meteoros do tipo 4 e atualiza a flag
			CALL desenha_inimigo_4
			JMP update_met_flag

		draw_met_5:		;desenha meteoros do tipo 5 e atualiza a flag
			CALL desenha_inimigo_5
			JMP update_met_flag

		; testa o limites inferior do ecrã
		FALHA:	; caso o meteoro chegue ao fundo da tela volta ao topo do ecrã
			MOV R1, 0
			MOV [R8], R1
			CALL gerador_de_numeros
			MOV R1, [NUMERO_ALEATORIO]
			MOV [R6], R1
		
		update_met_flag:
			MOV R4, MOVE_METEORO
			MOV R5, FALSE
			MOV [R4], R5
			
		proximo_met:
			ADD R6, 2
			ADD R8, 2
			CMP R7, 4
			JNZ desce
			
	JMP fim_meteoro
	
	desenha_bom:
		MOV R1, [R8]
		MOV R2, MAX_LINHA
		CMP R1, R2
		JGE FALHA_BOM
		; caso o meteoro já esteja no fundo do ecrã
		ADD R1, 1					; caso possa andar, anda uma linha para baixo
		MOV [R8], R1
		MOV R3, 3
		CMP R3, R1
		MOV R1, [R8]
		MOV R3, 11
		CMP R3, R1
		JGT draw_metbom_3
		MOV R3, 18
		CMP R3, R1
		JGT draw_metbom_4
		JMP draw_metbom_5
		
		draw_metbom_3:		;desenha meteoros do tipo 3 e atualiza a flag
			CALL desenha_metbom_3
			JMP update_met_flag_bom

		draw_metbom_4:		;desenha meteoros do tipo 4 e atualiza a flag
			CALL desenha_metbom_4
			JMP update_met_flag_bom

		draw_metbom_5:		;desenha meteoros do tipo 5 e atualiza a flag
			CALL desenha_metbom_5
			JMP update_met_flag_bom
		
		FALHA_BOM:
			MOV R1, 0
			MOV [R8], R1
			CALL gerador_de_numeros
			MOV R1, [NUMERO_ALEATORIO]
			MOV [R6], R1
		update_met_flag_bom:
			MOV R4, MOVE_METEORO
			MOV R5, FALSE
			MOV [R4], R5

	fim_meteoro:
		POP R9
		POP R8
		POP R7
		POP R6
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
	RET

; **********************************************************************
; cria_colunas - rotina responsável por gerar colunas pseudo-aleatórias para
;						cada um dos futuros meteoros
; Argumentos:	R1 - valor aleatório gerado pelo gerador_de_numeros
;			    R2 - endereço da tabela do meteoro correspondente 
;
; Retorna: nada
; **********************************************************************

cria_colunas:
	PUSH R1
	PUSH R2
	
	CALL gerador_de_numeros		;atribui coluna ao meteoro 1
	MOV R1, [NUMERO_ALEATORIO]
	MOV R2, METEORO_1
	MOV [R2], R1	
	MOV [COLUNA_METEORO1], R1
	
	
	CALL gerador_de_numeros		;atribui coluna ao meteoro 2
	MOV R1, [NUMERO_ALEATORIO]
	MOV R2, METEORO_2
	MOV [R2], R1	
	MOV [COLUNA_METEORO2], R1
	
	CALL gerador_de_numeros		;atribui coluna ao meteoro 3
	MOV R1, [NUMERO_ALEATORIO]
	MOV R2, METEORO_3
	MOV [R2], R1	
	MOV [COLUNA_METEORO3], R1

	CALL gerador_de_numeros		;atribui coluna ao meteoro 4
	MOV R1, [NUMERO_ALEATORIO]
	MOV R2, METEORO_4
	MOV [R2], R1	
	MOV [COLUNA_METEORO4], R1
	
	POP R2
	POP R1
	RET

; **********************************************************************
; configura_inimigo - rotina responsável por atualizar as tabelas dos meteoros
;						com as novas colunas
; Argumentos:	R1 - endereço da tabela do meteoro correspondente 
;			    R2 - valor da nova coluna do meteoro
;
; Retorna: nada
; **********************************************************************

configura_inimigo:
	PUSH R1
	PUSH R2
	PUSH R3
	
	MOV  R2, [COLUNA_BONECO]
	MOV R3, [LINHA_BONECO]
	
	MOV R1, DEF_METEORO_1	;atribuição da coluna e linha ao meteoro do tipo 1
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_METEORO_2	;atribuição da coluna e linha ao meteoro do tipo 2
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_INIMIGO_3	;atribuição da coluna e linha ao meteoro do tipo 3
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_INIMIGO_4	;atribuição da coluna e linha ao meteoro do tipo 4
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_INIMIGO_5	;atribuição da coluna e linha ao meteoro do tipo 5
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_MET_3	;atribuição da coluna e linha ao meteoro bom do tipo 3
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	MOV R1, DEF_MET_4	;atribuição da coluna e linha ao meteoro bom do tipo 4
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2

	MOV R1, DEF_MET_5	;atribuição da coluna e linha ao meteoro bom do tipo 5
	MOV [R1], R3
	ADD R1, 2
	MOV [R1], R2
	
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; RESET_LINHAS - rotina responsável por atualizar as linhas dos meteoros
;						com as novas linhas
; Argumentos:	R1 - novo valor da linha
;
; Retorna: nada
; **********************************************************************

RESET_LINHAS:
	PUSH R1
	MOV R1, 0
	MOV [LINHA_METEORO1], R1
	MOV [LINHA_METEORO2], R1
	MOV [LINHA_METEORO3], R1
	MOV [LINHA_METEORO4], R1
	POP R1
	RET
; **********************************************************************
; desenha_met_x - rotina responsável por desenhar meteoros de tipo x
;					nota que x é um valor entre 1 e 5
; Argumentos:	R1 - endereço da tabela do meteoro correspondente 
;			    R2 - valor da linha ou coluna do meteoro
;				R3 - contador de quantos meteoros já desenhou
;				R4 - endereço da tabela com as colunas dos meteoros
;
; Retorna: nada
; **********************************************************************

desenha_met_1:
	PUSH R1
	MOV R1, DEF_METEORO_1
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET

desenha_met_2:
	PUSH R1
	MOV R1, DEF_METEORO_2
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET

desenha_inimigo_3:
	PUSH R1
	MOV R1, DEF_INIMIGO_3
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET

desenha_inimigo_4:
	PUSH R1
	MOV R1, DEF_INIMIGO_4
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET
	

desenha_inimigo_5:
	PUSH R1
	MOV R1, DEF_INIMIGO_5
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET

desenha_metbom_3:
	PUSH R1
	MOV R1, DEF_MET_3
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET
	
desenha_metbom_4:
	PUSH R1
	MOV R1, DEF_MET_4
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET
	
desenha_metbom_5:
	PUSH R1
	MOV R1, DEF_MET_5
	MOV [DEF_BONECO], R1
	CALL desenha
	POP R1
	RET
	

; **********************************************************************
; * ROTINAS - DESENHA E APAGA
; **********************************************************************

; **********************************************************************
; apaga - rotinas para apagar qualquer objeto no ecrã (rover e meteoros)
;
; Argumentos:	R0 - tabela que define o boneco a apagar
;				R1 - tabela que define o boneco a apagar (auxiliar)
;				R2 - coluna do boneco
;				R3 - cor do pixel
;				R5 - largura do boneco (auxiliar)
;				R7 - altura do boneco
;				R8 - largura do boneco
;
; Retorna:	nada
; **********************************************************************

apaga:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R5
	PUSH R7
	PUSH R8
	
	MOV R0, [DEF_BONECO]	; obtém a tabela que define o ogbjeto a desenhar/ apagar
	; retira da tabela todos os dados necessários para desenhar/apagar o objeto
	MOV R1, [R0]
	ADD R0, 2
	MOV R2, [R0]
	MOV [COLUNA_BONECO], R2	; obtém coluna do ojeto
	ADD R0, 2
	MOV R7, [R0] 	; obtém altura do ojeto
	ADD R0, 2
	MOV R8, [R0]
	MOV [LARGURA_BONECO], R8 ; obtém largura do ojeto
	MOV  R3, 0
	

	LOOP:
		loop_apaga:       		; desenha o objeto a partir da tabela
			MOV	R5, [LARGURA_BONECO]	; obtém a largura do objeto

		apaga_pixel:       			; desenha os pixels do objeto a partir da tabela
			MOV  [DEFINE_LINHA], R1		; seleciona a linha
			MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
			MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
			ADD  R2, 1              	; próxima coluna
			SUB  R5, 1			    	; menos uma coluna para tratar
		JNZ apaga_pixel         	; continua até percorrer toda a largura do objeto

		SUB R1, 1					; menos uma linha para tratar
		MOV R2, [COLUNA_BONECO]		; reseta o valor da coluna (volta à coluna original)
		SUB R7, 1					; diminui a altura do objeto em 1, uma vez que uma linha já está apagada
		JNZ loop_apaga

	POP R8
	POP R7
	POP R5
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
; **********************************************************************
; desenha - rotinaa para desenhar qualquer objeto no ecrã a partir do
;				endereço da sua tabela

; Argumentos:	R0 - endereço da tabela do boneco a desenhar
;				R1 - linha do boneco
;				R2 - coluna do boneco
;				R3 - cor do pixel existente no ecra (se exitir)
;				R4 - variavel auxiliar
;				R5 - largura do boneco
;				R7 - altura do boneco
;				R8 - linha máxima do ecrã
;				R9 - variavél para comparar cores
;
; Retorna:	nada
; **********************************************************************
desenha:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7
	PUSH R8
	PUSH R9	
	
	MOV R0, [DEF_BONECO] ; ENDEREÇO DA TABELA
	MOV R1, [R0] ;LINHA
	ADD R0, 2
	MOV R2, [R0] ;COLUNA
	MOV [COLUNA_BONECO], R2
	ADD R0, 2
	MOV R7, [R0]  ; ALTURA
	ADD	 R0, 2		; endereço da cor do 1º pixel (2 porque a largura é uma word)
	MOV R4, [R0]
	MOV [LARGURA_BONECO], R4
	ADD R0, 2	
	
	desenha_boneco:		; desenha o boneco a partir da tabela

		MOV	R5, [LARGURA_BONECO]

	desenha_pixels:       			; desenha os pixels do boneco a partir da tabela
		MOV  [DEFINE_LINHA], R1		; seleciona a linha
		MOV  [DEFINE_COLUNA], R2	; seleciona a coluna
		
		MOV R3, [COR_PIXEL]
		MOV R9, LARANJA				;verifica se o pixel existente é laranja
		CMP R3, R9
		JZ COLISAO_ROVER
		MOV R9, VERMELHO			;verifica se o pixel existente é vermelho
		CMP R3, R9
		JZ COLISAO_ROVER
		MOV R9, VERDE				;verifica se o pixel existente é verde
		CMP R3, R9
		JZ COLISAO_ROVER
		
		MOV	R3, [R0]				; obtém a cor do próximo pixel do boneco
		MOV  [DEFINE_PIXEL], R3		; altera a cor do pixel na linha e coluna selecionadas
		ADD	R0, 2			    	; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
		ADD  R2, 1              	; próxima coluna
		SUB  R5, 1			   		; menos uma coluna para tratar
		
	JNZ desenha_pixels         	; continua até percorrer toda a largura do objeto
	
	MOV R2, [COLUNA_BONECO]	; reseta o valor da coluna (volta à coluna original)
	SUB R1, 1				; depois de desenhada uma linha do rover passar-se-á para a linha anterior
	SUB R7, 1				; diminui a altura do rover em 1, uma vez que uma linha já está desenhada
	JNZ desenha_boneco		; continua até percorrer todo o boneco
	
	JMP SAIR
	
	COLISAO_ROVER:

		MOV R0, [DEF_BONECO]
		MOV R1, DEF_MET_5		;verifica se está a desenhar um meteorito
		CMP R0, R1
		JNZ verificacao2
				
		
		colide_met_bom:		;rover colide com meteoro bom
			MOV R0, 0
			MOV [LINHA_METEORO4], R0	;desliga flag do meteoro 4
			CALL gerador_de_numeros
			MOV  R0, [NUMERO_ALEATORIO]
			MOV [COLUNA_METEORO4], R0
			CALL apaga
			CALL apaga_rover
			CALL aumenta_energia
			CALL aumenta_energia
			CALL desenha_rover
			JMP SAIR
		
		verificacao2:
			MOV R1, DEF_ROVER	;verifica se está a desenhar o rover
			CMP R0, R1
			JNZ colide
			MOV R0, DEF_MET_5
			MOV [DEF_BONECO], R0		
			
			MOV R0, VERDE
			CMP R3, R0
			JZ colide_met_bom
		
		
		colide:		;houve colisao
			DI0
			DI1
			DI2
			MOV R0, 0
			MOV [DESENHA_METEORO], R0
			CALL apaga_todos_inimigos
			CALL apaga_rover
			CALL reset_jogo
			CALL game_over
			JMP SAIR
	
	SAIR:
		POP R9
		POP R8
		POP R7
		POP R5
		POP R4
		POP R3
		POP R2
		POP R1
		POP R0
	RET

; **********************************************************************
; desenha_rover - rotina que passa os argumentos necessários ao desenho do rover
;      
; Argumentos:	R1 - tabela que define o rover
;
; Retorna:	nada
; **********************************************************************

desenha_rover:
	PUSH R1
	
	MOV R1, DEF_ROVER
	MOV [DEF_BONECO], R1
	POP R1
	
	CALL desenha
	
	CALL delay_loop
	RET

; **********************************************************************
; apaga_rover - rotina que passa os argumentos necessários ao apagar do rover
;      
; Argumentos:	R1 - tabela que define o rover
;
; Retorna:	nada
; **********************************************************************

apaga_rover:
	PUSH R1
	
	MOV R1, DEF_ROVER
	MOV [DEF_BONECO], R1
	CALL apaga
	
	POP R1
	RET

; **********************************************************************
; apaga_inimigo - rotina responsável por passar os argumentos necessários para apagas os meteoros
; Argumentos:	R1 - tabela que define o meteoro a apagar
;               R2 - linhas dos meteoros
;				R3 - contador - verificar se já passou pelos 4 meteoros
;				R4 - colunas dos meteoros
;				R5 - flags responsáveis pelo desenho dos meteoros
;
; Retorna:	nada
; **********************************************************************

apaga_inimigo:
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	
	MOV R3, DEF_INIMIGO_5
	MOV R4, [COLUNA_BONECO]
	MOV R5, [LINHA_BONECO]
	SUB R5, 1
	
	apaga_met:	; loop que irá passar por todos os meteoros para os apagar
		
		MOV [DEF_BONECO], R3
		MOV [R3], R5 ;LINHA
		ADD R3, 2
		MOV [R3], R4 ;COLUNA
		ADD R3, 2
		MOV R2, [R3]
		ADD R2, 1
		MOV [R3], R2
		SUB R2, 1
		CALL apaga
		MOV [R3], R2
		
	POP R5
	POP R4
	POP R3
	POP R2
	RET
	
apaga_todos_inimigos:
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	
	MOV R3, DEF_INIMIGO_5	
	MOV R4, [COLUNA_METEORO1]
	MOV R5, [LINHA_METEORO1]
	
	MOV [DEF_BONECO], R3
	MOV [R3], R5
	ADD R3, 2
	MOV [R3], R4
	ADD R3, 2
	MOV R2, [R3]
	ADD R2, 1
	MOV [R3], R2
	CALL apaga
	SUB R2, 1
	MOV [R3], R2
	
	MOV R3, DEF_INIMIGO_5
	MOV R4, [COLUNA_METEORO2]
	MOV R5, [LINHA_METEORO2]
	
	MOV [DEF_BONECO], R3
	MOV [R3], R5
	ADD R3, 2
	MOV [R3], R4
	ADD R3, 2
	MOV R2, [R3]
	ADD R2, 1
	MOV [R3], R2
	CALL apaga
	SUB R2, 1
	MOV [R3], R2
	
	MOV R3, DEF_INIMIGO_5
	MOV R4, [COLUNA_METEORO3]
	MOV R5, [LINHA_METEORO3]
	
	MOV [DEF_BONECO], R3
	MOV [R3], R5
	ADD R3, 2
	MOV [R3], R4
	ADD R3, 2
	MOV R2, [R3]
	ADD R2, 1
	MOV [R3], R2
	CALL apaga
	SUB R2, 1
	MOV [R3], R2
	
	MOV R3, DEF_INIMIGO_5
	MOV R4, [COLUNA_METEORO4]
	MOV R5, [LINHA_METEORO4]
	
	MOV [DEF_BONECO], R3
	MOV [R3], R5
	ADD R3, 2
	MOV [R3], R4
	ADD R3, 2
	MOV R2, [R3]
	ADD R2, 1
	MOV [R3], R2
	CALL apaga
	SUB R2, 1
	MOV [R3], R2
	
	POP R5
	POP R4
	POP R3
	POP R2
	RET
; **********************************************************************
; * ROTINAS - ESTADO DO JOGO (ECRÃS)
; **********************************************************************

; **********************************************************************
; update_estado_prog - atualiza o estdo do programa para o estado EM_JOGO          
; Argumentos: R4 - Estado do programa
;			  R5 - estado EM_JOGO
;
; Retorna:	Nada
; **********************************************************************

update_estado_prog:
	PUSH R4
	PUSH R5

	MOV R4, ESTADO_PROG
	MOV R5, EM_JOGO
	MOV [R4], R5

	POP R5
	POP R4
	RET

; **********************************************************************
; game_over - apresenta o ecrã de GAME OVER quando o rover colide com um meteoro mau 
;									atualizando o estado do programa para GAME_OVER         
; Argumentos: R1 - cénário
;			  R0 - vídeo para o ecrã de GAME OVER
;			  R2 - volume do vídeo
;			  R4 - Estado do programa
;			  R5 - estado GAME_OVER_ENERGIA
;
; Retorna:	R1 - Novo cenário
; **********************************************************************

game_over:
	PUSH R0
	PUSH R2
	PUSH R4
	PUSH R5

	MOV R4, ESTADO_PROG
	MOV R5, GAME_OVER_COLISAO	; atualiza os estado do programa para game over por colisão
	MOV [R4], R5

	MOV [APAGA_ECRA], R1	            ; apaga todos os pixels já desenhados 
	MOV R1, 1							
	MOV [SELECIONA_AUDIO], R1			; reproduz o video "rover_explodiu"
    MOV R1, 3			                ; cenário de fundo número 3 - "Ecran_perdeu"
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	
	POP R5
	POP R4
	POP R2
	POP R0
	RET

; **********************************************************************
; * OUTRAS ROTINAS
; **********************************************************************

; **********************************************************************
; tela_inicial - Rotinas que efetua todas as ações necessárias para apresentar 
;               a tela de inicio do jogo, reniciando as variaveis necessárias, atualizando
;				o estado do programa e apresentando os cenários pretendidos
; Argumentos:	R0 e R2 - registos auxiliares para verificar o estado do programa e atualizá-lo
;
; Retorna:	nada
; **********************************************************************

tela_inicial:
	PUSH R0
	PUSH R2
	
	CALL reset_jogo
	CALL menu_inicial
	CALL reset_meteoros
	CALL reset_rover

	MOV R0, ESTADO_PROG
	MOV R2, ESTADO_MENU
	MOV [R0], R2		; Muda o estado do prorama para o estado menu

	POP R2
	POP R0
	RET

reset_jogo:	; limpa o ecrã
	PUSH R0 
	MOV [APAGA_AVISO], R0	            ; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV [APAGA_ECRA], R0	            ; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	POP R0
	RET

menu_inicial:	; apresenta o cenário "capa"
	PUSH R1
    MOV R1, 0			                ; cenário de fundo número 0 - "capa"
    MOV [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	POP R1
	RET

reset_meteoros:	; coloca os meteoros no topo do ecrã prontos a descer - sem desenhar
	PUSH R0
	MOV R0, 0
	MOV [LINHA_METEORO1], R0
	POP R0
	RET

reset_rover:	; coloca o rover na posição inicial (centro do ecrã) - sem desenhar
	PUSH R0
	PUSH R1
	MOV R1, DEF_ROVER
	ADD R1, 2
	MOV R0, COLUNA_INI_ROVER
	MOV [R1], R0
	POP R1
	POP R0
	RET	

; **********************************************************************
; gerador_de_numeros - Rotinas que gera numeros pseudo_aleatórios que serão 
;			futuramente associados a uma coluna de um meteoro
;
; Argumentos:	R9 - numero aleatório guardado em memória
;				R6 - fator auxiliar
;				R11 - coluna máxima do ecrã
;
; Retorna:	nada
; **********************************************************************

gerador_de_numeros:
	PUSH R9
	PUSH R6
	PUSH R11

	MOV R9, [NUMERO_ALEATORIO]
	MOV R6, 10
	ADD R9, R6
	MOV R11, MAX_COLUNA
	CMP R11, R9
	JN gerador_especial	; caso o valor aleatório seja superior à coluna máxima

	MOV [NUMERO_ALEATORIO], R9
	JMP fim_gerador

gerador_especial:
	SUB R9, R11
	MOV [NUMERO_ALEATORIO], R9

fim_gerador:
	POP R11
	POP R6
	POP R9
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

fim:
	JMP fim


; **********************************************************************
; * 					ROTINAS DE INTERRUPÇÃO
; **********************************************************************

; **********************************************************************
; int_meteoro - Rotina de atendimento da interrupção 0
;			Faz o meteoro descer uma linha. 
; **********************************************************************

int_meteoro:				; Aciona a flag responsável por mover os meteoros
	PUSH R3
	PUSH R4
	MOV R3, MOVE_METEORO
	MOV R4, TRUE
	MOV [R3], R4
	POP R4
	POP R3
	RFE	

; **********************************************************************
; int_missil - Rotina de atendimento da interrupção 1
;			Faz o míssil subir uma linha. 
; **********************************************************************

int_missil: 			; Aciona a flag responsável por mover o missil
	PUSH R3
	PUSH R4
	MOV R3, MOVE_MISSIL
	MOV R4, TRUE
	MOV [R3], R4
	POP R4
	POP R3
	RFE	

; **********************************************************************
; int_energia - Rotina de atendimento da interrupção 2
;			Faz o valor da energia do rover descer automaticamente.
; **********************************************************************

int_energia:					; Aciona a flag responsável por decrementar a energia
	PUSH R3
	PUSH R4
	MOV R3, ATUALIZA_ENERGIA
	MOV R4, TRUE
	MOV [R3], R4
	POP R4
	POP R3
	RFE	

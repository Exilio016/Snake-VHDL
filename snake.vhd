library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY snake IS

	PORT(
		clk, reset  : IN STD_LOGIC;
		key	      : IN STD_LOGIC_VECTOR(7 DOWNTO 0);	-- teclado
		
		vga_pos		      : out STD_LOGIC_VECTOR(15 downto 0);
		vga_char		      : out STD_LOGIC_VECTOR(15 downto 0);
		videoflag	      : out std_LOGIC;
		
		rand_dado	      : in STD_LOGIC_VECTOR (15 downto 0);
		rand_end	      : out STD_LOGIC_VECTOR (7 DOWNTO 0);	
		cen_dado	      : in STD_LOGIC_VECTOR (15 downto 0);
		cen_end		      : buffer STD_LOGIC_VECTOR (10 DOWNTO 0)	
		);

END  snake;

ARCHITECTURE a OF snake IS
	TYPE VECPOS IS ARRAY(2 DOWNTO 0) of STD_LOGIC_VECTOR(15 DOWNTO 0);

	-- Cobra
	SIGNAL COBRAPOS   : VECPOS;
	SIGNAL COBRAPOSA  : STD_LOGIC_VECTOR(15 DOWNTO 0); --POS ANTERIOR DA CAUDA
	SIGNAL COBRACHAR  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COBRACOR   : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL INCCOBRA   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SINAL      : STD_LOGIC;

	-- Comida
	SIGNAL COMIDAPOS     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL COMIDAPOSA    : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL COMIDACHAR    : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COMIDACOR     : STD_LOGIC_VECTOR(3 DOWNTO 0);

	--Delay da Cobra
	SIGNAL DELAY1      : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	--Estados
	SIGNAL COBRAESTADO  : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL COMIDAESTADO : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL VIDEOE       : STD_LOGIC_VECTOR(7 DOWNTO 0);

	--Sinais de controle
	SIGNAL FIMJOGO   : STD_LOGIC;
	SIGNAL CONTOU : STD_LOGIC;
	
	SIGNAL CONTADORE : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CONTADOR  : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

-- Maquina de Estados da cobra
PROCESS (clk, reset)

	VARIABLE COLISAO : STD_LOGIC;
	VARIABLE COMIDA : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	BEGIN
		
	IF RESET = '1' THEN
		COBRACHAR <= x"4F";
		COBRACOR  <= x"2";
		INCCOBRA <= x"01";
		SINAL <= '0';
		COBRAPOS(0) <= x"026C";
		COBRAPOS(1) <= x"026B";
		COBRAPOS(2) <= X"026A";
		CONTADOR <= x"00";
		
		COBRAESTADO <= x"02";
		COLISAO := '0';
		FIMJOGO <= '1';
 	
	ELSIF (clk'event) and (clk = '1') THEN

		CASE COBRAESTADO IS
		
			WHEN X"00" =>
			
				CASE key IS
					WHEN x"73" => -- (S) BAIXO
						IF (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 39) AND (COBRAPOS(0) < 1159) AND (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 0)) AND (COBRAPOS(0) > 39)) THEN   -- nao esta' na ultima linha
							IF INCCOBRA /= x"28" THEN
								INCCOBRA <= x"28";
								SINAL <= '0';
							END IF;							
						ELSE
							COLISAO := '1';
						END IF;
					WHEN x"77" => -- (W) CIMA
						IF (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 39) AND (COBRAPOS(0) < 1159) AND (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 0)) AND (COBRAPOS(0) > 39)) THEN   -- nao esta' na primeira linha
							IF INCCOBRA /= x"28" THEN
								INCCOBRA <= x"28";
								SINAL <= '1';
							END IF;
						ELSE
							COLISAO := '1';
						END IF;
					WHEN x"61" => -- (A) ESQUERDA
						IF (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 39) AND (COBRAPOS(0) < 1159) AND (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 0)) AND (COBRAPOS(0) > 39)) THEN   -- nao esta' na extrema esquerda
							IF INCCOBRA /= x"01" THEN
								INCCOBRA <= x"01";
								SINAL <= '1';
							END IF;
						ELSE
							COLISAO := '1';
						END IF;					
						WHEN x"64" => -- (D) DIREITA
						IF (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 39) AND (COBRAPOS(0) < 1159) AND (NOT((conv_integer(COBRAPOS(0)) MOD 40) = 0)) AND (COBRAPOS(0) > 39)) THEN   -- nao esta' na extrema direita
							IF INCCOBRA /= x"01" THEN	
								INCCOBRA <= x"01";
								SINAL <= '0';
							END IF;
						ELSE
							COLISAO := '1';
						END IF;
					WHEN OTHERS =>
							--Verifica colisao 
							IF (((conv_integer(COBRAPOS(0)) MOD 40) = 39) OR (COBRAPOS(0) > 1159) OR (((conv_integer(COBRAPOS(0)) MOD 40) = 0)) OR (COBRAPOS(0) < 39)) THEN
								COLISAO := '1';
							END IF;
						
				END CASE;

				COBRAPOSA <= COBRAPOS(2);
				COBRAPOS(2) <= COBRAPOS(1);
				COBRAPOS(1) <= COBRAPOS(0);
								
				IF (SINAL = '0') THEN COBRAPOS(0) <= COBRAPOS(0) + INCCOBRA;
				ELSE COBRAPOS(0) <= COBRAPOS(0) - INCCOBRA;
				END IF;
								
				IF ((COBRAPOS(0) = COMIDAPOSA)  AND (CONTOU = '0')) THEN
					CONTADOR <= CONTADOR + x"01";
					CONTOU <= '1';
					COMIDA := COMIDAPOSA;
				END IF;
									
				IF COLISAO = '0' THEN
					COBRAESTADO <= x"01";
				ELSE
					COBRAESTADO <= x"02";
				END IF;

				FIMJOGO <= COLISAO;
			
			WHEN x"01" => -- Delay para movimentar a cobra
			 
				IF DELAY1 >= x"000009C4" THEN
					DELAY1 <= x"00000000";
					COBRAESTADO <= x"00";
				ELSE
					DELAY1 <= DELAY1 + x"01";
				END IF;
				
				IF COMIDA /= COMIDAPOSA THEN
					CONTOU <= '0';
				END IF;

			WHEN x"02" => --Estado de fim de jogo			
				COLISAO := '0';
				CONTADOR <= x"00";
				INCCOBRA <= x"01";
				SINAL <= '0';
				COBRAPOS(0) <= x"026C";
				COBRAPOS(1) <= x"026B";
				COBRAPOS(2) <= X"026A";

				IF key = x"20" THEN
					FIMJOGO <= '0';
					COBRAESTADO <= x"00";
				END IF;
			
			WHEN OTHERS =>
				INCCOBRA <= x"01";
				COBRAPOS(0) <= x"026C";
				COBRAPOS(1) <= x"026B";
				COBRAPOS(2) <= X"026A";

				IF key = x"20" THEN
					FIMJOGO <= '0';
					COBRAESTADO <= x"00";
				END IF;
		END CASE;
	END IF;

END PROCESS;

-- Maquina de Estados da comida
PROCESS (clk, reset)

	VARIABLE INDICE: INTEGER;
	
	BEGIN
		
	IF RESET = '1' THEN
	rand_end <= x"00";
	COMIDACOR <= x"5";
	COMIDACHAR <= x"2A";
	COMIDAPOS  <= rand_dado;
	COMIDAPOSA <= rand_dado;
	COMIDAESTADO <= x"00";
	INDICE := 0;
	
		
	ELSIF (clk'event) and (clk = '1') THEN

		CASE COMIDAESTADO IS
			WHEN x"00" =>				
				--Estado inicial, esperando jogo iniciar
				rand_end <= x"00";
				COMIDAPOS  <= rand_dado;
				COMIDAPOSA <= rand_dado;
								
				IF FIMJOGO = '0' THEN
					COMIDAESTADO <= x"01";
					COMIDAPOSA  <= x"0000"; -- Zerando pos anterior, faz com que seja impresso na tela a comida
				END IF;
				
			WHEN x"01" =>
				--Estadado que aleatoriza a posiçao da comida
				INDICE := (INDICE+1) MOD 256;
				rand_end <= conv_std_logic_vector(INDICE, 8);

				IF COMIDAPOS = COBRAPOS(0) THEN
					COMIDAESTADO <= x"02";
				END IF;
				
			WHEN x"02" => --Estado que gera posiçao da comida
				COMIDAPOSA <= COMIDAPOS	;		
				COMIDAPOS <= rand_dado;

				INDICE := (INDICE + 1) MOD 256;
				
				IF FIMJOGO = '1' THEN
					COMIDAESTADO <= x"00";
				ELSE
					COMIDAESTADO <= x"01";
				END IF;
				
			WHEN OTHERS =>
				COMIDAESTADO <= x"00";
		END CASE;
	END IF;

END PROCESS;

-- Maquina de Estados da tela
PROCESS (clk, reset)

	VARIABLE INDICE: INTEGER;
	VARIABLE FIMCENARIO: STD_LOGIC;
	
	BEGIN
		
	IF RESET = '1' THEN
		cen_end <= "00000000000";
	
		VIDEOE <= x"00";
		vga_char <= cen_dado;
		vga_pos <= x"0000"; 
		videoflag <= '0';
		INDICE := 0;
		
		FIMCENARIO := '0';
		
	ELSIF (clk'event) and (clk = '1') THEN

		CASE VIDEOE IS
			WHEN x"00" =>
				IF FIMJOGO = '1' AND FIMCENARIO = '0' THEN --Se o jogo acabou imprimir cenario
					cen_end <= conv_std_logic_vector(INDICE, 11);
					vga_pos(10 DOWNTO 0) <= cen_end;
					vga_char <= cen_dado;
					videoflag <= '1';
				
					INDICE := ((INDICE + 1) MOD 1200);
					VIDEOE <= x"0C";
					
					IF INDICE = 1200 THEN
						FIMCENARIO := '1';
					END IF;
					
				ELSE
					VIDEOE <= x"01";
				END IF;
			
			WHEN x"01" => -- Apaga cauda
				INDICE := 0;
				FIMCENARIO := '0';

				IF(COBRAPOSA = COBRAPOS(2)) THEN
					VIDEOE <= x"04";
				ELSE
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= "0000";
					vga_char(7 downto 0) <= "00000000";
					
					vga_pos(15 downto 0)	<= COBRAPOSA;
					
					videoflag <= '1';
					VIDEOE <= x"05";
				END IF;

			WHEN x"05" => --Abaixa o flag
				VIDEOE <= x"02";
				videoflag <= '0';
			
			WHEN x"02" => -- Desenha cabeça
				IF(COBRAPOSA = COBRAPOS(2)) THEN
					VIDEOE <= x"04";
				ELSE
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= COBRACOR;
					vga_char(7 downto 0) <= COBRACHAR;
					
					vga_pos(15 downto 0)	<= COBRAPOS(0);
					
					videoflag <= '1';
					VIDEOE <= x"06";
				END IF;

			WHEN x"06" => --Abaixa o flag
				VIDEOE <= x"04";
				videoflag <= '0';
			
--			WHEN x"03" => -- Apaga comida
--				IF(COMIDAPOSA = COMIDAPOS) THEN
--					VIDEOE <= x"00";
--				ELSE
--					vga_char(15 downto 12) <= "0000";
--					vga_char(11 downto 8) <= "0000";
--					vga_char(7 downto 0) <= "00000000";
					
--					vga_pos(15 downto 0)	<= COMIDAPOSA;
					
--					videoflag <= '1';
--					VIDEOE <= x"07";
--				END IF;

--			WHEN x"07" => --Abaixa o flag
--				VIDEOE <= x"04";
--				videoflag <= '0';

			WHEN x"04" => -- Desenha comida
				IF(COMIDAPOSA = COMIDAPOS) THEN
					VIDEOE <= x"09";
				ELSE
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= COMIDACOR;
					vga_char(7 downto 0) <= COMIDACHAR;
					
					vga_pos(15 downto 0)	<= COMIDAPOS;
					
					videoflag <= '1';
					VIDEOE <= x"08";
				END IF;
		
			WHEN x"08" => --Abaixa o flag
				videoflag <= '0';
				VIDEOE <= x"09";
				
			WHEN x"09" => --Imprime contador (unidade)
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= COMIDACOR;
					vga_char(7 downto 0) <= x"30" + conv_std_logic_vector( conv_integer(CONTADOR) MOD 10, 8);
					
					vga_pos(15 downto 0)	<= x"0014";
					
					videoflag <= '1';
					VIDEOE <= x"0A";
				
			WHEN x"0A" => --Abaixa o flag
				videoflag <= '0';
				VIDEOE <= x"0B";
				
			WHEN x"0B" => --Imprime contador (Dezena)
					vga_char(15 downto 12) <= "0000";
					vga_char(11 downto 8) <= COMIDACOR;
					vga_char(7 downto 0) <= x"30" + conv_std_logic_vector( conv_integer(CONTADOR) / 10, 8);
					
					vga_pos(15 downto 0)	<= x"0013";
					
					videoflag <= '1';
					VIDEOE <= x"0C";
						
			WHEN x"0C" => --Abaixa o flag
				videoflag <= '0';
				VIDEOE <= x"00";
			
	
			WHEN OTHERS =>
				videoflag <= '0';
				VIDEOE <= x"00";
				
		END CASE;
	END IF;

END PROCESS;

END a;


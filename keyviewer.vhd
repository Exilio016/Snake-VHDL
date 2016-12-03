library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity keyviewer is
	port(
		clkvideo, clk, reset: in std_logic;
		key: in std_logic_vector(7 downto 0);
		videochar: out std_logic_vector(15 downto 0);
		videopos: out std_logic_vector(15 downto 0);
		videodraw: out std_logic
	);
end keyviewer;

architecture behav of keyviewer is
begin

   --escreve na tela
	signal videoe: std_logic_vector(7 downto 0);
	--contador de tempo
	
	--barra1
	signal barra1pos1: std_logic_vector(15 downto 0);
	signal barra1posa1: std_logic_vector(15 downto 0);
	signal barra1char1: std_logic_vector(7 downto 0);
	signal barra1cor1: std_logic_vector(3 downto 0);
	
	signal barra1pos2: std_logic_vector(15 downto 0);
	signal barra1posa2: std_logic_vector(15 downto 0);
	signal barra1char2: std_logic_vector(7 downto 0);
	signal barra1cor2: std_logic_vector(3 downto 0);
	
	signal barra1pos3: std_logic_vector(15 downto 0);
	signal barra1posa3: std_logic_vector(15 downto 0);
	signal barra1char3: std_logic_vector(7 downto 0);
	signal barra1cor3: std_logic_vector(3 downto 0);
	
	signal barra1pos4: std_logic_vector(15 downto 0);
	signal barra1posa4: std_logic_vector(15 downto 0);
	signal barra1char4: std_logic_vector(7 downto 0);
	signal barra1cor4: std_logic_vector(3 downto 0);
	
	signal barra1pos5: std_logic_vector(15 downto 0);
	signal barra1posa5: std_logic_vector(15 downto 0);
	signal barra1char5: std_logic_vector(7 downto 0);
	signal barra1cor5: std_logic_vector(3 downto 0);
	
	--bolinha
	signal bolapos: std_logic_vector(15 downto 0);
	signal bolaposa: std_logic_vector(15 downto 0);
	signal bolachar: std_logic_vector(7 downto 0);
	signal bolacor: std_logic_vector(3 downto 0);
	signal incbola: std_logic_vector(7 downto 0);
	signal sinal: std_logic;
	
	--delay da barra1
	signal delay1: std_logic_vector(31 downto 0);
	--delay da bola 
	signal delay2: std_logic_vector(31 downto 0);
	--delay da barra 2
	signal delay3: std_logic_vector(31 downto 0);
	
	signal barra1estado: std_logic_vector(7 downto 0);
	signal barra2estado: std_logic_vector(7 downto 0);
	signal bolaestado: std_logic_vector(7 downto 0);
	
begin
--movimenta barra
process (clk, reset)
   begin
	
	if reset = '1' then
	   barra1char1 <= "00101111";
		barra1char2 <= "00101111";
		barra1char3 <= "00101111";
		barra1char4 <= "00101111";
		barra1char5 <= "00101111";
	   barra1cor1 <= "1111";
		barra1cor2 <= "1111";
		barra1cor3 <= "1111";
		barra1cor4 <= "1111";
		barra1cor5 <= "1111";
	   barra1pos1 <= x"049C";
		barra1pos2 <= x"049B";
		barra1pos3 <= x"049D";
		barra1pos4 <= x"049E";
		barra1pos5 <= x"049F";
	   delay1 <= x"00000000";
   	barra1estado <= x"00";
		
	elsif (clk'event) and (clk = 1) then
	   case barra1estado is
		   when x"00" => --peloteclado
			   case key is
				   when x"41" => --esquerda
					   if (not(conv_integer(barra1pos1)mod 40 = 0)) then
						   barra1pos1 <= barra1pos1 - x"01";
							barra1pos2 <= barra1pos2 - x"01";
							barra1pos3 <= barra1pos3 - x"01";
							barra1pos4 <= barra1pos4 - x"01";
							barra1pos5 <= barra1pos5 - x"01";
					   end if;
	            when x"44" => --direita
						if (not((conv_integer(barra1pos5) mod 40) = 39)) then
							barra1pos1 <= barra1pos1 + x"01";
							barra1pos2 <= barra1pos2 + x"01";
							barra1pos3 <= barra1pos3 + x"01";
							barra1pos4 <= barra1pos4 + x"01";
							barra1pos5 <= barra1pos5 + x"01";
						end if;
					when others =>
				end case;
		   barra1estado <= x"01";
			
			when x"01" => --delay
			   if delay1 >= x"0000FFFF" then 
				   delay1 <= x"00000000";
					barra1estado <= x"00";
				else
				   delay1 <= delay1 + x"01";
				end if;
			when others =>
		end case;
	end if;
end process;

--bolinha
process (clk, reset)
   begin
	
	if reset = '1' then
	   bolachar <= "00000010";
		bolacor <= "1111";
		bolapos <= x"006E";
		incbola <= x"29";
		sinal <= '0';
		delay2 <= x"00000000";
		bolaestado <= x"00";
	
	elsif (clk'event) and (clk '1') then
	   case bolaestado is
		   when x"00" => --incrementa a pos da bola
			   if (sinal = '0') then
				   bolapos <= bolapos + incbola;
				else
				   bolapos <= bolapos - incbola;
				end if;
				bolaestado <= x"01";
			
			when x"01" => --bola chegou em cima
			   if (bolapos < 40) then
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '0';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '0';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '0';
					end if;
				end if;
				bolaestado <= x"02";
				
			when x"02" => --bola chegou em baixo
			   if (bolapos > 1159) then
				   if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '1';
					end if;
				   if (incbola = 40) then
					   incbola <= x"28";
						sinal <= '1';
					end if;
					if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '1';
					end if;
				end if;
				bolaestado <= x"03";
				
			when x"03" => --bola esta na direita
			   if ((conv_integer(bolapos) mod 40) = 39) then
				   if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '1';
					end if;
					if (incbola = 1) then
					   incbola <= x"01";
						sinal <= '1';
					end if;
					if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '0';
					end if;
				end if;
				bolaestado <= x"04";
			
			when x"04" => --bola esta na esquerda
			   if ((conv_integer(bolapos) mod 40) = 0) then
				   if (incbola = 39) then
					   incbola <= x"29";
						sinal <= '0';
					end if;
					if (incbola = 1) then
					   incbola <= x"01";
						sinal <= '0';
					end if;
					if (incbola = 41) then
					   incbola <= x"27";
						sinal <= '1';
					end if;
				end if;
				bolaestado <= x"FF";
				
			when x"FF" => --delay
			   if delay2 >= x"0000FFFF" then
				   delay2 <= x"00000000";
					bolaestado <= x"00";
				else
				   delay2 <= delay2 + x"01";
				end if;
				
			when others =>
			   bolaestado <= x"00";
		end case;
	end if;
end process;

--escreve na tela
process (clkvideo, reset)
   begin
	
	if (reset = '1') then
	   videoe <= x"00";
		videodraw <= '0';
		barra1posa1 <= x"0000";
		barra1posa2 <= x"0000";
		barra1posa3 <= x"0000";
		barra1posa4 <= x"0000";
		barra1posa5 <= x"0000";
		bolaposa <= x"0000";
		
	elsif (clkvideo'event) and (clkvideo = '1') then
	   case videoe is
		   when x"00" =>
		
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:55:18 11/24/2023 
-- Design Name: 
-- Module Name:    LCD - arq_LCD 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--Código-base retirado do vídeo "DISPLAY LCD DO KIT EE03 | Curso de FPGA #080" no Youtube, do canal L "WR Kits"
--Link do vídeo: https://youtu.be/tbBiHPvzUIg?si=jQWMAsOxOqRG1Lmw

entity LCD is
generic (fclk: natural := 110_000_000); -- 50MHz , cristal do kit EE03			
		port (chute : in STD_LOGIC_VECTOR (2 downto 0);				--Entrada da forca: algarismo chutado pelo jogador (em binário)
		      botao : in STD_LOGIC;						--Botão: confirmação do chute botado nos switchs (input), de modo a mandar o chute ao jogo
		      reset : in STD_LOGIC;						--Botão de Reset: reinicia o jogo inteiro
		      clk   : in STD_LOGIC;						--Entrada de clock
		      ledvidas:  out std_logic_vector(2 downto 0); 			--Saída dos LEDS da placa FPGA, que serão proporcionais às vidas que o jogador possui
		      RS, RW      : out bit;						--RS = Register Select (Habilitação da memória) // RW = Read/Write Control (1 para habilitação da leitura, 0 para habilitação da escrita)
		      E           : buffer bit;  					--Read/Write Enable Pulse (indica que a memória está habilitada para armazenar dados)
		      DB          : out bit_vector(7 downto 0)); 			--Vetor dos data bits, os bits que são recebidos pela memória e podem aparecer no display lcd
end LCD;

architecture arq_LCD of LCD is																	--Esses estados foram criados pelo autor original desse código
	type state is (FunctionSetl, FunctionSet2, FunctionSet3,
	 FunctionSet4,FunctionSet5,FunctionSet6,FunctionSet7,FunctionSet8,FunctionSet9,FunctionSet10,FunctionSet11,FunctionSet12,				--Declaração dos estados do módulo do lcd, para
	 FunctionSet13,FunctionSet14,FunctionSet15,FunctionSet16,FunctionSet17,FunctionSet18,FunctionSet19,ClearDisplay, DisplayControl, EntryMode, 		--manipulação da memória do lcd. Os estados podem
	 WriteDatal, WriteData2, WriteData3, WriteData4, WriteData5,WriteData6,WriteData7,WriteData8,WriteData9,WriteData10,WriteData11,			--realizar o set, leitura ou escrita na memória,
	 WriteData12,SetAddress,SetAddress1, ReturnHome);													--para que seus valores apareçam no display lcd
	
	signal pr_state, nx_state: state; 	      --signal que representa a transição de estados
	signal comp : std_logic_vector(4 downto 0);   --signal do vetor que apresenta quais os algarismos da senha já foram acertados
	signal gpsig : std_logic_vector(1 downto 0);  --signal do vetor gp. Caso gp(1)=1, o jogador ganhou o jogo; caso gp=0, o jogador perdeu o jogo
	signal clkm : std_logic;		      --um clock extra para funcionar dentro do component "forca" e fazer sua transição de estados
	
Component forca is						--Declaração do component da forca, que realiza o jogo da forca.
    Port ( chute : in  STD_LOGIC_VECTOR (2 downto 0);    	--Suas saídas são trazidas para esse módulo de lcd para saber
           botao : in  STD_LOGIC;				--o que deve ser mostrado no display lcd e na placa FPGA
	   reset : in std_logic;
	   clk   : in std_logic;
	   vidasled: out std_logic_vector(2 downto 0);
	   compfinal: out STD_LOGIC_VECTOR(4 downto 0);
	   gp : out std_logic_vector(1 downto 0)
	 );
end component;
begin

forca_f: forca port map (chute,botao,reset,clkm,ledvidas,comp,gpsig);  --Chamada do component da forca

---—Clock generator (E->500Hz) :---------
		process (clk)					--Alterador da frequência do clock.
		variable count: natural range 0 to fclk/100; 	--Esse novo clock é usado para reger a transição dos estados para a manipulação  
		begin						--da memória do display lcd [E] e para a transição dos estados do jogo da forca (em
			if (clk' event and clk = '1') then 	--seu respectivo component) [clkm]
				count := count + 1;
				if (count=fclk/100) then 
				 E <= not E; 
				 clkm <= NOT clkm;
				 count := 0; 
				end if; 
			end if; 
		end process;

-----Lower section of FSM:---------------	
		process (E) 					--Realiza a transição de estados
		begin
			if (E' event and E = '1') then 
				pr_state <= FunctionSetl; 
				pr_state <= nx_state; 
			end if; 
		end process;
		
-----Upper section of FSX:---------------
		process (pr_state) 
		begin
		case pr_state is


		when FunctionSetl => 		--Os estados FunctionSetl, FunctionSet2, FunctionSet3, FunctionSet4, FunctionSet5, FunctionSet6,		
		RS<= '0'; RW<= '0'; 		--FunctionSet7, FunctionSet8, FunctionSet9, FunctionSet10, FunctionSet11, FunctionSet12, FunctionSet13,	
		DB<= "00111000"; 		--FunctionSet14, FunctionSet15, FunctionSet16, FunctionSet17, FunctionSet18 e FunctionSet19 são
		nx_state <= FunctionSet2; 	--responsáveis por setar as memórias do lcd.
						--Essa parte do código não foi mudada em relação ao código original do canal "WR Kits", até o início
		when FunctionSet2 => 		--dos estados de WriteData.
		RS<= '0'; RW<= '0'; 
		DB <= "00111000";
		nx_state <= FunctionSet3; 
		
		when FunctionSet3 => 
		RS <= '0'; RW<='0'; 
		DB <= "00111000"; 
		nx_state <= FunctionSet4;

		when   FunctionSet4   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet5;

		when   FunctionSet5   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet6;

		when   FunctionSet6   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet7;

		when   FunctionSet7   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet8;

		when   FunctionSet8   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet9;

		when   FunctionSet9   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet10;

		when   FunctionSet10   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet11;

		when   FunctionSet11   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet12;

		when   FunctionSet12   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet13;

		when   FunctionSet13   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet14;

		when   FunctionSet14   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet15;

		when   FunctionSet15   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet16;

		when   FunctionSet16   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet17;

		when   FunctionSet17   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet18;

		when   FunctionSet18   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= FunctionSet19;

		when   FunctionSet19   =>
		RS<=  '0'; RW<=  '0';
		DB   <=   "00111000";
		nx_state <= ClearDisplay ;


		when ClearDisplay =>
		RS<= '0'; RW<= '0';
		DB <= "00000001";
		nx_state <= DisplayControl; 
		
		when   DisplayControl   =>
		RS<= '0';   RW<=  '0';
		DB   <=  "00001100";
		nx_state <= EntryMode; 
		
		when EntryMode =>
		RS<= '0'; RW<= '0';
		DB <= "00000110";
		nx_state   <=  WriteDatal; 

		when  WriteDatal =>
		RS<=   '1';   RW <='0';
		DB   <=   "00100000";   
		nx_state <= SetAddress1; 

		when SetAddress1 =>
		RS<=   '0';   RW<=   '0';
		DB   <=  "10000101";         --COMANDO PARA POSICIONAR O CURSOR NA LINHA 2 COLUNA 6
		nx_state  <= WriteData2; 
		

		when WriteData2 =>		--A partir daqui as alterações no código foram feitas, de modo a definir o que seria mostrado no display lcd.
		RS<= '1'; RW<= '0';		--O vetor "comp" apresenta quais posições da senha já foram acertadas durante o jogo. Dessa forma, nesse módulo
		if (comp(4) = '1') then		--de print no display lcd, dependendo se a posição do bit no vetor "comp" for 1 ou 0, será mostrado no lcd, 
			DB <= X"37"; --7	--respectivamente, o algarismo acertado (que nem na forca) ou o símbolo "_" (algarismo ainda não foi acertado).
		else				--Por exemplo, nesse estado "WriteData2", caso a posição mais significativa do vetor "comp" esteja em nível alto,
			DB <= X"2D"; -- _	--será printado o algarismo 7, que é o valor mais significativo da senha; caso contrário, será printado "_". Essa
		end if;				--lógica foi aplicada dos estados "WriteData2" ao "WriteData6", para todos os cinco dígitos da senha.
		nx_state <= WriteData3; 
		
		when WriteData3 =>
		RS<= '1'; RW<= '0';
		if (comp(3) = '1') then
			DB <= X"31"; --1
		else
			DB <= X"2D"; -- _
		end if;     
		nx_state  <= WriteData4; 
		
		when  WriteData4   =>
		RS<=   '1';   RW<=   '0';
		if (comp(2) = '1') then
			DB <= X"36"; --6
		else
			DB <= X"2D"; -- _
		end if;
		nx_state  <= WriteData5; 

		when  WriteData5   =>
		RS<=   '1';   RW<=   '0';
		if (comp(1) = '1') then
			DB <= X"35"; --5
		else
			DB <= X"2D"; -- _
		end if;
		nx_state  <= WriteData6;
		
		when  WriteData6   =>
		RS<=   '1';   RW<=   '0';
		if (comp(0) = '1') then
			DB <= X"30"; --0
		else
			DB <= X"2D"; -- _
		end if;
		nx_state  <= SetAddress;
	
		when SetAddress =>
		RS<=   '0';   RW<=   '0';
		DB   <=  "11000101";         --COMANDO PARA POSICIONAR O CURSOR NA LINHA 2 COLUNA 6
		nx_state  <= WriteData7;

		when  WriteData7   =>			--Os estados "WriteData7" ao "WriteData12" ficam responsáveis pelo print caso aconteça alguma condição
		RS<=   '1';   RW<=   '0';		--de fim de jogo (vitória ou derrota). Nesse caso, é analisado o vetor gpsig: caso seu valor seja "00",
		if (gpsig = "00") then			--não aconteceu nenhuma condição de fim de jogo e este continua, nada sendo printado na segunda linha
			DB <= X"20"; -- espaço		--do lcd (por isso space).; caso gpsig = "10" = g = vitória, os estados "WriteData7" ao "WriteData12" 
		elsif (gpsig = "01") then		-- mostrarão no lcd a palavra "Ganhou"; por fim, caso gpsig = "01" = p = derrota, os estados printarão
			DB <= X"50"; --P		--"Perdeu"
		else
			DB <= X"47"; --G
		end if;
		nx_state  <= WriteData8;

		when  WriteData8   =>
		RS<=   '1';   RW<=   '0';
		if (gpsig = "00") then
			DB <= X"20"; -- espaço
		elsif (gpsig = "01") then
			DB <= X"65"; --e
		else
			DB <= X"61"; --a
		end if;
		nx_state  <= WriteData9;

		when WriteData9 =>
		RS<= '1'; RW<= '0';
		if (gpsig = "00") then
			DB <= X"20"; -- espaço
		elsif (gpsig = "01") then
			DB <= X"72"; --r
		else
			DB <= X"6e"; --n
		end if;
		nx_state <= WriteData10; 

		when WriteData10 =>
		RS<= '1'; RW<= '0';
		if (gpsig = "00") then
			DB <= X"20"; -- espaço
		elsif (gpsig = "01") then
			DB <= X"64"; --d
		else
			DB <= X"68"; --h
		end if;
		nx_state <= WriteData11; 

		when WriteData11 =>
		RS<= '1'; RW<= '0';
		if (gpsig = "00") then
			DB <= X"20"; -- espaço
		elsif (gpsig = "01") then
			DB <= X"65"; --e
		else
			DB <= X"6f"; --o
		end if;
		nx_state <= WriteData12;

		when WriteData12 =>
		RS<= '1'; RW<= '0';
		if (gpsig = "00") then
			DB <= X"20"; -- espaço
		elsif (gpsig = "01") then
			DB <= X"75"; --u
		else
			DB <= X"75"; --u
		end if;
		nx_state <= ReturnHome;
 
		
		when   ReturnHome   =>		--Reinício dos ciclos dos estados
		RS<=   '0';   RW<=  '0';
		DB   <=  "10000000";
		nx_state <= WriteDatal; 
		
		end case; 
	end process;

end arq_LCD;

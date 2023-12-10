----------------------------------------------------------------------------------
-- company: 
-- Engineer: 
-- 
-- Create Date:    16:37:53 11/07/2023 
-- Design Name: 
-- Module Name:    forca - arq_forca 
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
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity forca is
    Port ( chute : in  STD_LOGIC_VECTOR (2 downto 0);      	--Entrada da forca: algarismo chutado pelo jogador (em binário)
           botao : in  STD_LOGIC;                         	--Botão: confirmação do chute botado nos switchs (input), de modo a mandar o chute ao jogo
	   reset : in std_logic;                           	--Reset: reinicia o jogo inteiro
	   clk   : in std_logic;                           	--Entrada de clock
	   vidasled: out std_logic_vector(2 downto 0);     	--Saída dos LEDS da placa FPGA, que serão proporcionais às vidas que o jogador possui
	   compfinal: out STD_LOGIC_VECTOR(4 downto 0);    	--Saída de quais posições já foram acertadas pelo jogador, para configuração do print no lcd
	   gp : out std_logic_vector(1 downto 0)           	--Vetor de 2 elementos que apresenta condições para o fim de jogo: gp(1) = g = vitória, e gp(0) = p = derrota
	  );
end forca;

                                                                                                                                                                                                                                                                                                                                                 architecture arq_forca of forca is

--Sinais temporários:
signal senha4: STD_LOGIC_VECTOR (2 downto 0) := "111"; -- senha:
signal senha3: STD_LOGIC_VECTOR (2 downto 0) := "001"; -- 71650
signal senha2: STD_LOGIC_VECTOR (2 downto 0) := "110";
signal senha1: STD_LOGIC_VECTOR (2 downto 0) := "101";
signal senha0: STD_LOGIC_VECTOR (2 downto 0) := "000";

signal comp: STD_LOGIC_VECTOR(4 downto 0):= "00000";            --Vetor que contém quais posições da senha já foram acertadas pelo jogador (1 se já foi acertado, 0 caso ainda não)
signal comp0,comp1,comp2,comp3,comp4, bait : STD_LOGIC := '0';  --Signals auxiliares que mostram quais posições da senha já foram acertadas, para composição do vetor comp
signal estados: STD_LOGIC_VECTOR(2 downto 0):= "000";           --Estados do jogo. Sua codificação está abaixo* 
signal vidas : integer range 3 downto 0 := 3;                   --Quantidade de vidas que o jogador possui: diminui em 1 a cada erro realizado
signal gpsig : STD_LOGIC_VECTOR(1 downto 0):= "00"; 		--Signal de vetor de 2 elementos que apresenta condições para o fim de jogo: gp(1) = g = vitória, e gp(0) = p = derrota


--Estados* :
-- "000" -> possui as configurações do reset e realiza a comparação do chute com os algarismos da senha. Vai para o estado "001", onde tal os resultados da comparação serão analisados.
-- "001" -> determinação se a pessoa acertou algum algarismo (vai para o estado "010") ou se errou o chute (vai para o estado "011")
-- "010" -> o jogador acertou algo: salva os bits acertados no vetor comp, em seguida, vai para o estado "011",  onde ocorre a determinação se o jogo acaba ou não (vitória).
-- "011" -> analisa os bits de comp, verificando se o jogador ganhou ou não o jogo (ocorre quando todos os bits de comparação são 1, ou seja, todos foram acertados). Retorna ao estado "000".
-- "100" -> o jogador errou no chute: perda de uma vida, em seguida, vai para o estado "101", onde ocorre a determinação se o jogo acaba ou não (derrota).
-- "101" -> analisa quantas vidas o jogador possui. Caso a quantidade de vidas tenha chegado a 0, o jogador perde o jogo. Retorna ao estado "000".


BEGIN

bait <= (comp0 OR comp1 OR comp2 OR comp3 OR comp4);     --verificação se o chute do jogador foi um acerto ou um erro (algum dos algarismos está certo) -> OR nos valores de cada comparação

process(vidas)

begin
	if (vidas = 3) then            --Configuração das saídas de LED de acordo com a
		vidasled <= "111";     --quantidade de vidas que o jogador possui: a
	elsif (vidas = 2) then         --quantidade de vidas é igual à quantidade de
		vidasled <= "011";     --LEDS acesos. Caso não haja nenhum LED aceso,
	elsif (vidas = 1) then         --as vidas do jogador acabaram e o jogo se encerra
		vidasled <= "001";     --com a sua derrota 
	elsif (vidas = 0) then
		vidasled <= "000";
	end if;
end process;

process(clk)
begin
	if(rising_edge(clk)) then
		case estados is
			when "000" =>         			--Estado "000": realiza o reset do jogo, caso o botão tenha sido ativado, e a comparação do chute com os algarismos da senha
				if (reset = '1') then 		
					vidas <= 3;          	     --Caso o reset tenha sido ativado, todas as vidas
					comp <= "00000";             --e acertos do jogador devem ser reiniciados, bem 
					comp0 <= '0';		     --os dados relacionados a esse jogo
					comp1 <= '0';
					comp2 <= '0';
					comp3 <= '0';
					comp4 <= '0';
					estados <= "000";
					gpsig <= "00";
				elsif (botao = '1' AND vidas > 0) then             --Comparação de cada alagarismo da senha com o 
					if (chute = senha0) then                   --chute feito pelo jogador. Caso um algarismo
						comp0 <= '1';			   --esteja correto, seu respectivo signal virará
					end if;					   --'1', para composição do vetor comp que diz
					if (chute = senha1) then		   --quais posições da senha já foram acertadas
						comp1 <= '1';
					end if;
					if (chute = senha2) then
						comp2 <= '1';
					end if;
					if (chute = senha3) then
						comp3 <= '1';
					end if;
					if (chute = senha4) then
						comp4 <= '1';
					end if;
					--Próximo estado
					estados <= "001";
				end if;
				
			when "001" => --Estado "001": Verificação se houve acerto ou erro com o chute do jogador
				if (bait = '1') then
					estados <= "010"; --Acertou ao menos algum algarismo da senha
				else
					estados <= "100"; --Errou
				end if;
				
			when "010" =>                           --Estado "010": Houve Acerto: Salvar os algarismos da senha
				comp(0) <= comp0 or comp(0);    --já acertados no vetor "comp". Caso uma posição já tenha 
				comp(1) <= comp1 or comp(1);	--sido acertada ela se manterá em nível alto, e o vetor comp
				comp(2) <= comp2 or comp(2);	--só muda com novos acertos (ou caso o jogo resete).
				comp(3) <= comp3 or comp(3);
				comp(4) <= comp4 or comp(4);
				--Próximo estado
				estados <= "011";
				
			when "011" => --Estado "011": Verificação se o jogador ganhou: todos os algarismos da senha foram acertados (todas comparações foram iguais a 1)
					comp0 <= '0';
					comp1 <= '0';			--Todos os signals auxiliares "comp" da comparação voltam para 0 para a realização
					comp2 <= '0';			--da próxima rodada, ou seja, comparação do próximo chute do jogador
					comp3 <= '0';
					comp4 <= '0';
				if (comp(4 downto 0) = "11111") then    --Caso as todos os numeros tenham sido acertados, o jogador ganha; caso contrário, o jogo continua
					gpsig(1) <= '1'; 		--Jogador ganhou, print de "Ganhou" no lcd
					estados <= "000";
				else
					estados <= "000";
				end if;	
				
			when "100" => --Estado "100": Houve Erro: Jogador perde uma vida
				vidas <= vidas - 1;
				--Próximo estado
				estados <= "101";
				
			when "101" => --Estado "101": Verificação se o jogador perdeu: análise da quantidade de vidas do jogador
				if (vidas = 0) then	 --Caso as vidas tenham acabado, o jogador perde; caso contrário, o jogo continua
					gpsig(0) <= '1'; --Jogador perdeu, print de "Perdeu" no lcd
					estados <= "000";
				else
					estados <= "000";
				end if;	
				
			when others =>
		end case;
	end if;
end process;

compfinal <= comp;
gp <= gpsig;

END arq_forca;

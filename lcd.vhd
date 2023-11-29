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

entity LCD is
generic (fclk: natural := 150_000_000); -- 50MHz , cristal do kit EE03
		port (chute : in STD_LOGIC_VECTOR (2 downto 0);
				botao : in STD_LOGIC;
				reset : in STD_LOGIC;
				clk   : in STD_LOGIC;
				ledvidas:  out std_logic_vector(2 downto 0); 
				RS, RW      : out bit;
		      E           : buffer bit;  
		      DB          : out bit_vector(7 downto 0)); 
end LCD;

architecture arq_LCD of LCD is
	type state is (FunctionSetl, FunctionSet2, FunctionSet3,
	 FunctionSet4,FunctionSet5,FunctionSet6,FunctionSet7,FunctionSet8,FunctionSet9,FunctionSet10,FunctionSet11,FunctionSet12,
	 FunctionSet13,FunctionSet14,FunctionSet15,FunctionSet16,FunctionSet17,FunctionSet18,FunctionSet19,ClearDisplay, DisplayControl, EntryMode, 
	 WriteDatal, WriteData2, WriteData3, WriteData4, WriteData5,WriteData6,WriteData7,WriteData8,WriteData9,WriteData10,WriteData11,
	 WriteData12,SetAddress,SetAddress1, ReturnHome);
	
	signal pr_state, nx_state: state; 
	signal comp : std_logic_vector(4 downto 0);   --signal do vetor que apresenta quais os algarismos da senha já foram acertados
	signal gpsig : std_logic_vector(1 downto 0);  --signal do vetor gp. Caso gp(1)=1, o jogador ganhou o jogo; caso gp=0, o jogador perdeu o jogo
		
Component forca is
    Port ( entrada : in  STD_LOGIC_VECTOR (2 downto 0);    
           botao : in  STD_LOGIC;
			  reset : in std_logic;
			  clk   : in std_logic;
			  ledvidas: out std_logic_vector(2 downto 0);
			  compfinal: out STD_LOGIC_VECTOR(4 downto 0);
			  gp : out std_logic_vector(1 downto 0)
			  );
end component;
begin

forca_f: forca port map (chute,botao,reset,clk,ledvidas,comp,gpsig);

---—Clock generator (E->500Hz) :---------
		process (clk)
		variable count: natural range 0 to fclk/1000; 
		begin
			if (clk' event and clk = '1') then 
				count := count + 1;
				if (count=fclk/1000) then 
				 E <= not E; 
				 count := 0; 
				end if; 
			end if; 
		end process;

-----Lower section of FSM:---------------
		process (E) 
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


		when FunctionSetl => 
		RS<= '0'; RW<= '0'; 
		DB<= "00111000"; 
		nx_state <= FunctionSet2; 
		
		when FunctionSet2 => 
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
		

		when WriteData2 =>
		RS<= '1'; RW<= '0';
		if (comp(4) = '1') then
			DB <= X"07";
		else
			DB <= X"5F"; 
		end if;
		nx_state <= WriteData3; 
		
		when WriteData3 =>
		RS<= '1'; RW<= '0';
		if (comp(3) = '1') then
			DB <= X"01";
		else
			DB <= X"5F"; 
		end if;     
		nx_state  <= WriteData4; 
		
		when  WriteData4   =>
		RS<=   '1';   RW<=   '0';
		if (comp(2) = '1') then
			DB <= X"06";
		else
			DB <= X"5F"; 
		end if;
		nx_state  <= WriteData5; 

		when  WriteData5   =>
		RS<=   '1';   RW<=   '0';
		if (comp(1) = '1') then
			DB <= X"05";
		else
			DB <= X"5F"; 
		end if;
		nx_state  <= WriteData6;
		
		when  WriteData6   =>
		RS<=   '1';   RW<=   '0';
		if (comp(0) = '1') then
			DB <= X"00";
		else
			DB <= X"5F"; 
		end if;
		nx_state  <= SetAddress;
	
		when SetAddress =>
		RS<=   '0';   RW<=   '0';
		DB   <=  "11000101";         --COMANDO PARA POSICIONAR O CURSOR NA LINHA 2 COLUNA 6
		nx_state  <= WriteData7;

		when  WriteData7   =>
		RS<=   '1';   RW<=   '0';
		if (gpsig(1) = '1') then
			DB <= X"47";
		elsif (gpsig(0) = '1') then
			DB <= X"50";
		else
			DB <= X"20";
		end if;
		nx_state  <= WriteData8;

		when  WriteData8   =>
		RS<=   '1';   RW<=   '0';
		if (gpsig(1) = '1') then
			DB <= X"61";
		elsif (gpsig(0) = '1') then
			DB <= X"65";
		else
			DB <= X"20";
		end if;
		nx_state  <= WriteData9;

		when WriteData9 =>
		RS<= '1'; RW<= '0';
		if (gpsig(1) = '1') then
			DB <= X"6e";
		elsif (gpsig(0) = '1') then
			DB <= X"72";
		else
			DB <= X"20";
		end if;
		nx_state <= WriteData10; 

		when WriteData10 =>
		RS<= '1'; RW<= '0';
		if (gpsig(1) = '1') then
			DB <= X"68";
		elsif (gpsig(0) = '1') then
			DB <= X"64";
		else
			DB <= X"20";
		end if;
		nx_state <= WriteData11; 

		when WriteData11 =>
		RS<= '1'; RW<= '0';
		if (gpsig(1) = '1') then
			DB <= X"6f";
		elsif (gpsig(0) = '1') then
			DB <= X"65";
		else
			DB <= X"20";
		end if;
		nx_state <= WriteData12;

		when WriteData12 =>
		RS<= '1'; RW<= '0';
		if (gpsig(1) = '1') then
			DB <= X"75";
		elsif (gpsig(0) = '1') then
			DB <= X"75";
		else
			DB <= X"20";
		end if;
		nx_state <= ReturnHome;
 
		
		when   ReturnHome   =>
		RS<=   '0';   RW<=  '0';
		DB   <=  "10000000";
		nx_state <= WriteDatal; 
		
		end case; 
	end process;

end arq_LCD;

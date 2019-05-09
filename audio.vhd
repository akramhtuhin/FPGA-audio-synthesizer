library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity Audio  is
        port ( 
				A                      : in std_logic;
--				B                      : in std_logic;
				C                      : in std_logic;
				D                      : in std_logic;
				E                      : in std_logic;
				F                      : in std_logic;
				G                      : in std_logic;
		    -- Assuming 100MHz input clock.My need to adjust the counter below
          -- if any other input frequency is used   
				Clk                    : in std_logic;
			
          -- Output Audio			
				Audio_L                : out std_logic;		 
            Audio_R   				  : out std_logic			
            );
			
end Audio;

architecture Behavioral of Audio is

-- Intermediate Register to generate the required sound
signal counter      : integer := 0;
signal note        : std_logic_vector(2 downto 0);
signal temp           : std_logic := '0';

begin
	counterP: process (Clk, note) begin
	  if rising_edge(Clk) then
--			counter <= std_logic_vector (unsigned(counter) + 1);
			case note is
				when "000" => --a
					if (counter >= 11364) then
						counter <= 0;
						temp <= not temp;
					else 
						counter <= counter +1;
					end if;
--				when "001" => --b
--					if (counter >= 10142) then
--						counter <= 0;
--						temp <= not temp;
--					else
--						counter <= counter +1;
--					end if;
				when "010" => --c
					if (counter >= 19157) then
						counter <= 0;
						temp <= not temp;
					else
						counter <= counter +1;
					end if;
				when "011" => --d
					if (counter >= 17065) then
						counter <= 0;
						temp <= not temp;
					else
						counter <= counter +1;
					end if;
				when "100" => --e
					if (counter >= 15151) then
						counter <= 0;
						temp <= not temp;
					else
						counter <= counter +1;
					end if;
				when "101" => --f
					if (counter >= 14286) then
						counter <= 0;
						temp <= not temp;
					else
						counter <= counter +1;
					end if;
				when "110" => --g
					if (counter >= 12755) then
						counter <= 0;
						temp <= not temp;
					else
						counter <= counter +1;
					end if;
				when others =>
				temp <= '0';
				counter <= 0;
			end case;
		end if;
	end process;
Audio_L <= temp;
Audio_R <= temp;
	getNote: process (A, C, D, E, F, G) begin
		if (A = '1' AND C = '1' AND D = '1' AND E = '1' AND F = '1' AND G = '1') then
			note <="111";
		else
			if A='0' then
				note <="000";
--			elsif B='0' then
--				note <="001";
			elsif C='0' then
				note <="010";
			elsif D='0' then
				note <="011";
			elsif E='0' then
				note <="100";
			elsif F='0' then
				note <="101";
			else
				note <="110";
			end if;
		end if;
	end process;
end Behavioral;

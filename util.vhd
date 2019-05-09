--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package util is

function Int_7Seg (signal num : in integer)
   return std_logic_vector;

procedure BCD_COUNTER3  (
		signal bcd0 : inout integer; 
		signal bcd1 : inout integer; 
		signal bcd2 : inout integer; 
		signal clk : in std_logic; 
		signal up : in std_logic);

end util;

package body util is

function Int_7Seg (signal num : in integer)
		return std_logic_vector is
	variable seg : std_logic_vector(7 downto 0);
begin
			--        a    
			--      ____
			--   f |    | b
			--     |_g__| 
			--   e |    | c
			--     |____| .h
			--       d
  case num is
	  when 0      => seg := B"00000011";
	  when 1      => seg := B"10011111";
	  when 2      => seg := B"00100101";
	  when 3      => seg := B"00001101";
	  when 4      => seg := B"10011001";
	  when 5      => seg := B"01001001";
	  when 6      => seg := B"01000001";
	  when 7      => seg := B"00011111";
	  when 8      => seg := B"00000001";
	  when 9      => seg := B"00011001";
	  when others => seg := B"11111111";
  end case;
  return seg;
end Int_7Seg;

procedure BCD_COUNTER3  (
	signal bcd0 : inout integer; 
	signal bcd1 : inout integer; 
	signal bcd2 : inout integer; 
	signal clk : in std_logic; 
	signal up : in std_logic) is
begin
	if (up = '1') then
		bcd0 <= bcd0 + 1;
		if (bcd0 = 10) then
			bcd0 <= 0;
			bcd1 <= bcd1 + 1;
			if (bcd1 = 9) then
				bcd1 <= 0;
				bcd2 <= bcd2 + 1;
				if (bcd2 = 9) then
					bcd2 <= 0;
				end if;
			end if;
		end if;
	else
		bcd0 <= bcd0 - 1;
		if (bcd0 = 0) then
			bcd0 <= 9;
			bcd1 <= bcd1 - 1;
			if (bcd1 = 0) then
				bcd1 <= 9;
				bcd2 <= bcd2 - 1;
				if (bcd2 = 0) then
					bcd2 <= 9;
				end if;
			end if;
		end if;
	end if;
end BCD_COUNTER3;
 
end util;

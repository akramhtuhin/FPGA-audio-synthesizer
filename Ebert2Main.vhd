----------------------------------------------------------------------------------
-- Company: Jence Bangladesh
-- Engineer: Ejaz Jamil
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.UTIL.ALL;

entity Ebert2Main is
  port (   --Input's
           -- Assuming 12MHz input clock. My need to adjust the clocking_inst below
           -- if any other input frequency is used
               Clk   : IN STD_LOGIC;
			 
			  -- Input from the on board push buttons and DIP Switches.
              	Switch   : IN STD_LOGIC_VECTOR(5 downto 0); 
               DPSwitch : IN STD_LOGIC_VECTOR(7 downto 0);
								
			  -- Output
			  -- ElbertV2 VGA Display
--			      hsync    : OUT STD_LOGIC;
--             vsync    : OUT STD_LOGIC;
--             Red      : OUT STD_LOGIC_VECTOR(2 downto 0);
--             Green    : OUT STD_LOGIC_VECTOR(2 downto 0);
--             Blue     : OUT STD_LOGIC_VECTOR(2 downto 1);
			  
			  -- ElbertV2 Audio
			      Audio_L	 : INOUT STD_LOGIC;
					Audio_R	 : INOUT STD_LOGIC;

			  -- ElbertV2 Seven Segment Display
			      SevenSegment : OUT STD_LOGIC_VECTOR(7 downto 0);
               Enable       : OUT STD_LOGIC_VECTOR(2 downto 0);
					 
			  -- ElbertV2 LED
			      LED      : INOUT STD_LOGIC_VECTOR(7 downto 0)
			  
			  -- ElbertV2 Ports
			  -- The two GPI of Port P5 i.e, PIN 2 and PIN 8.
--			      IO_P1   : OUT   STD_LOGIC_VECTOR(7 downto 0);
--					IO_P2   : OUT   STD_LOGIC_VECTOR(7 downto 0);
--					IO_P4   : OUT   STD_LOGIC_VECTOR(7 downto 0);
--             IO_P5   : INOUT STD_LOGIC_VECTOR(7 downto 0);
--					IO_P6   : OUT   STD_LOGIC_VECTOR(7 downto 0)
		  );
end Ebert2Main;

architecture Behavioral of Ebert2Main is
signal counter : std_logic_vector(48 downto 0) := (others => '0');
signal En : std_logic_vector(2 downto 0) := B"110";
signal tick : std_logic := '0';
signal tick_mux : std_logic := '0';
signal num0 : integer := 0;
signal num1 : integer := 0;
signal num2 : integer := 0;
signal dir : std_logic := '1';

component Audio port ( 
	A                      : in std_logic;
--	B                      : in std_logic;
	C                      : in std_logic;
	D                      : in std_logic;
	E                      : in std_logic;
	F                      : in std_logic;
	G                      : in std_logic;
	Clk                    : in std_logic;
	Audio_L                : out std_logic;		 
	Audio_R   				  : out std_logic			
);			
end component;
	signal A                      : std_logic;
--	signal B                      : std_logic;
	signal C                      : std_logic;
	signal D                      : std_logic;
	signal E                      : std_logic;
	signal F                      : std_logic;
	signal G                      : std_logic;

begin

Clocking: process (Clk) begin
if rising_edge(Clk) then
	counter <= std_logic_vector(unsigned(counter) + 1);
	tick <= counter(23); -- divide by 2^23
	tick_mux <= counter(15); -- divide by 2^15 (multiplexer clock)
end if;
end process;

Ticking: process (tick) begin
if (rising_edge(tick)) then
	BCD_COUNTER3(num0, num1, num2, tick_mux, dir);
end if;
end process;

Multiplexing: process(tick_mux)
begin
	if (rising_edge(tick_mux)) then
		En <= En(1 downto 0) & En(2); -- this is a rol operation, & is concatenation operator
		Enable <= En;
	end if;
end process;

PushButton: process (Switch) begin

--B <= DPSwitch(1);
C <= Switch(0);
D <= Switch(1);
E <= Switch(2);
F <= Switch(3);
G <= Switch(4);
A <= Switch(5);
for k in 5 downto 0 loop
	LED(k) <= Switch(5-k);
end loop;	
end process;

DIPSwitches: process (DPSwitch) begin
--A <= DPSwitch(0);
--B <= DPSwitch(1);
--C <= DPSwitch(2);
--D <= DPSwitch(3);
--E <= DPSwitch(4);
--F <= DPSwitch(5);
--G <= DPSwitch(6);
--for k in 7 downto 0 loop
--	LED(k) <= DPSwitch(7-k);
--end loop;	
end process;

Display: process (tick_mux, En)
begin
if (rising_edge(tick_mux)) then
	if (En = "110") then
		SevenSegment <= Int_7Seg(num0);
	elsif (En = "101") then
	   SevenSegment <= Int_7Seg(num1);
	elsif (En = "011") then
	   SevenSegment <= Int_7Seg(num2);
	end if;
end if;
end process;

AU0: Audio port map (A, C, D, E, F, G, Clk, Audio_L, Audio_R);

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity creeping_line_3_tb is
--  Port ( );
end creeping_line_3_tb;

architecture Behavioral of creeping_line_3_tb is
component creeping_line_3 is
    Port ( reset : in STD_LOGIC;
           clock_100MHz : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal reset_tb :        std_logic;
signal clock_100MHz_tb : std_logic;
signal AN_tb:               STD_LOGIC_VECTOR (7 downto 0);

begin

uut: creeping_line_3

port map(
         AN=>AN_tb,
         clock_100MHz=>clock_100MHz_tb,
         reset=>reset_tb
);

clk:process
begin
clock_100MHz_tb <= '1';
wait for 5 ns;
clock_100MHz_tb <= '0';
wait for 5 ns;
end process;

reset: process
begin
reset_tb <= '1';
wait for 1 ns;
reset_tb <= '0';
wait for 100 ms;
wait;
end process;

end Behavioral;

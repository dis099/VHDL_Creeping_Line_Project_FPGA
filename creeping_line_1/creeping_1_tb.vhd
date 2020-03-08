
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity creeping_1_tb is
--  Port ( );
end creeping_1_tb;

architecture Behavioral of creeping_1_tb is

component creeping_1 is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           AN:  out STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal input_tb : STD_LOGIC_VECTOR (3 downto 0);
signal output_tb : STD_LOGIC_VECTOR (6 downto 0);
signal AN_tb:         STD_LOGIC_VECTOR (7 downto 0);
begin

uut: creeping_1

port map
(
input=>input_tb,
AN=>AN_tb,
output=>output_tb
);

process
begin
input_tb<="0000";
wait for 10 ns;
input_tb<="0001";
wait for 10 ns;
input_tb<="0010";
wait for 10 ns;
input_tb<="0011";
wait for 10 ns;
input_tb<="0100";
wait for 10 ns;
input_tb<="0101";
wait for 10 ns;
input_tb<="0110";
wait for 10 ns;
input_tb<="0111";
wait for 10 ns;
input_tb<="1000";
wait for 10 ns;
input_tb<="1001";
wait for 10 ns;
input_tb<="1010";
wait for 10 ns;
input_tb<="1011";
wait for 10 ns;
input_tb<="1100";
wait for 10 ns;
input_tb<="1101";
wait for 10 ns;
input_tb<="1110";
wait for 10 ns;
input_tb<="1111";
wait for 10 ns;
wait;
end process;

an: process
begin
AN_tb<="01111111";
wait for 10 ns;
AN_tb<="01111111";
wait for 10 ns;
wait;
end process;

end Behavioral;

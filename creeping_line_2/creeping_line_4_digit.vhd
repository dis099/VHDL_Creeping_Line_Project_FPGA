
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity creeping_line_4_digit is
    Port ( input_1 : in STD_LOGIC_VECTOR (3 downto 0);
           input_2 : in STD_LOGIC_VECTOR (3 downto 0);
           input_3 : in STD_LOGIC_VECTOR (3 downto 0);
           input_4 : in STD_LOGIC_VECTOR (3 downto 0);
           reset : in STD_LOGIC;
           clock_100MHz : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (6 downto 0));
end creeping_line_4_digit;

architecture creeping_2 of creeping_line_4_digit is
signal input : std_logic_vector(3 downto 0);
signal Q: std_logic_vector(1 downto 0);
signal clock_250Hz: std_logic;
signal counter: integer range 0 to 9900000; 

begin       

-- clock division
clock_divider:process (clock_100MHz)
begin
   if clock_100MHz'event and clock_100MHz = '1' then 
      if counter < 400000 then -- to reduce the clock to 250Hz = 4ms
         counter <= counter + 1;
         clock_250Hz <= '0';
      else
         counter <= 0;
         clock_250Hz <= '1';
      end if;
   end if;
end process;

---- counter 
Counting: process (clock_100MHz)
 begin
    if clock_100MHz'event and clock_100MHz = '1' then
      if reset = '1' then
        Q <= "00";
      elsif clock_250Hz = '1' then     
        Q <= std_logic_vector(unsigned(Q) + 1);
       end if;
    end if;
end process;

--multiplexer
with Q select
input <= input_1 when "00", -- for input digit 1
         input_2 when "01", -- for input digit 2
         input_3 when "10", -- for input digit 3
         input_4 when "11", -- for input digit 4
         "0000" when others; --default

--counter_decoder
with Q  select
AN<="01111111" when "00", -- for digit 1
    "10111111" when "01", --for digit 2
    "11011111" when "10", --for digit 3
    "11101111" when "11", --for digit 4
    "11111111" when others; --default

--bin to 7-SEG Decoder
with input
select
output<="0000001" when "0000", --0
        "1001111" when "0001",--1
        "0010010" when "0010",--2
        "0000110" when "0011",--3
        "1001100" when "0100",--4
        "0100100" when "0101",--5
        "0100000" when "0110",--6
        "0001111" when "0111",--7
        "0000000" when "1000",--8
        "0000100" when "1001",--9
        "0001000" when "1010",--a
        "1100000" when "1011",--b
        "0110001" when "1100",--c
        "1000010" when "1101",--d
        "0110000" when "1110",--e
        "0111000" when "1111",--f
        "1111111" when others; --default
    
end creeping_2;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity creeping_line_3 is
    Port ( reset : in STD_LOGIC;
           clock_100MHz : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (6 downto 0));
end creeping_line_3;

architecture Behavioral of creeping_line_3 is

signal input : std_logic_vector(3 downto 0);
signal Q: std_logic_vector(2 downto 0);
signal clock_250Hz: std_logic; -- clock for counter
signal clock_1Hz: std_logic; --clock for register
signal counter: integer range 0 to 40000000; 
signal counter_for_reg_clock: integer range 0 to 99999999; 
signal circular_shift_reg : std_logic_vector(0 to 31) := "00000000000110000100011000000011"; -- the circular shift register to be used
-- the circular shift register is initialized with the value 00184603

begin       
-- clock division for counter
counter_clock_divider:process (clock_100MHz)
begin
   if clock_100MHz'event and clock_100MHz = '1' then 
      if counter < 200000 then -- to reduce the clock to 250Hz = 4ms
         counter <= counter + 1;
         clock_250Hz <= '0';
      else
         counter <= 0;
         clock_250Hz <= '1';
      end if;
   end if;
end process;


-- clock division for register
register_clock_divider:process (clock_100MHz)
begin
   if clock_100MHz'event and clock_100MHz = '1' then 
      if counter_for_reg_clock < 99999999 then -- to reduce the clock to 1Hz = 1s
         counter_for_reg_clock <= counter_for_reg_clock + 1;
         clock_1Hz <= '0';
      else
         counter_for_reg_clock <= 0;
         clock_1Hz <= '1';
      end if;
   end if;
end process;

--shift register
Cir_shift_reg: process(clock_100MHz)
begin
 if clock_100MHz'event and clock_100MHz = '1' then 
    if clock_1Hz = '1' then     
          circular_shift_reg(4 to 31) <= circular_shift_reg(0 to 27); 
          circular_shift_reg(0 to 3) <= circular_shift_reg(28 to 31);
    end if;
 end if;
end process;

---- counter 
Counting: process (clock_100MHz)
 begin
    if clock_100MHz'event and clock_100MHz = '1' then
      if reset = '1' then
        Q <= "000";
      elsif clock_250Hz = '1' then     
        Q <= std_logic_vector(unsigned(Q) + 1);
       end if;
    end if;
end process;

--multiplexer
with Q select
input <= circular_shift_reg(0 to 3)     when "000", -- for input digit 1
         circular_shift_reg(4 to 7)     when "001", -- for input digit 2
         circular_shift_reg(8 to 11)    when "010", -- for input digit 3
         circular_shift_reg(12 to 15)   when "011", -- for input digit 4
         circular_shift_reg(16 to 19)   when "100", -- for input digit 5
         circular_shift_reg(20 to 23)   when "101", -- for input digit 6
         circular_shift_reg(24 to 27)   when "110", -- for input digit 7
         circular_shift_reg(28 to 31)   when "111", -- for input digit 8
         input when others; --default

--counter_decoder
with Q  select
AN<="01111111" when "000", -- for digit 1
    "10111111" when "001", --for digit 2
    "11011111" when "010", --for digit 3
    "11101111" when "011", --for digit 4
    "11110111" when "100", -- for digit 1
    "11111011" when "101", --for digit 2
    "11111101" when "110", --for digit 3
    "11111110" when "111", --for digit 4
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

end Behavioral;

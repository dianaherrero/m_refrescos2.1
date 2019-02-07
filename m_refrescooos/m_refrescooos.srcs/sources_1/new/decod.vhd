library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity decod is
	port(  code: in integer range 0 to 9;
	       led: out std_logic_vector (6 downto 0));
end decod;

architecture dataflow of decod is
begin
	with code select
		led <= "0000001" WHEN 0,
               "1001111" WHEN 1,
               "0010010" WHEN 2,
               "0000110" WHEN 3,
               "1001100" WHEN 4,
               "0100100" WHEN 5,
               "0100000" WHEN 6,
               "0001111" WHEN 7,
               "0000000" WHEN 8,
               "0000100" WHEN 9,
               "1111110" WHEN others;
end dataflow;
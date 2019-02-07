library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity decod is
	port(  code: in integer range 0 to 9;
	       led: out std_logic_vector (6 downto 0);
	       clk: in std_logic
	     );
end decod;

architecture behav of decod is
begin

process (clk)
begin
if rising_edge (clk) then
	case code is
	   when 0 => led<= "0000001";
	   when 1=> led<= "1001111";
	   when 2=> led<= "0010010";
	   when 3=> led<= "0000110";
	   when 4=> led<= "1001100";
	   when 5=> led<= "0100100";
	   when 6=> led<= "0100000";
	   when 7=> led<= "0001111";
	   when 8=> led<= "0000000";
	   when 9=> led<= "0000100";
	   when others=> led<= "1111110";
    end case;
end if;
end process;

end architecture;
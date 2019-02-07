library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

Entity clk_div is
	generic(N: integer:=27);
	port(	clk: in std_logic;
		clk_out: out std_logic:='0');
end entity;

architecture behavioral of clk_div is
begin
	process(clk)
		variable temporal: std_logic:='0';
		variable counter: natural range 0 to N-1:=0;
	begin
		if clk'event and clk='1' then
			if counter=N-1 then
				temporal:= not temporal;
				counter:=0;
			else
				counter:= counter+1;
			end if;
		   clk_out<= temporal;
		end if;
	end process;

end architecture;

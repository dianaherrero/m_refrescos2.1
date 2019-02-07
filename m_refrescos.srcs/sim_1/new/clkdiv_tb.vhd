library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity clkdiv_tb is
end entity;

architecture behav of clkdiv_tb is

component clk_div
	generic(N: integer:=27);
	port(	clk: in std_logic;
		clk_out: out std_logic);
end component;

signal clk, clk2: std_logic:='0';

begin

utt: clk_div port map (clk, clk2);

process
begin
clk<= not clk;
wait for 1 ns;
end process;

end architecture;
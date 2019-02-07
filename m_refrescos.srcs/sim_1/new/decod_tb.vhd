library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity decod_tb is
end entity;

architecture behavioral of decod_tb is
signal code: integer range 0 to 9;
signal led: std_logic_vector (6 downto 0);
signal clk: std_logic:='0';

component decod
	port(  code: in integer range 0 to 9;
	       led: out std_logic_vector (6 downto 0);
	       clk: in std_logic
	     );
end component;

begin

uutt: decod port map (code, led, clk);

process
begin
clk<=not clk;
wait for 1ns;
end process;

process
begin
code<=0;
wait for 20 ns;
code<=1;
wait for 20 ns;
code<=2;
wait for 20 ns;
code<=3;
wait for 20 ns;
code<=4;
wait for 20 ns;
code<=5;
wait for 20 ns;
code<=6;
wait for 20 ns;
code<=7;
wait for 20 ns;
code<=8;
wait for 20 ns;
code<=9;
wait for 20 ns;
end process;
end architecture;
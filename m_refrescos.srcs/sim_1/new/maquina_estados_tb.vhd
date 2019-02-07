library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end entity;

architecture behav of maquina_estados_tb is

component maquina_estados 
    port( clk, rst: in std_logic;
          state_i: out integer range 0 to 3 ;
          next_state_i: in integer range 0 to 3;
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (3-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          producto: in integer range 3-1 downto 0);
end component;
signal clk, rst, compuerta_dinero: std_logic;
signal state, next_state: integer range 0 to 3;
signal compuerta_refresco: std_logic_vector (3-1 downto 0);
signal producto: integer range 3-1 downto 0;

begin
 uut: maquina_estados port map (clk, rst, state, next_state, compuerta_dinero, compuerta_refresco, producto);
 
clock: process
begin
    clk<='0';
    wait for 1 ns;
    clk<='1';
    wait for 1 ns;
end process;

process
begin
    rst<='0';
    wait for 20 ns;
    rst<='1';
    wait for 50 ns;
end process;

process
begin
    next_state<=0;
    wait for 5 ns;
    next_state<=1;
    wait for 5 ns;
    next_state<=3;
    wait for 5 ns;
    next_state<=2;
    wait for 5 ns;
end process;

process
begin
    producto<=0;
    wait for 20 ns;
    producto<=1; 
    wait for 20 ns;
    producto<=2; 
    wait for 20 ns;
end process;

end architecture;

    
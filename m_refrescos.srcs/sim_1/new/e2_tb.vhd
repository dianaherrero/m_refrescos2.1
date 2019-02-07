library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity e2_tb is
end e2_tb;

architecture Behavioral of e2_tb is

signal state: integer range 0 to 3 ;
signal next_state: integer range 0 to 3;
signal sensor_dinero: std_logic;

component e2
     port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3;
          sensor_dinero: in std_logic;
          clk: in std_logic
        );--corresponderá al siguiente estado
end component;

begin
uut: e2 port map (state, next_state, sensor_dinero, '0');

process 
begin
    state<=0;
    sensor_dinero<='0';
    wait for 20 ns;
    state<=2;
    wait for 30 ns;
    sensor_dinero<='1';
    wait for 20 ns;
end process;

end Behavioral;

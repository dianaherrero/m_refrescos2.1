library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity e0_tb is
end entity;

architecture behavioral of e0_tb is

signal state: integer range 0 to 3 :=2;
signal next_state: integer range 0 to 3;
signal producto: integer range 2 downto 0;
signal refrescos: std_logic_vector (2 downto 0);

component e0
    generic(N: integer);
    port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3;
          producto: out integer range N-1 downto 0;
          refrescos: in std_logic_vector (N-1 downto 0));
end component;

begin
utt1: e0 generic map(3) port map(state, next_state, producto, refrescos);

process
begin
wait for 10 ns;
state<=0;
end process;

process
begin
refrescos<= "000";
wait for 2 ns;
refrescos<="110";
wait for 2 ns;
refrescos<="001";
wait for 2 ns;
refrescos<="000";
wait until state=0;
wait for 3 ns;
refrescos<="010";
wait for 2 ns;
refrescos<="011";
wait for 2 ns;
refrescos<="100";
wait for 2 ns;
refrescos<="001";
wait for 2 ns;
end process;
        
        
end architecture;
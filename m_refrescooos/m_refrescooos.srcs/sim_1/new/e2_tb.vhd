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

component e2
   port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3);
end component;

begin
uut: e2 port map (state, next_state);

process 
begin
    wait for 50 ns;
    if state=3 then state<=0;
    else state <= state+1;
    end if;
end process;

end Behavioral;

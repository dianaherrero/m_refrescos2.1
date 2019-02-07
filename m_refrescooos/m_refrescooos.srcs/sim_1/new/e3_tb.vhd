--ya está comprobado
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity e3_tb is
end e3_tb;

architecture Behavioral of e3_tb is

component e3
    generic( N: integer:=3);
    port( producto_agotado: in std_logic_vector (N-1 downto 0);--detecta si alguno de los productos está agotado
          producto: in integer range N-1 downto 0;
          state_in: in integer range 0 to 3;
          state_out: out integer range 0 to 3);
end component;

signal agotado:  std_logic_vector (2 downto 0);
signal producto: integer range 2 downto 0 ;
signal state: integer range 0 to 3 ;
signal next_state: integer range 0 to 3 ;

begin
uut: e3 port map(agotado, producto, state, next_state);

process 
begin
    wait for 50 ns;
    if state=3 then state<=0;
    else state <= state+1;
    end if;
end process;

process
begin
    agotado<="000";
    wait for 20 ns;
    agotado<="001";
    wait for 20 ns;
    agotado<="010";
    wait for 20 ns;
    agotado<="011";
    wait for 20 ns;
    agotado<="100";
    wait for 20 ns;
    agotado<="101";
    wait for 20 ns;
    agotado<="110";
    wait for 20 ns;
    agotado<="111";
    wait for 20 ns;
end process;

process
begin
    wait for 10 ns;
    if producto=2 then producto<=0;
    else producto<= producto+1;
    end if;
end process;
    
end Behavioral;
--ya está comprobado
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity e3 is
    generic( N: integer:=3);
    port( producto_agotado: in std_logic_vector (N-1 downto 0);--detecta si alguno de los productos está agotado
          producto: in integer range N-1 downto 0;
          state_in: in integer range 0 to 3;
          state_out: out integer range 0 to 3:=3;
          sensor_refresco: in std_logic;
          clk: in std_logic
         );
end e3;

architecture Behavioral of e3 is

begin         

e3: process(state_in, sensor_refresco)
begin
--if rising_edge (clk) then
    if state_in=3 then
    --para ejecutarse todo, tiene que cumplirse que se está en el estado 3
        if (producto_agotado(producto)='1') then --si está agotado te manda al estado de error
            state_out<=2;
        else
        --si no, se mantiene en el estado durante 5 s (suponemos que ese es el tiempo que tarda en caer)
             if sensor_refresco='1' then
                  state_out<=0 ;--vuelve al estado inicial
             else
                  state_out<=3;
             end if;
        end if;
    else
        state_out<=3;
    end if;
--end if;
end process;

end Behavioral;

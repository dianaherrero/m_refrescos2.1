library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

--no se puede (o no se como) poner en la entidad se�ales del tipo state_type, as� que las simulo con enteros
entity e2 is
    port( state_in: in integer range 0 to 3;--corresponder� al estado actual
          state_out: out integer range 0 to 3;
          sensor_dinero: in std_logic;--corresponder� al siguiente estado
          clk: in std_logic
        );
end e2;

architecture Behavioral of e2 is

begin

--estado de error, simplemente dura 5s (supongo que es el tiempo que tarda en caer el dinero), y luego te devuelve al estado 0. 
  --en el proceso de salidas est� indicado que mientras se est� en este estado, la compuerta del dinero estar� abierta
  e2: process(state_in)
   begin
   if rising_edge(clk) then
      if state_in=2 then
      state_out<=2;
        if sensor_dinero='1' then
            state_out<=0;--este no es el tiempo que luego se pondr�
        end if;
      end if;
   end if;
   end process;

end Behavioral;
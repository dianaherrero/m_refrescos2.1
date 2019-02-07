library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity e0 is
    generic(N: integer);
    port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3;
          producto: out integer range N-1 downto 0;
          refrescos: in std_logic_vector (N-1 downto 0);
          clk: in std_logic
        );
end entity;

architecture behavioral of e0 is

begin

--estado inicial. Elegir refresco  
e0: process(state_in, refrescos)
      variable prod: integer range N downto 0:=N;--hago una variable que luego asignaré a la señal del producto, para que se actualice inmediatamente en el proceso, y no al final del mismo
  begin
  --if rising_edge (clk) then
      if state_in=0 then
          prod := N;--inicializo a un producto N, que será un producto que no existe (el número máximo de producto es N-1)
          for i in refrescos'range loop --se asigna al producto el número correspondiente al interruptor elegido
              if refrescos(i)='1' then prod := i; end if;
          end loop;
          --si no se ha activado ningun pin, el producto debería seguir siendo el N, así que el estado no varía
          if prod<N and state_in=0 then --si se ha escogido un producto, te manda al estado 1
              state_out<=1;
              producto<=prod; --guardamos el producto escogido antes de salir del estado
          else 
              state_out<=0;
          end if;
      else
        prod:=N;
      end if;
 -- end if;
  end process;
end architecture;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity e1 is
    port(cancelar: in std_logic; --para cancelar el pedido y volver a elegir
         moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector
         precio: in integer range 0 to 900;--se gruardará el precio del producto correspondiente
         state_in: in integer range 0 to 3;--corresponderá al estado actual
         state_out: out integer range 0 to 3;--corresponderá al siguiente estado
         dinero: out integer range 0 to 900;--para mostrar en el decodificador el dinero que falta
         clk: in std_logic
         );
end entity;

architecture behavioral of e1 is

begin

e1: process(state_in, moneda, cancelar)--no va a haber problemas con el tiempo que esté acrivo el pin de lectura, porque sólo se vuelve a contar cuando moneda cambia
variable count: integer range 0 to 1000:=0;
begin
if rising_edge (clk) then
    if state_in=1 then --los procesos de cada estado sólo se ejecutan si se está en el estado correspondiente
        case moneda is --dependiendo de qué sensor esté activo, se suma el importe correspondiente. Cada sensor corresponde a un pin distinto del vector
            when "00001"=> count:= count+10;  
            when "00010"=> count:= count+20; 
            when "00100"=> count:= count+50; 
            when "01000"=> count:= count+100; 
            when "10000"=> count:= count+200; 
            when others=> count:= count; 
        end case;
            if cancelar='1' and count=0 then --si pulsas cancelar antes de haber introducido importe, vas al estado inicial
                state_out<=0;
            elsif cancelar='1' or count>precio then --si pulsas cancelar pero ya has introducido parte, o bien te pasas de precio, vas al estado de error para que te lo devuelva
                state_out<=2; 
                count:=0; --el contador se pone a 0 para la próxima vez que introduzcas el importe
            elsif count=precio then --si introduces lo exacto vas al estado que te saca el refresco
                state_out<=3; 
                count:=0;
            elsif count<precio then
                state_out<=1;
            end if;
            dinero<=precio-count;
    end if;
 end if;
 end process;
 
 end architecture;

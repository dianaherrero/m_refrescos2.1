library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity maquina_estados is
    port( clk, rst: in std_logic;
          state_i: out integer range 0 to 3 ;
          next_state_i: in integer range 0 to 3;
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (3-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          producto: in integer range 3-1 downto 0);
end maquina_estados;

architecture Behavioral of maquina_estados is
TYPE state_type IS (S0, S1, S2, S3);
SIGNAL state, next_state: state_type;--se guardan el estado actual y el siguiente

begin

with next_state_i select
    next_state<= s0 when 0,
            s1 when 1,
            s2 when 2,
            s3 when others;
with state select
    state_i<= 0 when s0,
                1 when s1,
                2 when s2,
                3 when others;


--sincronizar los procesos, se ejecuta para pasar de un estado al siguiente (es copiado de la práctica 3, pero debería funcionar igual)
SYNC_PROC: PROCESS (clk)--se actualiza con cada señal de reloj
BEGIN
 --IF rising_edge(clk) THEN
 IF (rst = '0') THEN --siempre el rst te devuelve al estado inicial
 state <= S0;
 ELSE --si no, el estado será el guardado en next_state, que varía en función del proceso referido a cada estado
 state <= next_state;
 END IF;
 --END IF;
END PROCESS;

--salidas del proceso, son las compuertas del dinero y del refresco
output: process (state, clk)
BEGIN
 CASE (state) is
 WHEN S2 => compuerta_dinero <= '1'; compuerta_refresco <=(others=>'0');--se abre mientras dura el estado 2, que serán 5s
 WHEN S3 => compuerta_refresco(producto)<='1';  compuerta_dinero <= '0';--se abre la correspondiente al producto escogido, mientras dura el estado 3, 5s
 WHEN OTHERS => compuerta_dinero <= '0'; compuerta_refresco <=(others=>'0');--en el 0 y 1, todas las compuertas están cerradas
 END CASE;
END PROCESS;


end Behavioral;

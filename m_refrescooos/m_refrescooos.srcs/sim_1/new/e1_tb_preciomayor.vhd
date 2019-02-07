library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

--nos mostrará un cambio de estado, y la introducción del precio justo
entity e1_tb_preciomayor is
end e1_tb_preciomayor;

architecture Behavioral of e1_tb_preciomayor is
    signal state: integer range 0 to 3 ;
    signal next_state: integer range 0 to 3;
    signal cancelar: std_logic;
    signal moneda: std_logic_vector (4 downto 0);
    signal precio: integer range 0 to 1000;
    signal dinero: integer range 0 to 1000;
    
component e1
    port(cancelar: in std_logic; --para cancelar el pedido y volver a elegir
        moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector
        precio: in integer range 0 to 1000;--se gruardará el precio del producto correspondiente
        state_in: in integer range 0 to 3;--corresponderá al estado actual
        state_out: out integer range 0 to 3;--corresponderá al siguiente estado
        dinero: out integer range 0 to 1000
      );
end component;

begin
uut: e1 port map (cancelar, moneda, precio, state, next_state, dinero);
precio<=100;--el precio en esta prueba es de 80 cents
cancelar<='0';--en ningún momento se pulsará cancelar
    cambio_estado:process 
    begin
        wait for 10 ns;
        state<=1;
    end process;
    
    echar_monedas:process--tiene que llevarnos al estado 3
    begin
        moneda<="00000"; 
        wait for 5ns;
        moneda<="00100"; --echo 50 cents
        wait for 5ns;
        moneda<="00010"; --echo 20cents
        wait for 5ns;
        moneda<="00001";--echo 10 cents
        wait for 5ns;
        moneda<="01000"; --echo 1euro
        wait for 5ns;
    end process;
        
end architecture;
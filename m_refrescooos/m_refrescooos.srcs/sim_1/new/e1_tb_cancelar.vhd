library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

--nos mostrará un cambio de estado, y la introducción del precio justo
entity e1_tb_cancelar is
end e1_tb_cancelar;

architecture Behavioral of e1_tb_cancelar is
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

process
begin
    cancelar<='0';
    state<=1;
    wait for 5ns;
    moneda<="00010";--echo 20 cents
    wait for 5 ns;
    cancelar<='1';--debería llevarme al estado 2
    wait for 5ns;
    moneda<="00000";--el lector deja de leer nada
    cancelar<='0';
    wait for 5ns;
    cancelar<='1';--debería llevarme al estado 3
    wait for 5ns;
end process;

end architecture;
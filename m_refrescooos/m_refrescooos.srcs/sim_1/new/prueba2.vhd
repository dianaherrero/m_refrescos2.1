--damos al reset, escogemos un producto, echamos el dinero; nos pasamos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity prueba2_tb is
end entity;

architecture behavioural of prueba2_tb is

component m_refrescos
        generic( N: integer:=3; --número de refrescos
             p1: integer:=100; --el precio de cada producto en cents
             p2: integer:=150;
             p3: integer:=200);
    port( clk, rst: in std_logic; --rst está activo a nivel bajo
          cancelar: in std_logic; --para cancelar el pedido y volver a elegir
          moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector. Es inout para que pueda dejar el sensor activo hasta que lo lea, y después desactivarlo
          refrescos: in std_logic_vector (N-1 downto 0); --eliges el refresco con un interruptor/pulsador conectado a un pin del vector
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (N-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          agotado: in std_logic_vector (N-1 downto 0);--un vector de sensores que detectan si el producto está agotado
          ledcien, leddiez, leduno: out std_logic_vector (6 downto 0)--muestra el precio que falta por pagar
    );
end component;

signal clk, rst, cancelar, compuerta_dinero: std_logic;
signal agotado, refrescos, compuerta_refresco: std_logic_vector (2 downto 0):="000";
signal moneda: std_logic_vector (4 downto 0):="00000";
signal ledcien, leddiez, leduno: std_logic_vector (6 downto 0);

begin
utt: m_refrescos port map(clk, rst, cancelar, moneda, refrescos, compuerta_dinero, compuerta_refresco, agotado, ledcien, leddiez, leduno);

cancelar<='0'; 

clock: process
begin
    clk<='0';
    wait for 1 ns;
    clk<='1';
    wait for 1 ns;
end process;

---cambiar a partir de aquí
process
begin
    rst<='0';
    wait for 5 ns;
    rst<='1';
    wait for 5 ns;
    refrescos<="001"; --he cogido el producto cuyo precio es 100
    wait for 5 ns;
    moneda<="00100"; --echo 50cents
        refrescos<="000";--no debería afectar a nada
    wait for 5ns;
    moneda<="00001";--echo 10 cents
    wait for 5ns;
    moneda<="00010"; --echo 20 cents
    wait for 5ns;
    moneda<="10000"; --echo 2 euros
    wait for 20ns;
end process;
end architecture;
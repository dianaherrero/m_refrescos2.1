--damos al reset, escogemos un producto, echamos el dinero hasta llegar al IMPORTE EXACTO
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity maq_estados_top_tb is
end entity;

architecture Behavioral of maq_estados_top_tb is

component maq_estados_top
    generic( N: integer:=3;--numero de refrescos
             p1: integer:=100; --el precio de cada producto en cents
             p2: integer:=150;
             p3: integer:=200
           );
    port( clk, rst: in std_logic; --rst está activo a nivel bajo
          cancelar: in std_logic; --para cancelar el pedido y volver a elegir
          moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector. Es inout para que pueda dejar el sensor activo hasta que lo lea, y después desactivarlo
          refrescos: in std_logic_vector (N-1 downto 0); --eliges el refresco con un interruptor/pulsador conectado a un pin del vector
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (N-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          agotado: in std_logic_vector (N-1 downto 0);--un vector de sensores que detectan si el producto está agotado
          dinero: out integer range 0 to 1000;--para mostrar en el decodificador el dinero que falta
          sensor_refresco, sensor_dinero: in std_logic;
          compuerta_dinero2: out std_logic;
          senal_estado0: out std_logic
        );
end component;

signal clk, rst, cancelar, compuerta_dinero: std_logic;
signal agotado, refrescos, compuerta_refresco: std_logic_vector (2 downto 0):="000";
signal moneda: std_logic_vector (4 downto 0):="00000";
signal dinero: integer range 0 to 1000;
signal sensor_refresco, sensor_dinero: std_logic;
signal compuerta_dinero2: std_logic;
signal senal_estado0: std_logic;

begin
utt: maq_estados_top port map ( clk, rst, cancelar, moneda, refrescos, compuerta_dinero, compuerta_refresco, 
agotado, dinero, sensor_refresco, sensor_dinero, compuerta_dinero2, senal_estado0);

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
    sensor_refresco<='0';
    wait for 5 ns;
    rst<='1';
    wait for 5 ns;
    refrescos<="010"; --he cogido el producto cuyo precio es 150
    wait for 5 ns;
    moneda<="00010"; --echo 20cents
        refrescos<="000";--no debería afectar a nada
    wait for 5ns;
    moneda<="00001";--echo 10 cents
    wait for 5ns;
    moneda<="01000"; --echo 1euro
    wait for 5ns;
    moneda<="00010"; --echo 20cents
    wait for 20ns;
    sensor_refresco<='1';
    wait for 20 ns;
end process;

end architecture;
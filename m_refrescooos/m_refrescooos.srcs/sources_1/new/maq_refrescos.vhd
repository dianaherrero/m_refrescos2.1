library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity maq_refrescos is
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
          sensor_refresco, sensor_dinero: in std_logic;
          compuerta_dinero2: out std_logic;
          senal_estado0: out std_logic;
          leds_display: out std_logic_vector (6 downto 0);--muestra el precio que falta por pagar
          activarleds: out std_logic_vector (3 downto 0);
          led_punto_display: out std_logic
    );
end maq_refrescos;

architecture Behavioral of maq_refrescos is

signal dinero: integer range 0 to 1000;--para mostrar en el decodificador el dinero que falta
signal unidades, centenas, decenas: integer range 0 to 9;--se usarán para los displays


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

component decod_top
    port(   leds_display: out std_logic_vector (6 downto 0);--muestra el precio que falta por pagar
            activarleds: out std_logic_vector (3 downto 0);
            dinero: in integer;
            clk: in std_logic;
            led_punto_display: out std_logic
         );
end component;

begin

utt: maq_estados_top port map ( clk, rst, cancelar, moneda, refrescos, compuerta_dinero, compuerta_refresco, 
agotado, dinero, sensor_refresco, sensor_dinero, compuerta_dinero2, senal_estado0);

dec: decod_top port map ( leds_display, activarleds, dinero, clk, led_punto_display);

end Behavioral;

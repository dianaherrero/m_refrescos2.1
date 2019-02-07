library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity m_refrescos is
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
          agotado: in std_logic_vector (N-1 downto 0)--un vector de sensores que detectan si el producto está agotado
         --ledcien, leddiez, leduno: out std_logic_vector (6 downto 0);--muestra el precio que falta por pagar
         --activarleds: out std_logic_vector (3 downto 0)
    );
end entity;

architecture Behavioral of m_refrescos is

signal precio: integer range 0 to 900;--se gruardará el precio del producto correspondiente
signal producto: integer range N-1 downto 0;--se guardará el producto justo antes de salir del estado 0 (donde se elige)
signal dinero: integer range 0 to 900;--para ir mostrando el dinero que falta por meter, así como el precio cuando no has metido nada
signal unidades, centenas, decenas: integer range 0 to 9;--se usarán para los displays
signal state_i: integer range 0 to 3 ;--estado actual (para ir pasándolo entre distintos components)
signal next_state_i, next0, next1, next2, next3: integer range 0 to 3;--siguiente
    

component e0
    generic(N: integer);--numero de productos que hay
    port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3;--estado siguiente
          producto: out integer range N-1 downto 0;--se guardará el producto seleccionado
          refrescos: in std_logic_vector (N-1 downto 0));--vector para seleccionar producto
end component;

component e1
    port(cancelar: in std_logic; --para cancelar el pedido y volver a elegir
        moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector
        precio: in integer range 0 to 1000;--se gruardará el precio del producto correspondiente
        state_in: in integer range 0 to 3;--corresponderá al estado actual
        state_out: out integer range 0 to 3;--corresponderá al siguiente estado
        dinero: out integer range 0 to 1000--para mostrar en el decodificador el dinero que falta
      );
end component;

component e2
   port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3);--estado siguiente
end component;


component e3
    generic( N: integer:=3);--numero de productos que hay
    port( producto_agotado: in std_logic_vector (N-1 downto 0);--detecta si alguno de los productos está agotado
          producto: in integer range N-1 downto 0;--que producto hay seleccionado
          state_in: in integer range 0 to 3;--estado actual
          state_out: out integer range 0 to 3);--estado siguiente
end component;

component maquina_estados 
    port( clk, rst: in std_logic;
          state_i: out integer range 0 to 3 ;--estado actual
          next_state_i: in integer range 0 to 3;--estado siguiente
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (3-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          producto: in integer range 3-1 downto 0);--que producto hay elegido(para poder abrir la compuerta correspondiente)
end component;

component decod
port(  code: in integer range 0 to 9;--numero que meteremos
	   led: out std_logic_vector (6 downto 0));--leds del display
end component;

begin

--asignación del precio:
--(si se os ocurre una forma de hacerlo para que sea genérico; que el número de productos sea N, mucho mejor)
with producto select
    precio<=p1 when 0,--son generics donde has introducido el precio de cada producto
            p2 when 1,
            p3 when others;

--Máquina de estados: sincroniza el proceso y da la salida de cada estado
 uut: maquina_estados port map (clk, rst, state_i, next_state_i, compuerta_dinero, compuerta_refresco, producto);
 

--estado inicial. Elegir refresco  
utt0: e0 generic map(3) port map(state_i, next0, producto, refrescos);

--estado 1: introducir el dinero
 uut1: e1 port map (cancelar, moneda, precio, state_i, next1, dinero);
 
 --estado de error, simplemente dura 5s (supongo que es el tiempo que tarda en caer el dinero), y luego te devuelve al estado 0. 
 --en el proceso de salidas está indicado que mientras se esté en este estado, la compuerta del dinero estará abierta
uut2: e2 port map (state_i, next2);
 
 
 --estado de salida del producto
uut3: e3 generic map(3) port map(agotado, producto, state_i, next3);
 
--según  el estado en que nos encontremos, su proceso correspondiente será el que nos diga cuál es el siguiente estado
with state_i select
    next_state_i<= next3 when 3,
                   next2 when 2,
                   next1 when 1,
                   next0 when others;

--visuslizar el precio (que falta por pagar)
centenas<=dinero/100;
decenas<=(dinero-centenas*100)/10;
unidades<=(dinero-centenas*100-decenas*10);
--uttc: decod port map (centenas, ledcien);
--uttd: decod port map (decenas, leddiez);
--uttu: decod port map (unidades, leduno);

end architecture;
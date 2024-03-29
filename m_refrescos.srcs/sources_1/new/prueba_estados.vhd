library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity prueba_estados is
    generic( N: integer:=3; --n�mero de refrescos
             p1: integer:=100; --el precio de cada producto en cents
             p2: integer:=150;
             p3: integer:=200);
    port( clk, rst: in std_logic; --rst est� activo a nivel bajo
          cancelar: in std_logic; --para cancelar el pedido y volver a elegir
         -- producto_agotado: in std_logic_vector (N-1 downto 0);--detecta si alguno de los productos est� agotado
          moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector. Es inout para que pueda dejar el sensor activo hasta que lo lea, y despu�s desactivarlo
          refrescos: in std_logic_vector (N-1 downto 0); --eliges el refresco con un interruptor/pulsador conectado a un pin del vector
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (N-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          agotado: in std_logic_vector (N-1 downto 0);--un vector de sensores que detectan si el producto est� agotado
          ledcien, leddiez, leduno: out std_logic_vector (6 downto 0)--muestra el precio que falta por pagar
          --prueba-----------------------------------------
          ;
          state: out integer range 0 to 3;
          next_state: out integer range 0 to 3
          -----------------------------------------------------
    );
end entity;

architecture Behavioral of prueba_estados is

signal precio: integer range 0 to 900;--se gruardar� el precio del producto correspondiente
signal producto: integer range N-1 downto 0;--se guardar� el producto justo antes de salir del estado 0 (donde se elige)
signal dinero: integer range 0 to 900;--para ir mostrando el dinero que falta por meter, as� como el precio cuando no has metido nada
signal unidades, centenas, decenas: integer range 0 to 9;
signal state_i: integer range 0 to 3 ;--estado actual (para ir pas�ndolo entre distintos components)
signal next_state_i, next0, next1, next2, next3: integer range 0 to 3;--siguiente
    

component e0
    generic(N: integer);
    port( state_in: in integer range 0 to 3;--corresponder� al estado actual
          state_out: out integer range 0 to 3;
          producto: out integer range N-1 downto 0;
          refrescos: in std_logic_vector (N-1 downto 0));
end component;

component e1
    port(cancelar: in std_logic; --para cancelar el pedido y volver a elegir
        moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector
        precio: in integer range 0 to 1000;--se gruardar� el precio del producto correspondiente
        state_in: in integer range 0 to 3;--corresponder� al estado actual
        state_out: out integer range 0 to 3;--corresponder� al siguiente estado
        dinero: out integer range 0 to 1000--para mostrar en el decodificador el dinero que falta
      );
end component;

component maquina_estados 
    port( clk, rst: in std_logic;
          state_i: out integer range 0 to 3 ;
          next_state_i: in integer range 0 to 3;
          compuerta_dinero: out std_logic; --abre la compuerta que deja caer el dinero 
          compuerta_refresco: out std_logic_vector (3-1 downto 0); --abre la compuerta que deja caer cada respectivo refresco
          producto: in integer range 3-1 downto 0);
end component;

begin

--asignaci�n del precio:
--(si se os ocurre una forma de hacerlo para que sea gen�rico; que el n�mero de productos sea N, mucho mejor)
with producto select
    precio<=p1 when 0,--son generics donde has introducido el precio de cada producto
            p2 when 1,
            p3 when others;

--M�quina de estados: sincroniza el proceso y da la salida de cada estado
 uut: maquina_estados port map (clk, rst, state_i, next_state_i, compuerta_dinero, compuerta_refresco, producto);
 

--estado inicial. Elegir refresco  
utt0: e0 generic map(3) port map(state_i, next0, producto, refrescos);

--estado 1: introducir el dinero
 uut1: e1 port map (cancelar, moneda, precio, state_i, next1, dinero);
 
with state_i select
    next_state_i<= next3 when 3,
                   next2 when 2,
                   next1 when 1,
                   next0 when others;

--prueba----------------------------------------------------------------
state<=state_i;
next_state<= next_state_i;
----------------------------------------------
  end architecture;
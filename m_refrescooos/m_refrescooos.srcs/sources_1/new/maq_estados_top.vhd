library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity maq_estados_top is
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
end entity;

architecture Behavioral of maq_estados_top is

TYPE state_type IS (S0, S1, S2, S3);
SIGNAL state, next_state: state_type;--se guardan el estado actual y el siguiente
signal estado, siguiente_estado, siguiente0, siguiente1, siguiente2, siguiente3: integer range 0 to 3;
signal producto: integer range N-1 downto 0;--se guardará el producto justo antes de salir del estado 0 (donde se elige)
signal precio: integer range 0 to 900;--se gruardará el precio del producto correspondiente
signal moneda2: std_logic_vector (4 downto 0);


component e0
    generic(N: integer);
    port( state_in: in integer range 0 to 3;--corresponderá al estado actual
          state_out: out integer range 0 to 3;
         producto: out integer range N-1 downto 0;
         refrescos: in std_logic_vector (N-1 downto 0);
         clk: in std_logic
        );
end component;

component e1
    port(cancelar: in std_logic; --para cancelar el pedido y volver a elegir
     moneda: in std_logic_vector (4 downto 0); --el sensor lee una moneda que activa el pin correspondiente del vector
     precio: in integer range 0 to 900;--se gruardará el precio del producto correspondiente
     state_in: in integer range 0 to 3;--corresponderá al estado actual
     state_out: out integer range 0 to 3;--corresponderá al siguiente estado
     dinero: out integer range 0 to 900;--para mostrar en el decodificador el dinero que falta
     clk: in std_logic
     );
end component;

component e2
    port( state_in: in integer range 0 to 3;--corresponderá al estado actual
      state_out: out integer range 0 to 3;
      sensor_dinero: in std_logic;--corresponderá al siguiente estado
      clk: in std_logic
    );
end component;


component e3
    generic( N: integer:=3);
port( producto_agotado: in std_logic_vector (N-1 downto 0);--detecta si alguno de los productos está agotado
      producto: in integer range N-1 downto 0;
      state_in: in integer range 0 to 3;
      state_out: out integer range 0 to 3:=3;
      sensor_refresco: in std_logic;
      clk: in std_logic
    );
end component;

component debouncer
     port (
 clk : in std_logic;
 rst : in std_logic;
 btn_in : in std_logic;
 btn_out : out std_logic);
 end component;
 
begin

deb0: debouncer port map (clk, rst, moneda(0), moneda2(0));
deb1: debouncer port map (clk, rst, moneda(1), moneda2(1));
deb2: debouncer port map (clk, rst, moneda(2), moneda2(2));
deb3: debouncer port map (clk, rst, moneda(3), moneda2(3));
deb4: debouncer port map (clk, rst, moneda(4), moneda2(4));

--cambios de estado

--estado inicial. Elegir refresco  
utt0: e0 generic map(3) port map(estado, siguiente0, producto, refrescos, clk);


--estado 1: introducir el dinero
 uut1: e1 port map (cancelar, moneda2, precio, estado, siguiente1, dinero, clk);
 
 --estado de error, simplemente dutra 5s (supongo que es el tiempo que tarda en caer el dinero), y luego te devuelve al estado 0. 
 --en el proceso de salidas está nindicado que mientras se esté en este estado, la compuerta del dinero estará abierta
uut2: e2 port map (estado, siguiente2, sensor_dinero, clk);
 
 
 --estado de salida del producto
uut3: e3 generic map(3) port map(agotado, producto, estado, siguiente3, sensor_refresco, clk);


--según  el estado en que nos encontremos, su proceso correspondiente será el que nos diga cuál es el siguiente estado
with estado select
    siguiente_estado<= siguiente3 when 3,
                   siguiente2 when 2,
                   siguiente1 when 1,
                   siguiente0 when others;

--asignación del precio:
--(si se os ocurre una forma de hacerlo para que sea genérico; que el número de productos sea N, mucho mejor)
with producto select
    precio<=p1 when 0,--son generics donde has introducido el precio de cada producto
            p2 when 1,
            p3 when others;


--sincronizar los procesos, se ejecuta para pasar de un estado al siguiente (es copiado de la práctica 3, pero debería funcionar igual)
SYNC_PROC: PROCESS (clk)--se actualiza con cada señal de reloj
BEGIN
 IF rising_edge(clk) THEN
 IF (rst = '0') THEN --siempre el rst te devuelve al estado inicial
 state <= S0;
 ELSE --si no, el estado será el guardado en next_state, que varía en función del proceso referido a cada estado
 state <= next_state;
 END IF;
 END IF;
END PROCESS;

--salidas del proceso, son las compuertas del dinero y del refresco
output: process (state, clk)
BEGIN
 CASE (state) is
 WHEN S2 => compuerta_dinero <= '1'; --se abre mientras dura el estado 2
            compuerta_refresco <=(others=>'0'); 
            senal_estado0<='0';
            compuerta_dinero2<= '0';
 WHEN S3 => compuerta_refresco(producto)<='1'; --se abre la correspondiente al producto escogido, mientras dura el estado 3
            compuerta_dinero <= '0'; 
            senal_estado0<='0';
            compuerta_dinero2<= '1';            
 WHEN s0 => senal_estado0<='1';
            compuerta_dinero <= '0'; 
            compuerta_refresco <=(others=>'0');
            compuerta_dinero2<= '0'; 
 WHEN others => compuerta_dinero <= '0'; 
                compuerta_refresco <=(others=>'0'); 
                senal_estado0<='0';
                compuerta_dinero2<= '0';
 END CASE;
END PROCESS;

with siguiente_estado select
    next_state<= s0 when 0,
            s1 when 1,
            s2 when 2,
            s3 when others;
with state select
    estado<= 0 when s0,
                1 when s1,
                2 when s2,
                3 when others;


end architecture;

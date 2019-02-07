library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity decod_top is
    port(   leds_display: out std_logic_vector (6 downto 0);--muestra el precio que falta por pagar
            activarleds: out std_logic_vector (3 downto 0):="1111";
            dinero: in integer;
            clk: in std_logic;
            led_punto_display: out std_logic
         );
end decod_top;

architecture Behavioral of decod_top is

signal clk2: std_logic;

component clk_div
	generic(N: integer:=27);
	port(	clk: in std_logic;
		    clk_out: out std_logic);
end component;

component decod
	port(  code: in integer range 0 to 9;
	       led: out std_logic_vector (6 downto 0);
	       clk: in std_logic
	     );
end component;

signal ledcien, leddiez, leduno: std_logic_vector(6 downto 0);
signal centenas, decenas, unidades: integer range 0 to 9;
signal act_leds: std_logic_vector (3 downto 0):="1111";

begin

centenas<=dinero/100;
decenas<=(dinero-centenas*100)/10;
unidades<=(dinero-centenas*100-decenas*10);
uttc: decod port map (centenas, ledcien, clk);
uttd: decod port map (decenas, leddiez, clk);
uttu: decod port map (unidades, leduno, clk);

clockdiv: clk_div generic map(500) port map (clk, clk2);

process (clk2)
begin
if rising_edge(clk2) then
    if act_leds="1101" then
        act_leds<="0111";
        leds_display<=ledcien;
        led_punto_display<='0';
    elsif act_leds="0111" then
        act_leds<="1011";
        leds_display<=leddiez;
        led_punto_display<='1';
    else
        act_leds<="1101";
        leds_display<=leduno;
        led_punto_display<='1';
    end if;
    activarleds<=act_leds;
end if;
end process;

end architecture;

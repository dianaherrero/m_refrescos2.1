library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity decod_top_tb is
end entity;

architecture behav of decod_top_tb is

component decod_top
    port(   leds_display: out std_logic_vector (6 downto 0);--muestra el precio que falta por pagar
            activarleds: out std_logic_vector (3 downto 0);
            dinero: in integer;
            clk: in std_logic;
            led_punto_display: out std_logic
         );
end component;

signal leds_display: std_logic_vector (6 downto 0);
signal activarleds: std_logic_vector (3 downto 0);
signal dinero: integer;
signal clk: std_logic:='0';
signal led_punto_display: std_logic;

begin

utt: decod_top port map (leds_display, activarleds, dinero, clk, led_punto_display);

dinero<=150;

clock: process 
begin
    clk<=not clk;
    wait for 1 ns;
end process;

end architecture;
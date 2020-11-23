----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2020 02:41:57 AM
-- Design Name: 
-- Module Name: RelojAlarm_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RelojAlarm_tb is
--  Port ( );
end RelojAlarm_tb;

architecture Behavioral of RelojAlarm_tb is

Component RelojAlarma is
    Port ( btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnC : in STD_LOGIC;
           clk : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (2 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           dp : out STD_LOGIC);
end Component RelojAlarma;

constant clk_hz : integer := 100e6;
constant clk_period: time := 1 sec / clk_hz;
constant num_cycles : integer := 1000;

signal clk: std_logic := '0';
signal buttons: std_logic_vector ( 4 downto 0);
signal leds: std_logic_vector ( 2 downto 0); 
signal segs: std_logic_vector ( 6 downto 0); 
signal ans: std_logic_vector ( 3 downto 0);
signal point: std_logic; 

begin
-----------------------------------------------------
    DBP: RelojAlarma port map(
           btnU => buttons(0),
           btnD => buttons(0),
           btnL => buttons(0),
           btnR => buttons(0),
           btnC => buttons(0),
           clk => clk,
           led => leds,
           seg => segs,
           an => ans,
           dp => point
        );
-----------------------------------------------------     
    process  
    begin
        for i in 1 to num_cycles loop
            clk <= not clk;
            wait for clk_period / 2;
            clk <= not clk;
            wait for clk_period / 2;
        end loop;
    end process;   
     

end Behavioral;

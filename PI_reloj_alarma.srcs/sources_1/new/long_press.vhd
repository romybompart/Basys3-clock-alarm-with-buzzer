----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2020 09:40:33 AM
-- Design Name: 
-- Module Name: long_press - Behavioral
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity long_press is

    generic (
            max_counter_size: integer:= 32
    );

    Port ( clk : in STD_LOGIC;
           pulse : in STD_LOGIC;
           enable : in STD_LOGIC;
           result : out STD_LOGIC);
end long_press;

architecture Behavioral of long_press is

signal counter : std_logic_vector (31 downto 0):= (others => '0');

begin

    detect_pulse: process (clk)
    begin
    
        if enable = '0' or pulse = '0' then
        
            counter <= (others => '0');
            result <= '0';
        elsif (clk'event and clk = '1') then 
        
            if counter = x"5F5E100" and pulse = '1' then -- 5F5E100 (1s) or 11E1A300 (3s)
                result <= '1';
            else
                counter <= counter + 1;
                result <= '0';
            end if;   
        end if;
         
    end process detect_pulse;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: FIME
-- Engineer: Romy Domingo Bompart Ballache
-- 
-- Create Date: 11/10/2020 08:20:48 PM
-- Design Name: Proyecto integrador
-- Module Name: clock_mult_div - Behavioral
-- Project Name: Clase de VHDL
-- Target Devices: BASYS 3
-- Tool Versions: VIVADO 2020
-- Description: Divisor de multiples salidas, utliza como entrada el reloj de entrada
-- y lo subdivide en diferentes frecuencias
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

entity clock_mult_div is

    Generic (
        max_counter_1sec: integer := 28;
        max_counter_500msec: integer := 28;
        max_counter_10msec: integer := 20;
        max_counter_1msec: integer := 20
--        max_counter_2usec: integer := 5
    );

    Port ( inPulse : in std_logic;
           OutPulse_1sec : out std_logic;
           OutPulse_500ms : out std_logic;
           OutPulse_10ms : out std_logic;
           OutPulse_1ms  : out std_logic
           );
end clock_mult_div;

architecture Behavioral of clock_mult_div is
    signal counter_out1: std_logic_vector (max_counter_1sec downto 0):= (others => '0');
    signal counter_out2: std_logic_vector (max_counter_500msec downto 0) := (others => '0');
    signal counter_out3: std_logic_vector (max_counter_10msec downto 0) := (others => '0');
    signal counter_out4: std_logic_vector (max_counter_1msec downto 0) := (others => '0');
--    signal counter_out4: std_logic_vector (max_counter_2usec downto 0) := (others => '0');
    --main process
    begin
    
    T_1sec : process (inPulse)
    begin
        if ( inPulse'event and inPulse='1' ) then
        
            -- counting every time the inpulse comes
            -- 1 sec counter
            counter_out1 <= counter_out1 + 1;
            if ( counter_out1 = x"5F5E100" ) then
                counter_out1 <= (others => '0');
                OutPulse_1sec <= '1';
            else
                OutPulse_1sec <= '0';
            end if;  
            
        end if;
        
    end process T_1sec;
    
    T_500msec : process (inPulse)
    begin
        if ( inPulse'event and inPulse='1' ) then
           -- 16 msec counter
           counter_out2 <= counter_out2 + 1;
           if ( counter_out2 = x"2FAF080" ) then
                OutPulse_500ms <= '1';
                counter_out2 <= (others => '0');
            else    
                OutPulse_500ms <= '0';
            end if; 
            
         end if;  
            
      end process T_500msec;        
            
            
        T_10msec : process (inPulse)
        begin
        if ( inPulse'event and inPulse='1' ) then
            -- 10 msec counter
            counter_out3 <= counter_out3 + 1;
            if ( counter_out3 = x"F4240" ) then
                OutPulse_10ms <= '1';
                counter_out3 <= (others => '0');
            else    
                OutPulse_10ms <= '0';
            end if;
         end if;
        end process T_10msec; 
  
  
        T_1msec : process (inPulse)
        begin
         if ( inPulse'event and inPulse='1' ) then
            -- 1 msec counter186A0
            counter_out4 <= counter_out4 + 1;
            if ( counter_out4 = x"186A0" ) then
                OutPulse_1ms <= '1';
                counter_out4 <= (others => '0');
            else    
                OutPulse_1ms <= '0';
            end if;
         end if;
        end process T_1msec;  

end Behavioral;

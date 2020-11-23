----------------------------------------------------------------------------------
-- Company: FIME
-- Engineer: Romy Domingo Bompart Ballache
-- 
-- Create Date: 11/10/2020 08:20:48 PM
-- Design Name: Proyecto integrador
-- Module Name: debouncer - Behavioral
-- Project Name: Clase de VHDL
-- Target Devices: BASYS 3
-- Tool Versions: VIVADO 2020
-- Description: Debouncer para amortiguar el efecto mecanico cuando se presiona
--  algun pulsador. 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    
    Generic (
           counter_size: integer :=20
    );

    Port ( InPulse : in STD_LOGIC;
           button : in STD_LOGIC;
           OutPulse : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    --FF1 and FF2
    signal flipflops : std_logic_vector(1 downto 0);
    --Clear counter
    signal counter_set: std_logic;
    --Counter registers
    signal counter_out: std_logic_vector(counter_size downto 0):=(others => '0');    

    --Main process
    begin

        counter_set <= flipflops(0) xor flipflops(1);

        process (InPulse)
         begin
            if(InPulse'event and InPulse='1') then
                flipflops(0)<=button;
                flipflops(1)<=flipflops(0);
                if(counter_set='1') then
                    counter_out <= (others => '0');
                elsif (counter_out(counter_size)='0') then
                    counter_out <= counter_out + 1;
                else
                    OutPulse <= flipflops(1);
                end if;
             end if;
        end process;


end Behavioral;

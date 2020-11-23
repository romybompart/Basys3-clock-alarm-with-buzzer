----------------------------------------------------------------------------------
-- Company: FIME
-- Engineer: Romy Domingo Bompart Ballache
-- 
-- Create Date: 11/10/2020 08:20:48 PM
-- Design Name: Proyecto integrador
-- Module Name: Deco_bcd27seg - Behavioral
-- Project Name: Clase de VHDL
-- Target Devices: BASYS 3
-- Tool Versions: VIVADO 2020
-- Description: Decodificador de bcd a display de 7 segmentos
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

entity Deco_bcd27seg is
    Port ( 
           clk : in std_logic;
           in_bcd : in STD_LOGIC_VECTOR (3 downto 0);
           out_7seg : out STD_LOGIC_VECTOR (6 downto 0));
end Deco_bcd27seg;

architecture Behavioral of Deco_bcd27seg is

    -- main process
    begin
    
    -- pseudosequencial code for the bcd decoder
    bcd_deco: process ( clk ) 
    begin
        if clk'event and clk = '1' then 
            case in_bcd is
                when "0000" => out_7seg <= "1000000"; -- "0"
                when "0001" => out_7seg <= "1111001"; -- "1" 
                when "0010" => out_7seg <= "0100100"; -- "2" 
                when "0011" => out_7seg <= "0110000"; -- "3" 
                when "0100" => out_7seg <= "0011001"; -- "4" 
                when "0101" => out_7seg <= "0010010"; -- "5" 
                when "0110" => out_7seg <= "0000010"; -- "6" 
                when "0111" => out_7seg <= "1111000"; -- "7" 
                when "1000" => out_7seg <= "0000000"; -- "8"     
                when "1001" => out_7seg <= "0011000"; -- "9" 
                when others => out_7seg <= "1111111"; -- "nothing" 
            end case;
         end if;
    end process bcd_deco;

end Behavioral;

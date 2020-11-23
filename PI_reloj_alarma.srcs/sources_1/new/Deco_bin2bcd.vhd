----------------------------------------------------------------------------------
-- Company: FIME
-- Engineer: Romy Domingo Bompart Ballache
-- 
-- Create Date: 11/10/2020 08:20:48 PM
-- Design Name: Proyecto integrador
-- Module Name: Deco_bin2bcd - Behavioral
-- Project Name: Clase de VHDL
-- Target Devices: BASYS 3
-- Tool Versions: VIVADO 2020
-- Description: Decodificador de binario a bcd del 0 al 59
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Deco_bin2bcd is
    Port ( 
           clk : in std_logic;
           in_binary : in STD_LOGIC_VECTOR (6 downto 0);
           out_bcd : out STD_LOGIC_VECTOR (7 downto 0));
end Deco_bin2bcd;

architecture Behavioral of Deco_bin2bcd is
    --new object romtable which consist in a vector of 64 elemnts 
    --each element posses 8 bits
    type romtable is array (0 to 59) of std_logic_vector ( 7 downto 0);
    -- set of data which storages the BCD code for number 0 to 59
    constant bcd_data : romtable := 
        (
        "00000000", "00000001", "00000010", "00000011", -- data for address 0, 1, 2, 3
        "00000100", "00000101", "00000110", "00000111",
        "00001000", "00001001", "00010000", "00010001",
        "00010010", "00010011", "00010100", "00010101",
        "00010110", "00010111", "00011000", "00011001",
        "00100000", "00100001", "00100010", "00100011",
        "00100100", "00100101", "00100110", "00100111",
        "00101000", "00101001", "00110000", "00110001",
        "00110010", "00110011", "00110100", "00110101",
        "00110110", "00110111", "00111000", "00111001",
        "01000000", "01000001", "01000010", "01000011",
        "01000100", "01000101", "01000110", "01000111",
        "01001000", "01001001", "01010000", "01010001",
        "01010010", "01010011", "01010100", "01010101",
        "01010110", "01010111", "01011000", "01011001" -- data for address 56, 57, 58, 59
        );
    
    -- Main process
    begin
        -- behavior
        -- purpose: main process
        -- input: in_binary
        -- outputs: out_bcd
        decoder: process ( clk )
        begin -- process 
            if clk'event and clk='1' then
                out_bcd <= bcd_data(to_integer(unsigned(in_binary)));
            end if;
        end process decoder;

end Behavioral;

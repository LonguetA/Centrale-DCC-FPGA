----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2023 09:39:24
-- Design Name: 
-- Module Name: testbench_Trames - Behavioral
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

entity testbench_Trames is
--  Port ( );
end testbench_Trames;

architecture Behavioral of testbench_Trames is
signal Interrupteur	: STD_LOGIC_VECTOR(7 downto 0);	-- Interrupteurs de la Carte
signal Trame_DCC 	: STD_LOGIC_VECTOR(50 downto 0);

begin

    -- INSTANCIATION FRAME GENERATOR
    A0 : entity work.DCC_FRAME_GENERATOR
    port map(
        Interrupteur => Interrupteur,
        Trame_DCC => Trame_DCC
    );
    
    
    -- PROCESS TEST
    process

    -- VAR POUR CHECKSUM (DEBUG)
    variable xorr : std_logic_vector (7 downto 0);

    begin

        -- VAL SWITCH 
        Interrupteur(7) <='1';

        -- VERIF CHEKCSUM (DEBUG)
        xorr := ("01010101" xor "01110011");
        
        wait for 5 ns;
        

        -- ASSERT BONNE GENERATION DE TRAME
        assert Trame_DCC = "111111111111111111111110010101010011100110001001101" report "Error 7" severity error;
       
        
        wait; 
    end process;
end Behavioral;

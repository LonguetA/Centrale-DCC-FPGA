----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 11:18:29
-- Design Name: 
-- Module Name: testbench_reg_DCC - Behavioral
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

entity testbench_reg_DCC is
--  Port ( );
end testbench_reg_DCC;

architecture Behavioral of testbench_reg_DCC is
signal clk_100MHz : std_logic := '0';
signal        reset : std_logic; 
signal       com_reg : std_logic_vector(1 downto 0);
signal        Trame_DCC 	: STD_LOGIC_VECTOR(50 downto 0);
signal       bit_s : std_logic;


begin
    
    -- INSTANCIATION REG DCC
    T1 : entity work.registre_DCC 
    port map(
        CLK_100MHz => clk_100MHz,
        reset => reset,
        Trame_DCC => Trame_DCC,
        com_reg => com_reg,
        bit_s => bit_s
    );

    -- CLOCK 100M
    CLK_100MHz <= not CLK_100MHz after 5 ns;
    
    -- INIT
    reset <= '1', '0' after 10 ns;

    -- TRAME DCC TEST
    Trame_DCC <= X"F0F0F0F0F0F0" & "111";

    -- TEST CHARGEMENT ET DECALAGE
    com_reg <= "01", "10" after 30 ns;
   
end Behavioral;

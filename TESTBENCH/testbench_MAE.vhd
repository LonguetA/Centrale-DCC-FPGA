----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2023 09:00:57
-- Design Name: 
-- Module Name: testbench_MAE - Behavioral
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

entity testbench_MAE is
--  Port ( );
end testbench_MAE;

architecture Behavioral of testbench_MAE is

signal    FIN_1,FIN_0,FIN: std_logic;
signal    GO_1,GO_0,START_TEMPO : std_logic;
signal    COM_REG : std_logic_vector(1 downto 0 );
signal    CLK_100Mhz : std_logic := '0';
signal    reset : std_logic;
signal    bit_s : std_logic;

begin

    -- INSTANCIATION MAE
    A0 : entity work.MAE
    port map(
        FIN_1,
        FIN_0,
        FIN,GO_1,
        GO_0,
        START_TEMPO,
        COM_REG,
        CLK_100Mhz,
        reset,
        bit_s
    );
    
    
    -- CLOCK 100M
    CLK_100MHz <= not CLK_100MHz after 5 ns;

    -- INIT
    reset <= '1', '0' after 10 ns;
    
    -- TEST MAE
    bit_s <= '0', '1' after 50 ns, '1' after 60 ns;
    
    


end Behavioral;

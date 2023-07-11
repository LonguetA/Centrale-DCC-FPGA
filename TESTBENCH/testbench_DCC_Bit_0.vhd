----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 09:41:37
-- Design Name: 
-- Module Name: testbench_DCC_Bit_0 - Behavioral
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

entity testbench_DCC_Bit_0 is
--  Port ( );
end testbench_DCC_Bit_0;

architecture Behavioral of testbench_DCC_Bit_0 is
    
signal CLK_100MHz : std_logic := '0';
signal CLK_1MHz : std_logic := '0'; 
signal reset : std_logic;
signal go : std_logic;
signal fin : std_logic;
signal DCC_0 : std_logic;

begin

    -- INSTANCIATION BIT 0
    B0 : entity work.DCC_Bit_0
    port map(
        CLK_100MHz => CLK_100MHz,
        CLK_1MHz => CLK_1MHz,
        reset => reset,
        go => go,
        fin => fin,
        DCC_0 => DCC_0
    );
    
    -- CLOCK 1M 
    CLK_1MHz <= not CLK_1MHz after 0.5 us;

    -- CLOCK 100M
    CLK_100MHz <= not CLK_100MHz after 5 ns;

    -- INIT
    reset <= '1', '0' after 10 ns;

    -- START GENERATION
    go <= '1', '0' after 30 ns;

    -- PROCESS TEST
    process
    begin
        -- WAIT FIN PARTIE A 0
        wait for 100.5 us;

        -- ASSERT BIT 0 VALUE
        assert DCC_0 = '1' report "error DCC_0" severity error; 
        wait;     
    end process;


end Behavioral;

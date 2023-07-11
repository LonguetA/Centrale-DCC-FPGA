----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 10:45:54
-- Design Name: 
-- Module Name: div_testbench - Behavioral
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

entity div_testbench is
--  Port ( );
end div_testbench;

architecture Behavioral of div_testbench is
 signal Reset : STD_LOGIC;	
 signal Clk_In : STD_LOGIC;	
 
 -- DIV TEST 
 signal Clk_Out:  STD_LOGIC;

 -- DEBUG
 signal p : integer range 0 to 396;

begin

    --  INSTANCIATION DIV CLOCK
    A0 : entity work.clk_div
    port map(
       Reset  => reset,		-- Reset Asynchrone
       Clk_In =>clk_in,		-- Horloge 100 MHz de la carte Nexys
       Clk_Out =>clk_out
    );

    --  PROCESS TEST
    process
    begin

        -- REST INIT
        Reset <= '1';
        Clk_In <= '0';
        wait for 1 ns;
        
        reset <= '0';

        -- TEST SI BONNE DIV 
        for i in 0 to 396 loop 

            -- CHANGE CLOCK
            Clk_In <= not Clk_In;

            -- DEBUG
            p <= i;
            
            -- ASSERT 
            if (i = 98) then assert clk_Out = '1' report "CLK_OUT 1" severity error; 
            elsif (i = 198) then assert clk_Out = '0' report "CLK_OUT 2" severity error;
            end if;
            
            wait for 5 ns;
        end loop;
        
        wait;
    end process;

end Behavioral;

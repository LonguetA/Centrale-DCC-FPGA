----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2023 09:27:08
-- Design Name: 
-- Module Name: tempo_testbench - Behavioral
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

entity tempo_testbench is
--  Port ( );
end tempo_testbench;

architecture Behavioral of tempo_testbench is
    -- SIGNAL INSTANCIATION
    signal  reset,start_tempo,fin_tempo : std_logic;

    -- CLOCK 100M
    signal Clk_In : STD_LOGIC;		

    -- CLOCK 1M
    signal Clk_Out:  STD_LOGIC;

    -- DEBUG
    signal cpt1 : integer range 0 to 1190000;
    signal p : integer range 0 to 1200000;
begin

    -- INSTANCIATION TEMPO
    A0 : entity work.compteur_tempo
    port map(
       Clk 	=> Clk_In,
       Reset => reset,
       Clk1M => Clk_Out,
       Start_Tempo => start_tempo,
       Fin_Tempo => fin_tempo
    );

    -- INSTANCIATION DIV
    A1 : entity work.clk_div
    port map(
       Reset  => reset,		-- Reset Asynchrone
       Clk_In =>clk_in,		-- Horloge 100 MHz de la carte Nexys
       Clk_Out =>clk_out
    );

    
    -- PROCESS TEST
    process
    
    
    begin

        -- INIT 
        reset <= '1';
        Clk_In <= '0';
        wait for 5 ns;
        
        reset <= '0';
        
        -- TEMPS POUR 6MS
        for i in 0 to 1199700 loop
            
            -- START TEMPO SI DEBUT
            if (i = 0)then start_tempo <= '1';
            else start_tempo <= '0';
            end if;
            
            -- CHANGE CLOCK
            Clk_In <= not Clk_In;

            wait for 5 ns;
            
            -- DEBUG 
            p<=i; 

        end loop;
        
        -- ASSERT SI 6MS
        assert fin_tempo = '1' report "TEMPO ERROR" severity error;
        
        wait;
     end process;
    


end Behavioral;

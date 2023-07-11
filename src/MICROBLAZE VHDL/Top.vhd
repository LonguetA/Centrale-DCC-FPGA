----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.03.2023 10:13:08
-- Design Name: 
-- Module Name: testbench_all - Behavioral
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

entity top is
    Port (Clk_In : in std_logic;                         -- CLK 100M
          reset :  in std_logic;                         -- RESET ASYN
          Trame_DCC : in STD_LOGIC_VECTOR(50 downto 0);  -- TRAME DCC 
          sortie_DCC : out std_logic                     -- SORTIE BIT DCC
     );
end top;

architecture Behavioral of top is

    -- SIGNAL POUR INSTANCIATION
    signal  start_tempo : std_logic;
    signal Clk_Out:  STD_LOGIC;
    signal DCC_0 : std_logic;
    signal DCC_1 : std_logic;
    signal FIN_1,FIN_0,FIN: std_logic;
    signal GO_1,GO_0 : std_logic;
    signal COM_REG : std_logic_vector(1 downto 0 );
    signal bit_s : std_logic;

    begin

        -- INSTANCIATION REG DCC
        R0 : entity work.registre_DCC
        port map(clk_In,reset,com_reg,Trame_DCC,bit_s);
        
        -- INSTANCIATION MAE
        M0 : entity work.MAE
        port map(fin_1,fin_0,fin,go_1,go_0,start_tempo,com_reg,clk_in,reset,bit_s);
        
        -- INSTANCIATION TEMPO
        T0 : entity work.Compteur_TEMPO
        port map(clk_In,reset,clk_out,start_tempo,fin);
        
        -- INSTANCIATION DCC 0
        D0 : entity work.DCC_bit_0
        port map(clk_In,clk_Out,reset,go_0,fin_0,DCC_0);
        
        -- INSTANCIATION DCC 1
        D1 : entity work.DCC_bit_1
        port map(clk_In,clk_Out,reset,go_1,fin_1,DCC_1);
        
        -- INSTANCIATION DIV
        C1 : entity work.CLK_DIV
        port map(reset,clk_in,clk_out);
        
        -- CALCUL SORTIE DCC
        sortie_DCC <= DCC_0 or DCC_1;
        
    
end Behavioral;

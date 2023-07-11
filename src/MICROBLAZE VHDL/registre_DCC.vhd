----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 10:54:25
-- Design Name: 
-- Module Name: registre_DCC - Behavioral
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

entity registre_DCC is
    Port (
        clk_100MHz : in std_logic;                      -- CLK 100M
        reset : in std_logic;                           -- RESET ASY
        com_reg : in  std_logic_vector(1 downto 0);     -- COMMANDE 
        Trame_DCC 	: in STD_LOGIC_VECTOR(50 downto 0); -- TRAME DCC A SAVE
        bit_s : out std_logic                           -- SORTIE DECALAGE
     );
end registre_DCC;

architecture Behavioral of registre_DCC is

    -- REG TRAME DCC
    signal trame_reg : std_logic_vector(50 downto 0);

    begin
        
        -- PROCESS 
        process(clk_100MHz,reset)
        begin
            -- RESET
            if reset = '0' then trame_reg <= (others => '0'); bit_S <= '1';
            elsif rising_edge(clk_100MHz) then 
                case (com_reg) is 
                    when "00" => null;  
                    when "01" => trame_reg <= trame_dcc;                                                -- SAUV
                    when "10" => bit_s <= trame_reg(50) ; trame_reg <= trame_reg(49 downto 0) & '1';    -- DECALAGE
                    when "11" => null;
                    when others => null;
                end case;
            end if;
        end process;

end Behavioral;

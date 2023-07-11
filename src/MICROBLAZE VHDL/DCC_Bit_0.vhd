----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 09:00:50
-- Design Name: 
-- Module Name: DCC_Bit_1 - Behavioral
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

entity DCC_Bit_0 is
   Port (CLK_100MHz : in std_logic; -- CLOCK 100M
         CLK_1MHz : in std_logic;   -- CLOCK 1M
         reset : in std_logic;      -- RESET ASYN
         go : in std_logic;         -- START GEN
         fin : out std_logic;       -- END GEN
         DCC_0 : out std_logic      -- VAL DCC SORTIE
    );
end DCC_Bit_0;

architecture Behavioral of DCC_Bit_0 is

    -- COMPTEUR
    signal cpt : integer range 0 to 201;

    -- ETAT
    type Etat is (S0,S1,S2,S3);
    signal EP,EF : Etat;

    begin

        -- RESET ET CHANGEMENT ETAT
        process(CLK_100MHz,reset)
        begin 
            if reset = '0' then EP <= S0;
            elsif rising_edge(CLK_100MHz) then EP <= EF;
            end if;
        end process;

        -- CALCUL ETAT FUTUR
        process(EP,go,cpt)
        begin 
            case (EP) is 
                when S0 => EF <= S0 ; if go = '1' and cpt = 0 then EF <= S1; end if;
                when S1 => EF <= S1 ; if cpt = 101 then EF <= S2; end if; 
                when S2 => EF <= S2 ; if cpt = 201 then EF <= S3; end if;
                when S3 => EF <= S0;
            end case;
        end process ;

        -- CALCUL SORTIE 
        process(EP)
        begin 
        case (EP) is 
                when S0 =>  fin <= '0' ; DCC_0 <= '0';
                when S1 =>  fin <= '0' ; DCC_0 <= '0';
                when S2 =>  fin <= '0' ; DCC_0 <= '1'; 
                when S3 =>  fin <= '1' ; DCC_0 <= '0';
            end case;
        end process ;

        -- CHANGEMENT CPT 
        process(CLK_1MHz,reset)
        begin
            if reset = '0' then cpt <= 0;
            elsif rising_edge(CLK_1MHz) then 
                case (EP) is 
                when S0 => cpt <= 0;
                when S1 => cpt <= cpt + 1;
                when S2 => cpt <= cpt + 1;
                when S3 => cpt <= cpt;
            end case;
        end if;
        end process;

end Behavioral;

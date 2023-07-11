----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2023 11:41:49
-- Design Name: 
-- Module Name: MAE - Behavioral
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

entity MAE is
Port (
    FIN_1,FIN_0,FIN: IN std_logic;                -- FIN DCC 1 0 TEMPO
    GO_1,GO_0,START_TEMPO : OUT std_logic;        -- START DCC 1 0 TEMPO
    COM_REG : out std_logic_vector(1 downto 0 );  -- COMMANDE REG DCC
    CLK_100Mhz : in std_logic;                    -- CLK 100M
    reset : in std_logic;                         -- RESET ASY
    bit_s : in std_logic                          -- BIT DCC SORTIE
 );
end MAE;

architecture Behavioral of MAE is

    -- STATE
    type ETAT is (S0,S1,S2,S3,S4,S5);

    -- CPT
    signal cpt : integer range 0 to 52;
    signal EF,EP : ETAT;

    begin

        -- RESET ET CHANGEMENT ETAT
        process(CLK_100MHZ,reset)
        begin
            if reset ='0' then EP<=S0;
            elsif rising_edge(CLK_100Mhz)then EP<=EF;
            end if;
        end process;
        
        -- CALCUL ETAT FUTUR
        process(EP,bit_s,FIN_1,FIN_0,FIN,cpt)
        begin
            case (EP) is 
            when S0 => EF<=S5;
            when S1 => EF<=S2; if cpt=52 then EF<=S4; elsif bit_s='1' then EF<=S3; end if;  
            when S2 => EF<=S2; if FIN_0='1' then EF<=S1; end if;
            when S3 => EF<=S3; if FIN_1='1' then EF<=S1; end if;
            when S4 => EF<=S4;  if FIN='1' then EF<=S5; end if;
            when S5 => EF<=S1;
        end case;
        end process;

        -- CALCUL SORTIE
        process(EP)
        begin
            case (EP) is 
            when S0 => COM_REG<="00"; GO_0<='0';GO_1<='0'; START_TEMPO<='0';
            when S1 => COM_REG<="10"; GO_0<='0';GO_1<='0'; START_TEMPO<='0';
            when S2 => GO_0<='1'; COM_REG<="00";GO_1<='0'; START_TEMPO<='0' ;
            when S3 => GO_1<='1'; COM_REG<="00"; GO_0<='0'; START_TEMPO<='0';
            when S4 => START_TEMPO<='1'; COM_REG<="00"; GO_0<='0'; GO_1<='0';
            when S5 => COM_REG<="01"; GO_0<='0'; GO_1<='0'; START_TEMPO<='0' ;
        end case;
        end process;
        
        -- CHANGEMENT CPT
        process(CLK_100MHz,reset)
        begin
            if reset = '0' then cpt <= 0;
            elsif rising_edge(CLK_100MHz) then
                case (EP) is 
                    when S1 => cpt <= cpt + 1;
                    when S5 => cpt <= 0;
                    when others => null;
                end case;
            end if;
        end process;
end Behavioral;

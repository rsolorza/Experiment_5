----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:48:00 01/10/2016 
-- Design Name: 
-- Module Name:    fsm_template - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  FSM template
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


entity my_fsm4 is 
    port (      RCO1, RCO2, RCO3, BTN ,CLK, LT : in  std_logic;  
                    WE, CLR, CLR2, EN, LD, EN2 : out std_logic;
                                        PRESET : out std_logic_vector (3 downto 0);
                                             Y : out std_logic_vector (2 downto 0);
                                           SEL : out std_logic_vector (1 downto 0));
end my_fsm4;

architecture fsm4 of my_fsm4 is
   type state_type is (DISPLAY, TRANSFER, COMPARE, SWAP1, SWAP2); 
   signal PS,NS : state_type; 
begin
   sync_proc: process(CLK, NS)
   begin
     if (rising_edge(CLK)) then  
	     PS <= NS; 
     end if; 
   end process sync_proc; 

   comb_proc: process(PS, RCO1, RCO2, RCO3, BTN, LT)
   begin
      -- Z1: the Moore output; Z2: the Mealy output
      WE <= '0'; CLR <= '0'; CLR2 <= '0'; EN <= '0'; EN2 <= '0'; SEL <= "00"; PRESET <= "0000"; -- pre-assign the outputs
      case PS is 
         when DISPLAY =>    -- items regarding state ST0 
            EN <= '1';           
            
            if (BTN = '0') then
                NS <= DISPLAY; 
            else 
                NS <= TRANSFER; 
                CLR <= '1';
            end if;
				
         when TRANSFER =>    -- items regarding state ST1
            WE <= '1';
            EN <= '1'; 
            SEL <= "11"; -- pre-assign the outputs
            
            if (RCO1 = '0') then 
				   NS <= TRANSFER;   
            else  
				   NS <= COMPARE;
				   PRESET <= "0001"; 
				   LD <= '1';   				   
            end if; 
				
         when COMPARE =>    -- items regarding state ST2
            if (LT = '1') then 
                NS <= COMPARE;
                EN <= '1';
                EN2 <= '1';   
            else  
                NS <= SWAP1;
                EN <= '0';                      
            end if;    
            
         when SWAP1 =>    -- items regarding state ST3
            WE <= '1';
            SEL <= "00";
            EN <= '1';
            NS <= SWAP2;
            	 
		 when SWAP2 =>
            WE <= '1'; 
            EN <= '0';
            SEL <= "01";
            if (RCO3 = '1') then 
                NS <= DISPLAY;  
                CLR <= '1';
                CLR2 <= '1';
            elsif (RCO2 = '0' and RCO3 = '0') then
                NS <= COMPARE;
                EN2 <= '1';
            else
                NS <= COMPARE;
                CLR <= '1';
                PRESET <= "0001";
                LD <= '1';
                EN2 <= '1';
            end if;   
            
		 
         when others => -- the catch all condition
            WE <= '0'; CLR <= '0'; CLR2 <= '0'; EN <= '0'; EN2 <= '0'; SEL <= "00"; PRESET <= "0000";
      end case; 
		
   end process comb_proc; 
 
   with PS select
      Y <= "000" when DISPLAY, 
           "001" when TRANSFER, 
           "010" when COMPARE, 
           "011" when SWAP1,
           "100" when SWAP2,
           "111" when others; 
end fsm4;

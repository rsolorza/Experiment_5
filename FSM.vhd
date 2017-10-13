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
              WE, CLR1, CLR2, CLR3, EN, LD, EN2 : out std_logic;
                                        PRESET : out std_logic_vector (3 downto 0);
                                             Y : out std_logic_vector (2 downto 0);
                                           SEL : out std_logic_vector (1 downto 0));
end my_fsm4;

architecture fsm4 of my_fsm4 is
   type state_type is (DISPLAY, TRANSFER, COMPARE, SWAP1, SWAP2, RESET); 
   signal PS, NS : state_type; 
begin
   sync_proc: process(CLK, NS)
   begin
     if (rising_edge(CLK)) then  
	     PS <= NS; 
     end if; 
   end process sync_proc; 

   comb_proc: process(PS, RCO1, RCO2, RCO3, BTN)
   begin
      -- Z1: the Moore output; Z2: the Mealy output
      WE <= '0'; CLR1 <= '0'; CLR2 <= '0'; CLR3 <= '0'; EN <= '0'; EN2 <= '0'; SEL <= "00"; PRESET <= "0000"; LD <= '0'; -- pre-assign the outputs
      case PS is 
         when DISPLAY =>    -- items regarding state ST0 
            EN <= '1';           
            
            if (BTN = '0') then
                NS <= DISPLAY; 
            else 
                NS <= TRANSFER; 
                CLR1 <= '1';
                CLR2 <= '1';
                CLR3 <= '1';
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
            if (RCO1 = '1') then
                NS <= RESET;
            end if;
            if (LT = '1') then
                if (RCO3 = '1') then
                    NS <= DISPLAY;
--                elsif (RCO1 = '1') then
--                    --NS <= RESET;
--                    EN <= '1';
--                    EN2 <= '1';
--                    NS <= COMPARE; 
--                    CLR1 <= '1';
--                    PRESET <= "0001";
--                    LD <= '1';
                else
                    NS <= COMPARE;
                    EN <= '1';
                    EN2 <= '1'; 
                end if;
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
            elsif(RCO1 = '1') then
                NS <= RESET;
            else
                NS <= COMPARE;
                EN2 <= '1';
            end if;   
            
		 when RESET =>
		      EN <= '1';
		      NS <= COMPARE;
		      CLR1 <= '1';
		      PRESET <= "0001";
		      EN2 <= '1';
		      LD <= '1';
		      
		      if (RCO3 = '1') then 
                 NS <= DISPLAY;
              end if;  
		 
		 
         when others => -- the catch all condition
            WE <= '0'; CLR1 <= '0'; CLR2 <= '0'; CLR3 <= '0'; EN <= '0'; EN2 <= '0'; SEL <= "00"; PRESET <= "0000";
      end case; 
		
   end process comb_proc; 
 
   with PS select
      Y <= "000" when DISPLAY, 
           "001" when TRANSFER, 
           "010" when COMPARE, 
           "011" when SWAP1,
           "100" when SWAP2,
           "101" when RESET,
           "111" when others; 
end fsm4;

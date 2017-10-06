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
    port (                RCO1, RCO2, BTN ,CLK, RESET : in  std_logic;  
            LD1, LD2, SEL1, SEL2, CLR, UP, EN, EN2, WE : out std_logic;
                                                    Y : out std_logic_vector (2 downto 0));  
end my_fsm4;

architecture fsm4 of my_fsm4 is
   type state_type is (DISPLAY,TRANSFER,LOAD_REG_1,LOAD_REG_2,WRITE_1,WRITE_2); 
   signal PS,NS : state_type; 
begin
   sync_proc: process(CLK,NS,RESET)
   begin
     if (RESET = '1') then  
	     PS <= DISPLAY; 
     elsif (rising_edge(CLK)) then  
	     PS <= NS; 
     end if; 
   end process sync_proc; 

   comb_proc: process(PS, RCO1, RCO2, BTN)
   begin
      -- Z1: the Moore output; Z2: the Mealy output
      LD1 <= '0'; LD2 <= '0'; SEL1 <= '0'; SEL2 <= '0'; CLR <= '0'; UP <= '0'; EN <= '0'; WE <= '0'; EN2 <= '0'; -- pre-assign the outputs
      case PS is 
         when DISPLAY =>    -- items regarding state ST0
            LD1 <= '0'; 
            LD2 <= '0'; 
            SEL1 <= '0'; 
            SEL2 <= '0'; 
            UP <= '1'; 
            EN <= '1';
            WE <= '0';
            EN2 <= '0';
            
            if (BTN = '0') then
                NS <= DISPLAY; 
                CLR <= '0';
            else 
                NS <= TRANSFER; 
                CLR <= '1';
            end if;
				
         when TRANSFER =>    -- items regarding state ST1
            LD1 <= '0'; 
            LD2 <= '0'; 
            SEL1 <= '0'; 
            SEL2 <= '1'; 
            UP <= '1'; 
            EN <= '1'; 
            WE <= '1';
            CLR <= '0';
            EN2 <= '0';
            
            if (RCO1 = '0') then 
				   NS <= TRANSFER;   
            else  
				   NS <= LOAD_REG_1;  
            end if; 
				
         when LOAD_REG_1 =>    -- items regarding state ST2
            LD1 <= '1'; 
            LD2 <= '0'; 
            SEL1 <= '0'; 
            SEL2 <= '0'; 
            UP <= '1';
            CLR <= '0'; 
            EN <= '1';
            EN2 <= '0';
            WE <= '0';
            
            NS <= LOAD_REG_2;
            
         when LOAD_REG_2 =>    -- items regarding state ST3
            LD1 <= '0'; 
            LD2 <= '1'; 
            SEL1 <= '0'; 
            SEL2 <= '0'; 
            UP <= '0'; 
            EN <= '1';
            CLR <= '0';
            WE <= '0';
            EN2 <= '0';
            
            NS <= WRITE_1;
		 
		 when WRITE_1 =>
            LD1 <= '0'; 
            LD2 <= '0'; 
            SEL1 <= '1'; 
            SEL2 <= '0'; 
            UP <= '1'; 
            EN <= '1';
            CLR <= '0';
            WE <= '1';
            EN2 <= '0';
            
            NS <= WRITE_2;
		 
		 when WRITE_2 =>
            LD1 <= '0'; 
            LD2 <= '0'; 
            SEL1 <= '0'; 
            SEL2 <= '0'; 
            UP <= '1'; 
            EN <= '0';
            WE <= '1';
            CLR <= '0';
            EN2 <= '1';
            
            if (RCO1 = '1') then
                EN <= '1';
            end if;
            
            if(RCO2 = '0') then
                NS <= LOAD_REG_1;
            else 
                NS <= DISPLAY; 
                --CLR <= '1';
            end if;
		 
         when others => -- the catch all condition
            LD1 <= '0'; LD2 <= '0'; SEL1 <= '0'; SEL2 <= '0'; CLR <= '0'; UP <= '0'; EN <= '0';
      end case; 
		
   end process comb_proc; 
 
   with PS select
      Y <= "000" when DISPLAY, 
           "001" when TRANSFER, 
           "010" when LOAD_REG_1, 
           "011" when LOAD_REG_2,
           "100" when WRITE_1,
           "101" when WRITE_2, 
           "111" when others; 
end fsm4;

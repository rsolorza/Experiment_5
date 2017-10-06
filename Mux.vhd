----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/19/2017 01:03:59 PM
-- Design Name: 
-- Module Name: Mux_2x1 - Behavioral
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

entity Mux_2x1 is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));

end Mux_2x1;

architecture Behavioral of Mux_2x1 is

begin
    myProcess: process (A, B, SEL)
    begin 
    
        if (SEL = '0') then
            OUTPUT <= A;
        else
            OUTPUT <= B;
        end if;
    end process;

end Behavioral;

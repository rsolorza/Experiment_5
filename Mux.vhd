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

entity Mux_3x2 is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           C : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));

end Mux_3x2;

architecture Behavioral of Mux_3x2 is

begin
    myProcess: process (A, B, C, SEL)
    begin 
    
        if (SEL = "00") then
            OUTPUT <= A;
        elsif (SEL = "01") then
            OUTPUT <= B;
        elsif (SEL = "11") then
            OUTPUT <= C;
        else
            OUTPUT <= "11111111";
        end if;
    end process;

end Behavioral;

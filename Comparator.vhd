----------------------------------------------------------------------------------
-- Company: CPE 133-05/06
-- Engineer: Ty Farris
--           Spencer Shaw
-- Create Date: 05/10/2017 02:46:43 PM
-- Design Name: 
-- Module Name: comp4b - Behavioral
-- Project Name: 8-bit Comparator with 4-bit Comparator Modules
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

entity Comp8B is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           EQ : out STD_LOGIC;
           GT : out STD_LOGIC;
           LT : out STD_LOGIC);
end Comp8B;

architecture Behavioral of Comp8B is
begin
    my_proc: process (A,B)
    begin
        if (A = B) then
            EQ <= '1'; GT <= '0'; LT <= '0';
        elsif (A < B) then
            EQ <= '0'; GT <= '0'; LT <= '1';
        else
            EQ <= '0'; GT <= '1'; LT <= '0';
        end if;
    end process;

end Behavioral;

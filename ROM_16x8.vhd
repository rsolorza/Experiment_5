----------------------------------------------------------------------------------
-- Company: Ratner Engineering  
-- Engineer: James Ratner
-- 
-- Create Date: 09/06/2017 06:06:49 PM
-- Design Name: 
-- Module Name: rom_16x8 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 16x8 ROM with random values
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity rom_16x8 is
    Port ( ADDR : in  STD_LOGIC_VECTOR(3 downto 0); 
           DATA : out STD_LOGIC_VECTOR(7 downto 0));
end rom_16x8;
 
architecture rom_16x8 of rom_16x8 is
 
   TYPE vector_array is ARRAY(0 to 15) of STD_LOGIC_VECTOR(7 downto 0); 
   
   --CONSTANT my_memory: vector_array := ( X"02", X"0A", X"12", X"1A",
     --                                    X"04", X"0C", X"14", X"1C",
       --                                  X"06", X"0E", X"16", X"1E",
         --                                X"08", X"10", X"18", X"20");
    CONSTANT my_memory: vector_array := ( X"20", X"1E", X"1C", X"1A",
                                          X"18", X"16", X"14", X"12",
                                          X"10", X"0E", X"0C", X"0A",
                                          X"08", X"06", X"04", X"02");         
begin
 
   DATA <= my_memory(CONV_INTEGER(ADDR));
 
end rom_16x8;

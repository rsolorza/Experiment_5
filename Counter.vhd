----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2017 10:52:10 PM
-- Design Name: 
-- Module Name: COUNT_8B - Behavioral
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
-- NOTE: NEED TO ADD RCO
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COUNT_4B is
    Port ( RESET : in STD_LOGIC;
           EN: in STD_LOGIC;
           CLK : in STD_LOGIC;
           LD : in STD_LOGIC;
           UP : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (3 downto 0);
           COUNT : out STD_LOGIC_VECTOR (3 downto 0);
           RCO : out STD_LOGIC);
end COUNT_4B;

architecture Behavioral of COUNT_4B is
    signal t_cnt : std_logic_vector(3 downto 0) := "0000";
begin
    
    cntr: process(CLK, LD, UP, DIN, RESET, t_cnt, EN)
    begin 
        if (RESET = '1') then
            t_cnt <= (others => '0'); -- async clear
        elsif (rising_edge(CLK) and EN = '1') then
            if (LD = '1') then
                t_cnt <= DIN; -- load
            else
                if (UP = '1') then
                    t_cnt <= t_cnt + 1; -- incr
                else 
                    t_cnt <= t_cnt - 1; -- decr
                    
                end if;
             end if;
          end if;
       end process;
       
       COUNT <= t_cnt;
       
       RC: process (t_cnt)
       begin 
            if (t_cnt = "1111") then
                RCO <= '1';
            else
                RCO <= '0';
            end if;
        end process;
    
end Behavioral;

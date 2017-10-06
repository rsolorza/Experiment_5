----------------------------------------------------------------------------------
-- Company: 
-- Engineers: Ty Farris, Ryan Solorzano
-- 
-- Create Date: 09/18/2017 12:27:19 PM
 
-- Module Name: Bubble_Sort - Behavioral
-- Project Name: Bubble Sort Project

-- Description: Digital Circuit which loads values from a ROM, then sorts it in a RAM, then displays on BAYSIS 3 board
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Bubble_Sort is
            Port (  CLK : in std_logic;
                    BTN : in std_logic;
                    seg : out std_logic_vector (7 downto 0);
                    led : out std_logic_vector (3 downto 0);
                     an : out std_logic_vector (3 downto 0));
end Bubble_Sort;
 
architecture Behavioral of Bubble_Sort is

    component CLK_DIV_FS
        Port (       CLK : in std_logic;
               FCLK,SCLK : out std_logic);
    end component;

    component sseg_dec_uni
        Port (       COUNT1 : in std_logic_vector(13 downto 0); 
                     COUNT2 : in std_logic_vector(7 downto 0);
                        SEL : in std_logic_vector(1 downto 0);
				      dp_oe : in std_logic;
                         dp : in std_logic_vector(1 downto 0); 					  
                        CLK : in std_logic;
				       SIGN : in std_logic;
				      VALID : in std_logic;
                    DISP_EN : out std_logic_vector(3 downto 0);
                   SEGMENTS : out std_logic_vector(7 downto 0));
    end component;

    component RegisterFile is
        Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
               DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
               DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
               ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
               ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
               WE     : in     STD_LOGIC;
               CLK    : in     STD_LOGIC);
    end component;

    component my_fsm4
        port (                 RCO1, RCO2, BTN ,CLK, RESET : in  std_logic;  
                LD1, LD2, SEL1, SEL2, CLR, UP, EN, EN2, WE : out std_logic;
                                                         Y : out std_logic_vector (2 downto 0));
    end component; 

    component reg
        Port (    D : in std_logic_vector(7 downto 0);
             CLK,LD : in std_logic;
                  Q : out std_logic_vector(7 downto 0));
    end component;

    component rom_16X8
        Port ( ADDR : in  STD_LOGIC_VECTOR(3 downto 0); 
               DATA : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component COUNT_4B
        Port ( RESET : in STD_LOGIC;
                  EN : in STD_LOGIC;
                 CLK : in STD_LOGIC;
                  LD : in STD_LOGIC;
                  UP : in STD_LOGIC;
                 DIN : in STD_LOGIC_VECTOR (3 downto 0);
               COUNT : out STD_LOGIC_VECTOR (3 downto 0);
                 RCO : out STD_LOGIC);
    end component;

    component Mux_2x1
        Port (     A : in STD_LOGIC_VECTOR (7 downto 0);
                   B : in STD_LOGIC_VECTOR (7 downto 0);
                 SEL : in STD_LOGIC;
              OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Comp8B
        Port (  A : in STD_LOGIC_VECTOR (7 downto 0);
                B : in STD_LOGIC_VECTOR (7 downto 0);
               EQ : out STD_LOGIC;
               GT : out STD_LOGIC;
               LT : out STD_LOGIC);
        end component;

    -- intermediate signal decclaration
    signal seg_in : std_logic_vector(13 downto 0) := (others => '0');
     
    signal ram_out : std_logic_vector(7 downto 0) := "00000000"; 
    signal rom_out : std_logic_vector(7 downto 0); 
    signal reg1_out : std_logic_vector(7 downto 0); 
    signal reg2_out : std_logic_vector(7 downto 0); 
    signal mux1_out : std_logic_vector(7 downto 0); 
    signal ram_in : std_logic_vector(7 downto 0) := "00000000";
    
    signal cnt1 : std_logic_vector(3 downto 0) := (others => '0');
    signal state_out : std_logic_vector (2 downto 0) := (others => '0');
    signal cnt2 : std_logic_vector(7 downto 0) := (others => '0');
    
    signal state : std_logic_vector (2 downto 0);
    
    signal rco1 : std_logic := '0'; 
    signal rco2 : std_logic; 
    signal sclk : std_logic; 
    signal fclk : std_logic; 
    signal clr : std_logic := '0'; 
    signal ld1 : std_logic; 
    signal ld2 : std_logic; 
    signal sel1 : std_logic; 
    signal sel2 : std_logic; 
    signal up : std_logic; 
    signal en : std_logic;
    signal en2 : std_logic; 
    signal we : std_logic; 
    signal lt : std_logic; 
    signal gt : std_logic; 
    signal eq : std_logic; 
    signal xnor_out : std_logic; 
    signal s1 : std_logic; 
    signal s2 : std_logic;

begin
	rco1 <= (cnt1(0) and cnt1(1) and cnt1(2) and cnt1(3));
	rco2 <= (cnt2(0) and not cnt2(1) and not cnt2(2) and not cnt2(3) and not cnt2(4) and cnt2(5) and cnt2(6) and cnt2(7));
	led <= cnt1;

    CLK_SLW: CLK_DIV_FS
        port map (CLK => CLK,
                  FCLK => fclk,
                  SCLK => sclk);

    MY_FSM: my_fsm4
        port map (RCO1 => rco1,
                  RCO2 => rco2, 
                  BTN => BTN,
                  CLK => sclk,
                  --CLK => CLK,
                  RESET => '0',
                  LD1 => ld1,
                  LD2 => ld2,
                  SEL1 => sel1,
                  SEL2 => sel2,
                  CLR => clr,
                  UP => up,
                  EN => en,
                  EN2 => en2,
                  WE => we,
                  Y => state_out); 

    CNTR1: COUNT_4B 
        port map ( RESET => CLR,
                   EN => en,
                   CLK => sclk,
                   --CLK => CLK, 
                   LD => '0',
                   UP => UP,
                   DIN => "0000",
                   COUNT => cnt1,
                   RCO => s1);
                   --RCO => rco1);
               
    MY_ROM: rom_16X8
        Port map ( ADDR => cnt1, 
                   DATA => rom_out);
    
    REG1: reg
        Port map (D => ram_out,
                  --CLK => CLK,
                  CLK => sclk,
                  LD => ld1,
                  Q => reg1_out);
                  
    REG2: reg
        Port map (D => ram_out,
                  --CLK => CLK,
                  CLK => sclk,
                  LD => ld2,
                  Q => reg2_out);

                 
    seg_in(7 downto 0) <= ram_out; 
    
    DISP: sseg_dec_uni
        Port map ( COUNT1 => seg_in, 
                   COUNT2 => ram_out,
                   SEL => "00",
                   dp_oe => '0',
                   dp => "00",                       
                   --CLK => sclk,
                   CLK => CLK,
                   SIGN => '0',
                   VALID => '1',
                   DISP_EN => an,
                   SEGMENTS => seg);
    
                   
    COMP: Comp8B
        Port map ( A => reg1_out,
                   B => reg2_out,
                   EQ => eq,
                   GT => gt,
                   LT => lt);
    
    xnor_out <= sel1 xnor lt;
    
    MUX1: Mux_2x1
        Port map ( A => reg2_out,
                   B => reg1_out,
                   SEL => xnor_out,
                   OUTPUT => mux1_out);    
    
    MUX2: Mux_2x1
        Port map ( A => mux1_out,
                   B => rom_out,
                   SEL => sel2,
                   OUTPUT => ram_in);          

end Behavioral;

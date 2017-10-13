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
               ADRX   : in     STD_LOGIC_VECTOR (3 downto 0);
               ADRY   : in     STD_LOGIC_VECTOR (3 downto 0);
               WE     : in     STD_LOGIC;
               CLK    : in     STD_LOGIC);
    end component;

    component my_fsm4
        port (      RCO1, RCO2, RCO3, BTN ,CLK, LT : in  std_logic;  
                 WE, CLR1, CLR2, CLR3, LD, EN, EN2 : out std_logic;
                                            PRESET : out std_logic_vector (3 downto 0);
                                                 Y : out std_logic_vector (2 downto 0);
                                               SEL : out std_logic_vector (1 downto 0));
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

    component COUNT_8B
        Port ( RESET : in STD_LOGIC;
                  EN : in STD_LOGIC;
                 CLK : in STD_LOGIC;
                  LD : in STD_LOGIC;
                  UP : in STD_LOGIC;
                 DIN : in STD_LOGIC_VECTOR (7 downto 0);
               COUNT : out STD_LOGIC_VECTOR (7 downto 0);
                 RCO : out STD_LOGIC);
    end component;


    component Mux_3x2
        Port (     A : in STD_LOGIC_VECTOR (7 downto 0);
                   B : in STD_LOGIC_VECTOR (7 downto 0);
                   C : in STD_LOGIC_VECTOR (7 downto 0);
                 SEL : in STD_LOGIC_VECTOR (1 downto 0);
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
     
    signal dx_out : std_logic_vector(7 downto 0) := "00000000"; 
    signal dy_out : std_logic_vector(7 downto 0) := "00000000"; 
    signal rom_out : std_logic_vector(7 downto 0) := (others => '0'); 
    signal reg1_out : std_logic_vector(7 downto 0) := (others => '0'); 
    signal mux1_out : std_logic_vector(7 downto 0) := (others => '0'); 
    signal ram_in : std_logic_vector(7 downto 0) := "00000000";
    
    signal cnt1 : std_logic_vector(3 downto 0) := (others => '0');
    signal cnt2 : std_logic_vector(3 downto 0) := (others => '0');
    signal cnt3 : std_logic_vector(7 downto 0) := (others => '0');
    signal state_out : std_logic_vector (2 downto 0) := (others => '0');
    
    signal state : std_logic_vector (2 downto 0) := (others => '0');
    
    signal preset : std_logic_vector (3 downto 0) := (others => '0');
    signal sel : std_logic_vector (1 downto 0) := (others => '0'); 
    signal rco1 : std_logic := '0'; 
    signal rco2 : std_logic := '0'; 
    signal rco3 : std_logic := '0';
    signal temp : std_logic := '0';
    signal sclk : std_logic := '0'; 
    signal fclk : std_logic := '0'; 
    signal clr1 : std_logic := '0'; 
    signal clr2 : std_logic := '0';
    signal clr3 : std_logic := '0';
    signal en : std_logic := '0';
    signal en2 : std_logic := '0'; 
    signal we : std_logic := '0'; 
    signal lt : std_logic := '0'; 
    signal gt : std_logic := '0'; 
    signal eq : std_logic := '0'; 
    signal ld : std_logic := '0'; 

begin
	rco3 <= (cnt3(0) and not cnt3(1) and not cnt3(2) and not cnt3(3) and not cnt3(4) and cnt3(5) and cnt3(6) and cnt3(7));
	led <= cnt1;

   DUAL_PORT_RAM: RegisterFile
       port map ( D_IN => mux1_out,
                DX_OUT => dx_out,
                DY_OUT => dy_out,
                  ADRX => cnt1,
                  ADRY => cnt2,
                    WE => we,
                   CLK => sclk);

    CLK_SLW: CLK_DIV_FS
        port map (CLK => CLK,
                  FCLK => fclk,
                  SCLK => sclk);

    MY_FSM: my_fsm4
        port map (RCO1 => rco1, 
                  RCO2 => rco2,
                  RCO3 => rco3,
                   BTN => BTN,
                   CLK => sclk,
                    LT => lt, 
                    WE => we,
                   CLR1 => clr1,
                  CLR2 => clr2,
                  CLR3 => clr3,
                    EN => en,
                   EN2 => en2,
                    LD => ld,
                PRESET => preset,
                Y => state_out,
                SEL => sel);
        
    CNTR1: COUNT_4B 
        port map ( RESET => CLR1,
                   EN => en,
                   CLK => sclk,
                   LD => '0',
                   UP => '1',
                   DIN => "0000",
                   COUNT => cnt1,
                   RCO => rco1);
 
     CNTR2: COUNT_4B 
            port map ( RESET => CLR2,
                          EN => en,
                         CLK => sclk,
                          LD => ld,
                          UP => '1',
                         DIN => preset,
                        COUNT => cnt2,
                          RCO => rco2);
                                  
    CNTR3: COUNT_8B 
        port map ( RESET => CLR3,
                      EN => en2,
                     CLK => sclk,
                       LD => '0',
                       UP => '1',
                      DIN => "00000000",
                    COUNT => cnt3,
                      RCO => temp);                                 
               
    MY_ROM: rom_16X8
        Port map ( ADDR => cnt1, 
                   DATA => rom_out);
    
    REG1: reg
        Port map (D => dx_out,
                  CLK => sclk,
                  LD => '1',
                  Q => reg1_out);
                 
    seg_in(7 downto 0) <= dx_out; 
    
    DISP: sseg_dec_uni
        Port map ( COUNT1 => seg_in, 
                   COUNT2 => dx_out,
                   SEL => "00",
                   dp_oe => '0',
                   dp => "00",                       
                   CLK => CLK,
                   SIGN => '0',
                   VALID => '1',
                   DISP_EN => an,
                   SEGMENTS => seg);
    
                   
    COMP: Comp8B
        Port map ( A => dx_out,
                   B => dy_out,
                   EQ => eq,
                   GT => gt,
                   LT => lt);
    
    
    MUX1: Mux_3x2
        Port map ( A => dy_out,
                   B => reg1_out,
                   C => rom_out,
                   SEL => sel,
                   OUTPUT => mux1_out);             

end Behavioral;

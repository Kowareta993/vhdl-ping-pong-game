library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( cpu_resetn : in STD_LOGIC;
           clk : in STD_LOGIC; 
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           led0 : out STD_LOGIC;
           led1 : out STD_LOGIC;
           led2 : out STD_LOGIC;
           led3 : out STD_LOGIC;
           led4 : out STD_LOGIC;
           led5 : out STD_LOGIC;
           led6 : out STD_LOGIC;
           led7 : out STD_LOGIC;
           ja0 : out STD_LOGIC;
           ja1 : out STD_LOGIC;
           ja2 : out STD_LOGIC;
           ja3 : out STD_LOGIC;
           jb0 : out STD_LOGIC;
           jb1 : out STD_LOGIC;
           jb2 : out STD_LOGIC;
           jb3 : out STD_LOGIC);
           
end top;

architecture Behavioral of top is

component controller is
    Port ( i_rst : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           i_push1 : in STD_LOGIC;
           i_push2 : in STD_LOGIC;
           o_led : out STD_LOGIC_VECTOR (7 downto 0);
           o_score1 : out STD_LOGIC_VECTOR (3 downto 0);
           o_score2 : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal led : std_logic_vector (7 downto 0);
signal ja : std_logic_vector (3 downto 0);
signal jb : std_logic_vector (3 downto 0);
signal rst : std_logic;
begin
    led7 <= led(7);
    led6 <= led(6);
    led5 <= led(5);
    led4 <= led(4);
    led3 <= led(3);
    led2 <= led(2);
    led1 <= led(1);
    led0 <= led(0);
    ja3 <= ja(3);
    ja2 <= ja(2);
    ja1 <= ja(1);
    ja0 <= ja(0);
    jb3 <= jb(3);
    jb2 <= jb(2);
    jb1 <= jb(1);
    jb0 <= jb(0);
    rst <= cpu_resetn nand cpu_resetn;
    UController: controller port map (rst , clk, btnl, btnr, led, ja, jb);

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.MyPackage.WINNING_SCORE;

entity controller is
    Port ( i_rst : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           i_push1 : in STD_LOGIC;
           i_push2 : in STD_LOGIC;
           o_led : out STD_LOGIC_VECTOR (7 downto 0);
           o_score1 : out STD_LOGIC_VECTOR (3 downto 0);
           o_score2 : out STD_LOGIC_VECTOR (3 downto 0));
end controller;

architecture Behavioral of controller is
    type state_type is (IDLE, MOVING, WAITING, SCORED, FINISHED);
    type dir_type is (RTL, LTR);
    signal w_state: state_type;
    signal w_led : std_logic_vector (7 downto 0);
    signal w_score1 : std_logic_vector (3 downto 0);
    signal w_score2 : std_logic_vector (3 downto 0);
    signal w_timer_tick : std_logic;
    signal w_timer_start : std_logic;
    signal w_timer_stop : std_logic;
    signal w_push1, w_push2 : std_logic;
    
    component timer is
        port(
            i_rst: in std_logic;
            i_clk: in std_logic;
            i_start: in std_logic;
            i_stop: in std_logic;
            o_tick: out std_logic
        );
    end component ;
    
    component  debouncer is
    Port ( i_rst : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           i_in : in STD_LOGIC;
           o_out : out STD_LOGIC);
    end component ;
    
begin

    UTimer: timer port map (i_rst, i_clk, w_timer_start, w_timer_stop, w_timer_tick);
    UDebouncer1: debouncer port map (i_rst, i_clk, i_push1, w_push1);
    UDebouncer2: debouncer port map (i_rst, i_clk, i_push2, w_push2);
    o_led  <= w_led;
    w_timer_start <= '1' when w_state = IDLE  or w_state = FINISHED else '0';
    w_timer_stop <= '1' when w_state = SCORED  else '0';  
    o_score1 <= w_score1;
    o_score2 <= w_score2;
    
    process (i_clk, i_rst) 
        variable r_dir : dir_type; 
        variable r_count : integer range 0 to 7;
    begin
        if (i_rst = '1') then
            w_state <= IDLE;
            w_led <= X"00";
            w_score1 <= X"0";
            w_score2 <= X"0";
            r_dir := LTR;
        elsif i_clk'event and i_clk = '1' then
             case w_state is 
                 when IDLE =>   case r_dir is 
                                    when LTR => w_led <= X"80";
                                                if w_push1 = '1' then
                                                    w_state <= MOVING;
                                                    r_count := 0;
                                                end if;
                                    when RTL => w_led <= X"01";
                                                if w_push2 = '1' then
                                                    w_state <= MOVING;
                                                    r_count := 0;
                                                end if;
                                end case;
                                
                            
                 when MOVING => if w_timer_tick = '1' then
                                    case r_dir is
                                        when LTR => w_led <= "0" & w_led(7 downto 1);
                                        when RTL => w_led <= w_led(6 downto 0) & "0";
                                    end case;
                                    if r_count = 6 then
                                        r_count := 0;
                                        w_state <= WAITING;
                                    else 
                                        r_count := r_count + 1;
                                        w_state <= MOVING;
                                    end if;
                                else
                                    w_led <= w_led;
                                    r_count := r_count;
                                end if;
                            
          
                            
                when WAITING => if w_timer_tick = '1' then
                                    w_state <= SCORED;
                                else
                                    case r_dir is
                                        when LTR => if w_push2 = '1' then 
                                                        w_state <= MOVING;
                                                        r_dir := RTL; 
                                                    end if;
                                        when RTL => if w_push1 = '1' then 
                                                        w_state <= MOVING;
                                                        r_dir := LTR; 
                                                    end if;
                                    end case;
                                end if;
                             
                when SCORED =>  case r_dir is
                                    when LTR => if w_score1 = WINNING_SCORE then
                                                    w_state <= FINISHED;
                                                else
                                                    w_state <= IDLE;
                                                end if ;
                                                w_score1 <= std_logic_vector(unsigned(w_score1) + 1);
                                    when RTL => if w_score2 = WINNING_SCORE then
                                                    w_state <= FINISHED;
                                                else
                                                    w_state <= IDLE;
                                                end if ;
                                                w_score2 <= std_logic_vector(unsigned(w_score2) + 1);
                                end case;
                                
                when FINISHED =>case r_dir is
                                    when LTR => if w_push1 = '1' then
                                                    w_led <= X"00";
                                                    w_score1 <= X"0";
                                                    w_score2 <= X"0";
                                                    w_state <= IDLE;
                                                elsif w_timer_tick = '1' then
                                                    if w_led = X"F0" then
                                                        w_led <= X"00";
                                                    else
                                                        w_led <= X"F0";
                                                    end if;
                                                    
                                                end if;
                                    when RTL => if w_push2 = '1' then
                                                    w_led <= X"00";
                                                    w_score1 <= X"0";
                                                    w_score2 <= X"0";
                                                    w_state <= IDLE;
                                                elsif w_timer_tick = '1' then
                                                    if w_led = X"0F" then
                                                        w_led <= X"00";
                                                    else
                                                        w_led <= X"0F";
                                                    end if;
                                                end if;
                                end case;
             end case;
        end if;
    end process;
    
end Behavioral;

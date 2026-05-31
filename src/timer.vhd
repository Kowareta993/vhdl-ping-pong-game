library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyPackage.all;

entity timer is
    Port ( i_start : in STD_LOGIC;
           i_stop : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           o_tick : out STD_LOGIC);
end timer;

architecture Behavioral of timer is
    signal w_ticks : integer range 0 to TICKS;
    signal w_counting : std_logic;
begin

    process (i_clk, i_rst) is
    begin
        if i_rst = '1' then
            w_counting <= '0';
        elsif i_clk'event and i_clk = '1' then
            if i_start = '1' then 
                w_counting <= '1';
            elsif i_stop = '1' then
                w_counting <= '0';
            end if;
        end if;
    end process;
    
    process (i_clk, i_rst) is
    begin
        if i_rst = '1' then
             w_ticks <= 0;
        elsif i_clk'event and i_clk = '1' then
            if w_counting = '1' then
                if w_ticks = TICKS then
                    w_ticks <= 0;
                else
                    w_ticks <= w_ticks + 1;
                end if;
            else
                w_ticks <= 0;
            end if;
        end if;
    end process;
                
    process(w_ticks) begin
        if w_ticks = TICKS  then
            o_tick <= '1';
        else
            o_tick <= '0'; 
        end if;
    end process;
    
end Behavioral;

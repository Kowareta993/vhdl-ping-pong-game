library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.MyPackage.BOUNCER_TICKS;

entity debouncer is
    Port ( i_rst : in STD_LOGIC;
           i_clk : in STD_LOGIC;
           i_in : in STD_LOGIC;
           o_out : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is
    signal w_state : std_logic;
    signal w_count : integer;
begin
    
    
    process (i_rst, i_clk )       
    begin
        if i_rst = '1' then
            w_state <= '0';
        elsif i_clk'event and i_clk = '1' then
            case w_state is
                when '0' =>
                        if w_count = BOUNCER_TICKS - 1 then
                            w_state <= '1';
                        end if; 
                when '1' =>
                        if w_count = BOUNCER_TICKS - 1 then
                            w_state <= '0';
                        end if; 
                when others =>     
            end case;
        end if;   
    end process;
    
    process (i_rst, i_clk)
    begin
        if i_rst = '1' then
            w_count <= 0;
        elsif i_clk'event and i_clk = '1' then
            case w_state is
                when '0' =>
                        if i_in = '1' then
                            if w_count = BOUNCER_TICKS - 1 then
                                w_count <= 0;
                            else
                                w_count <= w_count + 1;
                            end if;
                        else
                            w_count <= 0;
                        end if; 
                when '1' =>
                        if i_in = '0' then
                            if w_count = BOUNCER_TICKS - 1 then
                                w_count <= 0;
                            else
                                w_count <= w_count + 1;
                            end if;
                        else
                            w_count <= 0;
                        end if;    
               when others =>  
            end case;
        end if;   
    end process;
    
    process (i_rst, i_clk)
        variable r_state : std_logic ;
    begin
        if i_rst = '1' then
            o_out <= '0';
            r_state := '0';
        elsif i_clk'event and i_clk = '1' then
            case r_state is
                when '0' =>
                    if w_state = '1' then
                        r_state := '1';
                        o_out <= '1';
                    end if;  
                when '1' =>
                        if w_state = '0' then
                            r_state := '0';
                        end if;
                        o_out <= '0';
                when others =>
            end case;
        end if;
    end process;

end Behavioral;

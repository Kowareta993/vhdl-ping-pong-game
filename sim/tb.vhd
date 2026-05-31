LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE work.MyPackage.BOUNCER_TICKS;
USE work.MyPackage.TICKS;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
     
    
    COMPONENT controller
    PORT(
         i_rst : IN  std_logic;
         i_clk : IN  std_logic;
         i_push1 : IN  std_logic;
         i_push2 : IN  std_logic;
         o_led : OUT  std_logic_vector(7 downto 0);
         o_score1 : OUT  std_logic_vector(3 downto 0);
         o_score2 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal i_rst : std_logic := '0';
   signal i_clk : std_logic := '0';
   signal i_push1 : std_logic := '0';
   signal i_push2 : std_logic := '0';

 	--Outputs
   signal o_led : std_logic_vector(7 downto 0);
   signal o_score1 : std_logic_vector(3 downto 0);
   signal o_score2 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant i_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: controller PORT MAP (
          i_rst => i_rst,
          i_clk => i_clk,
          i_push1 => i_push1,
          i_push2 => i_push2,
          o_led => o_led,
          o_score1 => o_score1,
          o_score2 => o_score2
        );

   -- Clock process definitions
   i_clk_process :process
   begin
		i_clk <= '0';
		wait for i_clk_period/2;
		i_clk <= '1';
		wait for i_clk_period/2;
   end process;
 
    process
     variable seed1, seed2 : integer := 999;
    impure function rand return std_logic is
      variable r : real;
    begin
        uniform(seed1, seed2, r);
        if r > 0.5 then
            return '1';
        else
            return '0';
        end if;
    end function;
    begin
        if o_led = X"80"  or o_led = X"F0" then
            i_push1 <= rand;
            wait for i_clk_period *BOUNCER_TICKS;
        end if;
        i_push1 <= '0';
        wait for i_clk_period*BOUNCER_TICKS;
    end process;
    
    process
     variable seed1, seed2 : integer := 999;
    impure function rand return std_logic is
      variable r : real;
    begin
        uniform(seed1, seed2, r);
        if r > 0.5 then
            return '1';
        else
            return '0';
        end if;
    end function;
    begin
        if o_led = X"01" or o_led = X"0F" then
            i_push2 <= rand;
            wait for i_clk_period *BOUNCER_TICKS;          
        end if;
        i_push2 <= '0';
        wait for i_clk_period*BOUNCER_TICKS;
    end process;

   -- Stimulus process
   stim_proc: process
   begin		
      i_rst <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		i_rst <= '0';
      wait for 2000 ns;

      wait;
   end process;

END;

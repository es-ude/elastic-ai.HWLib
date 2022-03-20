 ----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/01 13:10:47
-- Design Name: 
-- Module Name: TestConvolutionLayer1 - Behavioral
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
USE ieee.numeric_std.ALL;

library work;
use work.cnn_common.all;

entity conv_1d_tb is
--  Port ( );
end conv_1d_tb;

architecture Behavioral of conv_1d_tb is
    -- Clock and reset signal
    constant period : time := 10 ns;
    signal clk : std_logic := '0';
    signal reset : std_logic:='1';
    signal testing     : boolean := true;
    
    signal control_signal : CNN_ControlState := Idle;
    signal conn_in : std_logic_vector(b-1 downto 0) :=(others=>'0');
    signal conn_rd_addr : std_logic_vector(conn_in_bram_addr_width - 1 downto 0);
    signal bias_rd_addr : std_logic_vector(conv1_biases_addr_width - 1 downto 0);
    signal bias_in : std_logic_vector(b-1 downto 0) :=(others=>'0');
    signal weight_rd_addr : std_logic_vector(conv1_weights_addr_width - 1 downto 0);
    signal weight_in : std_logic_vector(b-1 downto 0) :=(others=>'0');
    signal state : inside_states;
    signal conn_out : std_logic_vector(b-1 downto 0) :=(others=>'0');
    signal conn_we : std_logic;
    signal conn_wr_addr : std_logic_vector(conn1_out_bram_addr_width-1 downto 0);

begin
    convLayer1: entity work.conv_1d port map(
        clk => clk,
        reset => reset,
        ctrl => control_signal,
        conn_rd_addr => conn_rd_addr,
        conn_in => conn_in,
        bias_rd_addr => bias_rd_addr,
        bias_in => bias_in,
        weight_rd_addr => weight_rd_addr,
        weight_in => weight_in,
        inside_state => state,
        conn_out => conn_out,
        conn_we => conn_we,
        conn_wr_addr => conn_wr_addr
    );
    process 
    begin
        if testing then
            wait for period/2;
            clk <= not clk;
        else 
            wait;
        end if;
    end process;
    
    process 
    begin
        -- we could also give more meaningful test data
        conn_in <= std_logic_vector(to_fixed_point(0.25));
        weight_in <= std_logic_vector(to_fixed_point(1.0));
        bias_in <= std_logic_vector(to_fixed_point(0.0));

        reset <= '1';
        wait for period *2;
        reset <= '0';
        
        wait for period;
        
        control_signal <= Conv1_forward;
        wait for period;
        wait until state=Forward_Finished;
        control_signal <= Idle;
        
        testing <= false;
        report "Finished" severity warning;
        wait;
    end process;

    process(conn_we)
    begin
        if rising_edge(conn_we) then
            report "The value of conn_out(" & integer'image(to_integer(unsigned(conn_wr_addr)))& ") is " & integer'image(to_integer(signed(conn_out)));
            
        end if;
    end process;

end Behavioral;


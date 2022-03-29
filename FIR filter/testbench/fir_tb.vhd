----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2019 09:15:18 PM
-- Design Name: 
-- Module Name: fir_tb - Behavioral
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
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fir_common.all;

entity fir_tb is
    port ( clk: out std_logic);
end fir_tb; 

architecture Behavioral of fir_tb is
    ------------------------------------------------------------
    -- Testbench Internal Signals
    ------------------------------------------------------------
    signal clk_period : time := 10 ns;
    signal clock : std_logic;
    signal enable : std_logic;

    signal reset: std_logic:='0';
    signal data: fixed_point:=(others=>'0');
    signal coefficients: coefficient_array:= ("0000000010001011", "0000000001110101", "0000000000001010", "0000000010110000", "0000000011001101", "0000000000000101", "0000000001011100", "0000000010000010", "0000000010001100", "0000000010101101", "0000000011011001", "0000000011000111", "0000000000010101", "0000000001001001", "0000000000100011", "0000000000101100", "0000000000011110", "0000000000101111", "0000000000101000", "0000000001110101");
    signal result: fixed_point:=(others=>'0');

begin
    clock_process : process
    begin
        clock <= '0';
        wait for clk_period/2;
        clock <= '1';
        wait for clk_period/2;
    end process; -- clock_process

    clk <= clock;

    uut: entity work.fir(rtl)
    generic map(
        taps => taps_for_fir_filter
    )
    port map (
        clk   => clock,
        reset => reset,
        data  => data,
        coefficients => coefficients,
        result => result
    );

    test_process: process
        begin
            Report "======Tests start======" severity Note;

            --- (step response) --- 
            reset <= '1';
            wait for 1*clk_period;
            wait until clock = '0';
            data <= (others => '0');
            reset <= '0';
            
            wait until clock = '0';
            data <= one;
            wait for 30*clk_period;

            -- --- (impulse response) --- 
            -- reset <= '1';
            -- wait for 1*clk_period;
            -- wait until clock = '0';
            -- data <= (others => '0');
            -- reset <= '0';
            -- wait until clock = '0';
            -- data <= one;
            -- wait until clock = '0';
            -- data <= zero;
            -- wait for 30*clk_period;

            -- if there is no error message, that means all test case are passed.
            report "======Tests finished======" severity Note;
            report "Please check the output message." severity Note;
    
            -- wait forever
            wait;
    
    end process; -- test_process

end Behavioral;

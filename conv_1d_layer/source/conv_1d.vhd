----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/19/2019 10:00:09 AM
-- Design Name: 
-- Module Name: conv_1d_1 - Behavioral
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
use work.cnn_common.all;

entity conv_1d is
    generic(
    in_width : integer := 130;
    in_height : integer := 1;
    in_ch_num:integer := 1;
    kernel_size:integer := 7; 
    out_width : integer := 62;
    out_height : integer := 1;
    out_ch_num:integer := 18
);
Port (
    clk            : in std_logic;
    reset          : in std_logic;
    ctrl           : in CNN_ControlState;
    conn_rd_addr   : out std_logic_vector(conn_in_bram_addr_width - 1 downto 0);
    conn_in        : in std_logic_vector(b-1 downto 0);
    bias_rd_addr   : out std_logic_vector(conv1_biases_addr_width - 1 downto 0);
    bias_in        : in std_logic_vector(b-1 downto 0);
    weight_rd_addr : out std_logic_vector(conv1_weights_addr_width - 1 downto 0);
    weight_in      : in std_logic_vector(b-1 downto 0);
    
    inside_state   : out inside_states;
    conn_out       : out std_logic_vector(b-1 downto 0);
    conn_we        : out std_logic;
    conn_wr_addr   : out std_logic_vector(conn1_out_bram_addr_width-1 downto 0)

    -- temporary
--    intermediate_result : out fixed_point
);
end conv_1d; 

architecture Behavioral of conv_1d is
    signal current_state : inside_states;
    signal intemediate_dot_to_maxpool : vector_2;
    signal cnt_for_max_pool:integer;
    signal conv1_result_of_multiplication:fixed_point;
begin
    
    
Main_process: process (clk, reset, conn_in, weight_in, bias_in)
    
    variable current_ch : integer range 0 to out_ch_num;
    variable offset: integer range 0 to out_width*2;
    variable i: integer range 0 to kernel_size;
    variable out_index: unsigned(conn1_out_bram_addr_width-1 downto 0);
    variable intemediate_dot: fixed_point;
    variable prefetched_flag:integer; 
    
begin

if rising_edge(clk) then
    if reset='1' then
        -- reset all signals and variables initialize 
        current_state <= Idle;
    
        current_ch := 0;
        bias_rd_addr <= (others=>'0');
        cnt_for_max_pool <= 0;
        
        conn_rd_addr <= (others=>'0');
        weight_rd_addr <= (others=>'0');
    else   
        case current_state is--if current_state = Idle  then 
            when Idle =>
                if ctrl = Conv1_forward then
                    -- start one time forward
                    current_state <= Forward;
                    
                    -- start from ch_0 to ch_n
                    current_ch := 0;
                    offset := 0; -- convolution_core shif step is 0
                    i := 0;      -- dot_production at first pixel of the convolution core
                end if;
    
                bias_rd_addr <= (others=>'0');
                
                conn_rd_addr <= std_logic_vector(to_unsigned(0, conn_rd_addr'length));
                weight_rd_addr <= std_logic_vector(to_unsigned(0, weight_rd_addr'length));
                intemediate_dot := signed(bias_in);
                cnt_for_max_pool <= 0;
                prefetched_flag:=0;
            when Forward => 
            
                conv1_result_of_multiplication <= multiply(signed(conn_in), signed(weight_in));
                conn_we <= '0';
            
                -- prefetch the next conn_in and weight_i
                if prefetched_flag=0 then
                    prefetched_flag := 1;
                else
                    intemediate_dot := intemediate_dot + conv1_result_of_multiplication;
                    
                    i := i+1;
                    if i=kernel_size then
                        
                        
                        if cnt_for_max_pool=0 then
                            intemediate_dot_to_maxpool(0) <= intemediate_dot;
                            cnt_for_max_pool<=cnt_for_max_pool+1;
                            
                        else
                            intemediate_dot_to_maxpool(1) <= intemediate_dot;
                            cnt_for_max_pool<=0;
                            
                            out_index := to_unsigned(current_ch*conv_1_out_size+offset/2, conn_wr_addr'length);
                            conn_wr_addr <= std_logic_vector((out_index));
                            conn_we <= '1';
                        end if;
                        intemediate_dot := signed(bias_in);
                        prefetched_flag := 0;
                        i := 0;
                        -- move to next sub region
                        offset := offset+1;
                        if (offset)=out_width*2-1 then
                            bias_rd_addr <= std_logic_vector(to_unsigned(current_ch+1, bias_rd_addr'length));
                        elsif (offset)=out_width*2 then
                            current_ch := current_ch + 1;
                            if current_ch < out_ch_num then 
                                offset := 0;
                            else
                                -- end forward process   
                                current_ch := 0 ;
                                offset := 0 ;
                                current_state <= Forward_finished;
                                
                            end if;
                            
                        end if;
                    end if;
                end if;
                
                conn_rd_addr <= std_logic_vector(to_unsigned(offset+i, conn_rd_addr'length));
                weight_rd_addr <= std_logic_vector(to_unsigned( current_ch * 7 + i, weight_rd_addr'length));
                
            when Forward_finished =>

                if ctrl = Finished then 
                    current_state <= Idle;
                    conn_we <= '0';
                    bias_rd_addr <= (others=>'0');
                    conn_rd_addr <= (others=>'0');
                    weight_rd_addr <= (others=>'0');
                end if;
            end case;

        inside_state <= current_state;
    end if;
end if;
end process;
conn_out <= std_logic_vector(max_2(max_2(intemediate_dot_to_maxpool(0),intemediate_dot_to_maxpool(1)),zero));
end Behavioral;


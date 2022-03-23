----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/04 15:22:30
-- Design Name: 
-- Module Name: FullConnectLayer - Behavioral
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

entity linear_layer is
    generic(
        in_features : integer := gpool_out_ch;
        out_features : integer := fc_out_ch;
        weight_addr_width : integer := log2(fc_weights_size);
        bias_addr_width : integer := log2(fc_biases_size);
        fc_in_addr_width : integer := log2(gpool_out_ch);
        fc_out_addr_width : integer := log2(fc_out_ch)
    );
    Port (
        clk               : in std_logic;
        reset            : in std_logic;
        ctrl              : in CNN_ControlState;
        conn_rd_addr   : out std_logic_vector(fc_in_addr_width - 1 downto 0);
        conn_in         : in std_logic_vector(b-1 downto 0);
        weight_rd_addr : out std_logic_vector(weight_addr_width - 1 downto 0);
        weight_in     : in std_logic_vector(b-1 downto 0);

        bias_rd_addr : out std_logic_vector(bias_addr_width - 1 downto 0);
        bias_in         : in std_logic_vector(b-1 downto 0);

        inside_state  : out inside_states;
        conn_out       : out std_logic_vector(b-1 downto 0);
        conn_we       : out std_logic;
        conn_wr_addr   : out std_logic_vector(fc_out_addr_width-1 downto 0)
    );
end linear_layer;

architecture Behavioral of linear_layer is
    signal conn_rd_addr_t     : unsigned(fc_in_addr_width - 1 downto 0);
    signal weight_rd_addr_t : unsigned(weight_addr_width - 1 downto 0);
    signal bias_rd_addr_t : unsigned(bias_addr_width - 1 downto 0);

    signal current_state : inside_states;

    signal invert_clk : std_logic;

    signal fc_result_of_multiplication:fixed_point;
begin
    
    inside_state <= current_state;
    conn_rd_addr <= std_logic_vector(conn_rd_addr_t);
    weight_rd_addr <= std_logic_vector(weight_rd_addr_t);
    bias_rd_addr <= std_logic_vector(bias_rd_addr_t);

Main_process: process (clk, reset)
    variable current_forward_out_feature : integer;
    variable current_in_features_cnt : integer; -- range 0 to in_features;
    variable forward_dot_sum : fixed_point;
    variable conn_out_v :  fixed_point;
    variable prefetched_flag:integer;
begin

    invert_clk <= not clk;
    
    if rising_edge(clk) then
    
        if reset='1' then
            current_state <= Idle;
            current_forward_out_feature := 0;
            bias_rd_addr_t <=  (others => '0');
            weight_rd_addr_t <= (others => '0');
        else
            case current_state is
            when  Idle=>-- and  then 
            
                if ctrl = FullConnect_forward then
                    -- start one time forward
                    current_state <= Forward;
                    -- start from feature_0 to feature_n
                    current_forward_out_feature := 0;
                    current_in_features_cnt := 0;
                    forward_dot_sum := (others => '0');
                    bias_rd_addr_t <=  (others => '0');
                    weight_rd_addr_t <= (others => '0');
                end if;
                prefetched_flag :=0 ;
            when  Forward=>

                fc_result_of_multiplication <=  multiply(signed(conn_in), signed(weight_in));

                if prefetched_flag=0 then
                    prefetched_flag := 1;
                    
                else
                    conn_we <= '0';
                    weight_rd_addr_t <= weight_rd_addr_t+1;
                    forward_dot_sum := forward_dot_sum + fc_result_of_multiplication;
                    
                    current_in_features_cnt := current_in_features_cnt+1;
                    if current_in_features_cnt = in_features then
                        current_in_features_cnt := 0;
                        conn_out_v := forward_dot_sum + signed(bias_in);
                        conn_wr_addr <= std_logic_vector(to_unsigned(current_forward_out_feature, conn_wr_addr'length));
                        current_forward_out_feature := current_forward_out_feature + 1;
                        conn_out <= std_logic_vector(conn_out_v);
                        conn_we <= '1';
                        if current_forward_out_feature = out_features then
                            current_forward_out_feature := 0;
                            
                            current_state <= Forward_finished;

                        else
                            forward_dot_sum := (others => '0');
                        end if;
                        
                        bias_rd_addr_t <= to_unsigned(current_forward_out_feature, bias_rd_addr_t'length);
                    end if;
                end if;

                conn_rd_addr_t <= to_unsigned(current_in_features_cnt, conn_rd_addr_t'length);
            when  Forward_finished=>
                if ctrl=Finished then
                    current_state <= Idle;
                end if;
            end case;
        
        end if;

        
    end if;
end process Main_process;

    -- fc_weights_bram: entity convolutionNeuralNetwork.bram_weight_2 GENERIC map
    -- (
    --     DATA => b,
    --     ADDR => weights_width,
    -- INIT_VALUE => "" -- weight_2_init_vlaue:22bits eps
    -- )
    -- PORT map
    -- (
    --     a_clk => clk,
    --     a_wr => '0',
    --     a_addr => std_logic_vector(weights_address),
    --     a_din => (others => '0'),
    --     a_dout => current_weight_std,
        
    --     b_clk => '0',
    --     b_wr => '0',
    --     b_addr => (others => '0'),
    --     b_dout => open,
    --     b_din => (others => '0')
    -- );

    -- fc_biases_bram: entity convolutionNeuralNetwork.bram_bias_2 GENERIC map
    -- (
    --     DATA => b,
    --     ADDR => biases_width,
    -- INIT_VALUE => "" -- bias_2_init_vlaue:22bits eps
    -- )
    -- PORT map
    -- (
    --     a_clk => clk,
    --     a_wr => '0',
    --     a_addr => std_logic_vector(biases_address),
    --     a_din => (others => '0'),
    --     a_dout => current_bias_std,
        
    --     b_clk => '0',
    --     b_wr => '0',
    --     b_addr => (others => '0'),
    --     b_dout => open,
    --     b_din => (others => '0')
    -- );
    
end Behavioral;

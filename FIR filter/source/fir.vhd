----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/22/2019 09:03:18 PM
-- Design Name: 
-- Module Name: fir_filter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 1.0 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.fir_common.all;


entity fir is
generic(
    taps : integer := taps_for_fir_filter
);
Port( 
    clk     : in std_logic;
    reset   : in std_logic;
    data    : in fixed_point;
    coefficients : coefficient_array;
    result  : out fixed_point  --filtered result
);
end fir;

architecture rtl of fir is
    signal data_pipeline : data_array;        --pipeline of historic data values
    signal products 		: product_array;     --array of coefficient*data products
begin
process(clk, reset)
    variable sum : fixed_point; --sum of products
    variable data_v:data_array;
begin

    if(reset = '1') then                                       --asynchronous reset

        data_pipeline <= (others => (others => '0'));               --clear data pipeline values
        result <= (others => '0');                                  --clear result output

    elsif(clk'EVENT AND clk = '1') then                          --not reset

        for i in 1 to taps-1 loop
            data_v(i) := data_pipeline(i-1);	--shift new data into data pipeline
        end loop;
        data_v(0) := data;
        data_pipeline <= (data_v) ;	--shift new data into data pipeline

        sum := (OTHERS => '0');                                     --initialize sum
        for i in 0 TO taps-1 loop
            sum := sum + products(i);                                --add the products
        end loop;

        result <= sum;              --output result

        end if;
    end process;

    --perform multiplies
    product_calc: FOR i IN 0 TO taps-1 GENERATE
        products(i) <= multiply(data_pipeline(i), coefficients(i));
    END GENERATE;

end rtl;
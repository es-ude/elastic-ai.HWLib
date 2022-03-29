-- FileName: fir_common.vhd
-- Created date: 2019-12-22
-- Created by: Chao Qian
-- File Version: v1.0

library  ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fir_common is
    constant b				:	natural := 16;

    subtype fixed_point is signed(b-1 downto 0);
    subtype double_fixed_point is signed(b+b-1 downto 0);
    constant eps				:	natural := 8;

    constant factor				:	fixed_point := to_signed(2**eps, b);
    constant factor_shift		:	natural := eps;
    constant factor_shift_2		:	natural := eps/2;
    constant factor_2   		:	fixed_point := factor/2;
    constant zero				:	fixed_point := (others => '0');
    constant one				:	fixed_point := factor;
    constant minValue			:	fixed_point := ('1', others => '0');
    constant maxValue			:	fixed_point := ('0', others => '1');

    constant taps_for_fir_filter       : integer := 20;--number of fir filter taps
    constant bytes_per_fixed_point 	   : integer := b/8;
    constant buf_len_stream_input	   : integer := 1024;
    constant buf_len_coefficients	   : integer := taps_for_fir_filter;
    constant stream_input_bram_addr_width : integer := 10; --for test diff input stream, and diff clk
--	constant stream_input_bram_addr_width : integer := 13; -- for test 8k ram.

	type coefficient_array is array (0 to taps_for_fir_filter-1) of fixed_point;  --array of all coefficients
	type data_array is array (0 to taps_for_fir_filter-1) of fixed_point;                    --array of historic data values
	type product_array is array (0 to taps_for_fir_filter-1) of fixed_point; --array of coefficient * data products
	function multiply(A : in fixed_point; B : in fixed_point) return fixed_point;
end package fir_common;


package body fir_common is

    function multiply(A : in fixed_point; B : in fixed_point) return fixed_point is
		variable TEMP : double_fixed_point;
		variable TEMP2 : fixed_point;
		variable TEMP3 : signed(factor_shift-1 downto 0);
		variable A_short, B_short : signed(fixed_point'length+1-factor_shift downto 0);
	begin
		--A_short := A(fixed_point'length+1-factor_shift_2 downto factor_shift_2);
		--B_short := B(fixed_point'length+1-factor_shift_2 downto factor_shift_2);
		TEMP := A * B;
		--TEMP2 := TEMP(factor_shift+fixed_point'length-1 downto factor_shift);
		--return A_short * B_short;
		TEMP2 := TEMP(factor_shift+fixed_point'length-1 downto factor_shift);
		TEMP3 := TEMP(factor_shift-1 downto 0);
		-- tend to infinity if negative result
		-- add one if result is negative and there is a rest being thrown away
		if TEMP2(fixed_point'length-1) = '1' and TEMP3 /= 0 then
			TEMP2 := TEMP2 + 1;
		end if;
		--return TEMP(factor_shift+fixed_point'length-1 downto factor_shift); -- take result and divide by factor ( >> 10 ) and cut off top
		return TEMP2;
	end multiply;
end fir_common;
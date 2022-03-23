--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;    

use IEEE.NUMERIC_STD.all;

package cnn_common is

    constant b				:	natural := 24;

	-- fixed_point16_t
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

    type vector_2 is array (2-1 downto 0) of fixed_point;
    type vector_4 is array (4-1 downto 0) of fixed_point;
    type vector_9 is array (9-1 downto 0) of fixed_point;
    type vector_64 is array (64-1 downto 0) of fixed_point;
    

    type matrix_4x4 is array (4-1 downto 0) of vector_4;
    type matrix_4x9 is array (4-1 downto 0) of vector_9;
    type matrix_4x64 is array (4-1 downto 0) of vector_64;

-- SAME method -> the size of output and input are same
type CNN_ControlState is (
    Idle, 
    Conv1_forward, 
    Conv2_forward, 
    GlobalAveragePooling_forward, FullConnect_forward,                           
    Finished);
attribute enum_encoding : string;
attribute enum_encoding of CNN_ControlState : type is "sequential";

function real_to_fixed_point (A: in real) return fixed_point;
function to_fixed_point (A: in real) return fixed_point;
function to_fixed_point (A: in integer) return fixed_point;
function log2( i : natural) return integer;
function multiply(A : in fixed_point; B : in fixed_point) return fixed_point;
function  max_2 (x, y : fixed_point) RETURN fixed_point;

type inside_states is (Idle, Forward, Forward_finished );

constant class_num          :   integer := 6;
constant conv_1_input_size	:   integer := 130;
constant conv_1_out_ch : integer := 18;
constant conv_1_kernel_size : integer := 7;
constant maxpool_1_kernel_size : integer :=2;
constant conv_2_out_ch : integer := 18;
constant gpool_out_ch : integer :=  conv_2_out_ch;

constant fc_out_ch : integer :=  class_num;
constant fc_weights_size : integer := class_num * conv_2_out_ch;
constant fc_biases_size : integer :=  class_num;



constant conv1_weights_addr_width : integer := log2(conv_1_kernel_size * conv_1_out_ch);constant conv_1_out_size	:   integer := (conv_1_input_size-conv_1_kernel_size+1)/maxpool_1_kernel_size;
constant conn_in_bram_addr_width : integer := log2(conv_1_input_size);
constant conv1_biases_addr_width : integer := log2(conv_1_out_ch);
constant conn1_out_bram_addr_width : integer := log2(conv_1_out_size * conv_1_out_ch);

    


end cnn_common;

package body cnn_common is

    function real_to_fixed_point (A: in real) return fixed_point is
		variable prob : fixed_point;
	begin
		if A = 0.0 then
			return zero;
		elsif A = 1.0 then
			return factor;
		else 
			return factor_2;
		end if;
	end real_to_fixed_point;
	
	function to_fixed_point (A: in real) return fixed_point is
		variable prob : fixed_point;
	begin
		return real_to_fixed_point(A);
	end to_fixed_point;
	
	function to_fixed_point (A: in integer) return fixed_point is
	begin
		return to_signed(A, fixed_point'length);
	end to_fixed_point;


    function log2( i : natural) return integer is
		variable temp    : integer := i;
		variable ret_val : integer := 0; 
		variable init_div: integer := i/2;
	begin
	
		while temp > 1 loop
			ret_val := ret_val + 1;
			temp    := (temp / 2);
		end loop;
		
		if 2**ret_val < i then
			return ret_val + 1;
		else
			return ret_val;
		end if;
	end function;

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

    function  max_2 (x, y : fixed_point) RETURN fixed_point IS
    begin
        if x < y then
            return y;
        else
            return x;
        end if;
    end max_2;
    
end cnn_common;
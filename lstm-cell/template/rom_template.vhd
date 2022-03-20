-- This is just a template, you must replace the keywords to synthesis
-- keywords: PARAM_ROM_NAME, PARAM_ADDR_WIDTH, PARAM_DATA_WITH, PARAM_ROM_NAME_ARRAT_T, PARAM_ROM_STRING

-- ROM Inference on arsray
-- File: PARAM_ROM_NAME.vhd
-- data_width is PARAM_DATA_WITH bits
-- rom supports at most 2**PARAM_ADDR_WIDTH values
--     means addr is PARAM_ADDR_WIDTH bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PARAM_ROM_NAME is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(PARAM_ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(PARAM_DATA_WITH-1 downto 0)
    );
end PARAM_ROM_NAME;

architecture rtl of PARAM_ROM_NAME is
    type PARAM_ROM_NAME_ARRAT_T is array (0 to 2**PARAM_ADDR_WIDTH-1) of std_logic_vector(PARAM_DATA_WITH-1 downto 0);
    signal ROM : PARAM_ROM_NAME_ARRAT_T:=(PARAM_ROM_STRING);
    attribute rom_style : string;
    attribute rom_style of ROM : signal is "block";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                data <= ROM(conv_integer(addr));
            end if;
        end if;
    end process;
end rtl;

-- ROM Inference on array
-- File: bf_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bf_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(4 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end bf_rom;

architecture rtl of bf_rom is
    type BF_ARRAY is array (0 to 31) of std_logic_vector(16-1 downto 0);
    signal ROM : BF_ARRAY:=(x"ff97",x"ffe3",x"fffd",x"ffd9",x"0033",x"0032",x"0037",x"ffd3",x"001a",x"0049",x"fffc",x"0027",x"ffec",x"0032",x"fff9",x"000f",x"ffe6",x"ffc3",x"004f",x"fffb",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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
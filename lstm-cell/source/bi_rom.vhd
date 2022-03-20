-- ROM Inference on array
-- File: bi_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bi_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(4 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end bi_rom;

architecture rtl of bi_rom is
    type BI_ARRAY is array (0 to 31) of std_logic_vector(16-1 downto 0);
    signal ROM : BI_ARRAY:=(x"0009",x"ffe4",x"ffda",x"004b",x"001c",x"ffe7",x"ffde",x"0041",x"ffc4",x"001e",x"ffad",x"ffeb",x"0009",x"ffe7",x"0020",x"fff7",x"000f",x"0033",x"ffac",x"000c",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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

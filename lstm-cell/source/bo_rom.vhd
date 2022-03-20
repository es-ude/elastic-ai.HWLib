-- ROM Inference on array
-- File: bo_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bo_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(4 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end bo_rom;

architecture rtl of bo_rom is
    type BO_ARRAY is array (0 to 31) of std_logic_vector(16-1 downto 0);
    signal ROM : BO_ARRAY:=(x"fff1",x"004c",x"ffc7",x"ffe8",x"fff2",x"0034",x"ffd4",x"ffda",x"ffa4",x"ffde",x"0036",x"004e",x"fff2",x"002d",x"003e",x"ffb8",x"0021",x"ffaa",x"fff5",x"ffd7",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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




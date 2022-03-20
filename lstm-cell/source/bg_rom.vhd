-- ROM Inference on array
-- File: bg_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bg_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(4 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end bg_rom;

architecture rtl of bg_rom is
    type BG_ARRAY is array (0 to 31) of std_logic_vector(16-1 downto 0);
    signal ROM : BG_ARRAY:=(x"ffee",x"0015",x"0002",x"0034",x"000b",x"0027",x"0053",x"000c",x"000c",x"ffbd",x"ffc7",x"001f",x"ffd5",x"fffc",x"ffd5",x"0017",x"005f",x"0002",x"0003",x"002f",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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
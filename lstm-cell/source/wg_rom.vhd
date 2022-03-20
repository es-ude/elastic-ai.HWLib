-- ROM Inference on array
-- File: wg_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity wg_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(8 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end wg_rom;

architecture rtl of wg_rom is
    type WG_ARRAY is array (0 to 511) of std_logic_vector(16-1 downto 0);
    signal ROM : WG_ARRAY:=(x"0002",x"0024",x"ffd5",x"ffd9",x"ffdf",x"0018",x"0033",x"0035",x"ffcc",x"ffdb",x"ffe9",x"ffdc",x"0036",x"fffb",x"ffdb",x"ffe7",x"ffe1",x"0017",x"ffcf",x"ffcb",x"ffc8",x"0018",x"001c",x"ffdd",x"000e",x"0028",x"ffec",x"0030",x"0014",x"0007",x"002a",x"0008",x"fff4",x"0004",x"fffa",x"001c",x"ffda",x"001d",x"0020",x"ffde",x"002e",x"0038",x"ffea",x"fff0",x"001c",x"ffd4",x"0016",x"000d",x"0024",x"ffcf",x"0000",x"fff5",x"0007",x"fff3",x"0000",x"ffd1",x"0019",x"0014",x"ffcb",x"ffe1",x"ffcc",x"ffd7",x"ffe7",x"002f",x"fff5",x"0020",x"0036",x"001a",x"ffcd",x"001c",x"0015",x"002c",x"ffc8",x"0023",x"002e",x"0007",x"ffd4",x"ffe2",x"002e",x"ffd2",x"ffcb",x"0005",x"0030",x"ffd7",x"0012",x"0019",x"000f",x"0038",x"002e",x"0031",x"fff9",x"0030",x"ffcb",x"ffe2",x"fff4",x"ffef",x"0034",x"001a",x"0024",x"0026",x"fffc",x"0038",x"0014",x"0001",x"ffcf",x"ffd6",x"fffa",x"0008",x"000e",x"001d",x"ffea",x"ffef",x"002f",x"fff1",x"ffd9",x"0026",x"0026",x"ffef",x"fff5",x"ffd6",x"ffd1",x"0015",x"ffe8",x"002d",x"ffd3",x"001c",x"ffd8",x"fff0",x"ffed",x"fff8",x"fff9",x"0001",x"001d",x"002e",x"0026",x"0019",x"ffe6",x"ffd8",x"ffcd",x"0002",x"0037",x"fff6",x"fffe",x"ffd7",x"0011",x"0024",x"ffc8",x"ffd8",x"002a",x"000d",x"0000",x"002f",x"0007",x"0033",x"0023",x"fffd",x"000a",x"fff8",x"ffd8",x"ffcb",x"0025",x"fffa",x"ffeb",x"fff2",x"ffe1",x"fff0",x"ffcf",x"002a",x"0017",x"ffe4",x"ffed",x"0019",x"ffeb",x"000f",x"000f",x"ffdc",x"0019",x"ffd8",x"ffe8",x"0010",x"ffdc",x"000e",x"0003",x"0031",x"ffec",x"fff2",x"0031",x"ffd2",x"0004",x"0037",x"ffe7",x"0036",x"0032",x"0035",x"fffb",x"0033",x"ffe8",x"ffed",x"0015",x"000c",x"0012",x"002a",x"ffee",x"0000",x"001d",x"001f",x"0036",x"ffdd",x"001e",x"0013",x"001e",x"001b",x"ffeb",x"ffd3",x"002d",x"ffe0",x"0024",x"ffca",x"fff7",x"0000",x"0009",x"0004",x"0012",x"fffa",x"000e",x"ffc9",x"0029",x"ffd1",x"0000",x"fff7",x"0038",x"ffdb",x"fffd",x"ffeb",x"0032",x"0031",x"ffff",x"ffed",x"ffdd",x"0028",x"fffd",x"0035",x"0020",x"0032",x"002d",x"ffdb",x"0010",x"ffe9",x"001c",x"fffb",x"ffe2",x"0007",x"002f",x"fff0",x"ffdf",x"0004",x"ffd9",x"ffcd",x"0015",x"000d",x"0004",x"0026",x"ffe9",x"0014",x"ffe1",x"000b",x"fff3",x"0028",x"0032",x"0031",x"0002",x"0021",x"ffc7",x"ffdf",x"000a",x"ffeb",x"ffc8",x"0019",x"ffe5",x"ffda",x"0000",x"ffd4",x"ffe7",x"ffe6",x"ffc8",x"0005",x"0027",x"0017",x"ffe5",x"ffcc",x"ffd2",x"0001",x"0027",x"ffe9",x"ffe1",x"ffe2",x"fffc",x"ffca",x"ffce",x"0038",x"ffe0",x"0020",x"001e",x"002b",x"0014",x"ffe5",x"fff6",x"fff1",x"ffce",x"fff6",x"0011",x"ffe9",x"fffe",x"0000",x"ffc8",x"0029",x"002e",x"0027",x"ffee",x"001d",x"ffcb",x"fff2",x"fff5",x"ffec",x"0018",x"ffed",x"fff1",x"0010",x"002f",x"000f",x"ffe6",x"fffa",x"fff0",x"ffcb",x"fff7",x"ffd0",x"0021",x"001e",x"0035",x"ffed",x"0002",x"000b",x"0039",x"0034",x"ffe3",x"ffd0",x"ffcd",x"ffe5",x"0030",x"0013",x"ffe5",x"ffe6",x"ffca",x"000c",x"ffe0",x"0037",x"002a",x"0000",x"ffdd",x"0037",x"002d",x"0018",x"ffe1",x"002d",x"0005",x"0025",x"0017",x"001e",x"ffce",x"ffe1",x"0022",x"fff5",x"ffcf",x"0034",x"ffff",x"ffcd",x"0032",x"ffdb",x"fffa",x"0010",x"002e",x"ffd4",x"0013",x"ffeb",x"ffe8",x"fff5",x"ffeb",x"001f",x"fff6",x"002b",x"000d",x"fff8",x"ffdf",x"ffcc",x"fff0",x"ffcb",x"fff6",x"0000",x"fffd",x"ffe4",x"0001",x"ffda",x"ffd2",x"002d",x"0009",x"0027",x"0020",x"fff2",x"ffea",x"0023",x"0031",x"ffcc",x"fff4",x"fffb",x"ffec",x"0030",x"fff8",x"0030",x"0000",x"fffa",x"ffdf",x"ffed",x"0012",x"0019",x"fffe",x"002f",x"ffed",x"0010",x"fff3",x"fffe",x"0036",x"ffd9",x"0015",x"0033",x"fff7",x"002d",x"0000",x"ffd6",x"ffe1",x"0015",x"ffe8",x"000d",x"0038",x"0013",x"fffb",x"000e",x"ffe0",x"ffd0",x"ffd5",x"ffd0",x"ffde",x"0013",x"0012",x"ffff",x"fff4",x"000b",x"000b",x"ffe8",x"ffc9",x"001f",x"ffe0",x"fff7",x"ffd1",x"ffe0",x"0017",x"ffcb",x"ffe0",x"002a",x"ffe3",x"ffe9",x"fff0",x"0018",x"ffdb",x"0005",x"0017",x"ffdd",x"0027",x"ffd6",x"0017",x"ffed",x"fffc",x"000a",x"ffd5",x"0019",x"0015",x"fff9",x"ffd1",x"0016",x"0025",x"fff6",x"001a",x"0015",x"ffea",x"fffd",x"0038",x"0000",x"ffd3",x"fffc",x"001c",x"ffee",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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
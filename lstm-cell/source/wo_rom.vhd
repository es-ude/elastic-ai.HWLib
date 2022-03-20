-- ROM Inference on array
-- File: wo_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity wo_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(8 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end wo_rom;

architecture rtl of wo_rom is
    type WO_ARRAY is array (0 to 511) of std_logic_vector(16-1 downto 0);
    signal ROM : WO_ARRAY:=(x"ffe5",x"000a",x"ffe3",x"000d",x"000b",x"ffe3",x"002f",x"001e",x"fff7",x"0002",x"fffa",x"000d",x"0002",x"ffde",x"000a",x"0001",x"0003",x"ffeb",x"000e",x"ffd2",x"0011",x"001f",x"fffa",x"ffd4",x"0000",x"ffd6",x"0009",x"0018",x"0016",x"fff9",x"0000",x"ffcf",x"ffd8",x"0034",x"002a",x"001f",x"0027",x"0016",x"0020",x"0025",x"fff3",x"fff9",x"0028",x"0000",x"ffdb",x"ffd4",x"0020",x"002f",x"002c",x"0009",x"ffd2",x"fff8",x"0013",x"ffec",x"0015",x"0027",x"ffcc",x"ffd7",x"ffc9",x"002e",x"0000",x"ffe6",x"0013",x"ffeb",x"ffdc",x"0016",x"000a",x"ffd8",x"ffdb",x"001a",x"002b",x"0004",x"ffe4",x"001b",x"0009",x"0026",x"ffe3",x"0000",x"0017",x"0004",x"ffce",x"ffdb",x"000c",x"0023",x"ffee",x"001b",x"ffdd",x"0036",x"0028",x"000a",x"0019",x"0013",x"ffdf",x"0000",x"000f",x"fff4",x"0036",x"ffea",x"ffcd",x"ffe5",x"0004",x"0007",x"ffd3",x"0004",x"0027",x"ffcb",x"002f",x"ffe7",x"ffd8",x"fffa",x"ffda",x"ffe3",x"001d",x"ffd6",x"001a",x"0029",x"0000",x"0019",x"ffe0",x"002c",x"0037",x"000d",x"0034",x"ffc8",x"fffa",x"0033",x"0021",x"0007",x"001a",x"ffe5",x"000b",x"ffcf",x"001b",x"ffeb",x"ffec",x"ffd3",x"0017",x"ffd7",x"fff4",x"0019",x"002b",x"000c",x"ffeb",x"ffe8",x"0020",x"000a",x"0030",x"0015",x"002e",x"ffd2",x"ffd1",x"ffcf",x"0039",x"0024",x"ffd9",x"002e",x"ffe6",x"fff1",x"0000",x"fff6",x"000b",x"0033",x"ffde",x"0011",x"ffd2",x"0008",x"002f",x"0026",x"0031",x"001e",x"fffc",x"000e",x"ffe9",x"0030",x"001c",x"0016",x"002b",x"0039",x"0032",x"002c",x"ffd7",x"0031",x"0000",x"fffe",x"fff1",x"fff1",x"0002",x"ffe5",x"ffcb",x"ffe3",x"fff5",x"002b",x"002a",x"ffde",x"fffe",x"fff0",x"ffe2",x"fff6",x"ffed",x"001f",x"fff3",x"ffec",x"002e",x"0020",x"ffde",x"ffe4",x"0008",x"ffe0",x"ffef",x"002d",x"ffe4",x"fffd",x"0036",x"0013",x"ffe3",x"ffde",x"ffec",x"ffef",x"0018",x"fff4",x"0030",x"ffe1",x"ffef",x"0014",x"002d",x"0033",x"001b",x"001f",x"ffdd",x"0010",x"0036",x"0009",x"0002",x"ffe7",x"0020",x"ffdf",x"fff1",x"ffd1",x"ffc9",x"001f",x"0003",x"002d",x"002d",x"001e",x"0016",x"fff2",x"001e",x"001b",x"0013",x"ffff",x"ffec",x"002c",x"fff6",x"0016",x"000a",x"0008",x"0000",x"ffd7",x"000d",x"ffd6",x"001b",x"ffde",x"ffee",x"ffe5",x"002d",x"ffd8",x"001d",x"001c",x"0028",x"000e",x"001f",x"002d",x"000b",x"0013",x"ffd4",x"0018",x"ffed",x"001b",x"ffd9",x"000c",x"fff1",x"0005",x"0006",x"ffec",x"ffc8",x"fff2",x"0015",x"0031",x"ffcd",x"001b",x"ffca",x"ffca",x"ffdd",x"fff9",x"000f",x"ffd5",x"002c",x"0033",x"0003",x"002e",x"ffda",x"ffc8",x"ffd3",x"002d",x"001e",x"ffe7",x"ffea",x"fff9",x"0006",x"ffd9",x"ffd3",x"0016",x"0010",x"0037",x"ffe9",x"0014",x"ffe9",x"001c",x"fffd",x"002a",x"001f",x"002f",x"001d",x"0002",x"0031",x"0035",x"002d",x"ffcd",x"ffd9",x"fff7",x"ffdf",x"0035",x"0037",x"0036",x"ffe6",x"ffe2",x"0003",x"0011",x"001c",x"0017",x"0030",x"fff2",x"ffee",x"0013",x"000f",x"ffdf",x"0005",x"ffd5",x"fff0",x"ffea",x"ffdb",x"0027",x"ffd5",x"ffe5",x"ffc9",x"0032",x"ffcd",x"ffdf",x"ffc8",x"000e",x"ffd4",x"0012",x"ffd9",x"ffdc",x"ffe3",x"0008",x"0034",x"0035",x"fffc",x"ffc8",x"ffee",x"ffeb",x"fff4",x"0015",x"001c",x"ffe0",x"002f",x"002e",x"0028",x"002c",x"0019",x"0010",x"ffe9",x"0000",x"0007",x"ffe3",x"fffb",x"fff9",x"ffca",x"0026",x"fffb",x"ffcf",x"002d",x"ffe2",x"0014",x"0038",x"0002",x"0010",x"0016",x"002b",x"0032",x"fff2",x"0019",x"0032",x"0012",x"ffef",x"ffe0",x"fffc",x"002c",x"0004",x"0027",x"0000",x"0011",x"0001",x"0001",x"ffca",x"ffce",x"0004",x"001c",x"0026",x"0002",x"0018",x"0017",x"ffcf",x"ffce",x"0039",x"001d",x"0023",x"ffec",x"001b",x"ffd4",x"0000",x"ffdc",x"ffee",x"fff8",x"0016",x"000d",x"0035",x"0033",x"ffdc",x"0000",x"0009",x"0031",x"ffef",x"ffea",x"ffdc",x"002a",x"fff0",x"ffeb",x"0026",x"0006",x"fff3",x"ffe0",x"ffe0",x"ffd4",x"0034",x"fffe",x"ffd8",x"002e",x"ffed",x"ffe6",x"ffd8",x"ffe5",x"ffd4",x"ffdf",x"ffcc",x"fff5",x"0017",x"ffd5",x"0000",x"ffeb",x"001b",x"0031",x"fff9",x"ffe4",x"0026",x"0028",x"fffa",x"ffdf",x"002c",x"ffd5",x"ffdf",x"0010",x"000d",x"001e",x"fff8",x"001d",x"ffce",x"000f",x"0037",x"ffc8",x"ffe3",x"0024",x"fff8",x"ffe2",x"0022",x"0003",x"0002",x"ffef",x"002b",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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




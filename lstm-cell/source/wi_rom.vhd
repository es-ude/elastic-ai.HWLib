-- ROM Inference on array
-- File: wi_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity wi_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(8 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end wi_rom;

architecture rtl of wi_rom is
    type WI_ARRAY is array (0 to 511) of std_logic_vector(16-1 downto 0);
    signal ROM : WI_ARRAY := (x"0000",x"001e",x"ffd1",x"ffd6",x"ffea",x"0024",x"0004",x"ffe5",x"0034",x"0017",x"ffd5",x"0036",x"002b",x"ffec",x"0020",x"ffe0",x"fff8",x"0030",x"0002",x"ffd8",x"ffed",x"fff1",x"fff5",x"0005",x"0034",x"000f",x"ffff",x"002d",x"fffb",x"000f",x"0003",x"ffdd",x"0002",x"001b",x"001c",x"ffcc",x"fff6",x"ffd6",x"ffe8",x"0014",x"ffd8",x"0015",x"0030",x"0003",x"ffda",x"ffec",x"000c",x"ffd5",x"001c",x"ffcd",x"ffef",x"fff5",x"ffca",x"ffdb",x"ffe9",x"ffc9",x"ffc9",x"fff5",x"0026",x"ffca",x"002f",x"ffea",x"0010",x"0002",x"ffcd",x"002f",x"001e",x"0038",x"001c",x"ffdb",x"002f",x"0003",x"001b",x"ffd3",x"fff0",x"0002",x"0016",x"0022",x"ffda",x"ffe8",x"ffc8",x"ffea",x"000c",x"ffd4",x"0012",x"001e",x"0007",x"ffda",x"ffd4",x"ffef",x"0019",x"0038",x"0020",x"fffa",x"0014",x"ffc8",x"ffd0",x"001a",x"ffe0",x"001b",x"0014",x"002f",x"fff5",x"002a",x"fff7",x"ffd8",x"ffe4",x"ffd1",x"001d",x"fffb",x"002c",x"0023",x"001f",x"0001",x"ffef",x"fff4",x"0007",x"001c",x"ffd8",x"0030",x"fffa",x"ffd1",x"ffe2",x"0032",x"0034",x"0006",x"0033",x"ffcb",x"ffdc",x"fff2",x"ffcb",x"0028",x"001c",x"0021",x"0030",x"ffe2",x"0012",x"0017",x"fff0",x"0013",x"fff0",x"0023",x"fff1",x"ffeb",x"000e",x"0014",x"ffe5",x"0005",x"0021",x"fffb",x"ffea",x"0031",x"ffdb",x"ffe6",x"ffd9",x"0011",x"fff3",x"0014",x"ffd7",x"ffdf",x"ffe3",x"0034",x"fff1",x"0000",x"ffe5",x"0039",x"0037",x"ffd5",x"ffd2",x"ffd5",x"0000",x"fff2",x"ffdb",x"ffec",x"000a",x"ffcb",x"ffdf",x"0031",x"0019",x"001b",x"ffe3",x"000c",x"fff3",x"ffe5",x"0007",x"002f",x"ffda",x"0002",x"ffeb",x"0038",x"ffca",x"ffca",x"0038",x"ffdc",x"000a",x"fffc",x"fff4",x"fff4",x"0024",x"0002",x"0003",x"ffe3",x"0009",x"ffcb",x"ffd7",x"ffc9",x"ffdf",x"ffed",x"001c",x"ffdb",x"0035",x"fff4",x"fff6",x"002c",x"001c",x"0030",x"0021",x"ffef",x"ffdb",x"fffc",x"002f",x"ffed",x"ffcb",x"0017",x"0037",x"ffe3",x"0024",x"0021",x"ffe7",x"fffe",x"fff0",x"ffd1",x"ffcd",x"000e",x"fffc",x"ffe4",x"000b",x"0015",x"002d",x"002c",x"fff8",x"ffce",x"ffcd",x"0035",x"0019",x"0018",x"ffcf",x"0035",x"0036",x"0033",x"0024",x"0038",x"0016",x"0007",x"0026",x"ffd0",x"ffeb",x"ffd9",x"0036",x"ffe8",x"ffe6",x"001d",x"ffe6",x"ffe4",x"fffb",x"fffb",x"ffd4",x"002f",x"ffe7",x"0014",x"0031",x"001c",x"0008",x"0030",x"0007",x"ffdf",x"000a",x"ffd4",x"ffd9",x"ffe3",x"ffe6",x"0036",x"000d",x"ffc9",x"fff0",x"ffda",x"0032",x"fff7",x"ffcc",x"fffd",x"0023",x"000e",x"0012",x"0005",x"0015",x"fff3",x"ffea",x"ffcb",x"ffd5",x"0018",x"0019",x"0017",x"ffdf",x"0011",x"001f",x"ffdf",x"0008",x"0012",x"0004",x"ffdb",x"0036",x"ffdf",x"002f",x"ffd3",x"fff3",x"001f",x"ffe9",x"0030",x"ffd9",x"ffd0",x"ffe7",x"0009",x"0034",x"ffe5",x"0014",x"fff9",x"0002",x"000d",x"0023",x"0036",x"fff2",x"fff4",x"002a",x"ffd4",x"0006",x"0035",x"fff9",x"002c",x"ffef",x"002e",x"ffc9",x"fff8",x"fff6",x"0012",x"0016",x"002b",x"fff8",x"fffe",x"0027",x"fff1",x"ffd4",x"ffec",x"0016",x"002f",x"0031",x"0032",x"ffda",x"fffa",x"fffd",x"0019",x"0027",x"fff7",x"ffd1",x"001c",x"0011",x"0016",x"ffdd",x"0024",x"0036",x"0004",x"ffcb",x"0028",x"ffd6",x"000d",x"0008",x"0032",x"000b",x"ffcf",x"0005",x"ffdd",x"ffe6",x"0013",x"ffcd",x"000d",x"ffdc",x"fffa",x"0007",x"0030",x"ffe5",x"0024",x"fff9",x"ffe5",x"ffcf",x"ffcc",x"0037",x"fff2",x"0002",x"000f",x"0026",x"0030",x"ffcb",x"0032",x"002b",x"ffc7",x"000a",x"002e",x"ffd6",x"fff7",x"ffdf",x"ffe0",x"000d",x"0035",x"ffd3",x"0022",x"ffe3",x"fff5",x"002d",x"fff4",x"0005",x"ffd8",x"0030",x"fff9",x"ffd7",x"0010",x"ffd8",x"fff7",x"fff7",x"ffe6",x"0016",x"ffdf",x"ffd3",x"0003",x"002d",x"fff0",x"001a",x"0031",x"0025",x"ffe2",x"fffa",x"ffee",x"ffd2",x"0000",x"002b",x"0030",x"0005",x"000d",x"ffe8",x"002b",x"ffe9",x"ffd9",x"0014",x"001c",x"0028",x"0015",x"ffc8",x"0008",x"0022",x"ffcd",x"0033",x"0014",x"ffd8",x"fff4",x"0031",x"ffd5",x"fff0",x"0012",x"ffce",x"001f",x"001d",x"0023",x"ffdc",x"0039",x"ffdf",x"0039",x"ffca",x"ffdb",x"001c",x"000b",x"ffd4",x"ffe0",x"ffcd",x"0023",x"0005",x"0003",x"ffe1",x"ffe8",x"fff0",x"ffc9",x"0002",x"000a",x"0000",x"0012",x"0036",x"000f",x"ffec",x"ffe9",x"ffdc",x"ffd9",x"fff7",x"fff6",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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

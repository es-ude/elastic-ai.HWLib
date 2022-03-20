-- ROM Inference on array
-- File: wf_rom.vhd
-- data_width is 16 bits
-- rom supports at most 32 values
--     means addr is 5 bits
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity wf_rom is
    port(
        clk : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(8 downto 0);
        data : out std_logic_vector(15 downto 0)
    );
end wf_rom;

architecture rtl of wf_rom is
    type WF_ARRAY is array (0 to 511) of std_logic_vector(16-1 downto 0);
    signal ROM : WF_ARRAY:=(x"0035",x"0026",x"ffe8",x"fff2",x"ffca",x"0019",x"ffe8",x"002d",x"ffd8",x"0000",x"0033",x"0038",x"ffdf",x"000a",x"0006",x"ffe6",x"ffed",x"000f",x"ffd9",x"0009",x"0018",x"ffea",x"002f",x"fffd",x"0019",x"ffff",x"ffd5",x"ffd4",x"fffd",x"0008",x"0038",x"ffef",x"001f",x"fff0",x"fff8",x"fff7",x"0000",x"ffeb",x"000d",x"0002",x"0024",x"fff5",x"0005",x"ffeb",x"ffd1",x"0017",x"0007",x"ffea",x"ffed",x"000e",x"ffe9",x"0021",x"ffde",x"0033",x"0027",x"fff6",x"0025",x"0003",x"0015",x"0018",x"fff2",x"0018",x"002a",x"0002",x"000b",x"0002",x"0027",x"ffe8",x"ffe2",x"0018",x"ffcf",x"0000",x"ffe6",x"0025",x"ffcb",x"ffd0",x"fff2",x"0002",x"0008",x"000d",x"0022",x"0038",x"000b",x"fffd",x"0038",x"ffe8",x"fffc",x"ffe7",x"fff9",x"000c",x"0007",x"fff6",x"ffc7",x"0002",x"ffff",x"0008",x"002b",x"0037",x"ffdf",x"fffd",x"0016",x"0003",x"ffe5",x"001b",x"ffca",x"ffea",x"ffcc",x"ffd7",x"0035",x"0021",x"001e",x"001f",x"ffd3",x"0006",x"0035",x"ffe1",x"0032",x"000f",x"0028",x"ffe8",x"001a",x"ffce",x"fffd",x"0013",x"0011",x"ffdf",x"fff2",x"ffe5",x"ffec",x"ffd2",x"002f",x"0038",x"0034",x"0026",x"0028",x"fff9",x"ffd4",x"ffeb",x"fffa",x"ffe2",x"001d",x"0014",x"0009",x"000d",x"0032",x"0014",x"ffce",x"ffd7",x"0019",x"0007",x"fff4",x"000c",x"ffdb",x"fffe",x"0028",x"001b",x"ffc7",x"ffcc",x"0023",x"0024",x"ffcd",x"0015",x"ffd4",x"002b",x"0011",x"0038",x"ffc8",x"ffc9",x"0026",x"0032",x"0023",x"0026",x"ffd0",x"0029",x"ffca",x"fffb",x"0001",x"fffc",x"000b",x"0024",x"000c",x"ffdb",x"ffea",x"000a",x"ffea",x"fff7",x"ffca",x"ffcb",x"0016",x"ffe8",x"ffde",x"ffea",x"ffd2",x"ffd3",x"0022",x"001d",x"0007",x"ffe1",x"0013",x"0002",x"0036",x"0024",x"0036",x"fffc",x"ffcd",x"ffd8",x"000c",x"0034",x"ffc8",x"ffc8",x"0007",x"002b",x"ffde",x"000c",x"0028",x"0011",x"000c",x"0039",x"0025",x"ffe0",x"0004",x"001d",x"0032",x"ffc8",x"001e",x"ffe5",x"0026",x"0000",x"ffe4",x"ffd5",x"fff0",x"ffc8",x"000c",x"ffe1",x"0008",x"ffdb",x"ffd5",x"fffc",x"ffed",x"0021",x"0004",x"002c",x"000a",x"ffee",x"0026",x"0003",x"000a",x"ffee",x"0000",x"fff5",x"ffcb",x"ffd0",x"fff5",x"001f",x"001e",x"fffc",x"ffd4",x"0000",x"ffd1",x"fff4",x"0021",x"ffd9",x"ffda",x"fff3",x"fff1",x"0009",x"0009",x"001d",x"ffd9",x"fffc",x"0020",x"0031",x"fffc",x"ffdf",x"0010",x"ffc9",x"0023",x"ffd4",x"fff4",x"ffe9",x"0020",x"ffdd",x"ffdf",x"0019",x"fffc",x"ffca",x"ffdf",x"0017",x"ffed",x"0027",x"002d",x"0008",x"fffc",x"ffee",x"fffe",x"000a",x"ffd5",x"fff3",x"ffd1",x"0023",x"fff5",x"fff5",x"ffcd",x"ffcf",x"fff8",x"ffdc",x"0034",x"fff2",x"ffe0",x"001b",x"0008",x"0027",x"0017",x"ffc9",x"0024",x"fff6",x"ffe7",x"0024",x"0029",x"ffce",x"fffb",x"002f",x"0016",x"0030",x"ffed",x"0000",x"ffe6",x"0015",x"ffcd",x"fffd",x"ffe1",x"0031",x"0017",x"0036",x"ffe9",x"ffdc",x"fffa",x"ffcb",x"0016",x"002a",x"000d",x"fffb",x"001c",x"ffdc",x"0037",x"ffc8",x"ffca",x"fff3",x"002e",x"0005",x"0032",x"ffe9",x"0033",x"0014",x"ffcd",x"0015",x"ffd7",x"0014",x"fffa",x"0016",x"0028",x"0018",x"fffc",x"fffd",x"ffdd",x"ffec",x"0025",x"ffea",x"0023",x"ffea",x"fff3",x"0001",x"ffcc",x"0000",x"fffb",x"0024",x"fffa",x"ffe7",x"002d",x"ffd2",x"fffb",x"fff5",x"002d",x"002a",x"ffda",x"001a",x"ffd4",x"ffd0",x"0011",x"0000",x"ffe6",x"ffc9",x"ffea",x"0013",x"ffcc",x"ffc9",x"0007",x"ffd7",x"ffce",x"ffea",x"0006",x"fff5",x"0028",x"000f",x"001b",x"fff7",x"ffcc",x"ffda",x"0003",x"ffcb",x"fff8",x"ffdc",x"ffd9",x"0016",x"ffd4",x"ffd5",x"0020",x"000a",x"0034",x"fff1",x"ffe5",x"fffb",x"0000",x"002b",x"ffc7",x"0014",x"fff3",x"fff4",x"ffd1",x"001f",x"fffc",x"0019",x"ffe1",x"ffe3",x"001b",x"ffca",x"000d",x"ffd4",x"001c",x"ffd0",x"0023",x"ffca",x"ffd0",x"0000",x"002d",x"ffcf",x"ffe7",x"0032",x"fff7",x"0017",x"002d",x"0027",x"ffd8",x"0002",x"ffd8",x"ffc9",x"ffee",x"ffe3",x"0030",x"0017",x"ffd7",x"0009",x"0000",x"ffe9",x"ffe0",x"ffee",x"002d",x"ffd7",x"ffd8",x"ffef",x"0000",x"000f",x"0001",x"fff3",x"ffde",x"ffe1",x"ffdf",x"0013",x"ffde",x"ffff",x"fff6",x"ffe9",x"002e",x"ffc9",x"ffdc",x"ffd2",x"fff6",x"002c",x"0032",x"ffcf",x"fffe",x"0021",x"0019",x"002e",x"ffff",x"ffda",x"0025",x"ffed",x"001d",x"fff2",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000",x"0000");
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
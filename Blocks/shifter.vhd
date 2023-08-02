library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity shifter is 
    port (
        M_A , M_B               : in std_logic_vector(22 downto 0);
        shamt                   : in std_logic_vector(7 downto 0);
        EA_LT_EB                : in std_logic;
        MA_shift , MB_shift     : out std_logic_vector(24 downto 0)
        );
end shifter;

architecture behavioral of shifter is
    signal M_shift1 : unsigned(24 downto 0);
    signal M_shift2 : std_logic_vector(24 downto 0);
begin
    M_shift1    <=  unsigned("01" & M_A) when EA_LT_EB = '1' else
                    unsigned("01" & M_B);

    M_shift2 <= std_logic_vector(SHIFT_RIGHT( unsigned(M_shift1), to_integer(unsigned(shamt))));

    MA_shift    <=  M_shift2 when EA_LT_EB = '1' else
                    ("01" & M_A);

    MB_shift    <=  M_shift2 when EA_LT_EB = '0' else
                    ("01" & M_B);

end behavioral;


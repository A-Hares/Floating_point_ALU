library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--use IEEE.numeric_std.all;

entity exp_compare is 
    port (
        E_A , E_B       : in std_logic_vector(7 downto 0);
        op, result_47   : in std_logic;
        E_pre       : out std_logic_vector(7 downto 0);
        EA_LT_EB    : out std_logic;
        shamt       : out std_logic_vector(7 downto 0)
        );
end exp_compare;

architecture behavioral of exp_compare is
    signal E_int1, E_int2   : std_logic_vector(7 downto 0);
    signal E_op, E_mult     : std_logic_vector(7 downto 0);
    signal Res , E_preX             : std_logic_vector(7 downto 0);
    signal xx ,EA_LT_EB_int : std_logic;
begin
    EA_LT_EB <= EA_LT_EB_int;

    E_op        <=  E_B when op = '1' else
                    not E_B;

    xx          <=  '0' when op = '1' else
                    '1';
    
    Res         <=  "01111111" when result_47 = '0' else
                    "01111110";

    E_int1      <= E_A + E_op + xx;
    E_int2      <= E_B + (not E_A) + xx;
    EA_LT_EB_int    <= E_int1(7);

    shamt       <=  "00000000" when op = '1' else
                    E_int2 when EA_LT_EB_int = '1' else
                    E_int1;

    E_preX      <=  E_int1 when op = '1' else
                    E_B when EA_LT_EB_int = '1' else
                    E_A;

    E_mult      <=  E_preX + (not Res) + '1';

    E_pre       <=  E_preX when op = '0' else
                    E_mult;

end behavioral;


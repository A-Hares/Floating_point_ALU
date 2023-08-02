library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity exp_compare is 
    port (
        E_A , E_B   : in std_logic_vector(7 downto 0);
        E_pre       : out std_logic_vector(7 downto 0);
        EA_LT_EB    : out std_logic;
        shamt       : out std_logic_vector(7 downto 0)
        );
end exp_compare;

architecture behavioral of exp_compare is
    signal E_int1, E_int2,shamt_int,E_pre_int : std_logic_vector(7 downto 0);
    signal EA_LT_EB_int : std_logic;
begin
    EA_LT_EB    <= EA_LT_EB_int;
    shamt       <= shamt_int;
    E_pre       <= E_pre_int;
    Subtract: process(E_A, E_B,E_int1,E_int2,EA_LT_EB_int)
    begin
        E_int1       <= std_logic_vector(unsigned(E_A) - unsigned(E_B));
        E_int2       <= std_logic_vector(unsigned(E_B) - unsigned(E_A));
        EA_LT_EB_int  <= E_int1(7);
        
        if (  EA_LT_EB_int = '1' ) then 
            E_pre_int   <= E_B;
            shamt_int   <= E_int2;
        else
            E_pre_int   <= E_A;
            shamt_int   <= E_int1;
        end if; 
    end process Subtract;

end behavioral;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity mant_mult is
  port(Mant_A      : in  std_logic_vector(23 downto 0);
       Mant_B      : in  std_logic_vector(23 downto 0);
       fract       : out std_logic_vector(22 downto 0);
       result_47   : out std_logic
       );
end;

architecture synth of mant_mult is
    signal result: std_logic_vector(47 downto 0);
begin
        result <= std_logic_vector(unsigned(Mant_A) * unsigned(Mant_B));
        result_47 <= result(47);
        fract <= result(46 downto 24) 
                 when (result(47) = '1')
                 else result(45 downto 23);
end;

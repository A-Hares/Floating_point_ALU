library ieee;
use ieee.std_logic_1164.all;

entity top is 
    port (
        rst, clk         : in std_logic;
        N_A , N_B   : in std_logic_vector(31 downto 0);
        sum         : out std_logic_vector(31 downto 0);
        DONE        : out std_logic
        );
end top;

architecture behavioral of top is
    component exp_compare is 
        port (
            E_A , E_B   : in std_logic_vector(7 downto 0);
            E_pre       : out std_logic_vector(7 downto 0);
            EA_LT_EB    : out std_logic;
            shamt       : out std_logic_vector(7 downto 0)
            );
    end component;
    component shifter is 
        port (
            M_A , M_B               : in std_logic_vector(22 downto 0);
            shamt                   : in std_logic_vector(7 downto 0);
            EA_LT_EB                : in std_logic;
            MA_shift , MB_shift     : out std_logic_vector(24 downto 0)
            );
    end component;
    component addmant is
        port(
        rst, clk : in std_logic;
        M_A_Shifted: in STD_LOGIC_VECTOR(24 downto 0);
        M_B_Shifted: in STD_LOGIC_VECTOR(24 downto 0);
        A_sign: in std_logic;
        B_sign: in std_logic;
        E_pre: in STD_LOGIC_VECTOR(7 downto 0);
        fract: out STD_LOGIC_VECTOR(22 downto 0);
        sum_sign: out std_logic;
        exp: out STD_LOGIC_VECTOR(7 downto 0);
        DONE: out std_logic);
    end component;
    signal E_A , E_B                :  std_logic_vector(7 downto 0);
    signal E_pre                    :  std_logic_vector(7 downto 0);
    signal EA_LT_EB                 :  std_logic;
    signal shamt                    :  std_logic_vector(7 downto 0);
    signal M_A , M_B                :  std_logic_vector(22 downto 0);
    signal MA_shift , MB_shift      :  std_logic_vector(24 downto 0);
    signal M_A_Shifted              :  STD_LOGIC_VECTOR(24 downto 0);
    signal M_B_Shifted              :  STD_LOGIC_VECTOR(24 downto 0);
    signal A_sign                   :  std_logic;
    signal B_sign                   :  std_logic;
    signal fract                    :  STD_LOGIC_VECTOR(22 downto 0);
    signal sum_sign                 :  std_logic;
    signal exp                      :  STD_LOGIC_VECTOR(7 downto 0);
begin
    E_A         <= N_A(30 downto 23);
    E_B         <= N_B(30 downto 23);
    M_A         <= N_A(22 downto 0);
    M_B         <= N_B(22 downto 0);
    A_sign      <= N_A(31);
    B_sign      <= N_B(31);
    
    sum         <= sum_sign & exp & fract;
    M_A_Shifted <= MA_shift;
    M_B_Shifted <= MB_shift;
    
    exp_compare1 : entity work.exp_compare port map(
        E_A , E_B,
        E_pre,  
        EA_LT_EB,   
        shamt
        );
    
    shifter1 : entity work.shifter port map(
        M_A , M_B,   
        shamt,                 
        EA_LT_EB,              
        MA_shift , MB_shift 
        );

    addmant1 : entity work.addmant port map(
        rst, clk ,
        M_A_Shifted,
        M_B_Shifted,
        A_sign,
        B_sign,
        E_pre,
        fract,
        sum_sign,
        exp,
        DONE
        );
    

end behavioral;


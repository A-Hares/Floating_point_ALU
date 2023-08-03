library ieee;
use ieee.std_logic_1164.all;

entity top is 
    port (
        rst, clk, en , op        : in std_logic;
        N_A , N_B   : in std_logic_vector(31 downto 0);
        FP_out      : out std_logic_vector(31 downto 0);
        DONE        : out std_logic
        );
end top;

architecture behavioral of top is
    component exp_compare is 
        port (
            E_A , E_B       : in std_logic_vector(7 downto 0);
            op, result_47   : in std_logic;
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
        en: in std_logic;
        fract: out STD_LOGIC_VECTOR(22 downto 0);
        sum_sign: out std_logic;
        exp: out STD_LOGIC_VECTOR(7 downto 0);
        DONE: out std_logic);
    end component;
    component mant_mult is
        port(Mant_A      : in  std_logic_vector(23 downto 0);
             Mant_B      : in  std_logic_vector(23 downto 0);
             fract       : out std_logic_vector(22 downto 0);
             result_47   : out std_logic
             );
    end component;
    component mult_fsm is 
        port (
            rst, clk, en        : in std_logic;
            N_A , N_B           : in std_logic_vector(31 downto 0);
            fract_int           : in std_logic_vector(22 downto 0);
            exp_int             : in std_logic_vector(7 downto 0);
            product             : out std_logic_vector(31 downto 0);
            DONE                : out std_logic
        );
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
    signal fract , fract_int        :  STD_LOGIC_VECTOR(22 downto 0);
    signal sum_sign                 :  std_logic;
    signal result_47                :  std_logic;
    signal exp                      :  STD_LOGIC_VECTOR(7 downto 0);
    signal DONE_add, DONE_mult      :  std_logic;
    signal en_mult , en_add         :  std_logic;
    signal sum                      : std_logic_vector(31 downto 0);
    signal product                  : std_logic_vector(31 downto 0);
    signal MantA_mul, MantB_mul     : std_logic_vector(23 downto 0);
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
    
    FP_out <=   product when op = '1' else
                sum;
    DONE   <=   DONE_mult when op = '1' else
                DONE_add;

    en_add <=   (not op) and en;
    en_mult <=  op and en; 

    MantA_mul <= ('1' & M_A);
    MantB_mul <= ('1' & M_B);
    
    exp_compare1 : entity work.exp_compare port map(
        E_A , E_B, op , result_47,
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
        en_add,
        fract,
        sum_sign,
        exp,
        DONE_add
        );
    mantmult1 : entity work.mant_mult port map(
            MantA_mul,
            MantB_mul,
            fract_int,
            result_47
        );
    
    mult_fsm1 : entity work.mult_fsm port map(
            rst, clk, en_mult,       
            N_A , N_B,
            fract_int,
            E_pre,
            product,
            DONE_mult
        );

end behavioral;

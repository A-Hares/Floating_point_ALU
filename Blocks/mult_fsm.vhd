library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mult_fsm is 
    port (
        rst, clk, en         : in std_logic;
        N_A , N_B   : in std_logic_vector(31 downto 0);
        sum         : out std_logic_vector(31 downto 0);
        DONE        : out std_logic
        );
end mult_fsm;


architecture fsm of mult_fsm is
    component mant_mult is
        port(Mant_A      : in  std_logic_vector(23 downto 0);
             Mant_B      : in  std_logic_vector(23 downto 0);
             fract       : out std_logic_vector(22 downto 0);
             result_47   : out std_logic
             );
    end component;
    signal E_A , E_B                :  std_logic_vector(7 downto 0);
    signal exp                    :  std_logic_vector(7 downto 0);
    signal Mant_A , Mant_B          :  std_logic_vector(23 downto 0);
    signal A_sign                   :  std_logic;
    signal B_sign                   :  std_logic;
    signal result_47                :  std_logic;
    signal fract                    :  STD_LOGIC_VECTOR(22 downto 0);
    signal sum_sign                 :  std_logic;
    signal temp                     : std_logic_vector(30 downto 0);
    type state_type is (calc_state, done_state);
    signal state, next_state : state_type;


begin
    E_A         <= N_A(30 downto 23);
    E_B         <= N_B(30 downto 23);
    Mant_A      <= '0' & N_A(22 downto 0);
    Mant_B      <= '0' & N_B(22 downto 0);
    A_sign      <= N_A(31);
    B_sign      <= N_B(31);
    sum         <= sum_sign & exp & fract;
    temp <= (others => '0');

    process (clk, rst, en, next_state)
    begin
        if rst = '0' then
            state <= calc_state;
        elsif rising_edge(clk) then
            if (en = '1') then
                state <= next_state;
            end if;
        end if;        
    end process;

    process(state)
    begin
        next_state <= state;
        DONE <= '0';
        case state is
            when calc_state =>
                if((N_A(30 downto 0) = (temp)) or (N_B(30 downto 0) = (temp))) then
                    exp <= "00000000";
                    fract <= (others => '0');
                    next_state <= done_state;
                else
                    mantmult1 : entity work.mant_mult port map(
                        Mant_A,
                        Mant_B,
                        fract,
                        result_47
                    );

                    if (A_sign xor B_sign) = '1' then
                        sum_sign <= '1';
                    else
                        sum_sign <= '0';
                    end if;

                    --add_exp block here
                    --exp <= .....
                end if;
            when done_state =>
                DONE <= '1';
                next_state <= calc_state;
        end case;
    end process;
end fsm;

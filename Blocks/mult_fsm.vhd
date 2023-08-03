library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mult_fsm is 
    port (
        rst, clk, en        : in std_logic;
        N_A , N_B           : in std_logic_vector(31 downto 0);
        fract_int           : in std_logic_vector(22 downto 0);
        exp_int             : in std_logic_vector(7 downto 0);
        product             : out std_logic_vector(31 downto 0);
        DONE                : out std_logic
        );
end mult_fsm;


architecture fsm of mult_fsm is

    signal A_sign                   :  std_logic;
    signal B_sign                   :  std_logic;
    signal exp                      :  std_logic_vector(7 downto 0);
    signal fract                    :  STD_LOGIC_VECTOR(22 downto 0);
    signal product_sign             :  std_logic;
    signal temp                     : std_logic_vector(30 downto 0);

    type state_type is (calc_state, done_state);
    signal state, next_state : state_type;


begin

    A_sign      <= N_A(31);
    B_sign      <= N_B(31);

    product     <= product_sign & exp & fract;
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

    

    process(state, fract_int, exp_int, N_A, N_B)
    begin
        next_state <= state;
        DONE <= '0';
        

        case state is
            when calc_state =>
                if((N_A(30 downto 0) = (temp)) or (N_B(30 downto 0) = (temp))) then
                    product_sign <= '0';
                    fract <= (others => '0');
                    exp <= "00000000";
                else
                    fract <= fract_int;
                    exp   <= exp_int;

                    if (A_sign xor B_sign) = '1' then
                        product_sign <= '1';
                    else
                        product_sign <= '0';
                    end if;

                end if;
                next_state <= done_state;
            when done_state =>
                DONE <= '1';
                next_state <= calc_state;
        end case;
    end process;
end fsm;

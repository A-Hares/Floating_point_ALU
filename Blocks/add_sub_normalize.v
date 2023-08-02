library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity addmant is
    port(
    clk : in std_logic;
    M_A_Shifted: in STD_LOGIC_VECTOR(24 downto 0);
    M_B_Shifted: in STD_LOGIC_VECTOR(24 downto 0);
    A_sign: in std_logic;
    B_sign: in std_logic;
    E_pre: in STD_LOGIC_VECTOR(7 downto 0);
    fract: out STD_LOGIC_VECTOR(22 downto 0);
    sum_sign: out std_logic;
    exp: out STD_LOGIC_VECTOR(7 downto 0);
    DONE: out std_logic);
end;

architecture synth of addmant is
    type state_type is (add_state, normalize_state, done_state);
    signal state : state_type;
    signal M_sum: STD_LOGIC_VECTOR(24 downto 0);
    signal exp_temp: std_logic_vector (7 downto 0);

begin
    process(clk)
        begin
            if rising_edge(clk) then
                case state is
                    when add_state =>
                        exp_temp <= E_pre;
                        if (A_sign xor B_sign) = '0' then --same sign
                            M_sum <= std_logic_vector(unsigned(M_A_Shifted) + unsigned(M_B_Shifted));  
                            sum_sign <= A_sign;
                            state <= normalize_state;

                        elsif (M_A_Shifted >= M_B_Shifted) then --Mantessa A bigger than Mantessa B
                            M_sum <= std_logic_vector(unsigned(M_A_Shifted) - unsigned(M_B_Shifted));
                            sum_sign <= A_sign;
                            state <= normalize_state;

                        else
                            M_sum <= std_logic_vector(unsigned(M_B_Shifted) - unsigned(M_A_Shifted));
                            sum_sign <= B_sign;
                            state <= normalize_state;
                        end if;
                    
                    when normalize_state =>
                        if (M_sum(24) = '1') then
                            M_sum <= '0' & M_sum(24 downto 1);
                            exp_temp <= std_logic_vector(unsigned(exp_temp) + 1);
                            state <= normalize_state;
                        elsif (M_sum(23) = '0') then
                            M_sum <= M_sum(23 downto 0) & '0';
                            exp_temp <= std_logic_vector(unsigned(exp_temp) - 1);
                            state <= normalize_state;
                        else
                            state <= done_state;
                        end if;
                    when done_state => 
                    fract <= M_sum(22 downto 0);
                    exp <= exp_temp;
                    DONE <= '1';
                    when others => 
			        state <= add_state;     
                end case;
            end if;
    end process;
end;

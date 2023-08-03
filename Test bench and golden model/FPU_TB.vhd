library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity FPU_TB is 
end FPU_TB;

architecture behavioral of FPU_TB is 

    component top is 
        port (
            clk         : in std_logic;
            N_A , N_B   : in std_logic_vector(31 downto 0);
            sum         : out std_logic_vector(31 downto 0);
            DONE        : out std_logic
            );
    end component;

    signal rst, clk, en        : std_logic;
    signal N_A , N_B   : std_logic_vector(31 downto 0);
    signal sum         : std_logic_vector(31 downto 0);
    signal DONE        : std_logic;
    signal Golden_sum  : std_logic_vector(31 downto 0);
begin

    DUT : entity work.top port map(
        rst, clk, en,       
        N_A , N_B,   
        sum,        
        DONE        
    );
    
    rst <= '0' , '1' after 5 ns;
    en <= '1';
    process 
    begin
        clk <= '0';
        wait for 1 ns;
        clk <= '1';
        wait for 1 ns;
    end process;

    testvectors : process
        file file_A     : TEXT open READ_MODE is "a.txt";    
		file file_B     : TEXT open READ_MODE is "b.txt";    
		file file_sum   : TEXT open READ_MODE is "sum.txt";  
		file file_out   : TEXT open WRITE_MODE is "result.txt";  
		variable L_A, L_B, L_sum, L_out: LINE;
		variable correct: boolean;
		variable NA_golden, NB_golden, NS_golden : std_logic_vector(31 downto 0);
    begin
        write(L_out, string'("Test                  Golden_Model    VHDL      correct?"));		
        WRITELINE(file_out, L_out);
        wait for 16 ns;
        while not (ENDFILE(file_A) or ENDFILE(file_B) or  ENDFILE(file_sum)) loop
			READLINE(file_A, L_A);      READLINE(file_B, L_B);      READLINE(file_sum, L_sum);
			HREAD(L_A, NA_golden);      HREAD(L_B, NB_golden);   HREAD(L_sum, NS_golden);
			N_A         <= NA_golden;
            N_B         <= NB_golden;
            Golden_sum  <= NS_golden;

			wait until rising_edge(DONE);
                if Golden_sum = sum then
                    correct := True;
                else
                    correct := False;
                end if;
                HWRITE(L_out, NA_golden, Left, 10);
                write(L_out, string'(" + "));
                HWRITE(L_out, NB_golden, Left, 10);
                write(L_out, string'(" = "));
                HWRITE(L_out, sum, Left, 10);
                HWRITE(L_out, Golden_sum, Left, 10);
                WRITE(L_out, correct, Left, 10);			
                WRITELINE(file_out, L_out);
			wait until falling_edge(DONE);
		end loop;
        assert FALSE Report "SImulation Finished" severity FAILURE;
    end process;


end behavioral;

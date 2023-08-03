library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity FPU_TB_product is 
end FPU_TB_product;

architecture behavioral of FPU_TB_product is 

    component top is 
        port (
            rst, clk, en , op        : in std_logic;
            N_A , N_B   : in std_logic_vector(31 downto 0);
            FP_out      : out std_logic_vector(31 downto 0);
            DONE        : out std_logic
            );
    end component;

    signal rst, clk,en ,op        : std_logic;
    signal N_A , N_B   : std_logic_vector(31 downto 0);
    signal product         : std_logic_vector(31 downto 0);
    signal DONE        : std_logic;
    signal Golden_product  : std_logic_vector(31 downto 0);
begin

    DUT : entity work.top port map(
        rst, clk, en, op,  
        N_A , N_B,   
        product,        
        DONE        
    );

    op <= '1';
    rst <= '0' , '1' after 5 ns;
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
		file file_product   : TEXT open READ_MODE is "mult.txt";  
		file file_out   : TEXT open WRITE_MODE is "resultpro.txt";  
		variable L_A, L_B, L_product, L_out: LINE;
		variable correct: boolean;
		variable NA_golden, NB_golden, NS_golden : std_logic_vector(31 downto 0);
    begin
        en <= '0';
        write(L_out, string'("Test                        Golden_Model_pro     VHDL_pro      correct_pro?"));		
        WRITELINE(file_out, L_out);
        wait for 16 ns;
        while not (ENDFILE(file_A) or ENDFILE(file_B) or  ENDFILE(file_product)) loop
			READLINE(file_A, L_A);      READLINE(file_B, L_B);      READLINE(file_product, L_product);
			HREAD(L_A, NA_golden);      HREAD(L_B, NB_golden);   HREAD(L_product, NS_golden);
			N_A         <= NA_golden;
            N_B         <= NB_golden;
            Golden_product  <= NS_golden;
            en <= '1';
			wait until DONE = '1';
                wait until falling_edge(clk);
                if Golden_product = product then
                    correct := True;
                else
                    correct := False;
                end if;
                HWRITE(L_out, NA_golden, Left, 10);
                write(L_out, string'(" +/* "));
                HWRITE(L_out, NB_golden, Left, 10);
                write(L_out, string'(" = "));
                HWRITE(L_out, Golden_product, Left, 21);
                HWRITE(L_out, product, Left, 14);
                WRITE(L_out, correct, Left, 10);			
                WRITELINE(file_out, L_out);
			wait until falling_edge(DONE);
		end loop;
        assert FALSE Report "SImulation Finished" severity FAILURE;
    end process;


end behavioral;

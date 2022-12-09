library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.TypeDeclarations.all;
use work.SimpleImageAugmenter_functions.all;

entity tb is
end entity;

architecture tb_arch of tb is
	component SimpleImageAugmenter is
		port(
			Rd : in std_logic := '0'; -- Read
			Wr : in std_logic := '0'; -- Write
			Mx : in std_logic := '0'; -- Mirror-X
			My : in std_logic := '0'; -- Mirror-Y
			Rt : in std_logic := '0'; -- Rotate
			AdBr : in std_logic := '0'; -- Adjust Brightness
			Bright : in integer := 110; -- Brightness value % (Ex: 10% inc is 110)
			clk : in std_logic;
			-- TB-related ports
			RESULT: out matrix
		);
	end component;
	
	procedure readImage(
		variable pathRd : in line;
        variable Img : out matrix;
        variable w, h : out integer 
    ) is
        file input_buf : text;
        variable read_line : line;
        variable red, green, blue : integer;
        variable spaces : character;
        variable wdth, height : integer;
    begin
        file_open(input_buf, pathRd.all, read_mode);
        -- Read width and height at first row
        readline(input_buf, read_line);
        read(read_line, wdth);
        read(read_line, height);
        -- Looping according to width and height of image
        for i in 1 to height loop
            for j in 1 to wdth loop
                readline(input_buf, read_line);
                read(read_line, red); -- Read red channel
                read(read_line, spaces); -- Read space
                read(read_line, green); -- Read green channel
                read(read_line, spaces); -- Read space
                read(read_line, blue); -- Read blue channel
                Img(i - 1, j - 1, 2) := red; 
                Img(i - 1, j - 1, 1) := green;
                Img(i - 1, j - 1, 0) := blue;
            end loop;
        end loop;
        w := wdth;
        h := height;
    end procedure readImage;
    
    procedure verify(
		signal testImg : in matrix;
		variable path_toCorrect: in line
    ) is
		file input_buf : text;
		variable correct : matrix;
        variable wdth, height : integer;
    begin
		readImage(path_toCorrect, correct, wdth, height);
		for i in 1 to height loop
            for j in 1 to wdth loop
				assert(testImg(i - 1, j - 1, 2) = correct(i - 1, j - 1, 2) and
						testImg(i - 1, j - 1, 2) = correct(i - 1, j - 1, 1) and
						testImg(i - 1, j - 1, 2) = correct(i - 1, j - 1, 0))
				report "Test gagal" severity error;
			end loop;
		end loop;
    end procedure;
    
	signal Rd : std_logic := '0'; -- Read
	signal Wr : std_logic := '0'; -- Write
	signal Mx : std_logic := '0'; -- Mirror-X
	signal My : std_logic := '0'; -- Mirror-Y
	signal Rt : std_logic := '0'; -- Rotate
	signal AdBr : std_logic := '0'; -- Adjust Brightness
	signal Bright : integer := 110; -- Brightness value %
	signal clk : std_logic := '0';
	signal RESULT : matrix;
	
	
	
	constant clk_time : time := 10 ns;
	constant path_normal : string := "testbench/smallimage.txt";
	constant path_rotate : string := "testbench/small_rotate.txt";
	constant path_mirrorX : string := "testbench/small_mirrorX.txt";
	constant path_mirrorY : string := "testbench/small_mirrorY.txt";
	
	
	
begin
		UUT: SimpleImageAugmenter port map (Rd, Wr, Mx, My, Rt, AdBr, Bright, clk, RESULT);
		
		clock: process
		variable end_time : time := 1000 ns;
		begin
			while end_time > 0 ms loop
				clk <= '0';
				end_time := end_time - clk_time;
				wait for clk_time/2;
				
				clk <= '1';
				end_time := end_time - clk_time;
				wait for clk_time/2;
			end loop;
			wait;
		end process;
		
		test: process
		variable PATH_toTest: line;
		begin
			-- TEST: readImage
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			write(PATH_toTest, path_normal);
			tb_arch.verify(RESULT, PATH_toTest);
			
			--TEST: 
			
			
		end process;
end architecture;

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
			RES: out matrix;
			RES_W: out integer;
			RES_H: out integer
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
		variable TST_IMG : matrix;
		variable TST_W : integer;
		variable TST_H : integer;
		variable COR_PATH : in line
    ) is
		variable COR_IMG : matrix;
		variable COR_W : integer;
		variable COR_H : integer;
		variable sizeCheckFail : std_logic := '1';
    begin
		-- Read the correct augmented image at COR_PATH
		readImage(COR_PATH, COR_IMG, COR_W, COR_H);
		
		-- Check for size inequalities
		if((COR_W = TST_W) or (COR_H = TST_H)) then
			sizeCheckFail := '0';
		end if;
		
		assert(sizeCheckFail = '0')
			report "Size Check: GAGAL" & CR & LF &
					"Expected: " 
						& integer'image(COR_H) & "x" & integer'image(COR_W) & CR & LF &
					"Got: " 
						& integer'image(TST_H) & "x" & integer'image(TST_W)
					severity error;
		
		-- Check equality on individual pixel
		if(sizeCheckFail = '0') then
			for i in 1 to COR_H loop
				for j in 1 to COR_W loop
					
					assert(TST_IMG(i - 1, j - 1, 2) = COR_IMG(i - 1, j - 1, 2) and 
							TST_IMG(i - 1, j - 1, 1) = COR_IMG(i - 1, j - 1, 1)) and
							(TST_IMG(i - 1, j - 1, 0) = COR_IMG(i - 1, j - 1, 0))
						
					report "Pixel Check: GAGAL" & CR & LF &
						
						"In: " 
							& integer'image(i) & "," & integer'image(j) & CR & LF &
						
						"Expected: " 
							& integer'image(COR_IMG(i - 1, j - 1, 0)) & " " 
							& integer'image(COR_IMG(i - 1, j - 1, 1)) & " "
							& integer'image(COR_IMG(i - 1, j - 1, 2)) & CR & LF &
										
						"Got: " 
							& integer'image(TST_IMG(i - 1, j - 1, 0)) & " " 
							& integer'image(TST_IMG(i - 1, j - 1, 1)) & " "
							& integer'image(TST_IMG(i - 1, j - 1, 2))
					severity error;
					
					end loop;
			end loop;
		end if;
	end procedure;
    
    procedure verifyBright(
		variable TST_IMG : matrix;
		variable TST_W : integer;
		variable TST_H : integer;
		variable COR_PATH : in line;
		constant incBright : std_logic
    ) is
		variable COR_IMG : matrix;
		variable COR_W : integer;
		variable COR_H : integer;
		variable sizeCheckFail : std_logic := '1';
    begin
		-- Read the correct augmented image at COR_PATH
		readImage(COR_PATH, COR_IMG, COR_W, COR_H);
		
		-- Check for size inequalities
		if((COR_W = TST_W) or (COR_H = TST_H)) then
			sizeCheckFail := '0';
		end if;
		
		assert(sizeCheckFail = '0')
			report "Size Check: GAGAL" & CR & LF &
					"Expected: " & integer'image(COR_H) & "x" & integer'image(COR_W) & CR & LF &
					"Got: " & integer'image(TST_H) & "x" & integer'image(TST_W)
					severity error;
		
		-- Check RGB-level inequality (TST < COR) on individual pixel
		if(sizeCheckFail = '0' and incBright = '0') then
			for i in 1 to COR_H loop
				for j in 1 to COR_W loop
					assert (((TST_IMG(i - 1, j - 1, 2) <= COR_IMG(i - 1, j - 1, 2) 
							and TST_IMG(i - 1, j - 1, 1) <= COR_IMG(i - 1, j - 1, 1))
							and TST_IMG(i - 1, j - 1, 0) <= COR_IMG(i - 1, j - 1, 0))
							and ((TST_IMG(i - 1, j - 1, 2) >= 0
							and TST_IMG(i - 1, j - 1, 1) >= 0)
							and TST_IMG(i - 1, j - 1, 2) >= 0))
					report "Pixel Brightness Check: GAGAL" & CR & LF &
							"In: " 
								& integer'image(i) & "," & integer'image(j) & CR & LF &
							
							"COR: " 
								& integer'image(COR_IMG(i - 1, j - 1, 0)) & " " 
								& integer'image(COR_IMG(i - 1, j - 1, 1)) & " "
								& integer'image(COR_IMG(i - 1, j - 1, 2)) & CR & LF &
											
							"TST: " 
								& integer'image(TST_IMG(i - 1, j - 1, 0)) & " " 
								& integer'image(TST_IMG(i - 1, j - 1, 1)) & " "
								& integer'image(TST_IMG(i - 1, j - 1, 2))
					severity error;
				end loop;
			end loop;
			
		-- Check RGB-level inequality (TST > COR) on individual pixel
		elsif(sizeCheckFail = '0' and incBright = '1') then 
			for i in 1 to COR_H loop
				for j in 1 to COR_W loop
					assert (((TST_IMG(i - 1, j - 1, 2) >= COR_IMG(i - 1, j - 1, 2) 
							and TST_IMG(i - 1, j - 1, 1) >= COR_IMG(i - 1, j - 1, 1))
							and TST_IMG(i - 1, j - 1, 0) >= COR_IMG(i - 1, j - 1, 0))
							and ((TST_IMG(i - 1, j - 1, 2) <= 255
							and TST_IMG(i - 1, j - 1, 1) <= 255)
							and TST_IMG(i - 1, j - 1, 2) <= 255))
					report "Pixel Brightness Check: GAGAL" & CR & LF &
							"In: " 
								& integer'image(i) & "," & integer'image(j) & CR & LF &
							
							"COR: " 
								& integer'image(COR_IMG(i - 1, j - 1, 0)) & " " 
								& integer'image(COR_IMG(i - 1, j - 1, 1)) & " "
								& integer'image(COR_IMG(i - 1, j - 1, 2)) & CR & LF &
											
							"TST: " 
								& integer'image(TST_IMG(i - 1, j - 1, 0)) & " " 
								& integer'image(TST_IMG(i - 1, j - 1, 1)) & " "
								& integer'image(TST_IMG(i - 1, j - 1, 2))
					severity error;
				end loop;
			end loop;
		end if;
    end procedure;
    
	signal Rd : std_logic := '0'; -- Read
	signal Wr : std_logic := '0'; -- Write
	signal Mx : std_logic := '0'; -- Mirror-X
	signal My : std_logic := '0'; -- Mirror-Y
	signal Rt : std_logic := '0'; -- Rotate
	signal AdBr : std_logic := '0'; -- Adjust Brightness
	signal Bright : integer := 110; -- Brightness value %
	signal clk : std_logic := '0';
	signal RES : matrix;
	signal RES_W: integer;
    signal RES_H: integer;
	
	constant clk_time : time := 50 ns;
	constant path_normal : string := "testbench/smallimage.txt";
	constant path_rotate : string := "testbench/small_rotate.txt";
	constant path_mirrorX : string := "testbench/small_mirrorX.txt";
	constant path_mirrorY : string := "testbench/small_mirrorY.txt";
	
begin
		UUT: SimpleImageAugmenter port map (Rd, Wr, Mx, My, Rt, AdBr, Bright, clk, RES, RES_W, RES_H);
		
		clock: process
		variable end_time : time := 5000 ns;
		variable current_time : time := 0 ns;
		begin
			while current_time < end_time loop
				clk <= '0';
				wait for clk_time/2;
				
				clk <= '1';
				current_time := current_time + clk_time/2;
				wait for clk_time/2;
			end loop;
			wait;
		end process;
		
		test: process
			variable TST_IMG : matrix;
			variable TST_W : integer;
			variable TST_H : integer;
			variable COR_PATH : line;
			
		begin
			-- TEST: readImage
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for 3*clk_time;			
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_normal);
			
			tb_arch.verify(TST_IMG, TST_W, TST_H, COR_PATH);
			
			
			--TEST: mirrorX
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			Mx <= '1';
			wait for clk_time;
			Mx <= '0';
			wait for 3*clk_time;			
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_mirrorX);
			
			tb_arch.verify(TST_IMG, TST_W, TST_H, COR_PATH);
			
			
			--TEST: mirrorY
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			My <= '1';
			wait for clk_time;
			My <= '0';
			wait for 3*clk_time;			
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_mirrorY);
			
			tb_arch.verify(TST_IMG, TST_W, TST_H, COR_PATH);
			
			
			--TEST: rotate
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			Rt <= '1';
			wait for clk_time;
			Rt <= '0';
			wait for 3*clk_time;
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_rotate);
			
			tb_arch.verify(TST_IMG, TST_W, TST_H, COR_PATH);
			
			--TEST: adjustBrightness >>>
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			Bright <= 150;
			AdBr <= '1';
			wait for clk_time;
			AdBr <= '0';
			wait for 3*clk_time;
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_normal);
			
			tb_arch.verifyBright(TST_IMG, TST_W, TST_H, COR_PATH, '1');
			
			--TEST: adjustBrightness <<<
			Rd <= '1';
			wait for clk_time;
			Rd <= '0';
			wait for clk_time;
			Bright <= 50;
			AdBr <= '1';
			wait for clk_time;
			AdBr <= '0';
			wait for 3*clk_time;
			
			TST_IMG := RES; 
			TST_H := RES_H; 
			TST_W := RES_W;
			COR_PATH := new string'(path_normal);
			
			tb_arch.verifyBright(TST_IMG, TST_W, TST_H, COR_PATH, '0');
			
			wait;
		end process;
end architecture;

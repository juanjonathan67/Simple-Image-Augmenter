library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.TypeDeclarations.all;

package SimpleImageAugmenter_functions is
    procedure readImage(
        signal Img : out matrix;
        signal w, h : out integer 
    );

    procedure writeImage(
        signal wdth, height : in integer;
        signal Img : in matrix
    );

    procedure adjustBrightness (
        constant bright : in integer range 0 to 200;
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal Img : inout matrix -- original image
    );

    procedure mirrorY(
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal Img : inout matrix -- image to be mirrored
    );

    procedure mirrorX(
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal Img : inout matrix -- image to be mirrored
    );
        
    function rotate(
        constant wdth : integer; -- width of original image
        constant height : integer; -- heigth of original image
        signal Img : matrix -- image to be mirrored      
    ) return matrix;
    
end package SimpleImageAugmenter_functions;

package body SimpleImageAugmenter_functions is
    procedure readImage(
        signal Img : out matrix;
        signal w, h : out integer 
    ) is
        file input_buf : text;
        variable read_line : line;
        variable red, green, blue : integer;
        variable spaces : character;
        variable wdth, height : integer;
    begin
        file_open(input_buf, "C:\Users\juanj\OneDrive\Documents\Kuliah\Semester 3\PSD\Praktikum\Proyek Akhir\Simple-Image-Augmenter\images\file.txt", read_mode);
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
                Img(i - 1, j - 1, 2) <= red; 
                Img(i - 1, j - 1, 1) <= green;
                Img(i - 1, j - 1, 0) <= blue;
            end loop;
        end loop;
        w <= wdth;
        h <= height;
    end procedure readImage;

    procedure writeImage(
        signal wdth, height : in integer;
        signal Img : in matrix
    ) is
        file output_buf : text;
        variable out_line : line;
    begin
        file_open(output_buf, "C:\Users\juanj\OneDrive\Documents\Kuliah\Semester 3\PSD\Praktikum\Proyek Akhir\Simple-Image-Augmenter\VHDL\file.txt", write_mode);
        write(out_line, integer'image(wdth) & " " & integer'image(height), left, 10); -- Write width and height first
        writeline(output_buf, out_line);
        for i in 1 to height loop
            for j in 1 to wdth loop
                write(out_line, integer'image(Img(i - 1, j - 1, 2)) & " " & 
                                integer'image(Img(i - 1, j - 1, 1)) & " " &
                                integer'image(Img(i - 1, j - 1, 0)), left, 11); -- Write R G B
                writeline(output_buf, out_line);
            end loop;
        end loop;
    end procedure writeImage;

    procedure adjustBrightness (
        constant bright : in integer range 0 to 200;
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal Img : inout matrix -- original image
    ) is
        variable i : integer range 0 to 1999;
    begin
        for i in 1 to height loop
            for j in 1 to wdth loop
                if(Img(i - 1, j - 1, 2) = 0 and bright /= 0) then
                    Img(i - 1, j - 1, 2) <= 1;
                end if;
                if(Img(i - 1, j - 1, 1) = 0 and bright /= 0) then
                    Img(i - 1, j - 1, 1) <= 1;
                end if;
                if(Img(i - 1, j - 1, 0) = 0 and bright /= 0) then
                    Img(i - 1, j - 1, 0) <= 1;
                end if;
                Img(i - 1, j - 1, 2) <= Img(i - 1, j - 1, 2) * bright / 100;
                Img(i - 1, j - 1, 1) <= Img(i - 1, j - 1, 1) * bright / 100;
                Img(i - 1, j - 1, 0) <= Img(i - 1, j - 1, 0) * bright / 100;
                if(Img(i - 1, j - 1, 2) > 255) then
                    Img(i - 1, j - 1, 2) <= 255;
                end if;
                if(Img(i - 1, j - 1, 1) > 255) then
                    Img(i - 1, j - 1, 1) <= 255;
                end if;
                if(Img(i - 1, j - 1, 0) > 255) then
                    Img(i - 1, j - 1, 0) <= 255;
                end if;
            end loop;
        end loop;
    end procedure;
    
    procedure mirrorX(
        constant wdth : in integer;
        constant height : in integer;
        signal Img : inout matrix
    ) is 
        type RGB is array(2 downto 0) of Integer range 0 to 255; -- type declaration for array of RGB values
        variable i, j : integer range 0 to 1999; -- counter for height and width
        variable temp : RGB; -- temporary variable to store RGB values
    begin
        for j in 1 to wdth loop
            for i in 1 to height / 2 loop
                temp(2) := Img(i - 1, j - 1, 2); -- Storing Red value of the original left side pixels to a temporary array
                temp(1) := Img(i - 1, j - 1, 1); -- Storing Green value of the original left side pixels to a temporary array
                temp(0) := Img(i - 1, j - 1, 0); -- Storing Blue value of the original left side pixels to a temporary array
                Img(i - 1, j - 1, 2) <= Img(height - i, j - 1, 2); -- Replacing Red value of the top side pixels with the bottom side pixels
                Img(i - 1, j - 1, 1) <= Img(height - i, j - 1, 1); -- Replacing Green value of the top side pixels with the bottom side pixels
                Img(i - 1, j - 1, 0) <= Img(height - i, j - 1, 0); -- Replacing Blue value of the top side pixels with the bottom side pixels
                Img(height - i, j - 1, 2) <= temp(2); -- Replacing Red value of the bottom side pixels with the temporary array
                Img(height - i, j - 1, 1) <= temp(1); -- Replacing Green value of the bottom side pixels with the temporary array
                Img(height - i, j - 1, 0) <= temp(0); -- Replacing Blue value of the bottom side pixels with the temporary array
            end loop;
        end loop;
    end procedure mirrorX;
    
    procedure mirrorY(
        constant wdth : in integer;
        constant height : in integer;
        signal Img : inout matrix
    ) is 
        type RGB is array(2 downto 0) of Integer range 0 to 255; -- type declaration for array of RGB values
        variable i, j : integer range 0 to 1999; -- counter for height and width
        variable temp : RGB; -- temporary variable to store RGB values
    begin
        for i in 1 to height loop
            for j in 1 to wdth / 2 loop
                temp(2) := Img(i - 1, j - 1, 2); -- Storing Red value of the original left side pixels to a temporary array
                temp(1) := Img(i - 1, j - 1, 1); -- Storing Green value of the original left side pixels to a temporary array
                temp(0) := Img(i - 1, j - 1, 0); -- Storing Blue value of the original left side pixels to a temporary array
                Img(i - 1, j - 1, 2) <= Img(i - 1, wdth - j, 2); -- Replacing Red value of the left side pixels with the right side pixels
                Img(i - 1, j - 1, 1) <= Img(i - 1, wdth - j, 1); -- Replacing Green value of the left side pixels with the right side pixels
                Img(i - 1, j - 1, 0) <= Img(i - 1, wdth - j, 0); -- Replacing Blue value of the left side pixels with the right side pixels
                Img(i - 1, wdth - j, 2) <= temp(2); -- Replacing Red value of the right side pixels with the temporary array
                Img(i - 1, wdth - j, 1) <= temp(1); -- Replacing Green value of the right side pixels with the temporary array
                Img(i - 1, wdth - j, 0) <= temp(0); -- Replacing Blue value of the right side pixels with the temporary array
            end loop;
        end loop;
    end procedure mirrorX;

    procedure adjustBrightness (
        constant bright : in integer range 0 to 200;
        constant wdth : in integer;
        constant height : in integer;
        signal Img : inout matrix
    ) is
        type RGB is array(2 downto 0) of integer range 0 to 255;
        variable i, j : integer range 0 to 1999;
        variable temp : RGB;
    begin
        for i in 1 to height loop
            for j in 1 to wdth loop
                if(RGB(2) = 0) then
                    RGB(2) := 1;
                end if;
                if(RGB(2) = 0) then
                    RGB(2) := 1;
                end if;
                if(RGB(2) = 0) then
                    RGB(2) := 1;
                end if;
                RGB(2) := Img(i - 1, j - 1, 2) * bright / 100;
                RGB(1) := Img(i - 1, j - 1, 1) * bright / 100;
                RGB(0) := Img(i - 1, j - 1, 0) * bright / 100;
                if(RGB(2) > 255) then
                    RGB(2) := 255;
                end if;
                if(RGB(1) > 255) then
                    RGB(1) := 255;
                end if;
                if(RGB(0) > 255) then
                    RGB(0) := 255;
                end if;
            end loop;
        end loop;
    end procedure;

    function rotate(
        constant wdth : integer;
        constant height : integer;
        signal Img : matrix
    ) return matrix 
    is 
        --variable i, j : integer range 0 to 1999; -- counter for height and width
        variable rot_proc : matrix;
    begin
		for i in 1 to height loop
			for j in 1 to  wdth loop
				rot_proc(j - 1, height - i, 2) := Img(i - 1, j - 1, 2);
				rot_proc(j - 1, height - i, 1) := Img(i - 1, j - 1, 1);
				rot_proc(j - 1, height - i, 0) := Img(i - 1, j - 1, 0);
			end loop;
		end loop;
        return rot_proc;
    end function rotate; 
end package body SimpleImageAugmenter_functions;

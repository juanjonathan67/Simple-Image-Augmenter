library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.TypeDeclarations.all;

entity ImageReader is
    port (
        Img : out matrix;
        w, h : out Integer
    );
end entity ImageReader;

architecture rtl of ImageReader is
    file input_buf : text;
begin
    process is
        variable read_line : line;
        variable red, green, blue : integer;
        variable spaces : character;
        variable wdth, height : integer;
    begin
        file_open(input_buf, "C:\Users\juanj\OneDrive\Documents\Kuliah\Semester 3\PSD\Praktikum\Proyek Akhir\Simple-Image-Augmenter\images\file.txt", read_mode);
        readline(input_buf, read_line);
        read(read_line, wdth);
        read(read_line, height);
        for i in 1 to wdth loop
            for j in 1 to height loop
                readline(input_buf, read_line);
                read(read_line, red);
                read(read_line, spaces);
                read(read_line, green);
                read(read_line, spaces);
                read(read_line, blue);
                Img(i - 1, j - 1, 2) <= red;
                Img(i - 1, j - 1, 1) <= green;
                Img(i - 1, j - 1, 0) <= blue;
            end loop;
        end loop;
        w <= wdth;
        h <= height;
        wait;
    end process;
end architecture;
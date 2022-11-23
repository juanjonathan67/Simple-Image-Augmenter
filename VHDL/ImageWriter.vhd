library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.TypeDeclarations.all;
use ieee.numeric_std.all;

entity ImageWriter is
    port (
        wdth, height : in integer;
        Done : in std_logic;
        Img : in matrix
    );
end entity ImageWriter;

architecture rtl of ImageWriter is
    file output_buf : text;
begin
    process (Done) is
        variable out_line : line;
    begin
        if(Done = '1') then
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
        end if;
    end process;
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.TypeDeclarations.all;

package SimpleImageAugmenter_functions is
    function mirrorY(
        constant wdth : in integer;
        constant height : in integer;
        signal unmirrored : in matrix
    ) return matrix;

    procedure adjustBrightness (
        constant wdth : in integer;
        constant height : in integer;
        signal Img : inout matrix
    );
        
end package SimpleImageAugmenter_functions;

package body SimpleImageAugmenter_functions is
    function mirrorY(
        constant wdth : in integer;
        constant height : in integer;
        signal unmirrored : inout matrix
    ) return matrix is 
        type RGB is array(2 downto 0) of integer range 0 to 255;
        variable i, j : integer range 0 to 1999;
        variable temp : RGB;
        variable mirrored : matrix;
    begin
        mirrored := unmirrored;
        i := height;
        j := wdth;
        for i in 1 to height loop
            for j in 1 to wdth / 2 loop
                temp(2) := unmirrored(i - 1, j - 1, 2);
                temp(1) := unmirrored(i - 1, j - 1, 1);
                temp(0) := unmirrored(i - 1, j - 1, 0);
                mirrored(i - 1, j - 1, 2) := unmirrored(i - 1, wdth - j, 2);
                mirrored(i - 1, j - 1, 1) := unmirrored(i - 1, wdth - j, 1);
                mirrored(i - 1, j - 1, 0) := unmirrored(i - 1, wdth - j, 0);
                mirrored(i - 1, wdth - j, 2) := temp(2);
                mirrored(i - 1, wdth - j, 1) := temp(1);
                mirrored(i - 1, wdth - j, 0) := temp(0);
            end loop;
        end loop;
        return mirrored;
    end function mirrorY;

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
end package body SimpleImageAugmenter_functions;

--(i - 1, j - 1) = (j - 1, height - i)
--
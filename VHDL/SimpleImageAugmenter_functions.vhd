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
end package body SimpleImageAugmenter_functions;

--(i - 1, j - 1) = (j - 1, height - i)
--
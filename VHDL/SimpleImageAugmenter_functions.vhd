library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TypeDeclarations.all;

package SimpleImageAugmenter_functions is
    function mirrorY(
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal unmirrored : in matrix -- original image
    ) return matrix;

    function mirrorX(
        constant wdth : in integer; -- width of original image
        constant height : in integer; -- heigth of original image
        signal unmirrored : in matrix -- original image
    ) return matrix;

end package SimpleImageAugmenter_functions;

package body SimpleImageAugmenter_functions is
    function mirrorY(
        constant wdth : in integer;
        constant height : in integer;
        signal unmirrored : inout matrix
    ) return matrix is 
        variable i, j : integer range 0 to 1999; -- counter for height and width
        -- variable mirrored : matrix; -- mirrored image to be returned
    begin
        mirrored := unmirrored;
        i := height;
        j := wdth;
        for i in 1 to height loop
            for j in 1 to wdth / 2 loop
                temp(2) := unmirrored(i - 1, j - 1, 2);
                temp(1) := unmirrored(i - 1, j - 1, 1);
                temp(0) := unmirrored(i - 1, j - 1, 0);
                mirrored(i - 1, j - 1, 2) := unmirrored(i - 1, wdth - j, 2); -- Storing Red value of the original right side pixels to the new left side pixels
                mirrored(i - 1, j - 1, 1) := unmirrored(i - 1, wdth - j, 1); -- Storing Green value of the original right side pixels to the new left side pixels
                mirrored(i - 1, j - 1, 0) := unmirrored(i - 1, wdth - j, 0); -- Storing Blue value of the original right side pixels to the new left side pixels
                mirrored(i - 1, wdth - j, 2) := temp(2); -- Storing Red value of the original left side pixels to the new right side pixels
                mirrored(i - 1, wdth - j, 1) := temp(1); -- Storing Green value of the original left side pixels to the new right side pixels
                mirrored(i - 1, wdth - j, 0) := temp(0); -- Storing Blue value of the original left side pixels to the new right side pixels
            end loop;
        end loop;
        return mirrored;
    end function mirrorY;

    function mirrorX(
        constant wdth : in integer;
        constant height : in integer;
        signal unmirrored : inout matrix
    ) return matrix is 
        variable i, j : integer range 0 to 1999; -- counter for height and width
        -- variable mirrored : matrix; -- mirrored image to be returned
    begin
        mirrored := unmirrored;
        i := height;
        j := wdth;
        for j in 1 to wdth loop
            for i in 1 to height / 2 loop
                temp(2) := unmirrored(i - 1, j - 1, 2);
                temp(1) := unmirrored(i - 1, j - 1, 1);
                temp(0) := unmirrored(i - 1, j - 1, 0);
                mirrored(i - 1, j - 1, 2) := unmirrored(height - i, j - 1, 2); -- Storing Red value of the original top side pixels to the new bottom side pixels
                mirrored(i - 1, j - 1, 1) := unmirrored(height - i, j - 1, 1); -- Storing Green value of the original top side pixels to the new bottom side pixels
                mirrored(i - 1, j - 1, 0) := unmirrored(height - i, j - 1, 0); -- Storing Blue value of the original top side pixels to the new bottom side pixels
                mirrored(height - i, j - 1, 2) := temp(2); -- Storing Red value of the original bottom side pixels to the new top side pixels
                mirrored(height - i, j - 1, 1) := temp(1); -- Storing Green value of the original bottom side pixels to the new top side pixels
                mirrored(height - i, j - 1, 0) := temp(0); -- Storing Blue value of the original bottom side pixels to the new top side pixels
            end loop;
        end loop;
        return mirrored;
    end function MirrorX;    
end package body SimpleImageAugmenter_functions;

library ieee;
use ieee.std_logic_1164.all;

package TypeDeclarations is

    -- 2 Dimensional Array to store image per pixel
    type matrix is array(1919 downto 0, 1079 - 1 downto 0) of Integer range 0 to 255;

end package TypeDeclarations;


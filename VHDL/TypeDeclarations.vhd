library ieee;
use ieee.std_logic_1164.all;

package TypeDeclarations is

    -- 2 Dimensional Array to store image per pixel (2k x 2k RGB) 
    type matrix is array(1999 downto 0, 1999 downto 0, 2 downto 0) of Integer range 0 to 255;

    type RGB is array(2 downto 0) of integer range 0 to 255;

end package TypeDeclarations;


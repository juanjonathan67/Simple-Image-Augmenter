library ieee;
use ieee.std_logic_1164.all;

package TypeDeclarations is

    -- 2 Dimensional Array to store image per pixel (2k x 2k RGB) 
    type matrix is array(1999 downto 0, 1999 downto 0, 2 downto 0) of Integer range 0 to 255;

    -- Temporary array for (R, G, B) channels
    type RGB is array(2 downto 0) of integer range 0 to 255;

    -- States :
    -- S0 --> Wait for input
    -- S1 --> Read image
    -- S2 --> Mirror X
    -- S3 --> Mirror Y
    -- S4 --> Rotate
    -- S5 --> Adjust brightness
    -- S6 --> Write image
    type state_types is (S0, S1, S2, S3, S4, S5, S6);

end package TypeDeclarations;


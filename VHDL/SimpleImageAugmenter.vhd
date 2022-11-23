library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TypeDeclarations.all;
use work.SimpleImageAugmenter_functions.all;

entity SimpleImageAugmenter is
end entity SimpleImageAugmenter;

architecture rtl of SimpleImageAugmenter is
    component ImageReader is
        port (
            Img : out matrix;
            w, h : out Integer
        );
    end component ImageReader;

    component ImageWriter is
        port (
            wdth, height : in integer;
            Done : in std_logic;
            Img : in matrix
        );
    end component ImageWriter;

    signal Img : matrix;
    signal w, h : integer;
    signal Done : std_logic := '0';
    signal final : matrix;
begin
    Reader : ImageReader port map (Img => Img, w => w, h => h);
    Writer : ImageWriter port map (w, h, Done, final);
    process is
    begin
        wait for 100 ns;
        final <= mirrorY(w, h, Img);
        wait for 100 ns;
        Done <= '1';
        -- wait until (Done = '1');
    end process;
end architecture;
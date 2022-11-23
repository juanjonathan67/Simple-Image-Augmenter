library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.TypeDeclarations.all;
use work.SimpleImageAugmenter_functions.all;

entity SimpleImageAugmenter is
    port(
        Rd : in std_logic; -- Read
        Wr : in std_logic; -- Write
        Mx : in std_logic; -- Mirror-X
        My : in std_logic; -- Mirror-Y
        Rt : in std_logic; -- Rotate
        AdBr : in std_logic; -- Adjust Brightness
        Bright : in integer range 0 to 200; -- Brightness value
        clk : in std_logic
    );
end entity SimpleImageAugmenter;

architecture rtl of SimpleImageAugmenter is
    component ImageReader is
        port (
            Rd : in std_logic;
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
    signal final : matrix;
    signal present, nxt : state_types;
    signal inputs : std_logic_vector(5 downto 0);
begin

    Reader : ImageReader port map (Rd, Img, w, h);
    Writer : ImageWriter port map (w, h, Wr, final);

    process (clk) is
    begin
        if rising_edge(clk) then
            present <= nxt;
        end if;
    end process;

    process (Rd, Wr, Mx, My, Rt, AdBr, Bright) is
    begin
        inputs <= Rd & Wr & Mx & My & Rt & AdBr;
        case present is
            when S0 => -- Wait for Input
                if(inputs = "100000") then
                    nxt <= S1;
                elsif(inputs = "010000") then
                    nxt <= S2;
                elsif(inputs = "001000") then
                    nxt <= S3;
                end if;
            when S1 => -- Read Image
                if(Rd = '1') then
                    nxt <= S1;
                else
                    nxt <= S0;
                end if;
            when S2 => -- Mirror X
                if(Mx = '1') then
                    nxt <= S2;
                else
                    mirrorX(w, h, Img);
                    nxt <= S0;
                end if;
            when S3 => -- Mirror Y
                if(My = '1') then
                    nxt <= S3;
                else
                    mirrorY(w, h, Img);
                    nxt <= S0;
                end if;
            when S4 => -- Rotate
                if(Rt = '1') then
                    nxt <= S4;
                else
                    Img <= rotate(w, h, Img);
                    nxt <= S0;
                end if;
            when S5 => -- Add Brightness
                if (AdBr = '1') then
                    nxt <= S5;
                else
                    adjustBrightness(Bright, w, h, Img);
                    nxt <= S0;
                end if;
            when S6 => -- Write Image
                if(Wr = '1') then
                    nxt <= S6;
                else
                    nxt <= S0;
                end if;
            when others =>
                nxt <= S0;
        end case;
    end process;
end architecture;

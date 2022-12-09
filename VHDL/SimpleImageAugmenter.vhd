library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.TypeDeclarations.all;
use work.SimpleImageAugmenter_functions.all;

entity SimpleImageAugmenter is
    port(
        Rd : in std_logic := '0'; -- Read
        Wr : in std_logic := '0'; -- Write
        Mx : in std_logic := '0'; -- Mirror-X
        My : in std_logic := '0'; -- Mirror-Y
        Rt : in std_logic := '0'; -- Rotate
        AdBr : in std_logic := '0'; -- Adjust Brightness
        Bright : in integer := 110; -- Brightness value % (Ex: 10% inc is 110)
        clk : in std_logic;
        -- TB-related port
        RESULT: out matrix
    );
end entity SimpleImageAugmenter;

architecture rtl of SimpleImageAugmenter is
    -- component ImageReader is
    --     port (
    --         Rd : in std_logic;
    --         Img : out matrix;
    --         w, h : out Integer
    --     );
    -- end component ImageReader;

    -- component ImageWriter is
    --     port (
    --         wdth, height : in integer;
    --         Done : in std_logic;
    --         Img : in matrix
    --     );
    -- end component ImageWriter;

    signal Img : matrix;
    signal w, h : integer;
    signal present, nxt : state_types;
    signal inputs : std_logic_vector(5 downto 0);
begin

    -- Reader : ImageReader port map (Rd, Img, w, h);
    -- Writer : ImageWriter port map (w, h, Wr, Img);

    process (clk, nxt) is
    begin
        if rising_edge(clk) then
            present <= nxt;
        end if;
    end process;

    process (Rd, Wr, Mx, My, Rt, AdBr, Bright) is
    variable tmp: integer;
    begin
        inputs <= Rd & Mx & My & Rt & AdBr & Wr;
        case present is
            when S0 => -- Wait for Input
                -- if(Rd = '1') then
                --     nxt <= S1;
                -- elsif(Mx = '1') then
                --     nxt <= S2;
                -- elsif(My = '1') then
                --     nxt <= S3;
                -- elsif(Rt = '1') then
                --     nxt <= S4;
                -- elsif(AdBr = '1') then
                --     nxt <= S5;
                -- elsif(Wr = '1') then
                --     nxt <= S6;
                -- else
                --     nxt <= present;
                -- end if;
                
                Result <= Img;
                
                if(inputs = "100000") then
                    nxt <= S1;
                elsif(inputs = "010000") then
                    nxt <= S2;
                elsif(inputs = "001000") then
                    nxt <= S3;
                elsif(inputs = "000100") then
                    nxt <= S4;
                elsif(inputs = "000010") then
                    nxt <= S5;
                elsif(inputs = "000001") then
                    nxt <= S6;
                else
                    nxt <= present;
                end if;
            when S1 => -- Read Image
                if(Rd = '0') then
                    readImage(Img, w, h);
                    nxt <= S0;
                end if;
            when S2 => -- Mirror X
                if(Mx = '0') then
                    mirrorX(w, h, Img);
                    nxt <= S0;
                end if;
            when S3 => -- Mirror Y
                if(My = '0') then
                    mirrorY(w, h, Img);
                    nxt <= S0;
                end if;
            when S4 => -- Rotate
                if(Rt = '0') then
                    rotate(w, h, Img);
                    tmp := w;
                    w <= h;
                    h <= tmp;
                    nxt <= S0;
                end if;
            when S5 => -- Add Brightness
                if(AdBr = '0') then
                    adjustBrightness(Bright, w, h, Img);
                    nxt <= S0;
                end if;
            when S6 => -- Write Image
                if(Wr = '0') then
                    writeImage(w, h, Img);
                    nxt <= S0;
                end if;
            when others =>
                nxt <= present;
        end case;
    end process;
end architecture;

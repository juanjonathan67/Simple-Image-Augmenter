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
        RES: out matrix;
        RES_W: out integer := 0;
        RES_H: out integer := 0
    );
end entity SimpleImageAugmenter;

architecture rtl of SimpleImageAugmenter is
    signal Img : matrix;
    signal w, h : integer := 0;
    signal present, nxt : state_types;
    signal inputs : std_logic_vector(5 downto 0) := "000000";
begin

    -- Reader : ImageReader port map (Rd, Img, w, h);
    -- Writer : ImageWriter port map (w, h, Wr, Img);

    process (clk) is
    begin
        if rising_edge(clk) then
            present <= nxt;
        end if;
    end process;

    process (Rd, Wr, Mx, My, Rt, AdBr, Bright, clk) is
    variable tmp: integer;
    begin
      inputs <= Rd & Mx & My & Rt & AdBr & Wr;
      case present is
        when S0 => -- Wait for Input

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
          if(Rd = '0' and rising_edge(clk)) then
            readImage(Img, w, h);
            nxt <= S0;	
          end if;

        when S2 => -- Mirror X
          if(Mx = '0' and rising_edge(clk)) then
            mirrorX(w, h, Img);
            nxt <= S0;
          end if;

        when S3 => -- Mirror Y
          if(My = '0' and rising_edge(clk)) then
            mirrorY(w, h, Img);
            nxt <= S0;
          end if;

        when S4 => -- Rotate
          if(Rt = '0' and rising_edge(clk)) then
            rotate(w, h, Img);
            nxt <= S0;
          end if;

        when S5 => -- Add Brightness
          if(AdBr = '0' and rising_edge(clk)) then
            adjustBrightness(Bright, w, h, Img);
            adjustBrightness(100, w, h, Img);					
            nxt <= S0;
          end if;

        when S6 => -- Write Image
          if(Wr = '0' and rising_edge(clk)) then
            writeImage(w, h, Img);
            nxt <= S0;
          end if;

        when others => -- Default state
          nxt <= present;
      end case;


      -- TB-related
      RES <= Img;
      RES_W <= w;
      RES_H <= h;
    end process;
end architecture;

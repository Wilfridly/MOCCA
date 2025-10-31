library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY clicker4 IS
PORT(
    ck    : IN  std_logic;
    plus  : IN  std_logic;
    raz   : IN  std_logic;
    led   : OUT std_logic_vector (0 to 6);
    led_segment : OUT std_logic_vector(1 downto 0);
);
END clicker4;

ARCHITECTURE model OF clicker4 IS

    signal count : unsigned(15 downto 0);
    signal cmpt_seg : unsigned(1 downto 0);

    signal val : std_logic_vector (3 downto 0);
    signal old_plus : std_logic;

BEGIN

    process(ck) -- Compteur BCD sur 4 chiffres
    begin
        if raz = '1' then
            count <= (others => '0');
            old_plus <= '0';
        elsif rising_edge(ck) then
            if plus = '1' and old_plus = '0' then
                if count(3 downto 0) = "1001" then
                    count(3 downto 0) <= "0000";
                    count(7 downto 4) <= count(7 downto 4) + 1;
                    if count(7 downto 4) = "1001" then
                        count(7 downto 4) <= "0000";
                        count(11 downto 8) <= count(11 downto 8) + 1;
                        if count( 11 downto 8) = "1001" then
                            count( 11 downto 8) <= "0000";
                            count( 15 downto 12) <= count( 15 downto 12) + 1;
                            if count( 15 downto 12) = "1001" then
                                count( 15 downto 12) <= "0000";
                            else
                                count( 15 downto 12) <= count( 15 downto 12) + 1;
                            end if;
                        else
                            count( 11 downto 8) <= count( 11 downto 8) + 1;
                        end if;
                    else
                        count( 7 downto 4) <= count( 7 downto 4) + 1;
                    end if;
                else
                    count(3 downto 0) = count(3 downto 0) + 1;    
                end if;
            end if;
            old_plus <= plus;
        end if;
    end process;
    
    process(ck) -- Segment à afficher
    begin
        if rising_edge(ck) then 
            cmpt_seg <= cmpt_seg + 1;
        end if;
    end process;

    with cmpt_seg select led_segment <=
        "00" when "00",
        "01" when "01",
        "11" when "11",
        "10" when "10";
            

    with val select led (0 to 6) <= 
        "1111110" when x"0",
        "0110000" when x"1",
        "1101101" when x"2",
        "1111001" when x"3",
        "0110011" when x"4",
        "1011011" when x"5",
        "0011111" when x"6",
        "1110000" when x"7",
        "1111111" when x"8",
        "1111011" when others;

END model;
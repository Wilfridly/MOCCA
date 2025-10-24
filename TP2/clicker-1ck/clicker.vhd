ENTITY clicker IS
PORT(
    ck    : IN  std_logic;
    plus  : IN  std_logic;
    raz   : IN  std_logic;
    led   : OUT std_logic_vector (0 to 6)
);
END clicker;

ARCHITECTURE model OF clicker IS

    SIGNAL val, val_new : std_logic_vector (3 downto 0);
    SIGNAL old_plus : std_logic;

BEGIN

    val_new <=   x"0"      when raz OR (val = x"9")
            else val + 1   when plus and not old_plus
            else val;

    memoire : 
    block (ck = '1' AND not ck'stable) begin
        val <= guarded val_new;
        old_plus <= guarded plus;
    end block;

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

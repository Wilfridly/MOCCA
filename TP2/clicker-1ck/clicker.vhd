ENTITY clicker IS
PORT(
    ck    : IN  std_logic;
    plus  : IN  std_logic;
    raz   : IN  std_logic;
    led   : OUT std_logic_vector (0 to 6);
    led_seg : out std_logic_vector(1 downto 0)
);
END clicker;

ARCHITECTURE model OF clicker IS

    SIGNAL val, val0, val1, val2, val3 : std_logic_vector (3 downto 0):= "0000";
    SIGNAL val_new0, val_new1, val_new2, val_new3 : std_logic_vector(3 downto 0):= "0000";
    SIGNAL old_plus : std_logic:= '0';
    signal trigger : std_logic:= '0';
    signal cmpt_sel : std_logic_vector(1 downto 0):= "00";
    signal cmpt_sel_new : std_logic_vector(1 downto 0):= "00";
BEGIN

    trigger <= plus and not old_plus;

    val_new0 <=   x"0"      when raz OR (val0 = x"9" and trigger)
            else val0 + 1   when trigger
            else val0;

    val_new1 <=   x"0"      when raz OR (val0 = x"9" and val1 = x"9" and trigger) 
            else val1 + 1   when trigger and (val0 = x"9")
            else val1;

    val_new2 <=   x"0"      when raz OR (val0 = x"9" and val1 = x"9"  and val2 = x"9" and trigger)
            else val2 + 1   when trigger and (val0 = x"9" and val1 = x"9")
            else val2;

    val_new3 <=   x"0"      when raz OR (val0 = x"9" and val1 = x"9"  and val2 = x"9" and val3 = x"9" and trigger)
            else val3 + 1   when trigger and (val0 = x"9" and val1 = x"9" and val2 = x"9")
            else val3;
        
    cmpt_sel_new <= "00" when raz or (trigger and cmpt_sel = "11")
        else cmpt_sel +1;

    memoire : 
    block (ck = '1' AND not ck'stable) begin
        val0        <= guarded val_new0;
        val1        <= guarded val_new1;
        val2        <= guarded val_new2;
        val3        <= guarded val_new3;
        old_plus    <= guarded plus;
        cmpt_sel    <= guarded cmpt_sel_new;
    end block;


    with cmpt_sel select val <=
        val0 when "00",
        val1 when "01",
        val2 when "10",
        val3 when others;
        
    led_seg <= cmpt_sel;
    
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
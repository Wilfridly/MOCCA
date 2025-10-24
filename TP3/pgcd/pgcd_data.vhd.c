ENTITY pgcd_data IS
PORT(
    ck          : IN  std_logic;
    nreset      : IN  std_logic;

    wr_arg_p    : OUT std_logic;
    arg_p       : OUT std_logic_vector(VALWD-1 DOWNTO 0);
    wok_arg_p   : IN  std_logic;

    rd_res_p    : OUT std_logic;
    res_p       : IN  std_logic_vector(VALWD-1 DOWNTO 0);
    rok_res_p   : IN  std_logic;

    ko_p        : OUT std_logic
);
END pgcd_data;

ARCHITECTURE vhd OF pgcd_data IS

    SIGNAL          -- FSM states
        opa,        -- set first operande
        opb,        -- set second operande
        res,        -- get result
        stop,       -- it's over
        lastpt      -- 1 when pt = address of the last filled box in ROM 
    : std_logic;

    SIGNAL
        pt          -- rom_pointer
    : std_logic_vector(ADDRWD-1 downto 0);

    SIGNAL
        value       -- rom_value
    : std_logic_vector(VALWD-1 downto 0);

BEGIN

    REG : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE)) then
        if (nreset = '0') then
            opa  <= '1';
            opb  <= '0';
            res  <= '0';
            stop <= '0';
            pt   <= (others=>'0');
        else
            opa  <= (res AND rok_res_p AND not lastpt)
                 OR (opa AND not wok_arg_p);
            opb  <= (opa AND wok_arg_p)
                 OR (opb AND not wok_arg_p);
            res  <= (opb AND wok_arg_p)
                 OR (res AND not rok_res_p);
            stop <= (res AND rok_res_p AND lastpt)
                 OR stop;
            if ((opa AND wok_arg_p) OR (opb AND wok_arg_p) OR (res AND rok_res_p)) then
                pt   <= pt + 1;
            end if;
        end if;
    end if;
    end process REG;

    lastpt   <= (pt = LASTPT);
    wr_arg_p <= opa OR opb;
    rd_res_p <= res;
    arg_p    <= value;
    ko_p     <= res AND rok_res_p AND (value /= res_p);

--  #include <rom.txt> incudes a file with a generated ROM, defined as below
--  value       <= x"12"    when pt = 0
--            else x"60"    when pt = 1
--            else x"06"    when pt = 2
--            else x"00";
#   include "rom.txt"

END vhd;

ENTITY cordic_data IS
PORT(
        ck          : IN std_logic;
        nreset      : IN std_logic;

        -- juste pour les arguments
        wr_arg_p    : OUT std_logic; --producteur
        a_p         : OUT  std_logic_vector(7 DOWNTO 0);
        x_p         : OUT  std_logic_vector(7 DOWNTO 0);
        y_p         : OUT  std_logic_vector(7 DOWNTO 0);
        wok_arg_p   : IN std_logic; --consommateur
        
        -- juste pour les résultats
        rd_res_p    : OUT std_logic; --producteur
        nx_p        : IN std_logic_vector(7 DOWNTO 0);
        ny_p        : IN std_logic_vector(7 DOWNTO 0);
        rok_res_p   : IN std_logic; --consommateur
        ko_p        : OUT std_logic
);
END cordic_data;

ARCHITECTURE vhd OF cordic_data IS

    SIGNAL          -- FSM states
        sendarg,    -- send argument
        getres,     -- get result
        stop,       -- it's over
        lastpt      -- 1 when pt = address of the last filled box in ROM
    : std_logic;

    SIGNAL
        pt          -- rom_pointer 
        : std_logic_vector(ADDRWD-1 downto 0);

    SIGNAL
        a_in,
        x_in,
        y_in,
        nx_in,
        ny_in       -- rom_value
    : std_logic_vector(VALWD-1 downto 0);

BEGIN

    REG : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE)) then
        if (nreset = '0') then
            sendarg  <= '1';
            getres   <= '0';
            stop <= '0';
            pt   <= (others=>'0');
        else
            sendarg  <= (getres AND rok_res_p AND not lastpt)
                 OR (sendarg AND not wok_arg_p);

            getres   <= (sendarg AND wok_arg_p) 
                 OR (getres AND not rok_res_p);
                 
            stop <= (getres AND rok_res_p AND lastpt)
                 OR stop;

            if ((sendarg AND wok_arg_p)) then
                pt   <= pt + 1;
            end if;
        end if;
    end if;
    end process REG;

    lastpt     <= (pt = LASTPT);
    wr_arg_p   <= sendarg;
    rd_res_p   <= getres;
    a_p      <= a_in;

    x_in      <= x"7F"; --127
    y_in      <= x"00"; --0
    
    x_p      <= x_in; --127
    y_p      <= y_in; --0

    ko_p       <= (getres AND rok_res_p AND (nx_in /= nx_p)) OR (getres AND rok_res_p AND (ny_in /= ny_p));
    
--  #include <rom.txt> incudes a file with a generated ROM, defined as below
--  a_in       <= x"12"    when pt = 0
--            else x"60"    when pt = 1
--            else x"06"    when pt = 2
--            else x"00";
#   include "rom.txt"

END vhd;
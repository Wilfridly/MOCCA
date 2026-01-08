ENTITY cordic_io IS
PORT(
    ck          : IN  std_logic;
    raz         : IN  std_logic;

    -- Donnée en entrée
    data_in     : IN  std_logic_vector(7 downto 0);

    -- Opérandes vers le CORDIC
    a_p         : OUT std_logic_vector(7 downto 0);
    x_p         : OUT std_logic_vector(7 downto 0);
    y_p         : OUT std_logic_vector(7 downto 0);

    -- Résultats venant du CORDIC
    nx_p        : IN  std_logic_vector(7 downto 0);
    ny_p        : IN  std_logic_vector(7 downto 0);

    --------------------------------------------------
    -- Interface DATA -> one_in_three_out
    --------------------------------------------------
    wr_arg_p    : IN  std_logic;  -- DATA écrit un argument
    wok_arg_p   : OUT std_logic;  -- prêt à recevoir

    --------------------------------------------------
    -- Interface one_in_three_out -> NET (CORDIC)
    --------------------------------------------------
    wr_axy_p    : OUT std_logic;  -- écrit A,X,Y
    wok_axy_p   : IN  std_logic;  -- NET prêt

    --------------------------------------------------
    -- Interface NET -> two_in_one_out
    --------------------------------------------------
    rd_nxy_p    : OUT std_logic;  -- lire NX, NY
    rok_nxy_p   : IN  std_logic;  -- résultats prêts

    --------------------------------------------------
    -- Interface vers DATA
    --------------------------------------------------
    rd_res_p    : IN  std_logic;  -- DATA lit un résultat
    rok_res_p   : OUT std_logic;  -- résultat prêt

    data_out    : OUT std_logic_vector(7 downto 0)
);
END cordic_io;


architecture vhd of cordic_io is

    signal st, n_st : std_logic_vector(7 downto 0);

    signal x_reg, y_reg, a_reg : std_logic_vector(7 downto 0);
    signal nx_reg, ny_reg     : std_logic_vector(7 downto 0);

begin

--------------------------------------------------
-- FSM + registres synchrones
--------------------------------------------------
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            st <= "00000001";  -- RX_X
        else
            st <= n_st;

            -- DATA -> module
            if (st(0) = '1' and wr_arg_p = '1' and wok_arg_p = '1') then
                x_reg <= data_in;
            elsif (st(1) = '1' and wr_arg_p = '1' and wok_arg_p = '1') then
                y_reg <= data_in;
            elsif (st(2) = '1' and wr_arg_p = '1' and wok_arg_p = '1') then
                a_reg <= data_in;
            end if;

            -- NET -> module
            if (st(4) = '1' and rok_nxy_p = '1') then
                nx_reg <= nx_p;
            elsif (st(5) = '1' and rok_nxy_p = '1') then
                ny_reg <= ny_p;
            end if;
        end if;
    end if;
end process;

--------------------------------------------------
-- FSM combinatoire (one-hot)
--------------------------------------------------
process(st, wr_arg_p, wok_axy_p, rok_nxy_p, rd_res_p)
begin
    n_st <= st;

    -- RX_X
    if (st(0) = '1' and wr_arg_p = '1') then
        n_st <= "00000010";
    end if;

    -- RX_Y
    if (st(1) = '1' and wr_arg_p = '1') then
        n_st <= "00000100";
    end if;

    -- RX_A
    if (st(2) = '1' and wr_arg_p = '1') then
        n_st <= "00001000";
    end if;

    -- SEND_AXY
    if (st(3) = '1' and wok_axy_p = '1') then
        n_st <= "00010000";
    end if;

    -- RX_NX
    if (st(4) = '1' and rok_nxy_p = '1') then
        n_st <= "00100000";
    end if;

    -- RX_NY
    if (st(5) = '1' and rok_nxy_p = '1') then
        n_st <= "01000000";
    end if;

    -- SEND_NX
    if (st(6) = '1' and rd_res_p = '1') then
        n_st <= "10000000";
    end if;

    -- SEND_NY
    if (st(7) = '1' and rd_res_p = '1') then
        n_st <= "00000001"; -- back to RX_X
    end if;

end process;

--------------------------------------------------
-- Handshakes
--------------------------------------------------
wok_arg_p <= st(0) or st(1) or st(2);
wr_axy_p  <= st(3);

rd_nxy_p  <= st(4) or st(5);
rok_res_p <= st(6) or st(7);

--------------------------------------------------
-- Sorties
--------------------------------------------------
x_p <= x_reg;
y_p <= y_reg;
a_p <= a_reg;

data_out <= nx_reg when st(6) = '1' else
            ny_reg when st(7) = '1' else
            (others => '0');

end vhd;

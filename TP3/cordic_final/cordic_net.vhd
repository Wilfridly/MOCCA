ENTITY cordic_net IS
    PORT (
        ck : IN STD_LOGIC;
        raz : IN STD_LOGIC;

        wr_axy_p : IN STD_LOGIC;
        axy_p : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wok_axy_p : OUT STD_LOGIC;

        rd_nxy_p : IN STD_LOGIC;
        nxy_p : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        rok_nxy_p : OUT STD_LOGIC
    );
END cordic_net;

ARCHITECTURE vhd OF cordic_net IS

    -- common internal signals

    SIGNAL mkc_p : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL cmd_get_p : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL cmd_calc_p : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL cmd_mpp_p : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL i_calc_p : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL i_mpp_p : STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- #######################################################
    -- ################ CTL signals/registers ################
    -- #######################################################

    -- get & norm FSM states
    SIGNAL
    n_get_x, get_x,
    n_get_y, get_y,
    n_get_a, get_a,
    n_norm, norm,
    n_done_norm, done_norm
    : STD_LOGIC;

    -- calc FSM states
    SIGNAL
    n_get_calc, get_calc, -- x, y, a, quadrant
    n_calc, calc,
    n_done_calc, done_calc
    : STD_LOGIC;

    -- mkc & place & put (mpp) FSM states
    SIGNAL
    n_get_mpp, get_mpp, -- x, y, a, quadrant
    n_mkc, mkc,
    n_place, place,
    n_put_x, put_x,
    n_put_y, put_y
    : STD_LOGIC;

    -- Convention : wr_X = actif quand X présente ses données pour Y
    -- Convention : wok_x = actif quand Y lit les données présentées par X
    -- get_norm to calc sync signals
    SIGNAL wr_get, wok_get, quadrant_0 : STD_LOGIC;

    -- calc to mpp sync signals
    SIGNAL wr_calc, wok_calc : STD_LOGIC;

    -- Registres propres get & norm
    SIGNAL n_quadrant_get, quadrant_get : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL n_a_get, a_get : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL atan, a_mpidiv2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Registres propres calc
    SIGNAL n_a_calc, a_calc : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL n_i_calc, i_calc : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL n_quadrant_calc, quadrant_calc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL a_lt_0 : STD_LOGIC;

    -- Registres propres mpp
    SIGNAL n_i_mpp, i_mpp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL n_quadrant_mpp, quadrant_mpp : STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- #######################################################
    -- ################ DP signals/registers #################
    -- #######################################################

    SIGNAL
    n_x_get, x_get,
    n_y_get, y_get
    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL
    n_x_calc, x_calc,
    n_y_calc, y_calc,
    x_calc_sra_1, y_calc_sra_1, -- x >> 1 et y >> 1
    x_calc_sra_2, y_calc_sra_2, -- x >> 2 et y >> 2
    x_calc_sra_3, y_calc_sra_3, -- x >> 3 et y >> 3
    x_calc_sra_4, y_calc_sra_4, -- x >> 4 et y >> 4
    x_calc_sra_5, y_calc_sra_5, -- x >> 5 et y >> 5
    x_calc_sra_6, y_calc_sra_6, -- x >> 6 et y >> 6
    x_calc_sra_7, y_calc_sra_7, -- x >> 7 et y >> 7
    x_calc_sra_i, y_calc_sra_i -- x >> i et y >> i
    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL
    n_x_mpp, x_mpp,
    n_y_mpp, y_mpp,
    x_mpp_sra_1, y_mpp_sra_1, -- x >> 1 et y >> 1
    x_mpp_sra_2, y_mpp_sra_2, -- x >> 2 et y >> 2
    x_mpp_sra_3, y_mpp_sra_3, -- x >> 3 et y >> 3
    x_mpp_sra_4, y_mpp_sra_4, -- x >> 4 et y >> 4
    x_mpp_sra_5, y_mpp_sra_5, -- x >> 5 et y >> 5
    x_mpp_sra_6, y_mpp_sra_6, -- x >> 6 et y >> 6
    x_mpp_sra_7, y_mpp_sra_7, -- x >> 7 et y >> 7
    x_mpp_sra_i, y_mpp_sra_i, -- x >> i et y >> i
    n_xkc, xkc, -- x * KC
    n_ykc, ykc -- y * KC
    : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- #######################################################
    -- ###################### CTL Logic ######################
    -- #######################################################

    -------------------------------------------------------------------------------
    -- FSM
    -------------------------------------------------------------------------------

    -- Convention : dans les expressions, les transitions nemenant pas un changement d'état sont mises en premier (l'état actuel doit apparaître)

    -- get & norm FSM transitions
    n_get_x <= (get_x AND NOT wr_axy_p) OR (done_norm AND wok_get);
    n_get_y <= (get_y AND NOT wr_axy_p) OR (get_x AND wr_axy_p);
    n_get_a <= (get_a AND NOT wr_axy_p) OR (get_y AND wr_axy_p);
    n_norm <= (norm AND quadrant_0) OR (get_a AND wr_axy_p);
    n_done_norm <= (done_norm AND NOT wok_get) OR (norm AND quadrant_0); -- on attend que calc accepte les données

    -- calc FSM transitions
    n_get_calc <= (get_calc AND NOT wr_get) OR (done_calc AND wok_calc);
    n_calc <= (calc AND NOT (i_calc = 7)) OR (get_calc AND wr_get);
    n_done_calc <= (done_calc AND NOT wok_calc) OR (calc AND (i_calc = 7));

    -- mpp FSM transitions
    n_get_mpp <= (get_mpp AND NOT wr_calc) OR (put_y AND rd_nxy_p);
    n_mkc <= (mkc AND NOT (i_mpp = 2)) OR (get_mpp AND wr_calc);
    n_place <= mkc AND (i_mpp = 2);
    n_put_x <= (put_x AND NOT rd_nxy_p) OR place;
    n_put_y <= (put_y AND NOT rd_nxy_p) OR (put_x AND rd_nxy_p);

    -- Asignations get & norm
    get_norm_fsm : PROCESS (ck) BEGIN
        IF ((ck = '1') AND NOT(ck'STABLE)) THEN
            IF (raz = '0') THEN
                get_x <= '1';
                get_y <= '0';
                get_a <= '0';
                norm <= '0';
                done_norm <= '0';
            ELSE
                get_x <= n_get_x;
                get_y <= n_get_y;
                get_a <= n_get_a;
                norm <= n_norm;
                done_norm <= n_done_norm;
            END IF;
        END IF;
    END PROCESS get_norm_fsm;

    wr_get <= done_norm;
    wok_axy_p <= get_a OR get_x OR get_y;

    -- Asignations calc
    calc_fsm : PROCESS (ck) BEGIN
        IF ((ck = '1') AND NOT(ck'STABLE)) THEN
            IF (raz = '0') THEN
                get_calc <= '1';
                calc <= '0';
                done_calc <= '0';
            ELSE
                get_calc <= n_get_calc;
                calc <= n_calc;
                done_calc <= n_done_calc;
            END IF;
        END IF;
    END PROCESS calc_fsm;

    wr_calc <= done_calc;
    wok_get <= get_calc;
    i_calc_p <= i_calc;

    -- Assignations mpp
    mpp_fsm : PROCESS (ck) BEGIN
        IF ((ck = '1') AND NOT(ck'STABLE)) THEN
            IF (raz = '0') THEN
                get_mpp <= '1';
                mkc <= '0';
                place <= '0';
                put_x <= '0';
                put_y <= '0';
            ELSE
                get_mpp <= n_get_mpp;
                mkc <= n_mkc;
                place <= n_place;
                put_x <= n_put_x;
                put_y <= n_put_y;
            END IF;
        END IF;
    END PROCESS mpp_fsm;

    wok_calc <= get_mpp;
    rok_nxy_p <= put_x OR put_y;
    i_mpp_p <= i_mpp;

    mkc_p <= 0 WHEN mkc AND (i_mpp = 0)
        ELSE
        1 WHEN mkc AND (i_mpp = 1)
        ELSE
        2 WHEN mkc AND (i_mpp = 2)
        ELSE
        3;

    -- cmd get & norm
    cmd_get_p <= 0 WHEN get_x
        ELSE
        1 WHEN get_y
        ELSE
        2;

    -- cmd calc
    cmd_calc_p <= 0 WHEN get_calc
        ELSE
        1 WHEN calc AND a_lt_0
        ELSE
        2 WHEN calc AND NOT a_lt_0
        ELSE
        3;

    -- cmd mpp
    cmd_mpp_p <= 0 WHEN get_mpp
        ELSE
        1 WHEN place AND (quadrant_mpp = 0)
        ELSE
        2 WHEN place AND (quadrant_mpp = 1)
        ELSE
        3 WHEN place AND (quadrant_mpp = 2)
        ELSE
        4 WHEN place AND (quadrant_mpp = 3)
        ELSE
        5 WHEN put_x
        ELSE
        6 WHEN put_y
        ELSE
        7;

    -- get & norm : compteurs et logique propres
    n_a_get <= axy_p & "00" WHEN get_a
        ELSE
        a_mpidiv2 WHEN norm AND NOT quadrant_0
        ELSE
        a_get;

    n_quadrant_get <= "00" WHEN get_a
        ELSE
        quadrant_get + 1 WHEN norm AND NOT quadrant_0
        ELSE
        quadrant_get;

    a_mpidiv2 <= a_get - x"00C9";
    quadrant_0 <= a_mpidiv2(15);
    -- calc : compteurs et logiques propres
    n_a_calc <= a_get WHEN get_calc
        ELSE
        a_calc - atan WHEN calc AND NOT a_lt_0
        ELSE
        a_calc + atan WHEN calc AND a_lt_0
        ELSE
        a_calc;

    n_i_calc <= "000" WHEN get_calc
        ELSE
        i_calc + 1 WHEN calc
        ELSE
        i_calc;

    a_lt_0 <= a_calc(15); -- 1 si a est négatif (signe de a)

    -- ROM with arctan(2-i)

    atan <= x"0065" WHEN i_calc = 0 -- atan(2^-0)
        ELSE
        x"003B" WHEN i_calc = 1 -- atan(2^-1)
        ELSE
        x"001F" WHEN i_calc = 2 -- atan(2^-2)
        ELSE
        x"0010" WHEN i_calc = 3 -- atan(2^-3)
        ELSE
        x"0008" WHEN i_calc = 4 -- atan(2^-4)
        ELSE
        x"0004" WHEN i_calc = 5 -- atan(2^-5)
        ELSE
        x"0002" WHEN i_calc = 6 -- atan(2^-6)
        ELSE
        x"0001"; -- atan(2^-7)

    -- mpp : compteurs et logiques propres
    n_i_mpp <= "00" WHEN get_mpp
        ELSE
        i_mpp + 1 WHEN mkc
        ELSE
        i_mpp;

    -- assignations des registres propres
    CTL : PROCESS (ck) BEGIN
        IF ((ck = '1') AND NOT(ck'STABLE))
            THEN
            quadrant_get <= n_quadrant_get;
            a_get <= n_a_get;
            a_calc <= n_a_calc;
            i_calc <= n_i_calc;
            i_mpp <= n_i_mpp;
        END IF;
    END PROCESS CTL;

    -- #######################################################
    -- ###################### DP Logic #######################
    -- #######################################################

    -- ############################# get & norm #############################
    n_x_get <= axy_p(7) & axy_p & "0000000" WHEN cmd_get_p = 0
        ELSE
        x_get;

    n_y_get <= axy_p(7) & axy_p & "0000000" WHEN cmd_get_p = 1
        ELSE
        y_get;

    -- ############################# calc #############################
    n_x_calc <= x_get WHEN cmd_calc_p = 0 -- get_calc
        ELSE
        x_calc + y_calc_sra_i WHEN cmd_calc_p = 1 -- calc  AND a_lt_0
        ELSE
        x_calc - y_calc_sra_i WHEN cmd_calc_p = 2 -- calc  AND a_lt_0
        ELSE
        x_calc;

    n_y_calc <= y_get WHEN cmd_calc_p = 0 -- get_calc
        ELSE
        y_calc - x_calc_sra_i WHEN cmd_calc_p = 1 -- calc  AND a_lt_0
        ELSE
        y_calc + x_calc_sra_i WHEN cmd_calc_p = 2 -- calc  AND a_lt_0
        ELSE
        y_calc;

    x_calc_sra_1 <= x_calc(15) & x_calc(15 DOWNTO 1);
    x_calc_sra_2 <= x_calc(15) & x_calc_sra_1(15 DOWNTO 1);
    x_calc_sra_3 <= x_calc(15) & x_calc_sra_2(15 DOWNTO 1);
    x_calc_sra_4 <= x_calc(15) & x_calc_sra_3(15 DOWNTO 1);
    x_calc_sra_5 <= x_calc(15) & x_calc_sra_4(15 DOWNTO 1);
    x_calc_sra_6 <= x_calc(15) & x_calc_sra_5(15 DOWNTO 1);
    x_calc_sra_7 <= x_calc(15) & x_calc_sra_6(15 DOWNTO 1);

    x_calc_sra_i <= x_calc_sra_1 WHEN i_calc_p = 1
        ELSE
        x_calc_sra_2 WHEN i_calc_p = 2
        ELSE
        x_calc_sra_3 WHEN i_calc_p = 3
        ELSE
        x_calc_sra_4 WHEN i_calc_p = 4
        ELSE
        x_calc_sra_5 WHEN i_calc_p = 5
        ELSE
        x_calc_sra_6 WHEN i_calc_p = 6
        ELSE
        x_calc_sra_7 WHEN i_calc_p = 7
        ELSE
        x_calc;

    y_calc_sra_1 <= y_calc(15) & y_calc(15 DOWNTO 1);
    y_calc_sra_2 <= y_calc(15) & y_calc_sra_1(15 DOWNTO 1);
    y_calc_sra_3 <= y_calc(15) & y_calc_sra_2(15 DOWNTO 1);
    y_calc_sra_4 <= y_calc(15) & y_calc_sra_3(15 DOWNTO 1);
    y_calc_sra_5 <= y_calc(15) & y_calc_sra_4(15 DOWNTO 1);
    y_calc_sra_6 <= y_calc(15) & y_calc_sra_5(15 DOWNTO 1);
    y_calc_sra_7 <= y_calc(15) & y_calc_sra_6(15 DOWNTO 1);

    y_calc_sra_i <= y_calc_sra_1 WHEN i_calc_p = 1
        ELSE
        y_calc_sra_2 WHEN i_calc_p = 2
        ELSE
        y_calc_sra_3 WHEN i_calc_p = 3
        ELSE
        y_calc_sra_4 WHEN i_calc_p = 4
        ELSE
        y_calc_sra_5 WHEN i_calc_p = 5
        ELSE
        y_calc_sra_6 WHEN i_calc_p = 6
        ELSE
        y_calc_sra_7 WHEN i_calc_p = 7
        ELSE
        y_calc;

    -- ################################ mpp ################################
    x_mpp_sra_1 <= x_mpp(15) & x_mpp(15 DOWNTO 1);
    x_mpp_sra_2 <= x_mpp(15) & x_mpp_sra_1(15 DOWNTO 1);
    x_mpp_sra_3 <= x_mpp(15) & x_mpp_sra_2(15 DOWNTO 1);
    x_mpp_sra_4 <= x_mpp(15) & x_mpp_sra_3(15 DOWNTO 1);
    x_mpp_sra_5 <= x_mpp(15) & x_mpp_sra_4(15 DOWNTO 1);
    x_mpp_sra_6 <= x_mpp(15) & x_mpp_sra_5(15 DOWNTO 1);
    x_mpp_sra_7 <= x_mpp(15) & x_mpp_sra_6(15 DOWNTO 1);

    x_mpp_sra_i <= x_mpp_sra_1 WHEN i_mpp_p = 1
        ELSE
        x_mpp_sra_2 WHEN i_mpp_p = 2
        ELSE
        x_mpp_sra_3 WHEN i_mpp_p = 3
        ELSE
        x_mpp_sra_4 WHEN i_mpp_p = 4
        ELSE
        x_mpp_sra_5 WHEN i_mpp_p = 5
        ELSE
        x_mpp_sra_6 WHEN i_mpp_p = 6
        ELSE
        x_mpp_sra_7 WHEN i_mpp_p = 7
        ELSE
        x_mpp;

    y_mpp_sra_1 <= y_mpp(15) & y_mpp(15 DOWNTO 1);
    y_mpp_sra_2 <= y_mpp(15) & y_mpp_sra_1(15 DOWNTO 1);
    y_mpp_sra_3 <= y_mpp(15) & y_mpp_sra_2(15 DOWNTO 1);
    y_mpp_sra_4 <= y_mpp(15) & y_mpp_sra_3(15 DOWNTO 1);
    y_mpp_sra_5 <= y_mpp(15) & y_mpp_sra_4(15 DOWNTO 1);
    y_mpp_sra_6 <= y_mpp(15) & y_mpp_sra_5(15 DOWNTO 1);
    y_mpp_sra_7 <= y_mpp(15) & y_mpp_sra_6(15 DOWNTO 1);

    y_mpp_sra_i <= y_mpp_sra_1 WHEN i_mpp_p = 1
        ELSE
        y_mpp_sra_2 WHEN i_mpp_p = 2
        ELSE
        y_mpp_sra_3 WHEN i_mpp_p = 3
        ELSE
        y_mpp_sra_4 WHEN i_mpp_p = 4
        ELSE
        y_mpp_sra_5 WHEN i_mpp_p = 5
        ELSE
        y_mpp_sra_6 WHEN i_mpp_p = 6
        ELSE
        y_mpp_sra_7 WHEN i_mpp_p = 7
        ELSE
        y_mpp;

    n_xkc <= x_mpp_sra_6 + x_mpp_sra_5 WHEN mkc_p = 0 -- mkc AND i = 0
        ELSE
        xkc + x_mpp_sra_4 WHEN mkc_p = 1 -- mkc AND i = 1
        ELSE
        xkc + x_mpp_sra_1 WHEN mkc_p = 2 -- mkc AND i = 2
        ELSE
        xkc;

    n_ykc <= y_mpp_sra_6 + y_mpp_sra_5 WHEN mkc_p = 0 -- mkc AND i = 0
        ELSE
        ykc + y_mpp_sra_4 WHEN mkc_p = 1 -- mkc AND i = 1
        ELSE
        ykc + y_mpp_sra_1 WHEN mkc_p = 2 -- mkc AND i = 2
        ELSE
        ykc;

    n_x_mpp <= x_calc WHEN cmd_mpp_p = 0 -- get mpp
        ELSE
        xkc WHEN cmd_mpp_p = 1 -- place AND (quadrant = 0)
        ELSE
        - ykc WHEN cmd_mpp_p = 2 -- place AND (quadrant = 1)
        ELSE
        - xkc WHEN cmd_mpp_p = 3 -- place AND (quadrant = 2)
        ELSE
        ykc WHEN cmd_mpp_p = 4 -- place AND (quadrant = 3)
        ELSE
        x_mpp;

    n_y_mpp <= y_calc WHEN cmd_mpp_p = 0 -- init
        ELSE
        ykc WHEN cmd_mpp_p = 1 -- place AND (quadrant = 0)
        ELSE
        xkc WHEN cmd_mpp_p = 2 -- place AND (quadrant = 1)
        ELSE
        - ykc WHEN cmd_mpp_p = 3 -- place AND (quadrant = 2)
        ELSE
        - xkc WHEN cmd_mpp_p = 4 -- place AND (quadrant = 3)
        ELSE
        y_mpp;

    nxy_p <= x_mpp(14 DOWNTO 7) WHEN cmd_mpp_p = 5
        ELSE
        y_mpp(14 DOWNTO 7) WHEN cmd_mpp_p = 6
        ELSE
        "00000000";

    -- ################################ assignations ################################
    DP : PROCESS (ck) BEGIN
        IF ((ck = '1') AND NOT(ck'STABLE))
            THEN
            x_get <= n_x_get;
            y_get <= n_y_get;
            x_calc <= n_x_calc;
            y_calc <= n_y_calc;
            x_mpp <= n_x_mpp;
            y_mpp <= n_y_mpp;

            xkc <= n_xkc;
            ykc <= n_ykc;
        END IF;
    END PROCESS DP;

END vhd;
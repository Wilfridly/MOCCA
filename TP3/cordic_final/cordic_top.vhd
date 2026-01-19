entity cordic_top is
port(
    ck        : in  std_logic;
    raz       : in  std_logic;

    -- Interface DATA externe
    wr_top  : in  std_logic;
    data_in   : in  std_logic_vector(7 downto 0);
    wok_top : out std_logic;

    -- Lecture résultat
    rd_top  : in  std_logic;
    data_out  : out std_logic_vector(7 downto 0);
    rok_top : out std_logic
);
end cordic_top;

-------------------------------------------------------------------------------
-- ARCHITECTURE UNIQUE
-------------------------------------------------------------------------------
architecture vhd of cordic_top is

----------------------------------------------------------------------------
-- Signaux INTER-BLOCS (CÂBLAGE)
----------------------------------------------------------------------------

-- 1 -> 3 vers CORDIC
signal wr_arg_p  : std_logic;
signal wok_arg_p : std_logic;
signal wr_axy_p  : std_logic;
signal wok_axy_p : std_logic;

signal a_p, x_p, y_p : std_logic_vector(7 downto 0);

-- CORDIC -> 2 -> 1
signal rd_nxy_p  : std_logic;
signal rok_nxy_p : std_logic;
signal nx_p, ny_p : std_logic_vector(7 downto 0);

signal rd_res_p  : std_logic;
signal rok_res_p : std_logic;

----------------------------------------------------------------------------
-- 1 → 3  (FSM entrée)
----------------------------------------------------------------------------
signal stateoito, n_stateoito : std_logic;
signal counter, n_counter    : std_logic_vector(1 downto 0);

signal a_reg, x_reg, y_reg   : std_logic_vector(7 downto 0);

----------------------------------------------------------------------------
-- 2 → 1  (FSM sortie)
----------------------------------------------------------------------------
signal state, n_state        : std_logic_vector(1 downto 0);
signal nx_reg, ny_reg        : std_logic_vector(7 downto 0);
signal n_nx_reg, n_ny_reg    : std_logic_vector(7 downto 0);

----------------------------------------------------------------------------
-- === CORDIC
----------------------------------------------------------------------------
signal
    n_get, get,
    n_norm, norm,
    n_calc, calc,
    n_mkc, mkc,
    n_place, place,
    n_put, put,
    a_lt_0,
    quadrant_0 : std_logic;

signal
    n_quadrant, quadrant : std_logic_vector(1 downto 0);

signal
    n_i, i : std_logic_vector(2 downto 0);

signal
    n_x, x,
    n_y, y,
    n_a, a,
    n_xkc, xkc,
    n_ykc, ykc,
    atan,
    a_mpidiv2,
    x_sra_1, y_sra_1,
    x_sra_2, y_sra_2,
    x_sra_3, y_sra_3,
    x_sra_4, y_sra_4,
    x_sra_5, y_sra_5,
    x_sra_6, y_sra_6,
    x_sra_7, y_sra_7,
    x_sra_i, y_sra_i
: std_logic_vector(15 downto 0);


begin

----------------------------------------------------------------------------
-- Connexions TOP
----------------------------------------------------------------------------
wr_arg_p <= wr_top;
wok_top  <= wok_arg_p;

rd_res_p <= rd_top;
rok_top  <= rok_res_p;

----------------------------------------------------------------------------
-- 1 → 3 FSM
----------------------------------------------------------------------------
process(ck)
begin
    if ((ck = '1') AND NOT(ck'STABLE)) then
        if raz = '0' then
            stateoito <= '0';
            counter  <= "00";
            a_reg    <= (others => '0');
            x_reg    <= (others => '0');
            y_reg    <= (others => '0');
        else
            stateoito <= n_stateoito;
            counter  <= n_counter;

            if stateoito = '0' and wr_arg_p = '1' then
                case counter is
                    when "00" => a_reg <= data_in;
                    when "01" => x_reg <= data_in;
                    when "10" => y_reg <= data_in;
                    when others => null;
                end case;
            end if;
        end if;
    end if;
end process;

process(stateoito, wr_arg_p, wok_axy_p, counter)
begin
    n_stateoito <= stateoito;
    n_counter  <= counter;

    case stateoito is
        when '0' =>
            if wr_arg_p = '1' then
                if counter = "10" then
                    n_stateoito <= '1';
                    n_counter  <= "00";
                else
                    n_counter <= counter + 1;
                end if;
            end if;

        when '1' =>
            if wok_axy_p = '1' then
                n_stateoito <= '0';
            end if;

        when others =>
            n_stateoito <= '0';
            n_counter  <= "00";
    end case;
end process;

wok_arg_p <= '1' when stateoito = '0' else '0';
wr_axy_p  <= '1' when stateoito = '1' else '0';

a_p <= a_reg;
x_p <= x_reg;
y_p <= y_reg;

----------------------------------------------------------------------------
-- 2 → 1 FSM
----------------------------------------------------------------------------
process(ck)
begin
    if ((ck = '1') AND NOT(ck'STABLE)) then
        if raz = '0' then
            state  <= "00";
            nx_reg <= (others => '0');
            ny_reg <= (others => '0');
        else
            state  <= n_state;
            nx_reg <= n_nx_reg;
            ny_reg <= n_ny_reg;
        end if;
    end if;
end process;

process(state, rok_nxy_p, rd_res_p, nx_p, ny_p, nx_reg, ny_reg)
begin
    n_state  <= state;
    n_nx_reg <= nx_reg;
    n_ny_reg <= ny_reg;

    case state is
        when "00" =>
            if rd_res_p = '1' then
                n_state <= "01";
            end if;

        when "01" =>
            if rok_nxy_p = '1' then
                n_nx_reg <= nx_p;
                n_ny_reg <= ny_p;
                n_state  <= "10";
            end if;

        when "10" =>
            if rd_res_p = '1' then
                n_state <= "11";
            end if;

        when "11" =>
            if rd_res_p = '1' then
                n_state <= "00";
            end if;

        when others =>
            n_state <= "00";
    end case;
end process;

rd_nxy_p  <= '1' when state = "01" else '0';
rok_res_p <= '1' when (state = "10" or state = "11") else '0';

data_out <= nx_reg when state = "10" else
            ny_reg when state = "11" else
            (others => '0');

----------------------------------------------------------------------------
-- CORDIC
----------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- FSM
-------------------------------------------------------------------------------

    -- FSM transition

    n_get       <= (get  AND NOT wr_axy_p) OR (put  AND rd_nxy_p);
    n_norm      <= (get  AND wr_axy_p) OR (norm AND NOT quadrant_0);
    n_calc      <= (norm AND quadrant_0) OR (calc AND NOT (i = 7));
    n_mkc       <= (calc AND (i = 7)) OR (mkc  AND NOT (i = 2));
    n_place     <= (mkc  AND (i = 2));
    n_put       <= (place) OR (put  AND NOT rd_nxy_p);

    FSM : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE) )
    then
        if (raz = '0') then
            get   <= '1';
            norm  <= '0';
            calc  <= '0';
            mkc   <= '0';
            place <= '0';
            put   <= '0';
        else
            get   <= n_get   ;
            norm  <= n_norm  ;
            calc  <= n_calc  ;
            mkc   <= n_mkc   ;
            place <= n_place ;
            put   <= n_put   ;
        end if;
    end if;
    end process FSM;

    -- Sorties issues de l'automate

    wok_axy_p   <=  get;
    rok_nxy_p   <=  put;

-------------------------------------------------------------------------------
-- Compteurs de l'algorithme et calcul de l'angle de rotation@
-------------------------------------------------------------------------------

    -- Compteurs de normalisation de l'angle : quadrant est le numéro du quadrant

    n_quadrant  <= "00"           when get
              else quadrant + 1   when norm AND NOT quadrant_0
              else quadrant;

    -- ROM with arctan(2-i)

    atan        <= x"0065" when i = 0     -- atan(2^-0)
              else x"003B" when i = 1     -- atan(2^-1)
              else x"001F" when i = 2     -- atan(2^-2)
              else x"0010" when i = 3     -- atan(2^-3)
              else x"0008" when i = 4     -- atan(2^-4)
              else x"0004" when i = 5     -- atan(2^-5)
              else x"0002" when i = 6     -- atan(2^-6)
              else x"0001";               -- atan(2^-7)

    -- Calcul de l'angle : recherche par dichotomie

    a_mpidiv2   <= a - x"00C9";
    quadrant_0  <= a_mpidiv2(15);
    a_lt_0      <= a(15);    -- 1 si a est négatif (signe de a)

    n_a         <= a_p & "00" when get                     -- init
              else a_mpidiv2  when norm AND NOT quadrant_0 -- a - PI/2
              else a - atan   when calc AND NOT a_lt_0     -- trop grand
              else a + atan   when calc AND a_lt_0         -- trop petit
              else a;                                      -- stable

    -- Compteurs de la dichotomie et de la normalisation de l'angle

    n_i         <= "000"      when get                     -- init
              else i + 1      when calc or mkc             -- inc 
              else i ;                                     -- stable


    CTL : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE) )
    then
       i        <= n_i        ;
       quadrant <= n_quadrant ;
       a        <= n_a        ;
    end if;
    end process CTL;

-------------------------------------------------------------------------------
-- Chemin de données
-------------------------------------------------------------------------------

    -- Shifters : x_sra_i <= x << i et y_sra_i <= y << i

    x_sra_1     <= x(15) &       x(15 downto 1);
    x_sra_2     <= x(15) & x_sra_1(15 downto 1);
    x_sra_3     <= x(15) & x_sra_2(15 downto 1);
    x_sra_4     <= x(15) & x_sra_3(15 downto 1);
    x_sra_5     <= x(15) & x_sra_4(15 downto 1);
    x_sra_6     <= x(15) & x_sra_5(15 downto 1);
    x_sra_7     <= x(15) & x_sra_6(15 downto 1);
    x_sra_i     <= x_sra_1 when i = 1
              else x_sra_2 when i = 2
              else x_sra_3 when i = 3
              else x_sra_4 when i = 4
              else x_sra_5 when i = 5
              else x_sra_6 when i = 6
              else x_sra_7 when i = 7
              else x;

    y_sra_1     <= y(15) &       y(15 downto 1);
    y_sra_2     <= y(15) & y_sra_1(15 downto 1);
    y_sra_3     <= y(15) & y_sra_2(15 downto 1);
    y_sra_4     <= y(15) & y_sra_3(15 downto 1);
    y_sra_5     <= y(15) & y_sra_4(15 downto 1);
    y_sra_6     <= y(15) & y_sra_5(15 downto 1);
    y_sra_7     <= y(15) & y_sra_6(15 downto 1);
    y_sra_i     <= y_sra_1 when i = 1
              else y_sra_2 when i = 2
              else y_sra_3 when i = 3
              else y_sra_4 when i = 4
              else y_sra_5 when i = 5
              else y_sra_6 when i = 6
              else y_sra_7 when i = 7
              else y;

    -- produits des coordonnées de rotation par KC

    n_xkc       <= x_sra_6 + x_sra_5 when mkc AND i = 0
              else xkc     + x_sra_4 when mkc AND i = 1
              else xkc     + x_sra_1 when mkc AND i = 2
              else xkc;

    n_ykc       <= y_sra_6 + y_sra_5 when mkc AND i = 0
              else ykc     + y_sra_4 when mkc AND i = 1
              else ykc     + y_sra_1 when mkc AND i = 2
              else ykc;

    -- coordonnées

    n_x         <= x_p(7) & x_p & "0000000" when get                  -- init
              else x - y_sra_i              when calc  AND NOT a_lt_0 -- au dessus
              else x + y_sra_i              when calc  AND a_lt_0     -- en dessous
              else xkc                      when place AND (quadrant = 0)
              else -ykc                     when place AND (quadrant = 1)
              else -xkc                     when place AND (quadrant = 2)
              else ykc                      when place AND (quadrant = 3)
              else x;

    n_y         <= y_p(7) & y_p & "0000000" when get                  -- init
              else y + x_sra_i              when calc  AND NOT a_lt_0 -- au dessus
              else y - x_sra_i              when calc  AND a_lt_0     -- en dessous
              else ykc                      when place AND (quadrant = 0) 
              else xkc                      when place AND (quadrant = 1)
              else -ykc                     when place AND (quadrant = 2)
              else -xkc                     when place AND (quadrant = 3)
              else y;

    DP : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE) )
    then
       x     <= n_x     ;
       y     <= n_y     ;
       xkc   <= n_xkc   ;
       ykc   <= n_ykc   ;
    end if;
    end process DP;

    -- Sorties du chemin de données

    nx_p        <=  x(14 downto 7);
    ny_p        <=  y(14 downto 7);
end vhd;

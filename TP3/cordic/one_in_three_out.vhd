-- entity one_in_three_out is
-- port(
--     ck       : in  std_logic;
--     raz      : in  std_logic;

--     data_in  : in  std_logic_vector(7 downto 0);

--     -- opérandes en sortie
--     a_p      : out std_logic_vector(7 downto 0);
--     x_p      : out std_logic_vector(7 downto 0);
--     y_p      : out std_logic_vector(7 downto 0);

--     -- interface DATA -> one_in_three_out
--     wr_arg_p : in  std_logic;  -- DATA écrit un argument
--     wok_arg_p: out std_logic;  -- prêt à recevoir

--     -- interface one_in_three_out -> NET
--     wr_axy_p : out std_logic;  -- écrit A,X,Y
--     wok_axy_p: in  std_logic   -- aval prêt
-- );
-- end one_in_three_out;

-- architecture vhd of one_in_three_out is

--     signal state, n_state : std_logic;
--     signal counter, n_counter : std_logic_vector(2 downto 0);

--     signal a_reg, x_reg, y_reg : std_logic_vector(7 downto 0);
--     signal rx_reg, ry_reg     : std_logic_vector(7 downto 0);

-- begin

-- -------------------------------------------------
-- -- Registres (FSM + données)
-- -------------------------------------------------
-- process(ck)
-- begin
--     if (ck = '1' and not ck'stable) then
--         if raz = '0' then
--             state   <= '0';   -- IDLE
--             counter <= "000";
--             x_reg   <= (others => '0');
--             y_reg   <= (others => '0');
--             a_reg   <= (others => '0');
--         else
--             state   <= n_state;
--             counter <= n_counter;

--             if (state = '0' and wr_arg_p = '1') then
--                 if counter = "000" then
--                     x_reg <= data_in;
--                 elsif counter = "001" then
--                     y_reg <= data_in;
--                 elsif counter = "010" then
--                     a_reg <= data_in;
--                 elsif counter = "011" then
--                     rx_reg <= data_in;
--                 elsif counter = "100" then
--                     ry_reg <= data_in;
--                 end if;
--             end if;
--         end if;
--     end if;
-- end process;

-- -------------------------------------------------
-- -- FSM combinatoire
-- -------------------------------------------------
-- process(state, wr_arg_p, wok_axy_p, counter)
-- begin
--     -- valeurs par défaut
--     n_state   <= state;
--     n_counter <= counter;

--     case state is
--         when '0' => -- READ
--             if wr_arg_p = '1' then
--                 if counter = "010" then
--                     n_state   <= '1'; -- SEND
--                     n_counter <= "000";
--                 else
--                     n_counter <= counter + 1;
--                 end if;
--             end if;

--         when '1' => -- SEND
--             if wok_axy_p = '1' then
--                 n_state <= '0'; -- READ
--             end if;

--         when others =>
--             n_state <= '0';
--             n_counter <= "000";

--     end case;
-- end process;

-- -------------------------------------------------
-- -- Handshake
-- -------------------------------------------------
-- wok_arg_p <= '1' when state = '0' else '0';
-- wr_axy_p  <= '1' when state = '1' else '0';

-- -------------------------------------------------
-- -- Sorties
-- -------------------------------------------------
-- a_p <= a_reg when state = '1' else (others => '0');
-- x_p <= x_reg when state = '1' else (others => '0');
-- y_p <= y_reg when state = '1' else (others => '0');

-- end vhd;

entity one_in_three_out is
port(
    ck       : in  std_logic;
    raz      : in  std_logic;

    data_in  : in  std_logic_vector(7 downto 0);

    -- opérandes en sortie
    a_p      : out std_logic_vector(7 downto 0);
    x_p      : out std_logic_vector(7 downto 0);
    y_p      : out std_logic_vector(7 downto 0);

    -- interface DATA -> one_in_three_out
    wr_arg_p : in  std_logic;  -- DATA écrit un argument
    wok_arg_p: out std_logic;  -- prêt à recevoir

    -- interface one_in_three_out -> NET
    wr_axy_p : out std_logic;  -- écrit A,X,Y
    wok_axy_p: in  std_logic   -- aval prêt
);
end one_in_three_out;

architecture vhd of one_in_three_out is

    signal state, n_state : std_logic;
    signal counter, n_counter : std_logic_vector(1 downto 0);

    signal a_reg, x_reg, y_reg : std_logic_vector(7 downto 0);
    signal rx_reg, ry_reg     : std_logic_vector(7 downto 0);

begin

-------------------------------------------------
-- Registres (FSM + données)
-------------------------------------------------
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state   <= '0';   -- IDLE
            counter <= "00";
            x_reg   <= (others => '0');
            y_reg   <= (others => '0');
            a_reg   <= (others => '0');
        else
            state   <= n_state;
            counter <= n_counter;

            if (state = '0' and wr_arg_p = '1') then
                if counter = "00" then
                    a_reg <= data_in;
                elsif counter = "01" then
                    x_reg <= data_in;
                elsif counter = "10" then
                    y_reg <= data_in;
                end if;
            end if;
        end if;
    end if;
end process;

-------------------------------------------------
-- FSM combinatoire
-------------------------------------------------
process(state, wr_arg_p, wok_axy_p, counter)
begin
    -- valeurs par défaut
    n_state   <= state;
    n_counter <= counter;

    case state is
        when '0' => -- READ
            if wr_arg_p = '1' then
                if counter = "10" then
                    n_state   <= '1'; -- SEND
                    n_counter <= "00";
                else
                    n_counter <= counter + 1;
                end if;
            end if;

        when '1' => -- SEND
            if wok_axy_p = '1' then
                n_state <= '0'; -- IDLE
            end if;

        when others =>
            n_state <= '0';
            n_counter <= "00";

    end case;
end process;

-------------------------------------------------
-- Handshake
-------------------------------------------------
wok_arg_p <= '1' when state = '0' else '0';
wr_axy_p  <= '1' when state = '1' else '0';

-------------------------------------------------
-- Sorties
-------------------------------------------------
a_p <= a_reg when state = '1' else (others => '0');
x_p <= x_reg when state = '1' else (others => '0');
y_p <= y_reg when state = '1' else (others => '0');

end vhd;

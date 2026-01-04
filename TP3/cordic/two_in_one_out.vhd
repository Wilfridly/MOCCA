 entity two_in_one_out is
port(
    ck      : in  std_logic;
    raz     : in  std_logic;

    nx_p    : in  std_logic_vector(7 downto 0);
    ny_p    : in  std_logic_vector(7 downto 0);

    -- interface net -> tioo
    rd_nxy_p    : out std_logic;
    rok_nxy_p : in  std_logic;

    -- interface tioo -> data
    rd_res_p    : in  std_logic;
    rok_res_p   : out std_logic;

    data_out  : out std_logic_vector(7 downto 0)
);
end two_in_one_out;

architecture vhd of two_in_one_out is

    signal state, n_state : std_logic;
    signal counter, n_counter : std_logic;

begin

-------------------------------------------------
-- FSM synchrone
-------------------------------------------------
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state   <= '0';  -- READ
            counter <= '0';
        else
            state   <= n_state;
            counter <= n_counter;
        end if;
    end if;
end process;

-------------------------------------------------
-- FSM combinatoire
-------------------------------------------------
process(state, rok_nxy_p, rd_res_p, counter)
begin
    -- valeurs par défaut
    n_state   <= state;
    n_counter <= counter;

    case state is

        when '0' => -- READ
            n_counter <= '0';
            if rok_nxy_p = '1' then
                n_state <= '1';
            end if;

        when '1' => -- SEND
            if rd_res_p = '1' then
                if counter = '0' then
                    n_counter <= '1';
                else
                    n_state   <= '0';
                    n_counter <= '0';
                end if;
            end if;
            
        when others =>
            n_state   <= '0';
            n_counter <= '0';

    end case;
end process;

-------------------------------------------------
-- Handshake
-------------------------------------------------
rd_nxy_p  <= '1' when state = '0' else '0';   -- READ
rok_res_p <= '1' when state = '1' else '0';   -- SEND

-------------------------------------------------
-- Données
-------------------------------------------------
data_out <= nx_p when (state = '1' and counter = '0') else -- SEND
            ny_p when (state = '1' and counter = '1') else -- SEND
            x"00";

end vhd;

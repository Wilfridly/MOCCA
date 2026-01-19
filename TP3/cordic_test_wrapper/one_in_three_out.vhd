entity one_in_three_out is
port(
    ck      : in  std_logic;
    raz     : in  std_logic;

    data_in : in  std_logic_vector(7 downto 0);

    -- handshake unique Alliance
    wr_arg  : in  std_logic;  -- écriture / validation
    wok_arg : out std_logic;  -- prêt

    -- sortie vers CORE
    a_p     : out std_logic_vector(7 downto 0);
    x_p     : out std_logic_vector(7 downto 0);
    y_p     : out std_logic_vector(7 downto 0)
);
end one_in_three_out;

architecture vhd of one_in_three_out is
    signal state, n_state : std_logic;

    signal cnt, n_cnt : std_logic_vector(1 downto 0);

    signal a_reg, x_reg, y_reg : std_logic_vector(7 downto 0);

begin
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state <= '0';
            cnt   <= "00";
            a_reg <= (others => '0');
            x_reg <= (others => '0');
            y_reg <= (others => '0');
        else
            state <= n_state;
            cnt   <= n_cnt;

            -- handshake unique
            if (wr_arg = '1' and wok_arg = '1') then
                if state = '0' then
                    case cnt is
                        when "00" => a_reg <= data_in;
                        when "01" => x_reg <= data_in;
                        when "10" => y_reg <= data_in;
                        when others => null;
                    end case;
                end if;
            end if;
        end if;
    end if;
end process;

process(state, cnt, wr_arg)
begin
    n_state <= state;
    n_cnt   <= cnt;

    case state is

        when '0' =>
            if wr_arg = '1' then
                if cnt = "10" then
                    n_state <= '1';
                    n_cnt   <= "00";
                else
                    n_cnt <= cnt + 1;
                end if;
            end if;

        when '1' =>
            if wr_arg = '1' then
                n_state <= '0';
            end if;

    end case;
end process;

-- Alliance : wok = prêt
wok_arg <= '1';

a_p <= a_reg;
x_p <= x_reg;
y_p <= y_reg;

end vhd;

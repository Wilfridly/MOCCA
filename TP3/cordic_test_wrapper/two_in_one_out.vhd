entity two_in_one_out is
port(
    ck      : in  std_logic;
    raz     : in  std_logic;

    nx_p    : in  std_logic_vector(7 downto 0);
    ny_p    : in  std_logic_vector(7 downto 0);

    -- handshake unique DATA <-> CORE
    rd_res  : in  std_logic;   -- DATA demande
    rok_res : out std_logic;   -- prêt

    data_out : out std_logic_vector(7 downto 0)
);
end two_in_one_out;

architecture vhd of two_in_one_out is

    signal state, n_state : std_logic_vector(1 downto 0);
    signal nx_reg, ny_reg : std_logic_vector(7 downto 0);

begin
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state  <= "00";
            nx_reg <= (others => '0');
            ny_reg <= (others => '0');
        else
            state <= n_state;

            -- capture des données à la première demande
            if (state = "00" and rd_res = '1' and rok_res = '1') then
                nx_reg <= nx_p;
                ny_reg <= ny_p;
            end if;
        end if;
    end if;
end process;

process(state, rd_res)
begin
    n_state <= state;

    case state is

        when "00" =>
            if rd_res = '1' then
                n_state <= "01";
            end if;

        when "01" =>
            if rd_res = '1' then
                n_state <= "10";
            end if;

        when "10" =>
            if rd_res = '1' then
                n_state <= "00";
            end if;

    end case;
end process;

rok_res <= '1';

data_out <= nx_reg when state = "01" else
            ny_reg when state = "10" else
            (others => '0');

end vhd;
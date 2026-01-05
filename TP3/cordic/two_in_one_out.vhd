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

    signal state, n_state   : std_logic_vector(1 downto 0);
    signal nx_reg, ny_reg : std_logic_vector(7 downto 0);

begin

process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state <= "00";  -- IDLE
            nx_reg <= (others => '0');
            ny_reg <= (others => '0');
        else
            state <= n_state;

            -- Capturer quand on passe de WAIT à SEND
            if state = "01" and rok_nxy_p = '1' then
                nx_reg <= nx_p;
                ny_reg <= ny_p;
            end if;
        end if;
    end if;
end process;

process(state, rok_nxy_p, rd_res_p)
begin
    n_state <= state;

    case state is
        when "00" => -- IDLE (attendre demande)
            if rd_res_p = '1' then
                n_state <= "01"; -- WAIT pour les données
            end if;

        when "01" => -- WAIT (attendre rok_nxy)
            if rok_nxy_p = '1' then
                n_state <= "10"; -- SEND premier résultat
            end if;

        when "10" => -- SEND nx
            if rd_res_p = '1' then
                n_state <= "11"; -- SEND ny
            end if;

        when "11" => -- SEND ny
            if rd_res_p = '1' then
                n_state <= "00"; -- retour IDLE
            end if;

        when others =>
            n_state <= "00";
    end case;
end process;

-- Handshake : rd_nxy seulement en WAIT
rd_nxy_p  <= '1' when state = "01" else '0';
rok_res_p <= '1' when (state = "10" or state = "11") else '0';

-- Sortie
data_out <= nx_reg when state = "10" else ny_reg;

end vhd;
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
    signal nx_reg, ny_reg   : std_logic_vector(7 downto 0);
    signal n_nx_reg, n_ny_reg : std_logic_vector(7 downto 0);

begin

-- Registres
process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state  <= "00";  -- IDLE
            nx_reg <= (others => '0');
            ny_reg <= (others => '0');
        else
            state  <= n_state;
            nx_reg <= n_nx_reg;
            ny_reg <= n_ny_reg;
        end if;
    end if;
end process;

-- FSM combinatoire
process(state, rok_nxy_p, rd_res_p, nx_p, ny_p, nx_reg, ny_reg)
begin
    -- Valeurs par défaut
    n_state  <= state;
    n_nx_reg <= nx_reg;
    n_ny_reg <= ny_reg;

    case state is
        when "00" => -- IDLE
            if rd_res_p = '1' then
                n_state <= "01"; -- WAIT
            end if;

        when "01" => -- WAIT (demander les données au net)
            if rok_nxy_p = '1' then
                --  Capturer LES DEUX valeurs EN MÊME TEMPS
                n_nx_reg <= nx_p;
                n_ny_reg <= ny_p;
                n_state  <= "10"; -- SEND_NX
            end if;

        when "10" => -- SEND_NX
            if rd_res_p = '1' then
                n_state <= "11"; -- SEND_NY
            end if;

        when "11" => -- SEND_NY
            if rd_res_p = '1' then
                n_state <= "00"; -- retour IDLE
            end if;

        when others =>
            n_state <= "00";
    end case;
end process;

-- Signaux de handshake
rd_nxy_p  <= '1' when state = "01" else '0';
rok_res_p <= '1' when (state = "10" or state = "11") else '0';

-- Sortie depuis les registres
data_out <= nx_reg when state = "10" else
            ny_reg when state = "11" else
            (others => '0');

end vhd;
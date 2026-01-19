entity one_in_three_out is
port(
    ck      : in  std_logic;
    raz     : in  std_logic;

    wr_arg  : in  std_logic; 
    data_in : in  std_logic_vector(7 downto 0);
    wok_arg : out std_logic;

    a_p     : out std_logic_vector(7 downto 0);
    x_p     : out std_logic_vector(7 downto 0);
    y_p     : out std_logic_vector(7 downto 0)

    );
end one_in_three_out;

architecture vhd of one_in_three_out is
    signal state, n_state : std_logic;

    signal counter, n_counter : std_logic_vector(1 downto 0);

    signal a_reg, x_reg, y_reg : std_logic_vector(7 downto 0);

begin

process(ck)
begin
    if (ck = '1' and not ck'stable) then
        if raz = '0' then
            state <= '0';
            counter   <= "00";
            a_reg <= (others => '0');
            x_reg <= (others => '0');
            y_reg <= (others => '0');
        else
            state <= n_state;
            counter   <= n_counter;

            -- handshake unique
            if (state = '0' and wr_arg = '1)then
                case counter is
                    when "00" => 
                        a_reg <= data_in;
                    when "01" => 
                        x_reg <= data_in;
                    when "10" => 
                        y_reg <= data_in;
                    when others => null;
                end case;
            end if;
        end if;
    end if;
end process;

process(state, counter, wr_arg)
begin
    n_state <= state;
    n_counter   <= counter;

    case state is

        when '0' =>
            if wr_arg = '1' then
                if counter = "10" then
                    n_state <= '1';
                    n_counter   <= "00";
                else
                    n_counter <= counter + 1;
                end if;
            end if;

        when '1' =>
            if wok_arg = '1' then
                n_state <= '0';
            end if;

        when others => 
            n_state <= '0';
            n_counter   <= "00";

    end case;
end process;

-- Alliance : wok = prêt
wok_arg <= '1' when (state = '1') else '0';

a_p <= a_reg when state = '1' else (others => '0');
x_p <= x_reg when state = '1' else (others => '0');
y_p <= y_reg when state = '1' else (others => '0');

end vhd;

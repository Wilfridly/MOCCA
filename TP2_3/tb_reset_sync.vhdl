library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_reset_sync is
end tb_reset_sync;

architecture sim of tb_reset_sync is

    signal ck       : std_logic;
    signal RESET_RX : std_logic;  -- reset inactif au départ
    signal rst_sync : std_logic;

    constant CK_PERIOD : time := 10 ns;

begin

    -- Instance du DUT
    uut : entity work.reset_sync
        port map (
            ck       => ck,
            RESET_N => RESET_RX,
            rst_sync => rst_sync
        );

    clk_process : process
    begin
        ck <= '0';
        wait for CK_PERIOD / 2;
        ck <= '1';
        wait for CK_PERIOD / 2;
    end process;

    -- Stimuli
    stim_process : process
    begin
        -- Reset asynchrone actif
        RESET_RX <= '0';
        wait for 13 ns;

        -- Relâchement du reset
        RESET_RX <= '1';
        wait for 50 ns;

        -- Nouveau reset asynchrone
        RESET_RX <= '0';
        wait for 8 ns;

        RESET_RX <= '1';
        wait for 50 ns;

        WAIT;
    end process;

end sim;
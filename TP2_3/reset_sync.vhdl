library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reset_sync is
    port(
        ck       : in  std_logic;  -- horloge
        RESET_N : in  std_logic;  -- reset asynchrone actif bas
        rst_sync : out std_logic   -- reset synchronisé
    );
end reset_sync;

architecture vhd of reset_sync is
    signal rrf1, rrf2 : std_logic;
begin

    -- Process pour synchroniser le reset asynchrone
    process(ck, RESET_N)
    begin
        if RESET_N = '0' then       -- reset asynchrone actif bas
            rrf1 <= '0';
            rrf2 <= '0';
        elsif (CK = '1' and CK'EVENT) then
            rrf1 <= '1';
            rrf2 <= rrf1;
        end if;
    end process;

    rst_sync <= rrf2;

end vhd;


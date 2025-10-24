ENTITY pgcd_core IS
PORT(
    ck          : IN  std_logic;
    nreset      : IN  std_logic;
    
    rd_arg_p    : OUT std_logic;
    arg_p       : IN  std_logic_vector(7 DOWNTO 0);
    rok_arg_p   : IN  std_logic;

    wr_res_p    : OUT std_logic;
    res_p       : OUT std_logic_vector(7 DOWNTO 0);
    wok_res_p   : IN  std_logic
);
END pgcd_core;

ARCHITECTURE vhd OF pgcd_core IS

    SIGNAL
        n_read_opa, read_opa,       -- get first operande
        n_read_opb, read_opb,       -- get second operande
        n_compare,  compare,        -- is it ended
        n_decr_a,   decr_a,         -- if A > B
        n_decr_b,   decr_b,         -- if B > A
        n_write_res,write_res,      -- at the end
        opa_sup_opb,
        opb_sup_opa,
        opa_equal_opb
    : std_logic;

    SIGNAL
        n_opa,    opa,                  -- operande opa
        n_opb,    opb                   -- operande opb
    : std_logic_vector(7 downto 0);

BEGIN

-- FSM 

    -- A FAIRE
    -- Compléter les affectations concurentielles des états autre que read_opa
    -- vous devez utiliser les signaux opa_sup_opb, opb_sup_opa et opa_equal_opb
    -- qui sont défini plus bas 
    -- et le process utilisé pour l'affectation du registre d'état

    n_read_opa  <= (write_res   AND wok_res_p)
                OR (read_opa    AND not rok_arg_p)
                ;

    n_read_opb  <= ;
    n_compare   <= ;
    n_decr_a    <= ;
    n_decr_b    <= ;
    n_write_res <= ;

    FSM : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE))
    then
        if (nreset = '0') then
            read_opa    <= ;
            read_opb    <= ;
            compare     <= ;
            decr_a      <= ;
            decr_b      <= ;
            write_res   <= ;
        else
            read_opa    <= n_read_opa ;
            read_opb    <= ;
            compare     <= ;
            decr_a      <= ;
            decr_b      <= ;
            write_res   <= ;
        end if;
    end if;
    end process FSM;

    -- Sorties issues de l'automate
    
    -- A FAIRE
    -- Completer les valeur de sorties

    rd_arg_p      <= read_opa OR read_opb;
    wr_res_p      <= write_res;

-- Data path 

    opa_sup_opb   <= (opa > opb);
    opb_sup_opa   <= (opb > opa);
    opa_equal_opb <= (opa = opb);

    n_opa         <= arg_p      when read_opa
                else opa - opb  when decr_a
                else opa; 

    n_opb         <= arg_p      when read_opb
                else opb - opa  when decr_b
                else opb; 

    res_p         <= opa;

    DP : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE))
    then
        opa <= n_opa;
        opb <= n_opb;
    end if;
    end process DP;

END vhd;

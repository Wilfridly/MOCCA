ENTITY cordic_tb IS
PORT(
    ck          : IN  std_logic;
    nreset         : IN  std_logic;
    ko_p        : OUT std_logic
);
END cordic_tb;

ARCHITECTURE vhd OF cordic_tb IS

    signal wr_axy    : std_logic;
    signal data_in   : std_logic_vector(7 DOWNTO 0);
    signal wok_axy   : std_logic;
    signal rd_nxy    : std_logic;
    signal data_out  : std_logic_vector(7 DOWNTO 0);
    signal rok_nxy   : std_logic;
    

    COMPONENT cordic_data
    PORT(
        ck          : IN std_logic;
        nreset      : IN std_logic;

        -- juste pour les arguments
        wr_arg_p    : OUT std_logic; --producteur
        arg_p       : OUT std_logic_vector(7 DOWNTO 0);
        wok_arg_p   : IN std_logic; --consommateur

        -- juste pour les résultats
        rd_res_p    : OUT std_logic; --producteur
        res_p       : IN std_logic_vector(7 DOWNTO 0);
        rok_res_p   : IN std_logic; --consommateur

        ko_p        : OUT std_logic
    );
    END COMPONENT;


    COMPONENT cordic_cor
    PORT(
        ck          : IN  std_logic;
        raz         : IN  std_logic;

        wr_axy_p    : IN  std_logic;
        data_in_p         : IN  std_logic_vector(7 DOWNTO 0);
        wok_axy_p   : OUT std_logic;

        rd_nxy_p    : IN  std_logic;
        data_out_p        : OUT std_logic_vector(7 DOWNTO 0);
        rok_nxy_p   : OUT std_logic
    );
    END COMPONENT;


BEGIN

    data : cordic_data
    PORT MAP(
        ck          => ck      ,
        nreset      => nreset  ,

        wr_arg_p    => wr_axy, --out_data_oito
        arg_p       => data_in, --out_data_oito
        wok_arg_p   => wok_axy, --in_data_oito

        rd_res_p    =>  rd_nxy , --out_data_tioo TODO
        res_p       =>  data_out, --in_data_tioo
        rok_res_p   =>  rok_nxy, --in_data_tioo TODO
        
        ko_p        => ko_p      --out
    );


    core : cordic_cor
    PORT MAP(
        ck         => ck,
        raz        => nreset,

        wr_axy_p   => wr_axy,
        data_in_p  => data_in,
        wok_axy_p  => wok_axy,

        rd_nxy_p   => rd_nxy,
        data_out_p  => data_out,
        rok_nxy_p  => rok_nxy
    );

END vhd;

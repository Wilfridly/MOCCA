ENTITY cordic_tb IS
PORT(
    ck          : IN  std_logic;
    nreset         : IN  std_logic;
    ko_p        : OUT std_logic
);
END cordic_tb;

ARCHITECTURE vhd OF cordic_tb IS
    
    signal wr_arg    : std_logic;
    signal a_p       : std_logic_vector(7 downto 0);
    signal x_p       : std_logic_vector(7 downto 0);
    signal y_p       : std_logic_vector(7 downto 0);
    signal wok_arg   : std_logic;

    
    signal rd_res    : std_logic;
    signal nx        : std_logic_vector(7 downto 0);
    signal ny        : std_logic_vector(7 downto 0);
    signal rok_res   : std_logic;
    



    COMPONENT cordic_data
    PORT(
        ck          : IN std_logic;
        nreset      : IN std_logic;

        -- juste pour les arguments
        wr_arg_p    : OUT std_logic; --producteur
        a_p         : OUT  std_logic_vector(7 DOWNTO 0);
        x_p         : OUT  std_logic_vector(7 DOWNTO 0);
        y_p         : OUT  std_logic_vector(7 DOWNTO 0);

        wok_arg_p   : IN std_logic; --consommateur
        
        -- juste pour les résultats
        rok_res_p   : IN std_logic; --consommateur
        nx_p        : IN std_logic_vector(7 DOWNTO 0);
        ny_p        : IN std_logic_vector(7 DOWNTO 0);
        rd_res_p    : OUT std_logic; --producteur

        ko_p        : OUT std_logic
    );
    END COMPONENT;



    COMPONENT cordic_net
    PORT(
        ck          : IN  std_logic;
        raz         : IN  std_logic;

        a_p         : IN  std_logic_vector(7 DOWNTO 0);
        x_p         : IN  std_logic_vector(7 DOWNTO 0);
        y_p         : IN  std_logic_vector(7 DOWNTO 0);

        nx_p        : OUT std_logic_vector(7 DOWNTO 0);
        ny_p        : OUT std_logic_vector(7 DOWNTO 0);
        
        wr_axy_p    : IN  std_logic;
        wok_axy_p   : OUT std_logic;

        rok_nxy_p   : OUT std_logic;
        rd_nxy_p    : IN  std_logic
    );
    END COMPONENT;


BEGIN

    data : cordic_data
    PORT MAP(
        ck          => ck      ,
        nreset      => nreset  ,

        wr_arg_p    => wr_arg, --out_data_oito
        a_p         => a_p,
        x_p         => x_p,
        y_p         => y_p,--out_data_oito
        wok_arg_p   => wok_arg, --in_data_oito

        rd_res_p    =>  rd_res , --out_data_tioo TODO
        nx_p        =>  nx, --in_data_tioo
        ny_p        =>  ny, --in_data_tioo
        rok_res_p   =>  rok_res, --in_data_tioo TODO
        
        ko_p        => ko_p      --out
    );


    
    
    net : cordic_net
    PORT MAP(
        ck          => ck,
        raz         => nreset,
        
        wr_axy_p    => wr_arg, --out_net ok
        a_p         => a_p, --in_net_oito ok
        x_p         => x_p, --in_net_oito ok
        y_p         => y_p, --in_net_oito ok
        wok_axy_p   => wok_arg, --in_net ok
        
        rd_nxy_p    => rd_res, --in_net_tioo ok 
        nx_p        => nx, --out_net_tioo ok
        ny_p        => ny, --out_net_tioo ok
        rok_nxy_p   => rok_res --out_net_tioo ok 
        );

END vhd;

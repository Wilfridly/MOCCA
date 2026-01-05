ENTITY cordic_tb IS
PORT(
    ck          : IN  std_logic;
    nreset         : IN  std_logic;
    ko_p        : OUT std_logic
);
END cordic_tb;

ARCHITECTURE vhd OF cordic_tb IS

    signal res_in    : std_logic_vector(7 downto 0);
    signal data_in   : std_logic_vector(7 downto 0);
    
    signal wr_arg    : std_logic;
    signal wok_arg   : std_logic;

    signal wr_axy    : std_logic;
    signal wok_axy   : std_logic;
    
    signal rd_res    : std_logic;
    signal rok_res   : std_logic;
    
    signal rd_nxy    : std_logic;
    signal rok_nxy   : std_logic;

    signal a_p       : std_logic_vector(7 downto 0);
    signal x_p       : std_logic_vector(7 downto 0);
    signal y_p       : std_logic_vector(7 downto 0);
    signal nx        : std_logic_vector(7 downto 0);
    signal ny        : std_logic_vector(7 downto 0);

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
        rd_res_p    : OUT std_logic; --producteur
        nx_p        : IN std_logic_vector(7 DOWNTO 0);
        ny_p        : IN std_logic_vector(7 DOWNTO 0);
        rok_res_p   : IN std_logic; --consommateur

        ko_p        : OUT std_logic
    );
    END COMPONENT;

    -- COMPONENT one_in_three_out
    -- port(
    --     ck       : in  std_logic;
    --     raz      : in  std_logic;

    --     data_in  : in  std_logic_vector(7 downto 0);

    --     a_p      : out std_logic_vector(7 downto 0);
    --     x_p      : out std_logic_vector(7 downto 0);
    --     y_p      : out std_logic_vector(7 downto 0);

    --     -- data -> one_in_three_out
    --     wr_arg_p : in  std_logic;  -- DATA écrit un argument
    --     wok_arg_p: out std_logic;  -- prêt à recevoir

    --     -- one_in_three_out -> net
    --     wr_axy_p : out std_logic;  -- écrit A,X,Y
    --     wok_axy_p: in  std_logic   -- aval prêt
    -- );
    -- end COMPONENT;

    -- COMPONENT two_in_one_out
    -- port(
    --     ck      : in  std_logic;
    --     raz     : in  std_logic;

    --     nx_p    : in  std_logic_vector(7 downto 0);
    --     ny_p    : in  std_logic_vector(7 downto 0);

    --     -- interface  data -> tioo
    --     rd_res_p    : in  std_logic;
    --     rok_res_p   : out std_logic;

    --     -- interface net -> tioo
    --     rd_nxy_p  : out std_logic;
    --     rok_nxy_p : in  std_logic;

    --     data_out  : out std_logic_vector(7 downto 0)
    -- );
    -- end COMPONENT; 


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

        rd_nxy_p    : IN  std_logic;
        rok_nxy_p   : OUT std_logic
    );
    END COMPONENT;


BEGIN

    data : cordic_data
    PORT MAP(
        ck          => ck      ,
        nreset      => nreset  ,

        wr_arg_p    => wr_arg, --out_data_oito
        arg_p       => data_in, --out_data_oito
        wok_arg_p   => wok_arg, --in_data_oito

        rd_res_p    =>  rd_res , --out_data_tioo TODO
        res_p       =>  res_in, --in_data_tioo
        rok_res_p   =>  rok_res, --in_data_tioo TODO
        
        ko_p        => ko_p      --out
    );


    -- oito : one_in_three_out
    -- PORT MAP(
    --     ck     => ck,
    --     raz    => nreset,

    --     wr_arg_p => wr_arg , --data -> oito ok
    --     data_in => data_in, --data -> oito ok
    --     wok_arg_p => wok_arg,  --data -> oito ok
        
    --     a_p    => a_p, --oito -> net ok
    --     x_p    => x_p, --oito -> net ok 
    --     y_p    => y_p, --oito -> net ok
        
    --     wr_axy_p => wr_axy, --oito -> net ok
    --     wok_axy_p => wok_axy -- oito -> net ok
    -- );


    net : cordic_net
    PORT MAP(
        ck          => ck,
        raz         => nreset,

        wr_axy_p    => wr_axy, --out_net ok
        a_p         => a_p, --in_net_oito ok
        x_p         => x_p, --in_net_oito ok
        y_p         => y_p, --in_net_oito ok
        wok_axy_p   => wok_axy, --in_net ok
        
        rd_nxy_p    => rd_nxy, --in_net_tioo ok 
        nx_p        => nx, --out_net_tioo ok
        ny_p        => ny, --out_net_tioo ok
        rok_nxy_p   => rok_nxy --out_net_tioo ok 
    );

    -- tioo : two_in_one_out
    -- PORT MAP(
    --     ck     => ck,
    --     raz    => nreset,
        
    --     nx_p    => nx, --in_net ok 
    --     ny_p    => ny, --in_net ok
    --     data_out => res_in, --out_data_tioo ok

    --     rd_nxy_p => rd_nxy, --out_net_tioo ok 
    --     rok_nxy_p => rok_nxy, --in_net_tioo ok
        
    --     rd_res_p => rd_res, --out_data TODO
    --     rok_res_p => rok_res  --in_data TODO 
    -- );

END vhd;

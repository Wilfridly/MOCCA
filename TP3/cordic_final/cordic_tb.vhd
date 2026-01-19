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

    signal rd_res    : std_logic;
    signal rok_res   : std_logic;

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

    COMPONENT cordic_top
    PORT (
        ck : IN STD_LOGIC;
        raz : IN STD_LOGIC;

        wr_top : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wok_top : OUT STD_LOGIC;

        rd_top : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        rok_top : OUT STD_LOGIC
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

    top : cordic_top
    PORT MAP(
        ck => ck,
        raz => nreset,

        wr_top => wr_arg,
        data_in => data_in,
        wok_top => wok_arg,

        rd_top => rd_res,
        data_out => res_in,
        rok_top => rok_res
    );


END vhd;

ENTITY cordic_tb IS
PORT(
    ck          : IN  std_logic;
    raz         : IN  std_logic;
    ko_p        : OUT std_logic
);
END cordic_tb;

ARCHITECTURE vhd OF cordic_tb IS

    SIGNAL wr_arg  : std_logic;
    SIGNAL argd    : std_logic_vector(7 DOWNTO 0);
    SIGNAL wok_arg  : std_logic;
    
    SIGNAL rd_res  : std_logic;
    SIGNAL res     : std_logic_vector(7 DOWNTO 0);
    SIGNAL rok_res  : std_logic;

    signal a_p_tb  : std_logic_vector(7 downto 0);
    signal x_p_tb  : std_logic_vector(7 downto 0);
    signal y_p_tb  : std_logic_vector(7 downto 0);

    COMPONENT cordic_net
    PORT(
        ck          : IN  std_logic;
        raz         : IN  std_logic;

        wr_axy_p    : IN  std_logic;
        a_p         : IN  std_logic_vector(7 DOWNTO 0);
        x_p         : IN  std_logic_vector(7 DOWNTO 0);
        y_p         : IN  std_logic_vector(7 DOWNTO 0);
        wok_axy_p   : OUT std_logic;

        rd_nxy_p    : IN  std_logic;
        nx_p        : OUT std_logic_vector(7 DOWNTO 0);
        ny_p        : OUT std_logic_vector(7 DOWNTO 0);
        rok_nxy_p   : OUT std_logic
    );
    END COMPONENT;

    COMPONENT cordic_data IS
    PORT(
        ck          : IN std_logic;
        nreset      : IN std_logic;

        wr_arg_p    : OUT std_logic;
        arg_p       : OUT std_logic_vector(7 DOWNTO 0);
        wok_arg_p   : IN std_logic;

        rd_res_p    : OUT std_logic;
        res_p       : IN std_logic_vector(7 DOWNTO 0);
        rok_res_p   : IN std_logic;

        ko_p        : OUT std_logic
    );
    END COMPONENT;

BEGIN

    net : cordic_net
    PORT MAP(
        ck          => ck,
        raz         => raz,

        wr_axy_p    => wr_arg,
        a_p         => argd,
        x_p         => x_p_tb,
        y_p         => y_p_tb,
        wok_axy_p   => rd_arg,

        rd_nxy_p    => rd_res,
        nx_p        => res,
        ny_p        => open,
        rok_nxy_p   => wr_res
    );

    data : cordic_data
    PORT MAP(
        ck          => ck        ,
        nreset      => raz       ,

        wr_arg_p    => wr_arg    ,
        arg_p       => argd      ,
        wok_arg_p   => rd_arg    ,

        rd_res_p    => rd_res    ,
        res_p       => res       ,
        rok_res_p   => wr_res    ,

        ko_p        => ko_p
    );

END vhd;

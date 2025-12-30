ENTITY cordic_tb IS
PORT(
    ck          : IN  std_logic;
    nreset         : IN  std_logic;
    ko_p        : OUT std_logic
);
END cordic_tb;

ARCHITECTURE vhd OF cordic_tb IS

    signal wr_arg    : std_logic;
    signal data_in   : std_logic_vector(7 downto 0);
    signal wok_arg   : std_logic;

    signal rd_res    : std_logic;
    signal res_in    : std_logic_vector(7 downto 0);
    signal rok_res   : std_logic;

    signal x_p       : std_logic_vector(7 downto 0);
    signal y_p       : std_logic_vector(7 downto 0);
    signal a_p       : std_logic_vector(7 downto 0);
    signal nx        : std_logic_vector(7 downto 0);
    signal ny        : std_logic_vector(7 downto 0);

    COMPONENT cordic_data
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

    COMPONENT one_in_three_out
    port(
        ck     : in std_logic; 
        raz    : in std_logic;

        wok_axy_p : in std_logic;
        data_in : in std_logic_vector(7 downto 0);
        wr_axy_p : out std_logic;
        
        x_p : out std_logic_vector(7 downto 0);
        y_p : out std_logic_vector(7 downto 0); 
        a_p : out std_logic_vector(7 downto 0); 
        
        rok_nxy_p : in std_logic; 
        rd_nxy_p  : out std_logic
    );
    end COMPONENT; 

    COMPONENT two_in_one_out
    port(
        ck     : in std_logic; 
        raz    : in std_logic;

        nx_p    : in std_logic_vector(7 downto 0);
        ny_p    : in std_logic_vector(7 downto 0);
        
        rok_nxy_p        : in std_logic;  
        data_out         : out std_logic_vector(7 downto 0);
        rd_nxy_p         : out std_logic;
        
        wr_axy_p         : out std_logic;
        wok_axy_p        : in std_logic
    );
    end COMPONENT; 

    COMPONENT cordic_net
    PORT(
        ck          : IN  std_logic;
        raz         : IN  std_logic;

        wok_axy_p   : OUT std_logic;
        a_p         : IN  std_logic_vector(7 DOWNTO 0);
        x_p         : IN  std_logic_vector(7 DOWNTO 0);
        y_p         : IN  std_logic_vector(7 DOWNTO 0);
        wr_axy_p    : IN  std_logic;

        rok_nxy_p   : OUT std_logic;
        nx_p        : OUT std_logic_vector(7 DOWNTO 0);
        ny_p        : OUT std_logic_vector(7 DOWNTO 0);
        rd_nxy_p    : IN  std_logic
    );
    END COMPONENT;


BEGIN

    data : cordic_data
    PORT MAP(
        ck          => ck      ,
        nreset      => nreset  ,

        wr_arg_p    => wr_arg  , --out
        arg_p       => data_in , --out
        wok_arg_p   =>  ,

        rd_res_p    =>  rd_res , --out
        res_p       =>  ,
        rok_res_p   =>  ,
        
        ko_p        => ko_p      --out
    );

    oito : one_in_three_out
    PORT MAP(
        ck     => ck,
        raz    => nreset,

        wr_axy_p => wr_arg,
        data_in => data_in,
        wok_axy_p => , --out
        
        x_p    => x_p, --out
        y_p    => y_p, --out
        a_p    => a_p, --out
        
        rok_nxy_p => rd_res,
        rd_nxy_p => rok_res --out
    );
    
    net : cordic_net
    PORT MAP(
        ck          => ck,
        raz         => nreset,

        wr_axy_p    => wr_arg,
        a_p         => a_p,
        x_p         => x_p,
        y_p         => y_p,
        wok_axy_p   => wok_arg,

        rok_nxy_p   => rd_res,
        nx_p        => nx,
        ny_p        => ny,
        rd_nxy_p    => rok_res
    );

    tioo : two_in_one_out
    PORT MAP(
        ck     => ck,
        raz    => nreset,
        
        nx_p    => nx,
        ny_p    => ny,

        rok_nxy_p => rd_res,
        data_out => res_in,
        rd_nxy_p => rok_res,
        
        wr_axy_p => wr_arg,
        wok_axy_p => wok_arg
    );

END vhd;

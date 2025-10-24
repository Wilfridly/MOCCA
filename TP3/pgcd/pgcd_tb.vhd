ENTITY pgcd_tb IS
PORT(
    ck          : IN  std_logic;
    nreset      : IN  std_logic;
    ko_p        : OUT std_logic
);
END pgcd_tb;

ARCHITECTURE vhd OF pgcd_tb IS

    -- By convention, I choose the signal's name according to the port's name that produces it.
    -- Thus, any output port of a component (e.g. wr_arg_p) is connected to a signal with the same
    -- name, but without _p (port marker) (e.g. wr_arg_p => wr_arg)
    SIGNAL wr_arg  : std_logic;
    SIGNAL argd    : std_logic_vector(7 DOWNTO 0);
    SIGNAL rd_arg  : std_logic;
    SIGNAL rd_res  : std_logic;
    SIGNAL res     : std_logic_vector(7 DOWNTO 0);
    SIGNAL wr_res  : std_logic;

    COMPONENT pgcd_data
    PORT(
        ck          : IN  std_logic;
        nreset      : IN  std_logic;

        wr_arg_p    : OUT std_logic;
        arg_p       : OUT std_logic_vector(7 DOWNTO 0);
        wok_arg_p   : IN  std_logic;

        rd_res_p    : OUT std_logic;
        res_p       : IN  std_logic_vector(7 DOWNTO 0);
        rok_res_p   : IN   std_logic;

        ko_p        : OUT std_logic
    );
    END COMPONENT;

    COMPONENT pgcd_core
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
    END COMPONENT;

BEGIN

    data : pgcd_data
    PORT MAP (
        ck          => ck        ,
        nreset      => nreset       ,

        wr_arg_p    => wr_arg    ,
        arg_p       => argd      ,
        wok_arg_p   => rd_arg    ,

        rd_res_p    => rd_res    ,
        res_p       => res       ,
        rok_res_p   => wr_res    ,

        ko_p        => ko_p
    );

    core : pgcd_core
    PORT MAP (
        ck          => ck        ,
        nreset      => nreset       ,

        rd_arg_p    => rd_arg    ,
        arg_p       => argd      ,
        rok_arg_p   => wr_arg    ,

        wr_res_p    => wr_res    ,
        res_p       => res       ,
        wok_res_p   => rd_res
    );
END vhd;

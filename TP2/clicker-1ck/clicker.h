#define POWER_PORT ck,vdde,vddi,vsse,vssi : in bit
#define POWER ck=>ck_p,vdde=>vdde,vddi=>vddi,vsse=>vsse,vssi=>vssi

#ifdef PLOT

east  (p_ck p_raz p_led_0)
west  (p_led_1 p_led_2 p_led_3)
north (p_led_4 p_led_5 p_led_6 p_plus) 
south (p_vdde p_vddi p_vssi p_vsse)

#else

ENTITY clicker_chip IS
PORT (
    ck          : IN  bit;
    raz         : IN  bit;
    plus        : IN  bit;
    led         : OUT bit_vector (0 to 6);
    vddi, vssi  : IN  bit;
    vdde, vsse  : IN  bit
);
END clicker_chip;

ARCHITECTURE chip OF clicker_chip IS

component pi_sp    port ( pad : in bit; t : out bit; POWER_PORT ); end component;
component po_sp    port ( i : in bit; pad : out bit; POWER_PORT ); end component;
component pvdde_sp port ( POWER_PORT ); end component;
component pvsse_sp port ( POWER_PORT ); end component; 
component pvddi_sp port ( POWER_PORT ); end component;
component pvssi_sp port ( POWER_PORT ); end component;

component CORE port(
    ck          : IN  bit;
    raz         : IN  bit;
    plus        : IN  bit;
    led         : OUT bit_vector (0 to 6);
    vdd,  vss   : IN  bit 
);
END component;

signal ck_i, raz_i, ck_p, plus_i : bit;
signal led_i : bit_vector(0 to 6);

begin

p_ck    : pi_sp     port map ( pad=>ck,     t=>ck_i,     POWER );
p_raz   : pi_sp     port map ( pad=>raz,    t=>raz_i,    POWER );
p_plus  : pi_sp     port map ( pad=>plus,   t=>plus_i,   POWER );

p_led_0 : pi_sp     port map ( pad=>led(0), t=>led_i(0), POWER );
p_led_1 : pi_sp     port map ( pad=>led(1), t=>led_i(1), POWER );
p_led_2 : pi_sp     port map ( pad=>led(2), t=>led_i(2), POWER );
p_led_3 : pi_sp     port map ( pad=>led(3), t=>led_i(3), POWER );
p_led_4 : pi_sp     port map ( pad=>led(4), t=>led_i(4), POWER );
p_led_5 : pi_sp     port map ( pad=>led(5), t=>led_i(5), POWER );
p_led_6 : pi_sp     port map ( pad=>led(6), t=>led_i(6), POWER );

p_vdde  : pvdde_sp  port map ( POWER );
p_vsse  : pvsse_sp  port map ( POWER );
p_vddi  : pvddi_sp  port map ( POWER );
p_vssi  : pvssi_sp  port map ( POWER );

clicker : CORE port map (
    ck      => ck_i,
    raz     => raz_i,
    plus    => plus_i,
    led     => led_i(0 to 6),
    vdd     => vddi,
    vss     => vssi
);

END chip;

#endif

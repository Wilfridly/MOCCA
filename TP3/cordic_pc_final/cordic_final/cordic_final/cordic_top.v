module cordic_top (clk, reset, wr_top, data_in, wok_top, rd_top, data_out, rok_top);

  input  	clk;
  input  	reset;
  input  	wr_top;
  input  [7:0]	data_in;
  output 	wok_top;
  input  	rd_top;
  output [7:0]	data_out;
  output 	rok_top;

  wire	[15:0]  rtlexts_1;
  wire	[9:0]  rtlexts_0;
  reg 	  rtldef_40;
  reg 	  rtldef_39;
  reg 	  rtldef_38;
  reg 	  rtldef_37;
  reg 	  rtldef_36;
  reg 	  rtldef_35;
  reg 	  rtldef_34;
  reg 	  rtldef_33;
  reg 	  rtldef_32;
  reg 	  rtldef_31;
  reg 	  rtldef_30;
  reg 	  rtldef_29;
  reg 	  rtldef_28;
  reg 	  rtldef_27;
  reg 	  rtldef_26;
  reg 	  rtldef_25;
  reg 	  rtldef_24;
  reg 	  rtldef_23;
  reg 	  rtldef_22;
  reg 	  rtldef_21;
  reg 	  rtldef_20;
  reg 	  rtldef_19;
  reg 	  rtldef_18;
  reg 	  rtldef_17;
  reg 	  rtldef_16;
  reg 	  rtldef_15;
  reg 	  rtldef_14;
  reg 	  rtldef_13;
  reg 	  rtldef_12;
  reg 	  rtldef_11;
  reg 	  rtldef_10;
  reg 	  rtldef_9;
  reg 	  rtldef_8;
  reg 	  rtldef_7;
  reg 	  rtldef_6;
  reg 	  rtldef_5;
  reg 	  rtldef_4;
  reg 	  rtldef_3;
  reg 	  rtldef_2;
  reg 	  rtldef_1;
  reg 	  rtldef_0;
  wire	  wr_arg_p;
  reg 	  wok_arg_p;
  reg 	  wr_axy_p;
  wire	  wok_axy_p;
  wire	[7:0]  a_p;
  wire	[7:0]  x_p;
  wire	[7:0]  y_p;
  reg 	  rd_nxy_p;
  wire	  rok_nxy_p;
  wire	[7:0]  nx_p;
  wire	[7:0]  ny_p;
  wire	  rd_res_p;
  reg 	  rok_res_p;
  reg 	  stateoito;
  wire	  n_stateoito;
  reg 	[1:0]  counter;
  wire	[1:0]  n_counter;
  reg 	[7:0]  a_reg;
  reg 	[7:0]  x_reg;
  reg 	[7:0]  y_reg;
  reg 	[1:0]  state;
  wire	[1:0]  n_state;
  reg 	[7:0]  nx_reg;
  reg 	[7:0]  ny_reg;
  wire	[7:0]  n_nx_reg;
  wire	[7:0]  n_ny_reg;
  wire	  n_get;
  reg 	  get;
  wire	  n_norm;
  reg 	  norm;
  wire	  n_calc;
  reg 	  calc;
  wire	  n_mkc;
  reg 	  mkc;
  wire	  n_place;
  reg 	  place;
  wire	  n_put;
  reg 	  put;
  wire	  a_lt_0;
  wire	  quadrant_0;
  reg 	[1:0]  n_quadrant;
  reg 	[1:0]  quadrant;
  reg 	[2:0]  n_i;
  reg 	[2:0]  i;
  reg 	[15:0]  n_x;
  reg 	[15:0]  x;
  reg 	[15:0]  n_y;
  reg 	[15:0]  y;
  reg 	[15:0]  n_a;
  reg 	[15:0]  a;
  reg 	[15:0]  n_xkc;
  reg 	[15:0]  xkc;
  reg 	[15:0]  n_ykc;
  reg 	[15:0]  ykc;
  reg 	[15:0]  atan;
  wire	[15:0]  a_mpidiv2;
  wire	[15:0]  x_sra_1;
  wire	[15:0]  y_sra_1;
  wire	[15:0]  x_sra_2;
  wire	[15:0]  y_sra_2;
  wire	[15:0]  x_sra_3;
  wire	[15:0]  y_sra_3;
  wire	[15:0]  x_sra_4;
  wire	[15:0]  y_sra_4;
  wire	[15:0]  x_sra_5;
  wire	[15:0]  y_sra_5;
  wire	[15:0]  x_sra_6;
  wire	[15:0]  y_sra_6;
  wire	[15:0]  x_sra_7;
  wire	[15:0]  y_sra_7;
  reg 	[15:0]  x_sra_i;
  reg 	[15:0]  y_sra_i;
  wire	  p187_13_reddef_102;
  wire	  p187_13_reddef_101;
  wire	  p187_13_reddef_100;
  wire	  p187_13_reddef_99;
  wire	  p187_13_reddef_98;
  wire	  p135_6_reddef_88;
  wire	  p135_6_reddef_87;
  wire	  p110_5_def_64;
  wire	  p135_6_def_62;
  wire	  p135_6_def_61;
  wire	  p172_12_def_57;
  wire	  p187_13_def_55;
  wire	  p187_13_def_54;
  wire	  p187_13_def_53;
  wire	  fsm_def_47;
  assign	rtlexts_1 = {6'b000000 , rtlexts_0};
  assign	rtlexts_0 = {a_p , 2'b00};
  assign	ny_p = y[14:7];
  assign	nx_p = x[14:7];

  always @ ( posedge clk )
    begin
      ykc = n_ykc;
    end

  always @ ( posedge clk )
    begin
      xkc = n_xkc;
    end

  always @ ( posedge clk )
    begin
      y = n_y;
    end

  always @ ( posedge clk )
    begin
      x = n_x;
    end

  always @ ( xkc or ykc or quadrant or place or x_sra_i or y or a_lt_0 or calc or y_p or get )
    if (get == 1'b1) n_y = {{y_p[7] , y_p} , 7'b0000000};
    else if ((calc & ~(a_lt_0)) == 1'b1) n_y = (y + x_sra_i);
    else if ((calc & a_lt_0) == 1'b1) n_y = (y - x_sra_i);
    else if ((place & (quadrant == 2'b00)) == 1'b1) n_y = ykc;
    else if ((place & (quadrant == 2'b01)) == 1'b1) n_y = xkc;
    else if ((place & (quadrant == 2'b10)) == 1'b1) n_y = (-ykc);
    else if ((place & (quadrant == 2'b11)) == 1'b1) n_y = (-xkc);
    else n_y = y;

  always @ ( ykc or xkc or quadrant or place or y_sra_i or x or a_lt_0 or calc or x_p or get )
    if (get == 1'b1) n_x = {{x_p[7] , x_p} , 7'b0000000};
    else if ((calc & ~(a_lt_0)) == 1'b1) n_x = (x - y_sra_i);
    else if ((calc & a_lt_0) == 1'b1) n_x = (x + y_sra_i);
    else if ((place & (quadrant == 2'b00)) == 1'b1) n_x = xkc;
    else if ((place & (quadrant == 2'b01)) == 1'b1) n_x = (-ykc);
    else if ((place & (quadrant == 2'b10)) == 1'b1) n_x = (-xkc);
    else if ((place & (quadrant == 2'b11)) == 1'b1) n_x = ykc;
    else n_x = x;

  always @ ( y_sra_1 or y_sra_4 or ykc or y_sra_5 or y_sra_6 or i or mkc )
    if ((mkc & (i == 3'b000)) == 1'b1) n_ykc = (y_sra_6 + y_sra_5);
    else if ((mkc & (i == 3'b001)) == 1'b1) n_ykc = (ykc + y_sra_4);
    else if ((mkc & (i == 3'b010)) == 1'b1) n_ykc = (ykc + y_sra_1);
    else n_ykc = ykc;

  always @ ( x_sra_1 or x_sra_4 or xkc or x_sra_5 or x_sra_6 or i or mkc )
    if ((mkc & (i == 3'b000)) == 1'b1) n_xkc = (x_sra_6 + x_sra_5);
    else if ((mkc & (i == 3'b001)) == 1'b1) n_xkc = (xkc + x_sra_4);
    else if ((mkc & (i == 3'b010)) == 1'b1) n_xkc = (xkc + x_sra_1);
    else n_xkc = xkc;

  always @ ( y or y_sra_7 or y_sra_6 or y_sra_5 or y_sra_4 or y_sra_3 or y_sra_2 or y_sra_1 or i )
    if (i == 3'b001) y_sra_i = y_sra_1;
    else if (i == 3'b010) y_sra_i = y_sra_2;
    else if (i == 3'b011) y_sra_i = y_sra_3;
    else if (i == 3'b100) y_sra_i = y_sra_4;
    else if (i == 3'b101) y_sra_i = y_sra_5;
    else if (i == 3'b110) y_sra_i = y_sra_6;
    else if (i == 3'b111) y_sra_i = y_sra_7;
    else y_sra_i = y;
  assign	y_sra_7 = {y[15] , y_sra_6[15:1]};
  assign	y_sra_6 = {y[15] , y_sra_5[15:1]};
  assign	y_sra_5 = {y[15] , y_sra_4[15:1]};
  assign	y_sra_4 = {y[15] , y_sra_3[15:1]};
  assign	y_sra_3 = {y[15] , y_sra_2[15:1]};
  assign	y_sra_2 = {y[15] , y_sra_1[15:1]};
  assign	y_sra_1 = {y[15] , y[15:1]};

  always @ ( x or x_sra_7 or x_sra_6 or x_sra_5 or x_sra_4 or x_sra_3 or x_sra_2 or x_sra_1 or i )
    if (i == 3'b001) x_sra_i = x_sra_1;
    else if (i == 3'b010) x_sra_i = x_sra_2;
    else if (i == 3'b011) x_sra_i = x_sra_3;
    else if (i == 3'b100) x_sra_i = x_sra_4;
    else if (i == 3'b101) x_sra_i = x_sra_5;
    else if (i == 3'b110) x_sra_i = x_sra_6;
    else if (i == 3'b111) x_sra_i = x_sra_7;
    else x_sra_i = x;
  assign	x_sra_7 = {x[15] , x_sra_6[15:1]};
  assign	x_sra_6 = {x[15] , x_sra_5[15:1]};
  assign	x_sra_5 = {x[15] , x_sra_4[15:1]};
  assign	x_sra_4 = {x[15] , x_sra_3[15:1]};
  assign	x_sra_3 = {x[15] , x_sra_2[15:1]};
  assign	x_sra_2 = {x[15] , x_sra_1[15:1]};
  assign	x_sra_1 = {x[15] , x[15:1]};

  always @ ( posedge clk )
    begin
      a = n_a;
    end

  always @ ( posedge clk )
    begin
      quadrant = n_quadrant;
    end

  always @ ( posedge clk )
    begin
      i = n_i;
    end

  always @ ( i or mkc or calc or get )
    if (get == 1'b1) n_i = 3'b000;
    else if ((calc | mkc) == 1'b1) n_i = (i + 3'b001);
    else n_i = i;

  always @ ( atan or a or a_lt_0 or calc or a_mpidiv2 or quadrant_0 or norm or rtlexts_1 or get )
    if (get == 1'b1) n_a = rtlexts_1;
    else if ((norm & ~(quadrant_0)) == 1'b1) n_a = a_mpidiv2;
    else if ((calc & ~(a_lt_0)) == 1'b1) n_a = (a - atan);
    else if ((calc & a_lt_0) == 1'b1) n_a = (a + atan);
    else n_a = a;
  assign	a_lt_0 = a[15];
  assign	quadrant_0 = a_mpidiv2[15];
  assign	a_mpidiv2 = (a - 16'b0000000011001001);

  always @ ( i )
    if (i == 3'b000) atan = 16'b0000000001100101;
    else if (i == 3'b001) atan = 16'b0000000000111011;
    else if (i == 3'b010) atan = 16'b0000000000011111;
    else if (i == 3'b011) atan = 16'b0000000000010000;
    else if (i == 3'b100) atan = 16'b0000000000001000;
    else if (i == 3'b101) atan = 16'b0000000000000100;
    else if (i == 3'b110) atan = 16'b0000000000000010;
    else atan = 16'b0000000000000001;

  always @ ( quadrant or quadrant_0 or norm or get )
    if (get == 1'b1) n_quadrant = 2'b00;
    else if ((norm & ~(quadrant_0)) == 1'b1) n_quadrant = (quadrant + 2'b01);
    else n_quadrant = quadrant;
  assign	rok_nxy_p = put;
  assign	wok_axy_p = get;

  always @ ( posedge clk )
    begin
      put = (rtldef_40 & n_put);
    end

  always @ ( posedge clk )
    begin
      place = (rtldef_39 & n_place);
    end

  always @ ( posedge clk )
    begin
      mkc = (rtldef_38 & n_mkc);
    end

  always @ ( posedge clk )
    begin
      calc = (rtldef_37 & n_calc);
    end

  always @ ( posedge clk )
    begin
      norm = (rtldef_36 & n_norm);
    end

  always @ ( posedge clk )
    begin
      get = ((rtldef_35 & n_get) | fsm_def_47);
    end

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_40 = 1'b1;
    else rtldef_40 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_39 = 1'b1;
    else rtldef_39 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_38 = 1'b1;
    else rtldef_38 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_37 = 1'b1;
    else rtldef_37 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_36 = 1'b1;
    else rtldef_36 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_35 = 1'b1;
    else rtldef_35 = 1'b0;
  assign	fsm_def_47 = (reset == 1'b0);
  assign	n_put = (place | (put & ~(rd_nxy_p)));
  assign	n_place = (mkc & (i == 3'b010));
  assign	n_mkc = ((calc & (i == 3'b111)) | (mkc & ~((i == 3'b010))));
  assign	n_calc = ((norm & quadrant_0) | (calc & ~((i == 3'b111))));
  assign	n_norm = ((get & wr_axy_p) | (norm & ~(quadrant_0)));
  assign	n_get = ((get & ~(wr_axy_p)) | (put & rd_nxy_p));

  always @ ( ny_reg or nx_reg or state )
    if (state == 2'b10) data_out = nx_reg;
    else if (state == 2'b11) data_out = ny_reg;
    else data_out = 8'b00000000;

  always @ ( state )
    if (((state == 2'b10) | (state == 2'b11)) == 1'b1) rok_res_p = 1'b1;
    else rok_res_p = 1'b0;

  always @ ( state )
    if (state == 2'b01) rd_nxy_p = 1'b1;
    else rd_nxy_p = 1'b0;

  always @ ( p187_13_reddef_102 or p187_13_reddef_101 or p187_13_reddef_99 or p187_13_reddef_98 )
    if ((p187_13_reddef_98 | p187_13_reddef_99 | p187_13_reddef_101 | p187_13_reddef_102
) == 1'b1) rtldef_34 = 1'b1;
    else rtldef_34 = 1'b0;

  always @ ( p187_13_reddef_100 )
    if (p187_13_reddef_100 == 1'b1) rtldef_33 = 1'b1;
    else rtldef_33 = 1'b0;
  assign	n_ny_reg = (({rtldef_33 , rtldef_33 , rtldef_33 , rtldef_33 , rtldef_33 , rtldef_33 , rtldef_33
 , rtldef_33} & (({rtldef_21 , rtldef_21 , rtldef_21 , rtldef_21 , rtldef_21 , rtldef_21
 , rtldef_21 , rtldef_21} & ny_p) | ({rtldef_22 , rtldef_22 , rtldef_22 , rtldef_22
 , rtldef_22 , rtldef_22 , rtldef_22 , rtldef_22} & ny_reg))) | ({rtldef_34 , rtldef_34
 , rtldef_34 , rtldef_34 , rtldef_34 , rtldef_34 , rtldef_34 , rtldef_34} & ny_reg));

  always @ ( p187_13_reddef_102 or p187_13_reddef_101 or p187_13_reddef_99 or p187_13_reddef_98 )
    if ((p187_13_reddef_98 | p187_13_reddef_99 | p187_13_reddef_101 | p187_13_reddef_102
) == 1'b1) rtldef_32 = 1'b1;
    else rtldef_32 = 1'b0;

  always @ ( p187_13_reddef_100 )
    if (p187_13_reddef_100 == 1'b1) rtldef_31 = 1'b1;
    else rtldef_31 = 1'b0;
  assign	n_nx_reg = (({rtldef_31 , rtldef_31 , rtldef_31 , rtldef_31 , rtldef_31 , rtldef_31 , rtldef_31
 , rtldef_31} & (({rtldef_19 , rtldef_19 , rtldef_19 , rtldef_19 , rtldef_19 , rtldef_19
 , rtldef_19 , rtldef_19} & nx_p) | ({rtldef_20 , rtldef_20 , rtldef_20 , rtldef_20
 , rtldef_20 , rtldef_20 , rtldef_20 , rtldef_20} & nx_reg))) | ({rtldef_32 , rtldef_32
 , rtldef_32 , rtldef_32 , rtldef_32 , rtldef_32 , rtldef_32 , rtldef_32} & nx_reg));

  always @ ( p187_13_reddef_102 )
    if (p187_13_reddef_102 == 1'b1) rtldef_30 = 1'b1;
    else rtldef_30 = 1'b0;

  always @ ( p187_13_reddef_101 )
    if (p187_13_reddef_101 == 1'b1) rtldef_29 = 1'b1;
    else rtldef_29 = 1'b0;

  always @ ( p187_13_reddef_100 )
    if (p187_13_reddef_100 == 1'b1) rtldef_28 = 1'b1;
    else rtldef_28 = 1'b0;

  always @ ( p187_13_reddef_99 )
    if (p187_13_reddef_99 == 1'b1) rtldef_27 = 1'b1;
    else rtldef_27 = 1'b0;
  assign	n_state = (({rtldef_27 , rtldef_27} & (({rtldef_25 , rtldef_25} & 2'b01) | ({rtldef_26 , rtldef_26
} & state))) | ({rtldef_28 , rtldef_28} & (({rtldef_23 , rtldef_23} & 2'b10) | (
{rtldef_24 , rtldef_24} & state))) | ({rtldef_29 , rtldef_29} & ({rtldef_17 , rtldef_17
} | ({rtldef_18 , rtldef_18} & state))) | ({rtldef_30 , rtldef_30} & ({rtldef_16
 , rtldef_16} & state)));
  assign	p187_13_reddef_98 = ((((~(state[0] & state[1]) & ~(~(state[0]) & state[1])) & ~(state[0] & ~(state[1]
))) & ~(~(state[0]) & ~(state[1]))) == 1'b1);

  always @ ( p187_13_def_55 )
    if (p187_13_def_55 == 1'b0) rtldef_26 = 1'b1;
    else rtldef_26 = 1'b0;

  always @ ( p187_13_def_55 )
    if (p187_13_def_55 == 1'b1) rtldef_25 = 1'b1;
    else rtldef_25 = 1'b0;
  assign	p187_13_def_55 = (rd_res_p == 1'b1);
  assign	p187_13_reddef_99 = ((~(state[0]) & ~(state[1])) == 1'b1);

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b0) rtldef_24 = 1'b1;
    else rtldef_24 = 1'b0;

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b1) rtldef_23 = 1'b1;
    else rtldef_23 = 1'b0;

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b0) rtldef_22 = 1'b1;
    else rtldef_22 = 1'b0;

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b1) rtldef_21 = 1'b1;
    else rtldef_21 = 1'b0;

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b0) rtldef_20 = 1'b1;
    else rtldef_20 = 1'b0;

  always @ ( p187_13_def_54 )
    if (p187_13_def_54 == 1'b1) rtldef_19 = 1'b1;
    else rtldef_19 = 1'b0;
  assign	p187_13_def_54 = (rok_nxy_p == 1'b1);
  assign	p187_13_reddef_100 = ((state[0] & ~(state[1])) == 1'b1);

  always @ ( p187_13_def_53 )
    if (p187_13_def_53 == 1'b0) rtldef_18 = 1'b1;
    else rtldef_18 = 1'b0;

  always @ ( p187_13_def_53 )
    if (p187_13_def_53 == 1'b1) rtldef_17 = 1'b1;
    else rtldef_17 = 1'b0;
  assign	p187_13_def_53 = (rd_res_p == 1'b1);
  assign	p187_13_reddef_101 = ((~(state[0]) & state[1]) == 1'b1);

  always @ ( rd_res_p )
    if ((rd_res_p == 1'b1) == 1'b0) rtldef_16 = 1'b1;
    else rtldef_16 = 1'b0;
  assign	p187_13_reddef_102 = ((state[0] & state[1]) == 1'b1);

  always @ ( posedge clk )
    begin
      ny_reg = ({rtldef_15 , rtldef_15 , rtldef_15 , rtldef_15 , rtldef_15 , rtldef_15 , rtldef_15
 , rtldef_15} & n_ny_reg);
    end

  always @ ( posedge clk )
    begin
      nx_reg = ({rtldef_14 , rtldef_14 , rtldef_14 , rtldef_14 , rtldef_14 , rtldef_14 , rtldef_14
 , rtldef_14} & n_nx_reg);
    end

  always @ ( posedge clk )
    begin
      state = ({rtldef_13 , rtldef_13} & n_state);
    end

  always @ ( p172_12_def_57 )
    if (p172_12_def_57 == 1'b0) rtldef_15 = 1'b1;
    else rtldef_15 = 1'b0;

  always @ ( p172_12_def_57 )
    if (p172_12_def_57 == 1'b0) rtldef_14 = 1'b1;
    else rtldef_14 = 1'b0;

  always @ ( p172_12_def_57 )
    if (p172_12_def_57 == 1'b0) rtldef_13 = 1'b1;
    else rtldef_13 = 1'b0;
  assign	p172_12_def_57 = (reset == 1'b0);
  assign	y_p = y_reg;
  assign	x_p = x_reg;
  assign	a_p = a_reg;

  always @ ( stateoito )
    if (stateoito == 1'b1) wr_axy_p = 1'b1;
    else wr_axy_p = 1'b0;

  always @ ( stateoito )
    if (stateoito == 1'b0) wok_arg_p = 1'b1;
    else wok_arg_p = 1'b0;

  always @ ( p135_6_reddef_88 )
    if (p135_6_reddef_88 == 1'b1) rtldef_12 = 1'b1;
    else rtldef_12 = 1'b0;

  always @ ( p135_6_reddef_87 )
    if (p135_6_reddef_87 == 1'b1) rtldef_11 = 1'b1;
    else rtldef_11 = 1'b0;
  assign	n_counter = (({rtldef_11 , rtldef_11} & (({rtldef_5 , rtldef_5} & ({rtldef_3 , rtldef_3} & 
(counter + 2'b01))) | ({rtldef_6 , rtldef_6} & counter))) | ({rtldef_12 , rtldef_12
} & counter));

  always @ ( p135_6_reddef_88 )
    if (p135_6_reddef_88 == 1'b1) rtldef_10 = 1'b1;
    else rtldef_10 = 1'b0;

  always @ ( p135_6_reddef_87 )
    if (p135_6_reddef_87 == 1'b1) rtldef_9 = 1'b1;
    else rtldef_9 = 1'b0;
  assign	n_stateoito = ((rtldef_9 & ((rtldef_7 & (p135_6_def_62 | (rtldef_4 & stateoito))) | (rtldef_8
 & stateoito))) | (rtldef_10 & (rtldef_2 & stateoito)));

  always @ ( p135_6_def_61 )
    if (p135_6_def_61 == 1'b0) rtldef_8 = 1'b1;
    else rtldef_8 = 1'b0;

  always @ ( p135_6_def_61 )
    if (p135_6_def_61 == 1'b1) rtldef_7 = 1'b1;
    else rtldef_7 = 1'b0;

  always @ ( p135_6_def_61 )
    if (p135_6_def_61 == 1'b0) rtldef_6 = 1'b1;
    else rtldef_6 = 1'b0;

  always @ ( p135_6_def_61 )
    if (p135_6_def_61 == 1'b1) rtldef_5 = 1'b1;
    else rtldef_5 = 1'b0;

  always @ ( p135_6_def_62 )
    if (p135_6_def_62 == 1'b0) rtldef_4 = 1'b1;
    else rtldef_4 = 1'b0;

  always @ ( p135_6_def_62 )
    if (p135_6_def_62 == 1'b0) rtldef_3 = 1'b1;
    else rtldef_3 = 1'b0;
  assign	p135_6_def_62 = (counter == 2'b10);
  assign	p135_6_def_61 = (wr_arg_p == 1'b1);
  assign	p135_6_reddef_87 = (stateoito == 1'b0);

  always @ ( wok_axy_p )
    if ((wok_axy_p == 1'b1) == 1'b0) rtldef_2 = 1'b1;
    else rtldef_2 = 1'b0;
  assign	p135_6_reddef_88 = (stateoito == 1'b1);

  always @ ( posedge clk )
    begin
      if (reset == 1'b0) y_reg = 8'b00000000;
      else if ((~(stateoito) & reset & counter[1] & wr_arg_p) == 1'b1) y_reg = {(~(counter[0]) & data_in[7]) , (~(counter[0]) & data_in[6]) , (~(counter[0]) &
 data_in[5]) , (~(counter[0]) & data_in[4]) , (~(counter[0]) & data_in[3]) , (~(counter[0]
) & data_in[2]) , (~(counter[0]) & data_in[1]) , (~(counter[0]) & data_in[0])};
    end

  always @ ( posedge clk )
    begin
      if (reset == 1'b0) x_reg = 8'b00000000;
      else if ((~(stateoito) & reset & counter[0] & wr_arg_p) == 1'b1) x_reg = {(~(counter[1]) & data_in[7]) , (~(counter[1]) & data_in[6]) , (~(counter[1]) &
 data_in[5]) , (~(counter[1]) & data_in[4]) , (~(counter[1]) & data_in[3]) , (~(counter[1]
) & data_in[2]) , (~(counter[1]) & data_in[1]) , (~(counter[1]) & data_in[0])};
    end

  always @ ( posedge clk )
    begin
      if ((~(reset) | (~(stateoito) & (~(reset) | (counter[0] & counter[1] & wr_arg_p)))) == 1'b1) a_reg = 8'b00000000;
      else if ((~(stateoito) & reset & ~(counter[0]) & ~(counter[1]) & wr_arg_p) == 1'b1) a_reg = data_in;
    end

  always @ ( posedge clk )
    begin
      counter = ({rtldef_1 , rtldef_1} & n_counter);
    end

  always @ ( posedge clk )
    begin
      stateoito = (rtldef_0 & n_stateoito);
    end

  always @ ( p110_5_def_64 )
    if (p110_5_def_64 == 1'b0) rtldef_1 = 1'b1;
    else rtldef_1 = 1'b0;

  always @ ( p110_5_def_64 )
    if (p110_5_def_64 == 1'b0) rtldef_0 = 1'b1;
    else rtldef_0 = 1'b0;
  assign	p110_5_def_64 = (reset == 1'b0);
  assign	rok_top = rok_res_p;
  assign	rd_res_p = rd_top;
  assign	wok_top = wok_arg_p;
  assign	wr_arg_p = wr_top;

endmodule

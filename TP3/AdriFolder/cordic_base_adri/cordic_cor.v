module cordic_cor (ck, raz, wr_axy_p, a_p, x_p, y_p, wok_axy_p, rd_nxy_p, nx_p, ny_p, rok_nxy_p, vdd, vss);

  input  	ck;
  input  	raz;
  input  	wr_axy_p;
  input  [7:0]	a_p;
  input  [7:0]	x_p;
  input  [7:0]	y_p;
  output 	wok_axy_p;
  input  	rd_nxy_p;
  output [7:0]	nx_p;
  output [7:0]	ny_p;
  output 	rok_nxy_p;
  input  	vdd;
  input  	vss;

  wire	[15:0]  rtlexts_1;
  wire	[9:0]  rtlexts_0;
  reg 	  rtldef_5;
  reg 	  rtldef_4;
  reg 	  rtldef_3;
  reg 	  rtldef_2;
  reg 	  rtldef_1;
  reg 	  rtldef_0;
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
  wire	  fsm_def_47;
  assign	rtlexts_1 = {6'b000000 , rtlexts_0};
  assign	rtlexts_0 = {a_p , 2'b00};
  assign	ny_p = y[14:7];
  assign	nx_p = x[14:7];

  always @ ( posedge ck )
    begin
      ykc = n_ykc;
    end

  always @ ( posedge ck )
    begin
      xkc = n_xkc;
    end

  always @ ( posedge ck )
    begin
      y = n_y;
    end

  always @ ( posedge ck )
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

  always @ ( posedge ck )
    begin
      a = n_a;
    end

  always @ ( posedge ck )
    begin
      quadrant = n_quadrant;
    end

  always @ ( posedge ck )
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

  always @ ( posedge ck )
    begin
      put = (rtldef_5 & n_put);
    end

  always @ ( posedge ck )
    begin
      place = (rtldef_4 & n_place);
    end

  always @ ( posedge ck )
    begin
      mkc = (rtldef_3 & n_mkc);
    end

  always @ ( posedge ck )
    begin
      calc = (rtldef_2 & n_calc);
    end

  always @ ( posedge ck )
    begin
      norm = (rtldef_1 & n_norm);
    end

  always @ ( posedge ck )
    begin
      get = ((rtldef_0 & n_get) | fsm_def_47);
    end

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_5 = 1'b1;
    else rtldef_5 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_4 = 1'b1;
    else rtldef_4 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_3 = 1'b1;
    else rtldef_3 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_2 = 1'b1;
    else rtldef_2 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_1 = 1'b1;
    else rtldef_1 = 1'b0;

  always @ ( fsm_def_47 )
    if (fsm_def_47 == 1'b0) rtldef_0 = 1'b1;
    else rtldef_0 = 1'b0;
  assign	fsm_def_47 = (raz == 1'b0);
  assign	n_put = (place | (put & ~(rd_nxy_p)));
  assign	n_place = (mkc & (i == 3'b010));
  assign	n_mkc = ((calc & (i == 3'b111)) | (mkc & ~((i == 3'b010))));
  assign	n_calc = ((norm & quadrant_0) | (calc & ~((i == 3'b111))));
  assign	n_norm = ((get & wr_axy_p) | (norm & ~(quadrant_0)));
  assign	n_get = ((get & ~(wr_axy_p)) | (put & rd_nxy_p));

endmodule

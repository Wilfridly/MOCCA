ENTITY cordic_data IS
PORT(
    ck : IN std_logic;
    nreset : IN std_logic;

    wr_arg_p : OUT std_logic;
    arg_p : OUT std_logic_vector(8 -1 DOWNTO 0);
    wok_arg_p : IN std_logic;

    rd_res_p : OUT std_logic;
    res_p : IN std_logic_vector(8 -1 DOWNTO 0);
    rok_res_p : IN std_logic;

    ko_p : OUT std_logic
);
END cordic_data;

ARCHITECTURE vhd OF pgcd_data IS

    SIGNAL -- FSM states
        x_p, -- set x
        y_p, -- set y
        a_p, -- set angle
        nx_p -- get result
        ny_p -- get result
        stop, -- it's over
        lastpt -- 1 when pt = address of the last filled box in ROM
    : std_logic;

    SIGNAL
        pt -- rom_pointer
    : std_logic_vector(8 -1 downto 0);

    SIGNAL
        value -- rom_value
    : std_logic_vector(8 -1 downto 0);

BEGIN

    REG : PROCESS (ck) begin
    if ((ck = '1') AND NOT(ck'STABLE)) then
        if (nreset = '0') then
            x_p <= '1';
            y_p <= '0';
            a_p <= '0';
            nx_p <= '0';
            ny_p <= '0';
            stop <= '0';
            pt <= (others=>'0');
        else
            x_p <= (res AND rok_res_p AND not lastpt) OR (x_p AND not wok_arg_p);

            y_p <= (x_p AND wok_arg_p) OR (y_p AND not wok_arg_p);

            a_p <= (y_p AND wok_arg_p) OR (res AND not rok_res_p);

            nx_p <= (a_p AND wok_arg_p) OR (nx_p AND not rok_res_p);

            ny_p <= (nx_p AND wok_arg_p) OR (ny_p AND not rok_res_p);;

            stop <= (ny_p AND rok_res_p AND lastpt) OR stop;

            if ((x_p AND wok_arg_p) OR (y_p AND wok_arg_p) OR (a_p AND wok_arg_p) OR ((nx_p OR ny_p) AND rok_res_p)) then
                pt <= pt + 1;
            end if;
        end if;
    end if;
    end process REG;

    lastpt <= (pt = );
    wr_arg_p <= x_p OR y_p OR a_p;
    rd_res_p <= nx_p OR ny_p;
    arg_p <= value;
    ko_p <= (nx_p OR ny_p) AND rok_res_p AND (value /= res_p);

-- #include <rom.txt> incudes a file with a generated ROM, defined as below
-- value <= x"12" when pt = 0
-- else x"60" when pt = 1
-- else x"06" when pt = 2
-- else x"00";
value <= x"82" when pt = 0
    else x"ffffff91" when pt = 1
    else x"ffffffb4" when pt = 2
    else x"03" when pt = 3
    else x"79" when pt = 4
    else x"0a" when pt = 5
    else x"7a" when pt = 6
    else x"ffffffaa" when pt = 7
    else x"7e" when pt = 8
    else x"ffffffb0" when pt = 9
    else x"6f" when pt = 10
    else x"0d" when pt = 11
    else x"ffffffbe" when pt = 12
    else x"3a" when pt = 13
    else x"ffffffdd" when pt = 14
    else x"a4" when pt = 15
    else x"ffffffc5" when pt = 16
    else x"ffffffde" when pt = 17
    else x"0f" when pt = 18
    else x"ffffffbd" when pt = 19
    else x"b3" when pt = 20
    else x"28" when pt = 21
    else x"ffffff98" when pt = 22
    else x"6e" when pt = 23
    else x"13" when pt = 24
    else x"d1" when pt = 25
    else x"ffffff89" when pt = 26
    else x"ffffffad" when pt = 27
    else x"5a" when pt = 28
    else x"ffffff8d" when pt = 29
    else x"77" when pt = 30
    else x"7f" when pt = 31
    else x"ffffffca" when pt = 32
    else x"79" when pt = 33
    else x"42" when pt = 34
    else x"13" when pt = 35
    else x"54" when pt = 36
    else x"10" when pt = 37
    else x"51" when pt = 38
    else x"19" when pt = 39
    else x"6f" when pt = 40
    else x"ffffff8b" when pt = 41
    else x"1b" when pt = 42
    else x"ffffff9d" when pt = 43
    else x"ffffffba" when pt = 44
    else x"6e" when pt = 45
    else x"32" when pt = 46
    else x"ffffffee" when pt = 47
    else x"2e" when pt = 48
    else x"19" when pt = 49
    else x"04" when pt = 50
    else x"ffffffab" when pt = 51
    else x"ffffff81" when pt = 52
    else x"ffffffad" when pt = 53
    else x"7e" when pt = 54
    else x"af" when pt = 55
    else x"ffffffac" when pt = 56
    else x"fffffff2" when pt = 57
    else x"fffffffa" when pt = 58
    else x"ffffffaa" when pt = 59
    else x"5a" when pt = 60
    else x"1d" when pt = 61
    else x"fffffff6" when pt = 62
    else x"1c" when pt = 63
    else x"0a" when pt = 64
    else x"19" when pt = 65
    else x"ffffffb8" when pt = 66
    else x"ffffffbc" when pt = 67
    else x"ffffffc4" when pt = 68
    else x"ffffffb0" when pt = 69
    else x"ee" when pt = 70
    else x"6c" when pt = 71
    else x"ffffffdb" when pt = 72
    else x"07" when pt = 73
    else x"72" when pt = 74
    else x"80" when pt = 75
    else x"37" when pt = 76
    else x"65" when pt = 77
    else x"ffffffc8" when pt = 78
    else x"65" when pt = 79
    else x"26" when pt = 80
    else x"ffffffad" when pt = 81
    else x"ffffffdc" when pt = 82
    else x"ffffffb9" when pt = 83
    else x"ffffffc6" when pt = 84
    else x"ef" when pt = 85
    else x"ffffffb8" when pt = 86
    else x"31" when pt = 87
    else x"ffffffe5" when pt = 88
    else x"ffffffad" when pt = 89
    else x"01" when pt = 90
    else x"28" when pt = 91
    else x"ffffffb3" when pt = 92
    else x"27" when pt = 93
    else x"ffffffb2" when pt = 94
    else x"13" when pt = 95
    else x"ffffff95" when pt = 96
    else x"ffffffdc" when pt = 97
    else x"ffffff99" when pt = 98
    else x"ffffffcf" when pt = 99
    else x"02" when pt = 100
    else x"ffffff98" when pt = 101
    else x"ffffff89" when pt = 102
    else x"ffffff96" when pt = 103
    else x"ffffff89" when pt = 104
    else x"82" when pt = 105
    else x"41" when pt = 106
    else x"2e" when pt = 107
    else x"fffffffc" when pt = 108
    else x"4f" when pt = 109
    else x"6d" when pt = 110
    else x"ffffff9a" when pt = 111
    else x"42" when pt = 112
    else x"ffffff8a" when pt = 113
    else x"ffffffdf" when pt = 114
    else x"64" when pt = 115
    else x"ffffffab" when pt = 116
    else x"fffffff2" when pt = 117
    else x"ffffffcd" when pt = 118
    else x"ffffffba" when pt = 119
    else x"19" when pt = 120
    else x"ffffff9a" when pt = 121
    else x"5f" when pt = 122
    else x"ffffff8a" when pt = 123
    else x"4b" when pt = 124
    else x"f4" when pt = 125
    else x"13" when pt = 126
    else x"ffffff8d" when pt = 127
    else x"67" when pt = 128
    else x"38" when pt = 129
    else x"52" when pt = 130
    else x"39" when pt = 131
    else x"34" when pt = 132
    else x"10" when pt = 133
    else x"4b" when pt = 134
    else x"27" when pt = 135
    else x"29" when pt = 136
    else x"ffffffeb" when pt = 137
    else x"2d" when pt = 138
    else x"fffffff6" when pt = 139
    else x"57" when pt = 140
    else x"21" when pt = 141
    else x"0c" when pt = 142
    else x"12" when pt = 143
    else x"1d" when pt = 144
    else x"0c" when pt = 145
    else x"33" when pt = 146
    else x"ffffffa0" when pt = 147
    else x"3b" when pt = 148
    else x"ffffffa4" when pt = 149
    else x"e7" when pt = 150
    else x"35" when pt = 151
    else x"31" when pt = 152
    else x"ffffffc5" when pt = 153
    else x"29" when pt = 154
    else x"69" when pt = 155
    else x"ffffffae" when pt = 156
    else x"71" when pt = 157
    else x"75" when pt = 158
    else x"12" when pt = 159
    else x"8f" when pt = 160
    else x"1d" when pt = 161
    else x"05" when pt = 162
    else x"09" when pt = 163
    else x"1c" when pt = 164
    else x"d0" when pt = 165
    else x"78" when pt = 166
    else x"ffffffa7" when pt = 167
    else x"53" when pt = 168
    else x"7d" when pt = 169
    else x"c3" when pt = 170
    else x"ffffff91" when pt = 171
    else x"3a" when pt = 172
    else x"ffffffbe" when pt = 173
    else x"ffffff94" when pt = 174
    else x"1c" when pt = 175
    else x"7e" when pt = 176
    else x"4d" when pt = 177
    else x"6b" when pt = 178
    else x"65" when pt = 179
    else x"a0" when pt = 180
    else x"ffffffc7" when pt = 181
    else x"ffffff85" when pt = 182
    else x"63" when pt = 183
    else x"ffffffa3" when pt = 184
    else x"cb" when pt = 185
    else x"ffffffee" when pt = 186
    else x"ffffffa5" when pt = 187
    else x"5b" when pt = 188
    else x"ffffffed" when pt = 189
    else x"af" when pt = 190
    else x"3e" when pt = 191
    else x"ffffffc6" when pt = 192
    else x"46" when pt = 193
    else x"2f" when pt = 194
    else x"ba" when pt = 195
    else x"41" when pt = 196
    else x"fffffff8" when pt = 197
    else x"10" when pt = 198
    else x"3f" when pt = 199
    else x"53" when pt = 200
    else x"22" when pt = 201
    else x"26" when pt = 202
    else x"05" when pt = 203
    else x"32" when pt = 204
    else x"84" when pt = 205
    else x"ffffff8a" when pt = 206
    else x"ffffffd4" when pt = 207
    else x"ffffffe8" when pt = 208
    else x"ffffff83" when pt = 209
    else x"ec" when pt = 210
    else x"12" when pt = 211
    else x"ffffffe8" when pt = 212
    else x"13" when pt = 213
    else x"17" when pt = 214
    else x"e8" when pt = 215
    else x"ffffffda" when pt = 216
    else x"59" when pt = 217
    else x"ffffffb3" when pt = 218
    else x"ffffffc5" when pt = 219
    else x"90" when pt = 220
    else x"ffffff96" when pt = 221
    else x"ffffffe1" when pt = 222
    else x"ffffffed" when pt = 223
    else x"ffffff92" when pt = 224
    else x"ca" when pt = 225
    else x"ffffffa9" when pt = 226
    else x"60" when pt = 227
    else x"ffffff9f" when pt = 228
    else x"ffffffa9" when pt = 229
    else x"10" when pt = 230
    else x"4b" when pt = 231
    else x"21" when pt = 232
    else x"46" when pt = 233
    else x"29" when pt = 234
    else x"94" when pt = 235
    else x"0f" when pt = 236
    else x"10" when pt = 237
    else x"fffffff7" when pt = 238
    else x"14" when pt = 239
    else x"32" when pt = 240
    else x"ffffffbe" when pt = 241
    else x"4d" when pt = 242
    else x"ffffffa6" when pt = 243
    else x"2f" when pt = 244
    else x"f7" when pt = 245
    else x"79" when pt = 246
    else x"ffffff8e" when pt = 247
    else x"fffffffd" when pt = 248
    else x"65" when pt = 249
    else x"e9" when pt = 250
    else x"ffffffcc" when pt = 251
    else x"ffffffa7" when pt = 252
    else x"64" when pt = 253
    else x"ffffffe2" when pt = 254
    else x"00";

END vhd;

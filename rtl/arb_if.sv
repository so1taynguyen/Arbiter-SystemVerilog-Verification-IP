interface arb_if(input bit clock);
    bit req1, req2, req3, req4;
    bit gnt1, gnt2, gnt3, gnt4;
    bit rst;
    bit mon_flag, drv_flag;
    bit flag_req1, flag_req2, flag_req3, flag_req4;

    assign drv_flag = ~mon_flag;

    always @(posedge clock) begin
        if (req1) begin
                flag_req1 = '1;
                @(negedge gnt1) flag_req1 = '0;
            end
            else if (req2) begin
                flag_req2 = '1;
                @(negedge gnt2) flag_req2 = '0;
            end
            else if (req3) begin
                flag_req3 = '1;
                @(negedge gnt3) flag_req3 = '0;
            end
            else if (req4) begin
                flag_req4 = '1;
                @(negedge gnt4) flag_req4 = '0;
            end
    end

    clocking drv_cb @(posedge clock);
        default input #1 output #0;
        input gnt1, gnt2, gnt3, gnt4;
        output req1, req2, req3, req4;
    endclocking: drv_cb

    clocking mon_cb @(posedge clock);
        default input #1 output #0;
        input gnt1, gnt2, gnt3, gnt4;
        input req1, req2, req3, req4;
    endclocking: mon_cb

    modport DRV_MP(clocking drv_cb, output rst, mon_flag);
    modport MON_MP(clocking mon_cb, input mon_flag, drv_flag);

    sequence time_out_seq(req, gnt);
        $rose(req) ##1 $fell(req) ##[3:7] gnt;
    endsequence: time_out_seq

    sequence gnt_active_seq(gnt);
        gnt ##[1:2] ~gnt;
    endsequence: gnt_active_seq

    property time_out_property(req_main, req_check_1, req_check_2, req_check_3, gnt);
        disable iff(req_check_1 | req_check_2 | req_check_3 | flag_req1 | flag_req2 | 
                    flag_req3 | flag_req4)
        if (req_main)
            time_out_seq(req_main, gnt);
    endproperty: time_out_property

    property gnt_active_property(gnt);
        if (gnt)
            gnt_active_seq(gnt);
    endproperty: gnt_active_property

    property single_gnt_property;
        {gnt1, gnt2, gnt3, gnt4} inside {4'd0, 4'd1, 4'd2, 4'd4, 4'd8};
    endproperty: single_gnt_property

    property int_req_property_1;
        disable iff (~req1 & (flag_req2 | flag_req3 | flag_req4))
        $fell(req1) |=> strong(({req1, req2, req3, req4} == 0)[*] ##0 $fell(gnt1));
    endproperty: int_req_property_1

    property int_req_property_2;
        disable iff (~req2 & (flag_req1 | flag_req3 | flag_req4))
        $fell(req2) |=> strong(({req1, req2, req3, req4} == 0)[*] ##0 $fell(gnt2));
    endproperty: int_req_property_2

    property int_req_property_3;
        disable iff (~req3 & (flag_req1 | flag_req2 | flag_req4))
        $fell(req3) |=> strong(({req1, req2, req3, req4} == 0)[*] ##0 $fell(gnt3));
    endproperty: int_req_property_3

    property int_req_property_4;
        disable iff (~req4 & (flag_req1 | flag_req3 | flag_req2))
        $fell(req4) |=> strong(({req1, req2, req3, req4} == 0)[*] ##0 $fell(gnt4));
    endproperty: int_req_property_4

    t_out_1: assert property (@(posedge clock) time_out_property(req1, '0, '0, '0, gnt1))
        else $error("Time-out in generating gnt1 signal!");

    t_out_2: assert property (@(posedge clock) time_out_property(req2, req1, '0, '0, gnt2)) 
        else $error("Time-out in generating gnt2 signal!");

    t_out_3: assert property (@(posedge clock) time_out_property(req3, req1, req2, '0, gnt3)) 
        else $error("Time-out in generating gnt3 signal!");

    t_out_4: assert property (@(posedge clock) time_out_property(req4, req1, req2, req3, gnt4)) 
        else $error("Time-out in generating gnt4 signal!");

    gnt_active_1: assert property (@(posedge clock) gnt_active_property(gnt1))
        else $error("gnt1 lasts too long!");

    gnt_active_2: assert property (@(posedge clock) gnt_active_property(gnt2))
        else $error("gnt2 lasts too long!");

    gnt_active_3: assert property (@(posedge clock) gnt_active_property(gnt3))
        else $error("gnt3 lasts too long!");

    gnt_active_4: assert property (@(posedge clock) gnt_active_property(gnt4))
        else $error("gnt4 lasts too long!");

    single_gnt: assert property (@(posedge clock) single_gnt_property)
        else $error("More than one gnt signal were generated!");
    
    int_req_1: assert property (@(posedge clock) int_req_property_1)
        else $error("@%0t - Others req appear while generating gnt1!", $time);

    int_req_2: assert property (@(posedge clock) int_req_property_2)
        else $error("@%0t - Others req appear while generating gnt2!", $time);

    int_req_3: assert property (@(posedge clock) int_req_property_3)
        else $error("@%0t - Others req appear while generating gnt3!", $time);

    int_req_4: assert property (@(posedge clock) int_req_property_4)
        else $error("@%0t - Others req appear while generating gnt4!", $time);

    // Cover property for scenerio "Each grant was generated 3 to 7 clock cycles after request"
    property delay_clock(req, gnt, n);
        $fell(req) |-> ##n $rose(gnt);
    endproperty: delay_clock

    GNT1_3_CLK: cover property (@(posedge clock) delay_clock(req1, gnt1, 3));
    GNT2_3_CLK: cover property (@(posedge clock) delay_clock(req2, gnt2, 3));
    GNT3_3_CLK: cover property (@(posedge clock) delay_clock(req3, gnt3, 3));
    GNT4_3_CLK: cover property (@(posedge clock) delay_clock(req4, gnt4, 3));

    GNT1_4_CLK: cover property (@(posedge clock) delay_clock(req1, gnt1, 4));
    GNT2_4_CLK: cover property (@(posedge clock) delay_clock(req2, gnt2, 4));
    GNT3_4_CLK: cover property (@(posedge clock) delay_clock(req3, gnt3, 4));
    GNT4_4_CLK: cover property (@(posedge clock) delay_clock(req4, gnt4, 4));

    GNT1_5_CLK: cover property (@(posedge clock) delay_clock(req1, gnt1, 5));
    GNT2_5_CLK: cover property (@(posedge clock) delay_clock(req2, gnt2, 5));
    GNT3_5_CLK: cover property (@(posedge clock) delay_clock(req3, gnt3, 5));
    GNT4_5_CLK: cover property (@(posedge clock) delay_clock(req4, gnt4, 5));

    GNT1_6_CLK: cover property (@(posedge clock) delay_clock(req1, gnt1, 6));
    GNT2_6_CLK: cover property (@(posedge clock) delay_clock(req2, gnt2, 6));
    GNT3_6_CLK: cover property (@(posedge clock) delay_clock(req3, gnt3, 6));
    GNT4_6_CLK: cover property (@(posedge clock) delay_clock(req4, gnt4, 6));

    GNT1_7_CLK: cover property (@(posedge clock) delay_clock(req1, gnt1, 7));
    GNT2_7_CLK: cover property (@(posedge clock) delay_clock(req2, gnt2, 7));
    GNT3_7_CLK: cover property (@(posedge clock) delay_clock(req3, gnt3, 7));
    GNT4_7_CLK: cover property (@(posedge clock) delay_clock(req4, gnt4, 7));
endinterface: arb_if


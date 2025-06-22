class arb_cov_model;
    virtual arb_if.MON_MP cov_if;

    bit [3:0] req;

    covergroup cov_grp @(cov_if.mon_cb);
        REQ_COMB: coverpoint req iff (cov_if.mon_flag) {
            ignore_bins except_0 = {'0};
        }
        
        GNT1_ACT: coverpoint cov_if.mon_cb.gnt1 {
            bins one_clock = (1'b0 => 1'b1[*1] => 1'b0);
            bins two_clock = (1'b0 => 1'b1[*2] => 1'b0);
        }

        GNT2_ACT: coverpoint cov_if.mon_cb.gnt2 {
            bins one_clock = (1'b0 => 1'b1[*1] => 1'b0);
            bins two_clock = (1'b0 => 1'b1[*2] => 1'b0);
        }

        GNT3_ACT: coverpoint cov_if.mon_cb.gnt3 {
            bins one_clock = (1'b0 => 1'b1[*1] => 1'b0);
            bins two_clock = (1'b0 => 1'b1[*2] => 1'b0);
        }

        GNT4_ACT: coverpoint cov_if.mon_cb.gnt4 {
            bins one_clock = (1'b0 => 1'b1[*1] => 1'b0);
            bins two_clock = (1'b0 => 1'b1[*2] => 1'b0);
        }

        ERR_REQ: coverpoint {cov_if.mon_cb.req1, cov_if.mon_cb.req2, cov_if.mon_cb.req3, 
                            cov_if.mon_cb.req4} iff (cov_if.drv_flag) {
            bins req_0 = {'0};
            illegal_bins except_req = default;
        }
    endgroup: cov_grp

    function new(virtual arb_if.MON_MP cov_if);
        this.cov_if = cov_if;
        cov_grp = new();
    endfunction: new

    task start;
        wait (cov_if.mon_flag);
        @(cov_if.mon_cb);
        req = {cov_if.mon_cb.req1, cov_if.mon_cb.req2, cov_if.mon_cb.req3, 
                cov_if.mon_cb.req4};
    endtask: start
endclass: arb_cov_model
`include "../test/arb_pkg.sv"
import arb_pkg::*;

class arb_test;
    virtual arb_if.DRV_MP drv_if;
    virtual arb_if.MON_MP mon_if;
    virtual arb_if.MON_MP cov_if;

    arb_env env;

    function new(virtual arb_if.DRV_MP drv_if, virtual arb_if.MON_MP mon_if,
                virtual arb_if.MON_MP cov_if);
        this.drv_if = drv_if;
        this.mon_if = mon_if;
        this.cov_if = cov_if;
        this.env = new(drv_if, mon_if, cov_if);
    endfunction: new

    task build_n_run;
        env.build();
        env.run();
        #20 $finish;
    endtask: build_n_run
endclass: arb_test
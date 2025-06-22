class arb_env;
    virtual arb_if.DRV_MP drv_if;
    virtual arb_if.MON_MP mon_if;
    virtual arb_if.MON_MP cov_if;

    mailbox #(arb_trans) gen2drv = new();
    mailbox #(arb_trans) mon2sb = new();

    arb_gen gen;
    arb_drv drv;
    arb_mon mon;
    arb_sb sb;
    arb_cov_model cov_mdl;

    function new(virtual arb_if.DRV_MP drv_if, virtual arb_if.MON_MP mon_if, 
                virtual arb_if.MON_MP cov_if);
        this.drv_if = drv_if;
        this.mon_if = mon_if;
        this.cov_if = cov_if;
    endfunction: new

    task build;
        gen = new(gen2drv);
        drv = new(gen2drv, drv_if);
        mon = new(mon2sb, mon_if);
        sb = new(mon2sb);
        cov_mdl = new(cov_if);
    endtask: build

    task start;
        repeat (no_of_trans) begin
        fork
            gen.start();
            drv.start();
            mon.start();
            sb.start();
            cov_mdl.start();
        join
    end
    endtask: start

    task reset_dut;
        drv_if.rst <= '1;
        repeat (2) begin
            @(drv_if.drv_cb);
        end
        drv_if.rst <= '0;
    endtask: reset_dut

    task stop;
        wait (sb.DONE.triggered);
    endtask: stop

    task run;
        reset_dut();
        start();
        stop();
        sb.report();
    endtask: run
endclass: arb_env
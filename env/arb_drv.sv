class arb_drv;
    virtual arb_if.DRV_MP drv_if;

    mailbox #(arb_trans) gen2drv = new();

    arb_trans data2dut;

    function new(mailbox #(arb_trans) gen2drv, virtual arb_if.DRV_MP drv_if);
        this.gen2drv = gen2drv;
        this.drv_if = drv_if;
        this.data2dut = new();
    endfunction: new

    task drive;
        if (drv_if.drv_cb.gnt1) begin
            @(negedge drv_if.drv_cb.gnt1);
        end
        if (drv_if.drv_cb.gnt2) begin
            @(negedge drv_if.drv_cb.gnt2);
        end
        if (drv_if.drv_cb.gnt3) begin
            @(negedge drv_if.drv_cb.gnt3);
        end
        if (drv_if.drv_cb.gnt4) begin
            @(negedge drv_if.drv_cb.gnt4);
        end

        drv_if.rst <= '0;
        drv_if.drv_cb.req1 <= data2dut.req1;
        drv_if.drv_cb.req2 <= data2dut.req2;
        drv_if.drv_cb.req3 <= data2dut.req3;
        drv_if.drv_cb.req4 <= data2dut.req4;
        drv_if.mon_flag <= '1;
        
        @(drv_if.drv_cb);
        drv_if.drv_cb.req1 <= '0;
        drv_if.drv_cb.req2 <= '0;
        drv_if.drv_cb.req3 <= '0;
        drv_if.drv_cb.req4 <= '0;
        drv_if.mon_flag <= '0;
        
        wait (drv_if.drv_cb.gnt1 || drv_if.drv_cb.gnt2 || drv_if.drv_cb.gnt3 || 
                drv_if.drv_cb.gnt4);
    endtask: drive

    task start;
        gen2drv.get(data2dut);
        drive();
    endtask: start
endclass: arb_drv
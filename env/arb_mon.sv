class arb_mon;
    virtual arb_if.MON_MP mon_if;

    mailbox #(arb_trans) mon2sb = new();

    arb_trans dut2mon;

    function new(mailbox #(arb_trans) mon2sb, virtual arb_if.MON_MP mon_if);
        this.mon2sb = mon2sb;
        this.mon_if = mon_if;
        this.dut2mon = new();
    endfunction: new

    task monitor;
        @(posedge mon_if.mon_flag);
        @(mon_if.mon_cb);
            dut2mon.req1 = mon_if.mon_cb.req1;
            dut2mon.req2 = mon_if.mon_cb.req2;
            dut2mon.req3 = mon_if.mon_cb.req3;
            dut2mon.req4 = mon_if.mon_cb.req4;
            dut2mon.display("----- DATA FROM GENERATOR -----");

        wait (mon_if.mon_cb.gnt1 || mon_if.mon_cb.gnt2 || mon_if.mon_cb.gnt3 || 
                mon_if.mon_cb.gnt4);
        $display("----- DATA RESPONSED -----");
        $display("@%0t - Grant 1: %0b", $time, mon_if.mon_cb.gnt1);
        $display("@%0t - Grant 2: %0b", $time, mon_if.mon_cb.gnt2);  
        $display("@%0t - Grant 3: %0b", $time, mon_if.mon_cb.gnt3);  
        $display("@%0t - Grant 4: %0b", $time, mon_if.mon_cb.gnt4);  
        dut2mon.gnt1 = mon_if.mon_cb.gnt1;
        dut2mon.gnt2 = mon_if.mon_cb.gnt2;
        dut2mon.gnt3 = mon_if.mon_cb.gnt3;
        dut2mon.gnt4 = mon_if.mon_cb.gnt4;
    endtask: monitor

    task start;
        monitor();
        mon2sb.put(dut2mon);
    endtask: start
endclass: arb_mon
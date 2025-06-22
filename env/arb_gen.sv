class arb_gen;
    arb_trans gen_trans;

    mailbox #(arb_trans) gen2drv = new();

    function new(mailbox #(arb_trans) gen2drv);
        this.gen2drv = gen2drv;
        this.gen_trans = new();
    endfunction: new

    task start;
        gen_trans.trans_id++;
        assert (gen_trans.randomize());
        gen2drv.put(gen_trans);
    endtask: start
endclass: arb_gen
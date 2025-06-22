class arb_sb;
    mailbox #(arb_trans) mon2sb = new();

    event DONE;

    int data_verified = 0;
    int data_rcved = 0;
    int data_dismatched = 0;

    arb_trans rcved_data;

    function new(mailbox #(arb_trans) mon2sb);
        this.mon2sb = mon2sb;
        this.rcved_data = new();
    endfunction: new

    task start;
        mon2sb.get(rcved_data);
        data_rcved++;
        compare(rcved_data);
        if (data_rcved == no_of_trans) begin
           -> DONE; 
        end
    endtask: start

    function void compare(input arb_trans rcved_data);
        if (rcved_data.req1 && rcved_data.gnt1) begin
            data_verified++;
        end
        else if (rcved_data.req2 && rcved_data.gnt2) begin
            data_verified++;
        end
        else if (rcved_data.req3 && rcved_data.gnt3) begin
            data_verified++;
        end
        else if (rcved_data.req4 && rcved_data.gnt4) begin
            data_verified++;
        end
        else begin
            data_dismatched++;
        end
    endfunction: compare

    function void report;
        $display("===== SCOREBOARD REPORT =====");
        $display("No. of received transaction: %0d", data_rcved);
        $display("No. of verified transaction: %0d", data_verified);
        $display("No. of dismatched transaction: %0d", data_dismatched);
    endfunction
endclass: arb_sb
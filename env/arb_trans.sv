class arb_trans;
    rand bit req1, req2, req3, req4;
    bit gnt1, gnt2, gnt3, gnt4;

    bit [3:0] queue[$];

    static int trans_id;

    constraint C1 {
        !({req1, req2, req3, req4} inside {queue});
        {req1, req2, req3, req4} != 4'd0;
    }
    
    function void post_randomize;
        queue.push_front({req1, req2, req3, req4});
        if (queue.size() == 15) begin
            queue.delete();
        end
    endfunction: post_randomize

    function void display(input string mess);
        $display("%s", mess);
        $display("Transaction ID: %0d", trans_id);

        $display("@%0t - Request 1: %0b", $time, req1);
        $display("@%0t - Request 2: %0b", $time, req2);  
        $display("@%0t - Request 3: %0b", $time, req3);  
        $display("@%0t - Request 4: %0b", $time, req4);
    endfunction: display
endclass: arb_trans
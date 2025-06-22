`include "./../rtl/arb_if.sv"
`include "./../test/arb_test.sv"
`include "./../rtl/arb_dut.sv"

module top;

    bit clock;

    arb_if DUV_IF(clock);

    arb_test test_h;

    arb_dut DUT(.clock(clock), .rst(DUV_IF.rst),
                .req1(DUV_IF.req1), .req2(DUV_IF.req2), .req3(DUV_IF.req3), .req4(DUV_IF.req4),
                .gnt1(DUV_IF.gnt1), .gnt2(DUV_IF.gnt2), .gnt3(DUV_IF.gnt3), .gnt4(DUV_IF.gnt4));

    always #5 clock = ~clock;

    initial begin
        test_h = new(DUV_IF, DUV_IF, DUV_IF);
        test_h.build_n_run();
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, top, DUV_IF);
        clock = 0;
    end

    initial begin
        $set_coverage_db_name("coveraged.ucdb");
    end

    // Uncomment this line of code to test interupt request assertion
    // initial begin
    //     #145 DUV_IF.req2 = '1;
    //     #10 DUV_IF.req2 = '0;
    // end

    // initial begin
    //     #475 DUV_IF.req1 = '1;
    //     #10 DUV_IF.req1 = '0;
    // end

    // initial begin
    //     #315 DUV_IF.req4 = '1;
    //     #10 DUV_IF.req4 = '0;
    // end

    // initial begin
    //     #1855 DUV_IF.req3 = '1;
    //     #10 DUV_IF.req3 = '0;
    // end
endmodule: top
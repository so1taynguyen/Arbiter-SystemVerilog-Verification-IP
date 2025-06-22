module arb_dut(input bit clock, rst, req1, req2, req3, req4,
                output bit gnt1, gnt2, gnt3, gnt4);
    int delay_up;
    int delay_down;

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            gnt1 <= '0;
            gnt2 <= '0;
            gnt3 <= '0;
            gnt4 <= '0;
        end
        else begin
            delay_up = $urandom_range(7, 4);
            delay_down = $urandom_range(2, 1);

            casex ({req1, req2, req3, req4})
                4'b1???: begin
                    // Uncomment this line of code to test time-out assertion
                    // repeat (7) begin
                    //     @(posedge clock);
                    // end

                    repeat (delay_up) begin
                        @(posedge clock);
                    end 
                    gnt1 <= '1;

                    // Uncomment these lines of code to test single gnt assertion
                    // gnt2 <= '1;

                    // Uncomment this line of code to test time-out assertion
                    // repeat (4) begin
                    //     @(posedge clock);
                    // end 

                    repeat (delay_down) begin
                        @(posedge clock);
                    end 
                    gnt1 <= '0;
                    // gnt2 <= '0;
                end 
                4'b01??: begin
                    // Uncomment this line of code to test time-out assertion
                    // repeat (7) begin
                    //     @(posedge clock);
                    // end

                    repeat (delay_up) begin
                        @(posedge clock);
                    end 
                    gnt2 <= '1;
                    
                    // Uncomment this line of code to test time-out assertion
                    // repeat (4) begin
                    //     @(posedge clock);
                    // end 

                    repeat (delay_down) begin
                        @(posedge clock);
                    end 
                    gnt2 <= '0;
                end
                4'b001?: begin
                    // Uncomment this line of code to test time-out assertion
                    // repeat (7) begin
                    //     @(posedge clock);
                    // end

                    repeat (delay_up) begin
                        @(posedge clock);
                    end 
                    gnt3 <= '1;
                    
                    // Uncomment this line of code to test time-out assertion
                    // repeat (4) begin
                    //     @(posedge clock);
                    // end 

                    repeat (delay_down) begin
                        @(posedge clock);
                    end 
                    gnt3 <= '0;
                end
                4'b0001: begin
                    // Uncomment this line of code to test time-out assertion
                    // repeat (7) begin
                    //     @(posedge clock);
                    // end

                    repeat (delay_up) begin
                        @(posedge clock);
                    end 
                    gnt4 <= '1;

                    // Uncomment this line of code to test time-out assertion
                    // repeat (4) begin
                    //     @(posedge clock);
                    // end 

                    repeat (delay_down) begin
                        @(posedge clock);
                    end 
                    gnt4 <= '0;
                end
                default: begin
                    gnt1 <= '0;
                    gnt2 <= '0;
                    gnt3 <= '0;
                    gnt4 <= '0;
                end
            endcase
        end
    end
endmodule: arb_dut
// tb_vending_fsm.v
`timescale 1ns/1ps
module tb_vending_fsm;
    reg clk, rst;
    reg coin_5, coin_10, cancel;
    reg [1:0] select;
    wire dispense, refund;
    wire [1:0] product_id;

    // Instantiate DUT
    vending_fsm uut (
        .clk(clk),
        .rst(rst),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .cancel(cancel),
        .select(select),
        .dispense(dispense),
        .refund(refund),
        .product_id(product_id)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        $dumpfile("vending.vcd");
        $dumpvars(0, tb_vending_fsm);

        // Initialization
        rst = 1;
        coin_5 = 0; coin_10 = 0; cancel = 0; select = 2'b00;
        #15 rst = 0;

        // Scenario 1: Product 01 (₹15)
        $display("\n--- Scenario 1: Product 01 ---");
        select = 2'b01; #10; select = 2'b00; //'pressing' the product 01 button 
        #10 coin_10 = 1; #10 coin_10 = 0;
        #10 coin_5 = 1; #10 coin_5 = 0;
        #30;

        // Scenario 2: Product 10 (₹20) then cancel
        $display("\n--- Scenario 2: Product 10 + Cancel ---");
        select = 2'b10; #10; select = 2'b00;
        #10 coin_10 = 1; #10 coin_10 = 0;
        #10 cancel = 1; #10 cancel = 0; //showing cancel functionality
        #40;

        // Scenario 3: Product 11 (₹25)
        $display("\n--- Scenario 3: Product 11 ---");
        select = 2'b11; #10; select = 2'b00;
        #10 coin_10 = 1; #10 coin_10 = 0;
        #10 coin_10 = 1; #10 coin_10 = 0;
        #10 coin_10 = 1; #10 coin_10 = 0;
        #50;


        $finish;
    end
endmodule

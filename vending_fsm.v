module vending_fsm (
    input  wire clk,
    input  wire rst,
    input  wire coin_5,
    input  wire coin_10,
    input  wire cancel,
    input  wire [1:0] select,
    output reg  dispense,
    output reg  refund,
    output reg  [1:0] product_id
);

    // giving vals to all main states
    parameter IDLE       = 2'b00,
              WAIT_COINS = 2'b01,
              DISPENSE   = 2'b10,
              REFUND     = 2'b11;

    reg [1:0] state, next_state; //declaring vars
    reg [7:0] balance;
    reg [7:0] price;

    // sequential -> takes action based on state and updates data
    always @(posedge clk or posedge rst) begin
        if (rst) begin //resets everything to defaults and zeroes
            state <= IDLE;
            balance <= 8'd0;
            product_id <= 2'b00;
        end else begin
            state <= next_state; //update the state on every clock edge

            // updating values for balance based on condition
            if (state == WAIT_COINS) begin
                if (coin_5)
                    balance <= balance + 8'd5;
                if (coin_10)
                    balance <= balance + 8'd10;
            end else begin
                balance <= 8'd0;
            end

            // if were idle and the user selects a product, store that product code
            if (state == IDLE && select != 2'b00)
                product_id <= select;
        end
    end

    // m the prices for each product here (note we are not working with product b00)
    always @(*) begin
        case (product_id)
            2'b00: price = 8'd10;
            2'b01: price = 8'd15;
            2'b10: price = 8'd20;
            2'b11: price = 8'd25;
            default: price = 8'd10;
        endcase
    end

    // combinational -> what is the next state i should go to?
    always @(*) begin
        next_state = state;
        dispense = 1'b0;
        refund = 1'b0;

        case (state)
            IDLE: begin
                if (select != 2'b00)
                    next_state = WAIT_COINS;
            end

            WAIT_COINS: begin
                if (cancel)
                    next_state = REFUND;
                else if (balance >= price)
                    next_state = DISPENSE;
            end

            DISPENSE: begin
                dispense = 1'b1;
                next_state = IDLE;
            end

            REFUND: begin
                refund = 1'b1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule

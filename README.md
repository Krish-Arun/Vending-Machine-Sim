# Vending-Machine-Sim
A minimal simulation of the logic core behind a vending machine implemented using a Finite State Machine (FSM).
The entire explanation is included in this README - the project is absolutely minimal, and code is not commented clearly as of now

## Compilation:
Requires: Icarus Verilog on path as well as GTKWave to visualize waveform

- compile: `iverilog -o vending vending_fsm.v tb_vending_fsm.v`, 
- run the testbench (to create the .vcd waveform): `vvp vending`, 
- run the GTKWave: `gtkwave vending.vcd`

## Overview:
The machine offers products that can be bought with a fixed set of currency. It offers:
  - 3 products costing currency 15, 20 and 30
  - 2 coins: of currency 5 and 10

### Input:
Inputs are hard coded into the test file (./tb_vending_fsm.v):
  - `select`: can be set to the value of the `product_id` (binary)
  - the two coins `coin_5` and `coin_10`
  - interrupt variables `cancel` (which cancels proccessing of ongoing product) and `rst` (reset)(which resets to IDLE state and vars to default values)
  - `clk` (alternating binary clock as reference for all processes)

### Process States:
FSM States decide what processes must be run (actions taken):
  - `IDLE`: as the name suggests, idle state which waits for a new product to be selected
  - `WAIT_COINS`: upon a product being selected, machine must wait as coins are added till currency of suffient value is given (`balance==product price`)
  - `DISPENSE`: once price is reached, the machine dispenses the product and returns to `IDLE`
  - `REFUND`: if cancel is pulsed high mid operation OR the user overpays, all the money is refunded, product is NOT dispensed and machine returns to `IDLE`

### Working:
  1. Start ticking the clock(`clk`) and hit the reset switch (`rst=1`) -> machine starts `IDLE`{2}
  2. `IDLE`: If a product is selected (`select != NULL`)  -> switch to `WAIT_COINS`{3}, else, terminate{5}
  3. `WAIT_COINS`: wait until sufficient input:
     - if correct amount is paid (`balance = product_price`), `DISPENSE`{4} the product
     - else, if user overpays (`balance > product_price`), `REFUND`{4} the amount
  4. `DISPENSE` or `REFUND`: reset the balance to zero, go to `IDLE`{2}
  5. Terminate the clock(`clk`) if inactive for a while

Note that:
  - 'Terminate' is not a dedicated state
  - When a product is selected (`select != NULL`){1} or coins are deposited (`coin_n = 1`){2}, make sure to reset to `select = NULL` and `coin_n = 0` respectively, else the machine will:
    
    1. Keep initializing `WAIT_COINS` for the selected product, and
    2. Continually increment `balance` every `clk` pulse (even though we just want a single increment)
    respectively


## Upcoming features:

  - readable vars
  - decimal value displays for currency and strings for states
  - more products and currency options -> requires expansion beyong 2 bit
  - CLI inputs and output display
  - emojis in the README :)

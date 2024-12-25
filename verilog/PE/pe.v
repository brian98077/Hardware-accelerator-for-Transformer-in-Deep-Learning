`define DIGIT 16

module MUL_PE (
    input                 clk,
    input                 reset,
    input                 input_valid,
    input  [`DIGIT-1:0]   input_a,
    input  [`DIGIT-1:0]   input_b,
    output                output_valid,
    output [`DIGIT-1:0]   output_a,
    output [`DIGIT-1:0]   output_b,
    output [`DIGIT*2-`DIGIT/2-1:0] product
);

    reg [2:0] counter;
    reg [`DIGIT*2+1:0] partial_sum;
    reg [`DIGIT-1:0] input_a_buffer, input_b_buffer;
    reg done;

    assign output_valid = done;
    assign product = (counter == 3'd4) ? ( (partial_sum[`DIGIT*2] || partial_sum[`DIGIT*2 + 1]) ? -1 : partial_sum[`DIGIT*2-1:`DIGIT/2]) : 0; // saturation
    assign output_a = input_a_buffer;
    assign output_b = input_b_buffer;

    // counter
    always @(posedge reset or posedge clk) begin
        if(reset) counter <= 3'd0;
        else if(input_valid && counter != 3'd4) counter <= counter + 1;
        else counter <= counter;
    end

    // done
    always @(posedge reset or posedge clk) begin
        if(reset) done <= 0;
        else if(counter == 3'd3) done <= 1;
        else done <= done;
    end

    // sum
    always @(posedge reset or posedge clk) begin
        if(reset) partial_sum <= 0;
        else if(input_valid && counter != 3'd4) partial_sum <= partial_sum + input_a * input_b;
        else partial_sum <= partial_sum;
    end

    // buffer
    always @(posedge reset or posedge clk) begin
        if(reset) begin
            input_a_buffer <= 0;
            input_b_buffer <= 0;
        end
        else if(input_valid && counter != 3'd4) begin
            input_a_buffer <= input_a;
            input_b_buffer <= input_b;
        end
        else begin
            input_a_buffer <= input_a_buffer;
            input_b_buffer <= input_b_buffer;
        end
    end
endmodule
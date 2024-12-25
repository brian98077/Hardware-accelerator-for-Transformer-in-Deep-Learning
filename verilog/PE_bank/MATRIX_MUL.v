`define DIGIT 16

module MATRIX_MUL (
    input              clk,
    input              reset,
    input              i_valid,
    input [`DIGIT-1:0] i_data_up_0,
    input [`DIGIT-1:0] i_data_up_1,
    input [`DIGIT-1:0] i_data_up_2,
    input [`DIGIT-1:0] i_data_up_3,
    input [`DIGIT-1:0] i_data_left_0,
    input [`DIGIT-1:0] i_data_left_1,
    input [`DIGIT-1:0] i_data_left_2,
    input [`DIGIT-1:0] i_data_left_3,
    output             output_valid,
    // output [3:0]       o_addr_up_0,
    // output [3:0]       o_addr_up_1,
    // output [3:0]       o_addr_up_2,
    // output [3:0]       o_addr_up_3,
    // output [3:0]       o_addr_left_0,
    // output [3:0]       o_addr_left_1,
    // output [3:0]       o_addr_left_2,
    // output [3:0]       o_addr_left_3
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_0,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_1,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_2,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_3,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_4,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_5,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_6,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_7,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_8,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_9,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_10,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_11,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_12,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_13,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_14,
    output [`DIGIT*2-`DIGIT/2-1:0] o_data_15
);
    
    reg [3:0] counter;
    wire [`DIGIT-1:0] i_data_up [0:3];
    wire [`DIGIT-1:0] i_data_left [0:3];
    wire [`DIGIT-1:0] bus_a [0:15];
    wire [`DIGIT-1:0] bus_b [0:15];
    wire [`DIGIT*2-`DIGIT/2-1:0] mul_result [0:15];
    wire result_valid [0:15];
    reg output_valid_reg;

    assign i_data_up[0] = i_data_up_0;
    assign i_data_up[1] = i_data_up_1;
    assign i_data_up[2] = i_data_up_2;
    assign i_data_up[3] = i_data_up_3;
    assign i_data_left[0] = i_data_left_0;
    assign i_data_left[1] = i_data_left_1;
    assign i_data_left[2] = i_data_left_2;
    assign i_data_left[3] = i_data_left_3;
    assign output_valid = output_valid_reg;
    assign o_data_0 = mul_result[0];
    assign o_data_1 = mul_result[1];
    assign o_data_2 = mul_result[2];
    assign o_data_3 = mul_result[3];
    assign o_data_4 = mul_result[4];
    assign o_data_5 = mul_result[5];
    assign o_data_6 = mul_result[6];
    assign o_data_7 = mul_result[7];
    assign o_data_8 = mul_result[8];
    assign o_data_9 = mul_result[9];
    assign o_data_10 = mul_result[10];
    assign o_data_11 = mul_result[11];
    assign o_data_12 = mul_result[12];
    assign o_data_13 = mul_result[13];
    assign o_data_14 = mul_result[14];
    assign o_data_15 = mul_result[15];

    // counter
    always @(posedge reset or posedge clk) begin
        if(reset) counter <= 4'd0;
        else if(i_valid && counter != 4'd7) counter <= counter + 1;
        else counter <= counter;
    end

    // output valid
    always @(posedge reset or posedge clk) begin
        if(reset) output_valid_reg <= 0;
        else if(counter == 4'd7) output_valid_reg <= result_valid[15];
        else output_valid_reg <= output_valid_reg;
    end

    // PE bank
    genvar i;
    generate
        for (i=0;i<16;i=i+1) begin : PE_bank
            if(i == 0) begin
                MUL_PE mul_pe(
                    .clk(clk),
                    .reset(reset),
                    .input_valid(i_valid && counter <= 4'd4),
                    .input_a(i_data_left[0]),
                    .input_b(i_data_up[0]),
                    .output_valid(result_valid[0]),
                    .output_a(bus_a[0]),
                    .output_b(bus_b[0]),
                    .product(mul_result[0])
                );
            end
            else if(i > 0 && i <= 3) begin
                MUL_PE mul_pe(
                    .clk(clk),
                    .reset(reset),
                    .input_valid(i_valid && counter >= i &&  counter <= (i + 4'd4)),
                    .input_a(bus_a[i-1]),
                    .input_b(i_data_up[i]),
                    .output_valid(result_valid[i]),
                    .output_a(bus_a[i]),
                    .output_b(bus_b[i]),
                    .product(mul_result[i])
                );
            end
            else if(i == 4 || i == 8 || i == 12) begin
                MUL_PE mul_pe(
                    .clk(clk),
                    .reset(reset),
                    .input_valid(i_valid && counter >= i/4 &&  counter <= (i/4 + 4'd4)),
                    .input_a(i_data_left[i/4]),
                    .input_b(bus_b[i-4]),
                    .output_valid(result_valid[i]),
                    .output_a(bus_a[i]),
                    .output_b(bus_b[i]),
                    .product(mul_result[i])
                );
            end
            else begin
                MUL_PE mul_pe(
                    .clk(clk),
                    .reset(reset),
                    .input_valid(counter >= (i/4 + i%4) &&  counter <= (i/4 + i%4 + 4'd4)),
                    .input_a(bus_a[i-1]),
                    .input_b(bus_b[i-4]),
                    .output_valid(result_valid[i]),
                    .output_a(bus_a[i]),
                    .output_b(bus_b[i]),
                    .product(mul_result[i])
                );
            end
        end
    endgenerate


endmodule

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
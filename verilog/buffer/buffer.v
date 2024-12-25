`define DIGIT 16

module BUFFER (
    input              clk,
    input              reset,
    input              i_valid_0,
    input              i_valid_1,
    input              i_valid_2,
    input              i_valid_3,
    input [3:0]        i_address_0,
    input [3:0]        i_address_1,
    input [3:0]        i_address_2,
    input [3:0]        i_address_3,
    input [`DIGIT-1:0] i_data_0,
    input [`DIGIT-1:0] i_data_1,
    input [`DIGIT-1:0] i_data_2,
    input [`DIGIT-1:0] i_data_3
);

reg [`DIGIT-1:0] data [0:15] ;

integer i;

always @(posedge clk or reset) begin
    for(i=0;i<16;i=i+1) begin
        data[i] <= data[i];
    end
    if(reset) begin
        for(i=0;i<16;i=i+1) begin
            data[i] <= 0;
        end
    end
    else if(i_valid_0 || i_valid_1 || i_valid_2 || i_valid_3) begin
        data[i_address_0] <= (i_valid_0) ? i_data_0 : data[i_address_0];
        data[i_address_1] <= (i_valid_1) ? i_data_1 : data[i_address_1];
        data[i_address_2] <= (i_valid_2) ? i_data_2 : data[i_address_2];
        data[i_address_3] <= (i_valid_3) ? i_data_3 : data[i_address_3];
    end
end

endmodule
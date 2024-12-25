module SOFTMAX_EXP (
	input 		  		clk,
	input 	 	  		reset,
    input 		  		i_valid,
	input signed [11:0] i_x,
	output  	  		o_valid,
	output [15:0] 		o_y
);

reg o_valid_r, o_valid_w;
reg [15:0] o_y_r, o_y_w;

assign o_valid = o_valid_r;
assign o_y = o_y_r;

wire signed [27:0] partial_product_86 =   ($signed({1'b0, 16'b0000_0000_0100_0110}) * i_x); // -8 <= x <= -6
wire signed [27:0] partial_product_64 =   ($signed({1'b0, 16'b0000_0010_0010_0010}) * i_x); // -6 < x <= -4
wire signed [27:0] partial_product_42 =   ($signed({1'b0, 16'b0000_1111_0000_0001}) * i_x); // -4 < x <= -2
wire signed [27:0] partial_product_21 =   ($signed({1'b0, 16'b0011_1100_0001_1010}) * i_x); // -2 < x <= -1
wire signed [27:0] partial_product_1005 = ($signed({1'b0, 16'b0111_1101_0000_0011}) * i_x); // -1 < x <= -0.5
wire signed [27:0] partial_product_0525 = ($signed({1'b0, 16'b1011_0010_0010_1100}) * i_x); // -0.5 < x <= -0.25
wire signed [27:0] partial_product_0250 = ($signed({1'b0, 16'b1110_0101_0001_0000}) * i_x); // -0.25 < x < 0
// combinational
always @(*) begin
	o_y_w = 16'd0;
	o_valid_w = 0;
	if(i_valid) begin
		o_valid_w = 1;
		if(i_x == 12'b1111_1111_1111) begin	// x = 0
			o_y_w = 16'b1111_1111_0000_0000;
		end
		else if(i_x <= 12'b1010_0000_0000) begin  	 // -8 <= x <= -6
			o_y_w = $signed({1'b1, partial_product_86[23:8]}) + $signed({1'b0, 16'b0000_0010_0011_0000});
		end
		else if(i_x <= 12'b1100_0000_0000) begin // -6 < x <= -4
			o_y_w = $signed({1'b1, partial_product_64[23:8]}) + $signed({1'b0, 16'b0000_1100_1100_1010});
		end
		else if(i_x <= 12'b1110_0000_0000) begin // -4 < x <= -2
			o_y_w = $signed({1'b1, partial_product_42[23:8]}) + $signed({1'b0, 16'b0011_1011_1111_1101});
		end
		else if(i_x <= 12'b1111_0000_0000) begin // -2 < x <= -1
			o_y_w = $signed({1'b1, partial_product_21[23:8]}) + $signed({1'b0, 16'b1001_0101_1011_0001});
		end
		else if(i_x <= 12'b1111_1000_0000) begin // -1 < x <= -0.5
			o_y_w = $signed({1'b1, partial_product_1005[23:8]}) + $signed({1'b0, 16'b1101_0111_1111_0000});
		end
		else if(i_x <= 12'b1111_1100_0000) begin // -0.5 < x <= -0.25
			o_y_w = $signed({1'b1, partial_product_0525[23:8]}) + $signed({1'b0, 16'b1111_0011_0011_1001});
		end
		else begin 								 // -0.25 < x < 0
			o_y_w = $signed({1'b1, partial_product_0250[23:8]}) + $signed({1'b0, 16'b1111_1111_0001_1011});
		end
	end
end

// sequential
always @(posedge reset or posedge clk) begin
	if(reset) begin
		o_valid_r <= 0;
		o_y_r <= 16'd0;
	end
	else begin
		o_valid_r <= o_valid_w;
		o_y_r     <= o_y_w;
	end
end
endmodule
`include "SOFTMAX_EXP.v"

module SOFTMAX (
    input               clk,
    input               reset,
    input               i_valid,
    input signed [11:0] i_y,
    output              o_valid,
    output [15:0]       o_softmax_y
);
    
// state
parameter S_IDLE  = 0;
parameter S_ACC   = 1;
parameter S_DIV   = 2;

// declaration
integer i, j;
wire exp_valid;
wire [15:0] exp_result;
reg [1:0] state_r, state_w;
reg [3:0] acc_counter_r, acc_counter_w;
reg [3:0] div_counter_r, div_counter_w;
reg [15:0] data_buffer_r [0:15];
reg [15:0] data_buffer_w [0:15];
reg [19:0] acc_sum_r, acc_sum_w;

// assignment
assign o_valid = (state_r == S_DIV);
assign o_softmax_y = (state_r == S_DIV)? {data_buffer_r[div_counter_r], 16'd0} / acc_sum_r : 16'dz; 

SOFTMAX_EXP exp(
	.clk(clk),
	.reset(reset),
    .i_valid(i_valid),
	.i_x(i_y),
	.o_valid(exp_valid),
	.o_y(exp_result)
);

// FSM
always @(*) begin
    state_w = state_r;
    case (state_r)
        S_IDLE: begin
            if(i_valid) state_w = S_ACC;
            else        state_w = S_IDLE;
        end 
        S_ACC: begin
            if(acc_counter_r == 4'd15) state_w = S_DIV;
            else                       state_w = S_ACC;
        end
        S_DIV: begin
            if(div_counter_r == 4'd15) state_w = S_IDLE;
            else                       state_w = S_DIV;
        end
    endcase
end

// accumulate counter
always @(*) begin
    acc_counter_w = acc_counter_r;
    case (state_r)
        S_IDLE: begin
            acc_counter_w = acc_counter_r;
        end 
        S_ACC: begin
            if(acc_counter_r == 4'd15) acc_counter_w = 4'd0;
            else if(exp_valid)         acc_counter_w = acc_counter_r + 1;
            else                       acc_counter_w = acc_counter_r;
        end
        S_DIV: begin
            acc_counter_w = acc_counter_r;
        end
    endcase
end

// divide counter
always @(*) begin
    div_counter_w = div_counter_r;
    case (state_r)
        S_IDLE: begin
            div_counter_w = div_counter_r;
        end 
        S_ACC: begin
            div_counter_w = div_counter_r;
        end
        S_DIV: begin
            if(div_counter_r == 4'd15) div_counter_w = 4'd0;
            else                       div_counter_w = div_counter_r + 1;
        end
    endcase
end

// combinational
always @(*) begin
    acc_sum_w = acc_sum_r;
    for(j=0;j<16;j=j+1) begin
            data_buffer_w[j] = data_buffer_r[j];
    end
    case (state_r)
        S_IDLE: begin
            acc_sum_w = acc_sum_r;
            for(j=0;j<16;j=j+1) begin
                data_buffer_w[j] = data_buffer_r[j];
            end
        end 
        S_ACC: begin
            if(exp_valid) begin
                acc_sum_w = acc_sum_r + exp_result;
                data_buffer_w[acc_counter_r] = exp_result;
            end
        end
        S_DIV: begin
            acc_sum_w = acc_sum_r;
            for(j=0;j<16;j=j+1) begin
                data_buffer_w[j] = data_buffer_r[j];
            end
        end
    endcase    
end

// sequential
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state_r       <= S_IDLE;
        acc_counter_r <= 0;
        div_counter_r <= 0;
        acc_sum_r     <= 20'd0;
        for(i=0;i<16;i=i+1) begin
            data_buffer_r[i] <= 16'd0;
        end
    end
    else begin
        state_r       <= state_w;
        acc_counter_r <= acc_counter_w;
        div_counter_r <= div_counter_w;
        acc_sum_r     <= acc_sum_w;
        for(i=0;i<16;i=i+1) begin
            data_buffer_r[i] <= data_buffer_w[i];
        end
    end
end
endmodule
`timescale 1ns / 1ps
`define CYCLE 3.0
`define PATTERN 2048
`define END_CYCLE 10000

`ifdef SYN
    `define SDFFILE "SOFTMAX_EXP_syn.sdf"
`endif

module tb_SOFTMAX_EXP;

reg reset;
reg clk = 1;
always #(`CYCLE/2) clk = ~clk;

// initial begin
// 	$fsdbDumpfile("tb_SOFTMAX_EXP.fsdb");
// 	$fsdbDumpvars(0, tb_SOFTMAX_EXP, "+all");
// end

reg rst_n = 1;
reg [11:0] i_x;
reg i_valid;
wire o_valid;
wire [15:0] o_y;
real input_data;

SOFTMAX_EXP softmax_exp(
	.clk         (clk),
	.reset       (reset),
    .i_valid     (i_valid),
	.i_x         (i_x),
	.o_valid     (done),
	.o_y         (o_y)
);

initial begin
	`ifdef SYN
		$sdf_annotate(`SDFFILE, softmax_exp);
	`endif
end

// memory
reg signed[11:0]  INPUT_MEM [0:`PATTERN-1];
reg 	  [15:0]  GOLDEN_MEM [0:`PATTERN-1];

initial begin
	$readmemb("../pattern/exp/input_data.dat", INPUT_MEM);
	$readmemb("../pattern/exp/exp_golden.dat", GOLDEN_MEM);
end

//Latency
integer latency;
always @(posedge clk or posedge reset) begin 
	if (reset) begin 
		latency = -1;
	end
	else begin
		latency = latency + 1;
	end
end


integer i, j;
integer total_latency = 0;
integer diff;
reg [100:0] error;
reg [100:0] MSE = 0;

//input
initial begin
	i_valid = 0;
	@(posedge clk) reset = 1;
	@(posedge clk); 
	reset = 0;
	@(posedge clk);
	for (i=0; i<`PATTERN; i=i+1) begin
		// #(0.6); //filp flop hold time
		i_x = INPUT_MEM[i];
		i_valid = 1;
		@(posedge clk); 
	end
	// #(0.6);
	i_valid = 0;
	i_x = 'bx;
end


initial begin 
    #(`CYCLE*`END_CYCLE);
    $display("\n\033[0;31m================================================================\n");
    $display("====================  Time limit exceeded  =====================\n");
    $display("================================================================\033[0m\n");
    $finish;
end

//check output
initial begin
	wait (done);
	@(negedge clk);
	for (j=0; j<`PATTERN; j=j+1) begin
		if (done !== 1)begin
			$display("\n\033[1;31m=============================================");
			$display("        o_valid should be kept high         ");
			$display("=============================================\033[0m");
			@(negedge clk);
			$finish;
		end
		else begin
			diff  = (o_y >= GOLDEN_MEM[j]) ? (o_y - GOLDEN_MEM[j]) : (GOLDEN_MEM[j] - o_y);
			error = diff * diff;
			input_data = INPUT_MEM[j];
            $display("Pattern %4d. / Input: \033[1;96m%.4f\033[0m / Output: \033[1;96m%2d\033[0m / Golden: \033[1;96m%1d\033[0m / Square Error: \033[1;31m%1d\033[0m", j, input_data/256, o_y, GOLDEN_MEM[j], error);
			MSE = MSE + error;
		end
		@(negedge clk);
	end
	total_latency = latency - 1;

	$display("\n\033[1;92m=============================================");
	$display("              Simulation finished            ");
	$display("=============================================\033[0m");

	$display("\n\033[1;96m=============================================");
	$display("                   Summary                   ");
	$display("=============================================");
	$display("  Clock cycle :               %.1f ns", `CYCLE);
	$display("  Total excution cycle :      %.0f", $itor(total_latency));
	$display("  MSE : %.1f", $itor(MSE[100:11])); // divided by 2048
	// $display("  Performance Score:         %.1f", $itor(total_latency) * `CYCLE);
	$display("=============================================\033[0m");

	$finish;
end

endmodule

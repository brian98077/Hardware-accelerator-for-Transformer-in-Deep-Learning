`timescale 1ns / 1ps
`define CYCLE 25.0
`define END_CYCLE 5000
`define INPUT_LEN 12
`define OUTPUT_LEN 16
`define TEST_NUM 10

`ifdef SYN
    `define SDFFILE "SOFTMAX_syn.sdf"
`endif

module tb_SOFTMAX;

    reg clk = 1;
    always #(`CYCLE/2) clk = ~clk;

    integer i, j, input_addr, output_addr;
    wire output_valid;
    reg reset;
    reg input_valid;
    wire [`INPUT_LEN-1:0]  input_data;
    wire [`OUTPUT_LEN-1:0] output_data;
    real output_real, golden_real, avg_error, largest_data;

    // memory
    reg signed [`INPUT_LEN-1:0]  INPUT_MEM  [0:`TEST_NUM*16-1];
    reg 	   [`OUTPUT_LEN-1:0] GOLDEN_MEM [0:`TEST_NUM*16-1];

    initial begin
        $readmemb("../pattern/softmax/softmax_golden.dat", GOLDEN_MEM);
        $readmemb("../pattern/softmax/softmax_input.dat", INPUT_MEM);
    end

    assign input_data = INPUT_MEM[input_addr];

    SOFTMAX softmax(
        .clk(clk),
        .reset(reset),
        .i_valid(input_valid),
        .i_y(input_data),
        .o_valid(output_valid),
        .o_softmax_y(output_data)
    );

    initial begin
        `ifdef SYN
            $sdf_annotate(`SDFFILE, softmax);
        `endif
    end

    initial begin
	    $fsdbDumpfile("tb_SOFTMAX.fsdb");
	    $fsdbDumpvars(0, tb_SOFTMAX, "+all");
    end

    initial begin
        reset = 0;
        clk = 0;
        input_valid = 0;
        input_addr = 0;
        output_addr = 0;
        j = 0;
        avg_error = 0;
        while(j < `TEST_NUM) begin
            @(negedge clk) reset = 1;
            reset = 1;

            @(negedge clk) reset = 0;
            #(`CYCLE*2) input_valid = 1;
            for(i = 0; i < 16; i = i + 1) begin
                #(`CYCLE) input_addr = input_addr + 1;
            end
            input_valid = 0;

            $display("\n\033[1;96m========= test set %2d =========\033[0m\n", j+1);

            wait(output_valid);
            for(i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                if(output_valid) begin
                    if(i == 0) largest_data = GOLDEN_MEM[output_addr];
                    output_real = output_data;
                    golden_real = GOLDEN_MEM[output_addr];
                    if(output_real >= golden_real) begin
                        $display("pattern %2d , golden: %.5f, output: %.5f, error : %7.4f%%", i+1, golden_real/65536, output_real/65536, (output_real - golden_real)/largest_data*100);
                        avg_error = avg_error + (output_real - golden_real)/largest_data*100;
                    end
                    else begin
                        $display("pattern %2d , golden: %.5f, output: %.5f, error : %7.4f%%", i+1, golden_real/65536, output_real/65536, (golden_real - output_real)/largest_data*100);
                        avg_error = avg_error + (golden_real - output_real)/largest_data*100;  
                    end
                end
                #(`CYCLE);
                output_addr = output_addr + 1;
            end
            $display("\n  average error =\033[1;96m %.2f%% \033[0m\n", avg_error/16);
            $display("\n\033[1;96m====== test set %2d end ========\033[0m\n", j+1);
            avg_error = 0;
            #(`CYCLE*10);
            j = j + 1;
        end
        $finish;
    end
    
    initial begin 
        #(`CYCLE*`END_CYCLE);
        $display("\n\033[0;31m================================================================\n");
        $display("====================  Time limit exceeded  =====================\n");
        $display("================================================================\033[0m\n");
        $finish;
    end

endmodule
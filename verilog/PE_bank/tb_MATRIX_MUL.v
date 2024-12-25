`timescale 1ns / 1ps
`define CYCLE 10.0
`define DIGIT 16
`define END_CYCLE 5000

`ifdef P1
    `define A "../pattern/matrix_mul/inputs/matrix_A_1.dat"
    `define B "../pattern/matrix_mul/inputs/matrix_B_1.dat"
    `define GOLDEN "../pattern/matrix_mul/outputs/golden_1.dat"
`elsif P2
    `define A "../pattern/matrix_mul/inputs/matrix_A_2.dat"
    `define B "../pattern/matrix_mul/inputs/matrix_B_2.dat"
    `define GOLDEN "../pattern/matrix_mul/outputs/golden_2.dat"
`elsif P3
    `define A "../pattern/matrix_mul/inputs/matrix_A_3.dat"
    `define B "../pattern/matrix_mul/inputs/matrix_B_3.dat"
    `define GOLDEN "../pattern/matrix_mul/outputs/golden_3.dat"
`elsif P4
    `define A "../pattern/matrix_mul/inputs/matrix_A_4.dat"
    `define B "../pattern/matrix_mul/inputs/matrix_B_4.dat"
    `define GOLDEN "../pattern/matrix_mul/outputs/golden_4.dat"
`elsif P5
    `define A "../pattern/matrix_mul/inputs/matrix_A_5.dat"
    `define B "../pattern/matrix_mul/inputs/matrix_B_5.dat"
    `define GOLDEN "../pattern/matrix_mul/outputs/golden_5.dat"
`endif

`ifdef SYN
    `define SDFFILE "MATRIX_MUL_syn.sdf"
`endif

module tb_MATRIX_MUL;

    reg reset;
    reg clk = 1;
    always #(`CYCLE/2) clk = ~clk;
    
    reg input_valid;
    wire done;

    reg [`DIGIT-1:0] input_A [0:15];
    reg [`DIGIT-1:0] input_B [0:15];
    reg [`DIGIT*2-`DIGIT/2-1:0] golden [0:15];

    reg [`DIGIT-1:0] i_data_up_0, i_data_up_1, i_data_up_2, i_data_up_3, i_data_left_0, i_data_left_1, i_data_left_2, i_data_left_3;
    wire [`DIGIT*2-`DIGIT/2-1:0] output_data [0:15];

    initial begin
        $readmemh(`A, input_A);
        $readmemh(`B, input_B);
        $readmemh(`GOLDEN, golden);
    end

    MATRIX_MUL matrix_mul (
        .clk(clk),
        .reset(reset),
        .i_valid(input_valid),
        .i_data_up_0(i_data_up_0),
        .i_data_up_1(i_data_up_1),
        .i_data_up_2(i_data_up_2),
        .i_data_up_3(i_data_up_3),
        .i_data_left_0(i_data_left_0),
        .i_data_left_1(i_data_left_1),
        .i_data_left_2(i_data_left_2),
        .i_data_left_3(i_data_left_3),
        .output_valid(done),
        .o_data_0(output_data[0]),
        .o_data_1(output_data[1]),
        .o_data_2(output_data[2]),
        .o_data_3(output_data[3]),
        .o_data_4(output_data[4]),
        .o_data_5(output_data[5]),
        .o_data_6(output_data[6]),
        .o_data_7(output_data[7]),
        .o_data_8(output_data[8]),
        .o_data_9(output_data[9]),
        .o_data_10(output_data[10]),
        .o_data_11(output_data[11]),
        .o_data_12(output_data[12]),
        .o_data_13(output_data[13]),
        .o_data_14(output_data[14]),
        .o_data_15(output_data[15])
    );

    initial begin
        `ifdef SYN
            $sdf_annotate(`SDFFILE, matrix_mul);
        `endif
        `ifdef SYN
            $fsdbDumpfile("tb_MATRIX_MUL_syn.fsdb");
        `else
            $fsdbDumpfile("tb_MATRIX_MUL.fsdb");
        `endif
        $fsdbDumpvars(0, tb_MATRIX_MUL, "+all");
    end

    initial begin
        reset = 0;
        clk = 0;
        input_valid = 0;

        #(`CYCLE);
        @(negedge clk) reset = 1;
        @(negedge clk);
        @(negedge clk) reset = 0;
        

        #(`CYCLE*2);
        @(negedge clk) begin
            input_valid = 1;
            i_data_up_0 = input_B[0];
            i_data_up_1 = 0;
            i_data_up_2 = 0;
            i_data_up_3 = 0;
            i_data_left_0 = input_A[0];
            i_data_left_1 = 0;
            i_data_left_2 = 0;
            i_data_left_3 = 0;
        end
        @(negedge clk) begin
            i_data_up_0 = input_B[4];
            i_data_up_1 = input_B[1];
            i_data_up_2 = 0;
            i_data_up_3 = 0;
            i_data_left_0 = input_A[1];
            i_data_left_1 = input_A[4];
            i_data_left_2 = 0;
            i_data_left_3 = 0;
        end
        @(negedge clk) begin
            i_data_up_0 = input_B[8];
            i_data_up_1 = input_B[5];
            i_data_up_2 = input_B[2];
            i_data_up_3 = 0;
            i_data_left_0 = input_A[2];
            i_data_left_1 = input_A[5];
            i_data_left_2 = input_A[8];
            i_data_left_3 = 0;
        end
        @(negedge clk) begin
            i_data_up_0 = input_B[12];
            i_data_up_1 = input_B[9];
            i_data_up_2 = input_B[6];
            i_data_up_3 = input_B[3];
            i_data_left_0 = input_A[3];
            i_data_left_1 = input_A[6];
            i_data_left_2 = input_A[9];
            i_data_left_3 = input_A[12];
        end
        @(negedge clk) begin
            i_data_up_0 = 0;
            i_data_up_1 = input_B[13];
            i_data_up_2 = input_B[10];
            i_data_up_3 = input_B[7];
            i_data_left_0 = 0;
            i_data_left_1 = input_A[7];
            i_data_left_2 = input_A[10];
            i_data_left_3 = input_A[13];
        end
        @(negedge clk) begin
            i_data_up_0 = 0;
            i_data_up_1 = 0;
            i_data_up_2 = input_B[14];
            i_data_up_3 = input_B[11];
            i_data_left_0 = 0;
            i_data_left_1 = 0;
            i_data_left_2 = input_A[11];
            i_data_left_3 = input_A[14];
        end
        @(negedge clk) begin
            i_data_up_0 = 0;
            i_data_up_1 = 0;
            i_data_up_2 = 0;
            i_data_up_3 = input_B[15];
            i_data_left_0 = 0;
            i_data_left_1 = 0;
            i_data_left_2 = 0;
            i_data_left_3 = input_A[15];
        end

        @(negedge clk) input_valid = 0;
    end

    initial begin 
        #(`CYCLE*`END_CYCLE);
        $display("\n\033[0;31m================================================================\n");
        $display("====================  Time limit exceeded  =====================\n");
        $display("================================================================\033[0m\n");
        $finish;
    end

    integer i, error, pass_num;
    initial begin
        i = 0;
        error = 0;
        pass_num = 0;
    end
    
    always@ (negedge clk) begin
        if(done) begin
            while(i < 16) begin
                if(golden[i] == output_data[i]) begin
                    pass_num = pass_num + 1;
                    $display("pattern %2d pass , golden: %6h, output: %6h", i, golden[i], output_data[i]);
                end
                else begin
                    $display("pattern %2d error, golden: %6h, output: %6h", i, golden[i], output_data[i]);
                    error = error + 1;
                end
                i = i + 1;
            end
        end
    end

    always@ (negedge clk) begin
        if(error + pass_num == 16 && done) begin
            if (pass_num == 16 && error == 0) begin    
                $display("\n\033[0;32m================================================================\n");
                $display("===================== ALL TEST CASES PASS  =====================\n");
                $display("================================================================\033[0m\n");
                $finish;
            end 
            else begin
                $display("\n\033[0;31m================================================================\n");
                $display("============================  FAIL  ============================\n");
                $display("                   total error :%d\n", error);
                $display("================================================================\033[0m\n");
                $finish;
            end
        end
    end
endmodule
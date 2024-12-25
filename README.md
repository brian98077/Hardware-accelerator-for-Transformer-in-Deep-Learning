# Hardware-accelerator-for-Transformer-in-Deep-Learning  
Test files for Transformer  
Author : Yi-Chun, Hsu  
Latest edition : 2024/12/24 3:40 a.m.  
  
  
Please cd to the following directories for verilog simulation:  
  
	./verilog/PE_bank :  
	$ vcs tb_MATRIX_MUL.v MATRIX_MUL.v -full64 -R -debug_access+all +v2k +define+P1 (you can choose from P1 to P5)   
  
	./verilog/exp :  
	$ vcs tb_SOFTMAX_EXP.v SOFTMAX_EXP.v -full64 -R -debug_access+all +v2k   
  
	./verilog/softmax :  
	$ vcs tb_SOFTMAX.v SOFTMAX.v -full64 -R -debug_access+all +v2k   

  
More test patterns can be generated using files under ./cpp and ./python  

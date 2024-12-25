CC = g++
CFLAGS = -c
OPTFLAGS = -O2

bin/matrix_mul	:  matrix_mul.o
			$(CC) $(OPTFLAGS)  matrix_mul.o -o bin/matrix_mul
matrix_mul.o 	   	: src/matrix_mul.cpp
			$(CC) $(CFLAGS) $< -Ilib -o $@
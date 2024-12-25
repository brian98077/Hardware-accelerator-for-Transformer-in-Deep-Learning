from math import exp
INPUT_WIDTH = 12   # 4 int + 8 frac
OUTPUT_WIDTH = -16  # 16 frac

# convert decimal floating point (<1) to binary (16 bits fraction)
def decimal_to_bin(decimal_num):
    position = -1
    result = ""

    while(position >= OUTPUT_WIDTH):
        two_power = pow(2, position)
        if(decimal_num >= two_power):
            decimal_num -= two_power
            result += "1"
        else:
            result += "0"
        position -= 1

    return result

# convert binary(4 bits integer + 8 bits fraction) to decimal
def two_comp_to_decimal(two_comp_num):
    position = 0
    result = 0
    while(position < INPUT_WIDTH):
        if(two_comp_num[position] == '1') : result += pow(2, 3 - position)
        position = position + 1

    return result

fin = open("softmax_input.dat", 'r')
fout = open("softmax_golden.dat", 'w')
input_data = (fin.read().split())
exp_data = []
for i in range (len(input_data)):
    input_data[i] = two_comp_to_decimal(input_data[i])
    #input_data[i] = float(input_data[i])
    exp_data.append(exp(input_data[i]))


counter = 0
for i in range (len(input_data)):
    #fout.write(str( ( exp_data[i] / sum(exp_data[counter*16 : counter*16+16]) ) ) + " ")
    fout.write(str( decimal_to_bin( exp_data[i] / sum(exp_data[counter*16 : counter*16+16]) ) ) + " ")
    if(i == 15 or (i - 15) % 16 == 0): 
        fout.write('\n')
        counter = counter + 1
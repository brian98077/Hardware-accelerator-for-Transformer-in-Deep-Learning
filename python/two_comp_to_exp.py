import math
INPUT_WIDTH = 12   # 4 int + 8 frac
OUTPUT_WIDTH = -16  # 16 frac

# convert binary(4 bits integer + 8 bits fraction) to decimal
def two_comp_to_decimal(two_comp_num):
    position = 0
    result = 0
    while(position < INPUT_WIDTH):
        if(two_comp_num[position] == '1') : result += pow(2, 3 - position)
        position = position + 1

    return result 

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

fin = open("input_data.dat", 'r')
input_data = fin.read().splitlines()
data_size = len(input_data)
fin.close

fout_golden  = open("exp_golden.dat", 'w')
fout_decimal = open("exp_decimal.dat", 'w')

for i in range(data_size):
    num :int = input_data[i]
    one_comp_num :str = ""

    for i in range(len(num)):
        if(num[i] == '1'): one_comp_num += '0'
        else: one_comp_num += '1'

    two_comp_num_temp = bin(int(one_comp_num, 2) + 1)[2:]
    two_comp_num = two_comp_num_temp.rjust(INPUT_WIDTH,'0')
    decimal_num = two_comp_to_decimal(two_comp_num)
    fout_decimal.write(str("{:.8f}".format(math.exp(-1 * decimal_num))) + "\n")
    fout_golden.write(decimal_to_bin(math.exp(-1 * decimal_num)) + "\n")


fout_decimal.close
fout_golden.close
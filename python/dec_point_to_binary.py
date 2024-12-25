OUTPUT_WIDTH = -16

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
        if(position == -12 or position == -8 or position == -4):
            result += "_"
        position -= 1

    return result

input_num = input("decimal (<1) : ")
print(decimal_to_bin(float(input_num)))
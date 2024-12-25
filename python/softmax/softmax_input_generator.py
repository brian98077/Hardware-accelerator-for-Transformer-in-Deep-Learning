WIDTH = 12

# convert decimal point number to 2's complement (4 bits integer + 8 bits fraction)
def dec_to_two_comp(decimal_num):
    position = 3
    result = "1"
    partial_sub = decimal_num + pow(2, position)
    position -= 1

    while(position >= 3 + 1 - WIDTH):
        two_power = pow(2, position)
        if(partial_sub >= two_power):
            partial_sub -= two_power
            result += "1"
        else:
            result += "0"
        position -= 1

    return result

fin = open("softmax_input_origin.dat", 'r')
fout = open("softmax_input.dat", 'w')
input_data = (fin.read().split())

for i in range (len(input_data)):
    input_data[i] = float(input_data[i])
    fout.write(dec_to_two_comp(input_data[i]) + ' ')
    if(i == 15 or (i - 15) % 16 == 0): fout.write('\n')
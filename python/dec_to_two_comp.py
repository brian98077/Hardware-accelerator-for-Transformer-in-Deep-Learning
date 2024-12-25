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

input_num = input("decimal (<0) : ")
print(dec_to_two_comp(float(input_num)))
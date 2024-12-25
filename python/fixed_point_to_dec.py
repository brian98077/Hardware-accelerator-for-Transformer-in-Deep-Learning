# convert fixed point number (<1) to decimal

num = input("fixed point (<1): ")

position = 0
result = 0
underline = 0

while(position < len(num)):
    if(num[position] == '1') : result += pow(2, -position - 1 + underline)
    elif (num[position] == '_' or num[position] == 'b') : underline = underline + 1
    position = position + 1
print(result)
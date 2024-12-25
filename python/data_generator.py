f = open("input_data.dat", 'w')
data = 2048
while(data < 4096):
    f.write(bin(data)[2:] + "\n")
    data = data + 1
f.close
# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
import math
import numpy as np

def sigmoid(x):
    return 1 / (1 + math.exp(-x))

def bindigits(n, bits):
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    x_list = np.linspace(-5,5,259)
    frac_bits = 8
    ZERO = 0
    ONE = 2 ** frac_bits

    for i in range(len(x_list)):
        if i == 0:
            print("if int_x<" + str(int(x_list[0] * ONE)) + " then")
            print("\ty <= \"" + bindigits(-1*ONE, 16) + "\"; -- "+str(-1*ONE))
        elif i == (len(x_list) - 1):
            print("else")
            print("\ty <= \"" + '{0:016b}'.format(ONE) + "\"; -- "+str(ONE))
        else:
            print("elsif int_x<" + str(int(x_list[i] * ONE)) + " then")

            print("\ty <= \"" + bindigits(int(256 * math.tanh(x_list[i - 1])), 16) + "\"; -- "+str(int(256 * math.tanh(x_list[i - 1]))))


    print("end if;")
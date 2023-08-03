import struct
import random

def generate_random_float(start, end):
    return random.uniform(start, end)

# Input the range for the random float number
start_range = float(0.000000001)
end_range = float(1816531616)

def decimal_to_single_precision_binary(num):
    # Handle special cases
    if num == 0.0:
        return '0' * 32
    elif num == float('inf'):
        return '01111111100000000000000000000000'
    elif num == float('-inf'):
        return '11111111100000000000000000000000'
    elif num != num:  # Check if num is NaN
        return '01111111110000000000000000000000'

    # Get the sign bit
    if num < 0:
        sign_bit = '1'
        num = abs(num)
    else:
        sign_bit = '0'

    # Convert the float number to its 32-bit binary representation (big-endian)
    binary_representation = bin(struct.unpack('>I', struct.pack('>f', num))[0])[2:].zfill(32)

    # Add the sign bit to the binary representation
    binary_representation = sign_bit + binary_representation[1:]

    return binary_representation

def binary_to_hex(binary_string):
    # Ensure that the binary string has a length that is a multiple of 4
    padding = (4 - len(binary_string) % 4) % 4
    binary_string = '0' * padding + binary_string

    # Split the binary string into groups of 4 bits and convert each group to its hexadecimal representation
    hex_digits = [hex(int(binary_string[i:i+4], 2))[2:] for i in range(0, len(binary_string), 4)]

    # Join the hexadecimal digits and return the result
    return ''.join(hex_digits).upper()

def add_ieee754_single_precision(bin_num1, bin_num2):
    # Ensure that both binary numbers are 32 bits long
    bin_num1 = bin_num1.zfill(32)
    bin_num2 = bin_num2.zfill(32)

    # Separate the sign, exponent, and fraction parts of both numbers
    sign1 = int(bin_num1[0])
    sign2 = int(bin_num2[0])

    exponent1 = int(bin_num1[1:9], 2)
    exponent2 = int(bin_num2[1:9], 2)
    
    fraction1 = '1' + bin_num1[9:]
    fraction2 = '1' + bin_num2[9:]

    # Calculate the exponent difference to align the fractions
    exponent_diff = abs(exponent1 - exponent2)

    # Ensure that both fractions have the same length (shift the smaller one)
    if exponent1 > exponent2:
        fraction2 = '0' * exponent_diff + fraction2
        fraction2 = fraction2[0:24]
    else:
        fraction1 = '0' * exponent_diff + fraction1
        fraction1 = fraction1[0:24]
    

    # Add the fractions (treat sign separately for negatives)
    if sign1 == sign2:
        result_sign = sign1
        result_fraction = bin(int(fraction1, 2) + int(fraction2, 2))[2:]
    else:
        if int(fraction1, 2) >= int(fraction2, 2):
            result_sign = sign1
            result_fraction = bin(int(fraction1, 2) - int(fraction2, 2))[2:]
        else:
            result_sign = sign2
            result_fraction = bin(int(fraction2, 2) - int(fraction1, 2))[2:]

    # Calculate the new exponent for the result
    final_exponent = max(exponent1, exponent2)
    result_fraction = result_fraction.zfill(24)

    # Normalize the result fraction (remove the leading '1' and adjust the exponent)
    if (len(str(result_fraction)) > 24):
        result_fraction = result_fraction[0:24]
        final_exponent += 1
    else:
        for i in range(len(result_fraction)):
            if result_fraction.startswith('0'):
                result_fraction = result_fraction[1:]
                final_exponent -= 1

            else:
                break
    if result_fraction.startswith('1'):
        result_fraction = result_fraction[1:]
    result_fraction = result_fraction + '0'*23

    # Make sure the result fraction has at most 23 bits
    result_fraction = result_fraction[:23]

    # Pad the fraction to 23 bits if it is shorter
    result_fraction = result_fraction.zfill(23)

    # Convert the exponent to binary and ensure it has 8 bits
    final_exponent_binary = bin(final_exponent)[2:].zfill(8)


    # Combine the final parts to create the result IEEE 754 single precision binary number
    result = str(result_sign) + str(final_exponent_binary) + str(result_fraction)

    return result
    
def mult_ieee754_single_precision(bin_num1, bin_num2):
    # Ensure that both binary numbers are 32 bits long
    bin_num1 = bin_num1.zfill(32)
    bin_num2 = bin_num2.zfill(32)

    # Separate the sign, exponent, and fraction parts of both numbers
    sign1 = int(bin_num1[0])
    sign2 = int(bin_num2[0])

    exponent1 = int(bin_num1[1:9], 2)
    exponent2 = int(bin_num2[1:9], 2)
    
    fraction1 = '1' + bin_num1[9:]
    fraction2 = '1' + bin_num2[9:]

    final_exponent = exponent1 + exponent2 - 127

    result_fraction = bin(int(fraction1, 2) * int(fraction2, 2))[2:]

    if sign1 == sign2:
        result_sign = 0
    else:
        result_sign = 1

    if (len(str(result_fraction)) == 48):
        result_fraction = result_fraction[0:25]
        final_exponent += 1
    else:
        result_fraction = result_fraction[0:25]

    if result_fraction.startswith('1'):
        result_fraction = result_fraction[1:]
    result_fraction = result_fraction + '0'*23

    result_fraction = result_fraction[:23]

    result_fraction = result_fraction.zfill(23)

    # Convert the exponent to binary and ensure it has 8 bits
    final_exponent_binary = bin(final_exponent)[2:].zfill(8)

    # Combine the final parts to create the result IEEE 754 single precision binary number
    result = str(result_sign) + str(final_exponent_binary) + str(result_fraction)
    return result

file1 = open("a.txt", "w")
file1 = open("b.txt", "w")
file1 = open("sum.txt", "w")
file1 = open("mult.txt", "w")

for i in range(100):
    a = decimal_to_single_precision_binary(float(generate_random_float(start_range, end_range)))
    b = decimal_to_single_precision_binary(float(generate_random_float(start_range, end_range)))

    file1 = open("a.txt", "a")
    file1.write(str(binary_to_hex(a)))
    file1.write("\n")
    file1.close()

    file1 = open("b.txt", "a")
    file1.write(str(binary_to_hex(b)))
    file1.write("\n")
    file1.close()

    file1 = open("sum.txt", "a")
    file1.write(str(binary_to_hex(add_ieee754_single_precision(a,b))))
    file1.write("\n")
    file1.close()

    file1 = open("mult.txt", "a")
    file1.write(str(binary_to_hex(mult_ieee754_single_precision(a,b))))
    file1.write("\n")
    file1.close()

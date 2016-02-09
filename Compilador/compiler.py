from os import listdir
from os.path import isfile, join
from instruction_generator import asm_to_binary
from instruction_generator import dec_to_binary


def parse_instruction(instruction):
    fields = instruction.split()
    instruction_name = fields.pop(0)
    function = getattr(asm_to_binary, 'generate_' + instruction_name.lower())
    return function(fields)


def read_file(filename):
    assembler = open("assembler/" + filename, 'r')
    lines = assembler.read().split("\n")
    assembler.close()
    return lines


if __name__ == "__main__":
    print ("WELCOME TO THE MIPS COMPILER")

    print ("\nThe sources in the assembler directory are:")
    files = [f for f in listdir("assembler/") if isfile(join("assembler/", f))]
    index = 1;
    for file in files:
        print(str(index) + ") " + files[index-1])
        index += 1
    index = raw_input("Please, chose a file to compile: ")

    print ("\nReading assembler file...")
    instructions = read_file(files[int(index)-1])

    print ("Compiling...")
    binary = open("result/" + (files[int(index)-1])[:-4] + ".coe", 'w')
    binary.write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")
    for i in range(0, instructions.__len__()):
        binary.write(parse_instruction(instructions[i]))
        if i == instructions.__len__()-1:
            binary.write(";")
        else:
            binary.write(",\n")
    binary.close()

    print ("The compilation process was successfully completed..!")

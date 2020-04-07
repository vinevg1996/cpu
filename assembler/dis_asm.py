#!/usr/bin/python

import sys
in_f = open(sys.argv[1], 'r')
out_f = open('../mem_content.list', 'w')

def parse_R_type(line, out_f):
    reg1 = int(line[1][1])
    reg1_str = "{0:{fill}5b}".format(reg1, fill='0')
    out_f.write(reg1_str)
    reg2 = int(line[2][1])
    reg2_str = "{0:{fill}5b}".format(reg2, fill='0')
    out_f.write(reg2_str)
    reg3 = int(line[3][1])
    reg3_str = "{0:{fill}5b}".format(reg3, fill='0') 
    out_f.write(reg3_str)
    out_f.write("00000")
    return

def parse_I_type(line, out_f):
    #reg1 = int(line[1][1])
    reg1 = int(line[2][1])
    reg1_str = "{0:{fill}5b}".format(reg1, fill='0')
    out_f.write(reg1_str)
    #reg2 = int(line[2][1])
    reg2 = int(line[1][1])
    reg2_str = "{0:{fill}5b}".format(reg2, fill='0')
    out_f.write(reg2_str)
    IMM = int(line[3])
    reg3_str = "{0:{fill}16b}".format(IMM, fill='0')
    out_f.write(reg3_str)
    return

def parse_J_type(line, out_f):
    ADDR = int(line[1])
    ADDR_str = "{0:{fill}26b}".format(ADDR, fill='0')
    out_f.write(ADDR_str)
    return

for line in in_f:
    words = line.split(" ");
    #print words[0]
    if words[0] == "add":
        out_f.write("000000")
        parse_R_type(words, out_f)
        out_f.write("100000")
    elif words[0] == "sub":
        out_f.write("000000")
        parse_R_type(words, out_f)
        out_f.write("100010")
    elif words[0] == "addi":
        out_f.write("001000")
        parse_I_type(words, out_f)
    elif words[0] == "lw":
        out_f.write("100011")
        parse_I_type(words, out_f)
    elif words[0] == "sw":
        out_f.write("101011")
        parse_I_type(words, out_f)
    elif words[0] == "beq":
        out_f.write("000100")
        parse_I_type(words, out_f)
    elif words[0] == "jump":
        out_f.write("000010")
        parse_J_type(words, out_f)
    elif line == "nop\n":
        out_f.write("11111100000000000000000000000000")
    out_f.write("\n")


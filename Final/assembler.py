#!/usr/bin/env python

from turtle import end_fill

def operation_conversion(operation):
    if operation == ['A', 'D', 'D']:
        mc_operation = '000'
    if operation == ['A', 'N', 'D']:
        mc_operation = '001'
    if operation == ['N', 'O', 'T']:
        mc_operation = '010'
    if operation == ['S', 'L', 'T']:
        mc_operation = '011'
    if operation == ['S', 'T', 'U', 'R']:
        mc_operation = '100'
    if operation == ['L', 'O', 'A', 'D']:
        mc_operation = '101'
    return mc_operation

def register_conversion(register):
    if register == ['X', '0']:
        mc_register = '000'
    if register == ['X', '1']:
        mc_register = '001'
    if register == ['X', '2']:
        mc_register = '010'
    if register == ['X', '3']:
        mc_register = '011'
    if register == ['X', '4']:
        mc_register = '100'
    if register == ['X', '5']:
        mc_register = '101'
    if register == ['X', '6']:
        mc_register = '110'
    if register == ['X', '7']:
        mc_register = '111'
    return mc_register

def shamt_conversion(shamt):
    if shamt == ['0']:
        mc_shamt = '000'
    if shamt == ['1']:
        mc_shamt = '001'
    if shamt == ['2']:
        mc_shamt = '010'
    if shamt == ['3']:
        mc_shamt = '011'
    if shamt == ['4']:
        mc_shamt = '100'
    if shamt == ['5']:
        mc_shamt = '101'
    if shamt == ['6']:
        mc_shamt = '101'
    if shamt == ['7']:
        mc_shamt = '111'
    return mc_shamt

file1 = open("myfile.txt","r+") 

count = len(open("myfile.txt").readlines(  ))
arr = ['']*(count+1)

for i in range (0, count+1):
    arr[i] = file1.readline() 
file1.close()

file2 = open("Machine Code.txt", "w")
for i in range (0, len(arr)-1):
    instr_length = len(arr[i]) #The length of each instruction in assembly
    instruction = arr[i]
    print(instr_length)
    #for j in range (0, instr_length):
    j = 0
    operation = []
    reg_destination = []
    reg_source_1 = []
    reg_source_2 = []
    shamt = []
    #This part will break up the instruction into opcode, destination register, and source register(s)
    while(instruction[j] != ' '):
        operation.append(instruction[j])
        j = j + 1
    print(operation)
    print(operation_conversion(operation))
    j = j + 1
    while(instruction[j] != ' '):
        reg_destination.append(instruction[j])
        j = j + 1
    print(reg_destination)
    print(register_conversion(reg_destination))
    j = j + 1
    
    while(instruction[j] != ' '):
        reg_source_1.append(instruction[j])
        j = j + 1
    print(reg_source_1)
    print(register_conversion(reg_source_1))
    j = j + 1
    
    while(instruction[j] != ' '):
        reg_source_2.append(instruction[j])
        j = j + 1
    print(reg_source_2) 
    print(register_conversion(reg_source_2))
    j = j + 1
    print (j)
    print (instruction[j])
    while(instruction[j] != ' '):
        shamt.append(instruction[j])
        j = j + 1
    print(shamt) 
    print(shamt_conversion(shamt))
    MachineCodeLine = operation_conversion(operation)+register_conversion(reg_destination)+register_conversion(reg_source_1)+register_conversion(reg_source_2)+shamt_conversion(shamt)
    file2.write(MachineCodeLine + "\n")
print (arr)
file2.close()
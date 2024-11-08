.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp sp -128
    sw ra 0(sp)
    sw a0 4(sp)
    sw a1 8(sp)
    sw a2 12(sp) # number of mode
    li a1 5
    bne a0 a1 error_arg
    lw a1 8(sp)
    # Read pretrained m0
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 16(sp) # row of m0
    lw ra 0(sp)
    
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 20(sp) # col of m0
    mv a2 a0
    lw ra 0(sp)
    lw a1 8(sp)
    lw a0 4(a1)
    lw a1 16(sp)
    
    sw ra 0(sp)
    jal read_matrix
    lw ra 0(sp)
    sw a0 24(sp) # pointer to m0
    


    # Read pretrained m1
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 28(sp) # row of m1
    lw ra 0(sp)
    
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 32(sp) # col of m1
    mv a2 a0
    lw ra 0(sp)
    lw a1 8(sp)
    lw a0 8(a1)
    lw a1 28(sp)
    
    sw ra 0(sp)
    jal read_matrix
    lw ra 0(sp)
    sw a0 36(sp) # pointer to m1


    # Read input matrix
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 40(sp) # row of input
    lw ra 0(sp)
    
    li a0 4
    jal malloc
    beq a0 x0 error_malloc
    sw a0 44(sp) # col of input
    mv a2 a0
    lw ra 0(sp)
    lw a1 8(sp)
    lw a0 12(a1)
    lw a1 40(sp)
    
    sw ra 0(sp)
    jal read_matrix
    lw ra 0(sp)
    sw a0 48(sp) # pointer to input


    # Compute h = matmul(m0, input)
    lw a1 16(sp)
    lw a2 0(a1)
    mv a1 a2
    lw a5 44(sp)
    lw a2 0(a5)
    mv a5 a2
    li a0 4
    mul a0 a0 a1
    mul a0 a0 a5
    sw ra 0(sp)
    jal malloc
    beq a0 x0 error_malloc
    lw ra 0(sp)
    mv a6 a0
    sw a6 52(sp) # pointer to h = matmul(m0, input)
    
    lw a0 24(sp)
    lw a1 16(sp)
    lw t1 0(a1)
    mv a1 t1
    lw a2 20(sp)
    lw t1 0(a2)
    mv a2 t1
    lw a3 48(sp)
    lw a4 40(sp)
    lw t1 0(a4)
    mv a4 t1
    lw a5 44(sp)
    lw t1 0(a5)
    mv a5 t1
    sw ra 0(sp)
    jal matmul
    lw ra 0(sp)


    # Compute h = relu(h)
    lw a0 52(sp)
    lw a1 16(sp)
    lw a2 0(a1)
    mv a1 a2
    lw a5 44(sp)
    lw a2 0(a5)
    mv a5 a2
    mul a1 a1 a5
    sw ra 0(sp)
    jal relu
    lw ra 0(sp)


    # Compute o = matmul(m1, h)
    lw a1 28(sp)
    lw a2 0(a1)
    mv a1 a2
    lw a5 44(sp)
    lw a2 0(a5)
    mv a5 a2
    li a0 4
    mul a0 a0 a1
    mul a0 a0 a5
    sw ra 0(sp)
    jal malloc
    beq a0 x0 error_malloc
    lw ra 0(sp)
    mv a6 a0
    sw a6 56(sp) # pointer to o = matmul(m1, h)
    


    # Write output matrix o
    
    lw a0 36(sp)
    lw a1 28(sp)
    lw t1 0(a1)
    mv a1 t1
    lw a2 32(sp)
    lw t1 0(a2)
    mv a2 t1
    lw a3 52(sp)
    lw a4 16(sp)
    lw t1 0(a4)
    mv a4 t1
    lw a5 44(sp)
    lw t1 0(a5)
    mv a5 t1
    sw ra 0(sp)
    jal matmul
    lw ra 0(sp)
    
    lw a1 8(sp)
    lw a0 16(a1)
    lw a1 56(sp)
    lw a2 28(sp)
    lw t1 0(a2)
    mv a2 t1
    lw a3 44(sp)
    lw t1 0(a3)
    mv a3 t1
    sw ra 0(sp)
    jal write_matrix
    lw ra 0(sp)
    


    # Compute and return argmax(o)
    lw a0 56(sp)
    lw a1 16(sp)
    lw t1 0(a1)
    mv a1 t1
    lw a2 44(sp)
    lw t1 0(a2)
    mv a2 t1
    mul a1 a1 a2
    sw ra 0(sp)
    jal argmax
    lw ra 0(sp)
    sw a0 60(sp)
    lw a2 12(sp)
    beq a2 x0 print_argmax
    j free_data

    # If enabled, print argmax(o) and newline
print_argmax:
    sw ra 0(sp)
    jal print_int
    lw ra 0(sp)
    j print_new_line
    
print_new_line:
    li a0 '\n'
    sw ra 0(sp)
    jal print_char
    lw ra 0(sp)
    j free_data
    
free_data:    
    lw a0 16(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 20(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 28(sp)
    sw ra 0(sp)
    jal free 
    lw ra 0(sp)
    
    lw a0 32(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 40(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 44(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 52(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 56(sp)
    sw ra 0(sp)
    jal free
    lw ra 0(sp)
    
    lw a0 60(sp)
    addi sp sp 128
    jr ra
    
error_malloc:
    li a0 26
    addi sp sp 128
    j exit

error_arg:
    li a0 31
    addi sp sp 128
    j exit
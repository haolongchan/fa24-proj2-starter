.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    # open file
    addi sp sp -28
    sw a1 8(sp)
    sw a2 12(sp)
    addi a1 x0 0
    sw ra 0(sp)
    jal fopen
    addi a1 x0 -1
    beq a0 a1 error_fopen
    sw a0 4(sp)
    lw ra 0(sp)
    
    #read row
    addi a2 x0 4
    lw a1 8(sp)
    sw ra 0(sp)
    jal fread
    addi a2 x0 4
    bne a0 a2 error_fread
    lw a0 4(sp)
    lw ra 0(sp)
    
    # read column
    lw a1 12(sp)
    sw ra 0(sp)
    jal fread
    addi a2 x0 4
    bne a0 a2 error_fread
    lw a0 4(sp)
    lw ra 0(sp)
    
    # malloc
    lw a1 8(sp)
    lw a2 12(sp)
    lw t1 0(a1)
    lw t2 0(a2)
    li a2 4
    mul a3 t1 t2
    mul a0 a3 a2
    sw ra 0(sp)
    sw a3 20(sp)
    jal malloc
    beq a0 x0 error_malloc
    mv a1 a0
    sw a0 24(sp)
    lw a0 4(sp)
    lw a3 20(sp)
    lw ra 0(sp)
    
    #read matrix
    j loop_start
    

    
loop_start:
    addi a3 a3 -1
    blt a3 x0 loop_end
    addi a2 x0 4
    sw a1 16(sp)
    sw a3 20(sp)
    sw ra 0(sp)
    jal fread
    addi a2 x0 4
    bne a0 a2 error_fread
    lw a1 16(sp)
    lw a3 20(sp)
    lw a0 4(sp)
    lw ra 0(sp)
    addi a1 a1 4
    j loop_start


loop_end:
    sw ra 0(sp)
    jal fclose
    bne a0 x0 error_fclose
    lw ra 0(sp)
    lw a0 24(sp)
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 28
    
    # Epilogue

    jr ra


error_malloc:
    li a0 26
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 28
    j exit

error_fopen:
    li a0 27
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 28
    j exit

error_fclose:
    li a0 28
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 28
    j exit

error_fread:
    li a0 29
    lw a1 8(sp)
    lw a2 12(sp)
    addi sp sp 28
    j exit

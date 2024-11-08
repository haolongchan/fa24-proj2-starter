.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -32
    sw ra 20(sp)
    sw a1 4(sp)
    sw a2 8(sp)
    sw a3 12(sp)
    li a1 1
    jal fopen
    li a1 -1
    beq a0 a1 error_open
    sw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    lw ra 20(sp)
    addi a1 sp 8
    li a2 1
    li a3 4
    sw ra 20(sp)
    jal fwrite
    li a2 1
    bne a0 a2 error_write
    lw ra 20(sp)
    lw a0 0(sp)
    addi a1 sp 12
    li a2 1
    li a3 4
    sw ra 20(sp)
    jal fwrite
    li a2 1
    bne a0 a2 error_write
    lw ra 20(sp)
    lw a0 0(sp)
    lw a1 4(sp)
    lw a2 8(sp)
    lw a3 12(sp)
    
    mul a4 a2 a3
    mv a2 a4
    li a3 4
    sw a2 16(sp)
    sw ra 20(sp)
    jal fwrite
    lw a2 16(sp)
    bne a0 a2 error_write
    lw ra 20(sp)
    lw a0 0(sp)
    sw ra 20(sp)
    jal fclose
    bne a0 x0 error_close
    lw ra 20(sp)
    addi sp sp 32
    # Epilogue


    jr ra


error_open:
    li a0 27
    j exit

error_write:
    li a0 30
    j exit


error_close:
    li a0 28
    j exit






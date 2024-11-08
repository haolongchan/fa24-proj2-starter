.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t1 x0 1
    blt a1 t1 error_length
    blt a2 t1 error_length
    blt a4 t1 error_length
    blt a5 t1 error_length
    bne a2 a4 error_equal

    # Prologue
    mv t1 a1 # t1 stores row of first matrix
    mv t5 a5 # t2 stores column of second matrix
    mv t3 a3
    mv t0 a0
    mv a1 a3
    mv t6 a6
    # value of a4 should be a5
    mv a4 a5
    addi t2 x0 4
    mul t4 a2 t2
    addi a3 x0 1
    j outer_loop_start
    
error_length:
    li a0 38
    j exit

error_equal:
    li a0 38
    j exit

outer_loop_start:
    addi t1 t1 -1
    blt t1 x0 outer_loop_end
    mv a1 t3
    j inner_loop_start

inner_loop_start:
    addi a5 a5 -1
    blt a5 x0 inner_loop_end
    addi sp sp -32
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    sw t3 12(sp)
    sw t4 16(sp)
    sw t5 20(sp)
    sw t6 24(sp)
    sw ra 28(sp)
    call dot
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)
    lw t5 20(sp)
    lw t6 24(sp)
    lw ra 28(sp)
    addi sp sp 32
    sw a0 0(a6)
    addi a6 a6 4
    mv a0 t0
    addi a1 a1 4
    j inner_loop_start


inner_loop_end:
    mv a5 t5
    add t0 t0 t4
    mv a0 t0
    mv a1 t2
    j outer_loop_start


outer_loop_end:
    mv a6 t6

    # Epilogue


    jr ra

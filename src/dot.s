.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    addi t1 x0 1
    blt a2 t1 number_error
    blt a3 t1 stride_error
    blt a4 t1 stride_error
    mv t2 a2
    mv t3 a3
    mv t4 a4
    addi t5 x0 0 # store the answer
    addi t1 x0 4
    mul a3 a3 t1
    mul a4 a4 t1
    mv t1 a1
    j loop_start

number_error:
    li a0 36
    j exit

stride_error:
    li a0 37
    j exit

loop_start:
    addi a2 a2 -1
    blt a2 x0 loop_end
    lw t6 0(a0)
    lw t0 0(a1)
    mul t6 t6 t0
    add t5 t5 t6
    add a0 a0 a3
    add a1 a1 a4
    j loop_start

loop_end:
    mv a0 t5
    mv a1 t1
    mv a2 t2
    mv a3 t3
    mv a4 t4
    # Epilogue


    jr ra

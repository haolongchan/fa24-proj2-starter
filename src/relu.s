.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi a2, x0, 1
    blt a1, a2, Label
    mv a2, a1 # a0 + a2 points to the end of the array
    j loop_start

Label:
    li a0 36
    j exit

loop_start:
    addi a1, a1, -1 # address of a2 shifts
    blt a1, x0, loop_end # check
    lw a5, 0(a0)
    blt a5, x0, loop_continue
    addi a0, a0, 4
    j loop_start



loop_continue:
    addi a5, x0, 0
    sw a5, 0(a0)
    addi a0, a0, 4
    j loop_start


loop_end:
    addi a3, x0, 4
    mul a3, a3, a1
    sub a0, a0, a3

    # Epilogue


    jr ra

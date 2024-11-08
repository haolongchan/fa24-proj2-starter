.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi a2 x0 1
    blt a1 a2 exception
    addi a7 a1 -1
    addi a3 x0 4 # a3 is multiplier
    mul a7 a7 a3
    add a0 a0 a7 # reaches the bottom of container
    lw a3 0(a0)
    addi a6 a1 -1 
    mv a4 a3 # a4 represents the maxinmun number
    add a5 x0 a6 # a5 represents the index of the max num
    j loop_start

exception:
    li a0 36
    j exit

loop_start:
    addi a1 a1 -1
    lw a3 0(a0) # a3 is the value of a0
    blt a1 x0 loop_end
    blt a4 a3 loop_continue
    addi a0 a0 -4
    addi a6 a6 -1
    j loop_start


loop_continue:
    mv a5 a6
    mv a4 a3
    addi a6 a6 -1
    addi a0 a0 -4
    j loop_start

loop_end:
    mv a0 a5
    # Epilogue

    jr ra

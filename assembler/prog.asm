addi r1 r0 1
sw r1 r0 0
lw r2 r0 0
beq r1 r2 2
addi r3 r0 4
addi r3 r0 5
addi r3 r0 6
jump 9
addi r3 r0 8
addi r2 r0 9
beq r1 r2 4
addi r3 r0 11
jump 14
addi r3 r0 13
addi r3 r0 14
add r1 r2 r3

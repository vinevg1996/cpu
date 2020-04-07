addi r1 r0 3
sw r1 r0 0
lw r2 r0 0
beq r1 r2 2
addi r3 r0 4
addi r3 r0 5
jump 8
addi r3 r0 7
addi r3 r0 8
beq r1 r2 4
addi r3 r0 10
jump 14
addi r3 r0 12
addi r3 r0 13
nop
add r1 r2 r3

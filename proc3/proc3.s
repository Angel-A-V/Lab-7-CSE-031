.data
x: .word 2
y: .word 4
z: .word 6

stringfoo: .asciiz "p + q: "
newline: .asciiz "\n"

.text
main:
	la $t0, x
	lw $s0, 0($t0) # lw the value stored in the register with an offset of 0
	la $t1, y
	lw $s1, 0($t1)
	la $t2, z
	lw $s2, 0($t2)
	
	move $a0, $s0 # x
	move $a1, $s1 # y
	move $a2, $s2 # z
	jal foo
	
	addu $t0, $s1, $s0
	addu $t0, $s2, $t0
	addu $t0, $t0, $v0
	addu $a0, $zero, $t0
	
	li $v0, 1        
	syscall    
	j end
	
	
foo:	# foo for int p bar
	addi $sp, $sp, -24 # Allocate 16 bytes on the stack we do negative because the stack grows donward
	sw $a0, 0($sp)	# save $s0 at the offset 0($sp)
	sw $a1, 4($sp)	# save $s1 at the offset 4($sp)
	sw $a2, 8($sp)	# save $s2 at the offset 8($sp)
	sw $s0, 12($sp)
	sw $s1, 16($sp)
	sw $ra, 20($sp) # save the return address at the offset 20($sp)
	
	# Calculate  p = bar(x,y,z)
	addu $t0, $a0, $a2 # x + z
   	addu $t1, $a1, $a2 # y + z
   	addu $t2, $a0, $a1 # x + y
   
   	move $a0, $t0 # m
	move $a1, $t1 # n
	move $a2, $t2 # o
   	
   	jal bar
   	addu $s0, $zero, $v0	
   	
 	# foo for int q bar
 	lw $a0, 0($sp)	# Restore x
 	lw $a1, 4($sp)	# Restore y
 	lw $a2, 8($sp)	# Restore z
	
	subu $t0, $a0, $a2 # x - z
	subu $t1, $a1, $a0 # y - x
    	addu $t2, $a1, $a1 # y + y
    	
    	move $a0, $t0 # m
	move $a1, $t1 # n
	move $a2, $t2 # o
    	
    	jal bar
    	
    	addu $s1, $zero, $v0	# Save result of q in $s1
    	la $a0, stringfoo
    	li $v0, 4
    	syscall
	
	addu $v1, $s0, $s1 # $v0 = p + q
	addu $a0, $zero, $v1
	
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	# Restore the stack
	lw $ra, 20($sp)     # Restore $ra
	lw $s1, 16($sp)      # Restore $a1
	lw $s0, 12($sp)      # Restore $a0
	addi $sp, $sp, 24   # Deallocate the stack space
	addu $v0, $zero, $v1
	jr $ra              # Return
   
bar:
	subu $t0, $a1, $a0 	# b - a
	sllv $t0, $t0, $a2 	#  (b - a) < c
	move $v0, $t0		# Store result in $v0
	jr $ra			# Return
	
end:

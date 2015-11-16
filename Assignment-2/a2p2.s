 /*Lamess Kharfan          Student Number: 10150607
CPSC 355, Fall 2015     Leonard Manzara
Assignment 2 - Part A. Create a multiplier that completes 3 different 
multiplications:
	positive and positive
	positive and negative
	negative and negative
by following the algorithm:
negative = multiplier >= 0 ? 0 : 1;
product = 0;
for(i=0; i < 32; i++) {
	if(multiplier & 1)
		product += multiplicand;
	(product and multiplier as a unit) >> 1;
	}
if(negative)
	product -= multiplicand;	 
Prints the initial product, multiplier, and multiplicand
at the beginning of each multiplication, and the final 
multiplier, product and multiplicand at the end of each
multiplication, all in hexadecimal.

Version 1- No use of macros and m4. Part A.
*/



product1:	.asciz 		"The initial product is: %x\n"
		.align 4 
product2:	.asciz		"The final product is: %x\n"
		.align 4
multiplier1: 	.asciz		"The initial multipler is: %x \n"
		.align 4
multiplier2:	.asciz		"The final multiplier is: %x \n" 
		.align 4
multcand1:	.asciz		"The initial multiplicand is: %x \n\n"
		.align 4
multcand2: 	.asciz 		"The final multiplicand is: %x\n\n"
		.align 4
.global main

main:
	save	%sp, -96, %sp

	mov	-1, %l3			! Initialize bit tracker to 0
	set 	0x04ee67b7, %l2		! Set multiplicand for set 1
	set 	0x072e8b8c, %l1		! Set multiplier for set 1
	mov 	0, %l0			! Initialize product register
	mov	1, %l5			! Initialize set tracker to 1

	set 	product1, %o0		! Put the initial product string into %o0
	call	printf			! Print initial product value to screen
	mov     %l0, %o1                ! Put value of product into %o1

	set	multiplier1, %o0	! Put initial multipier string into %o0
	call 	printf			! Print value of multiplier to the screen
	mov     %l1, %o1                ! Put value of multiplier into %o1
	
	set	multcand1, %o0		! Put the initial multiplicand value into %o0
	call	printf			! Print val of initial multiplicand to screen
	mov     %l2, %o1                ! Put the val of initial multiplicand into %o1

	ba	loop			! Always branch to the loop
	srl     %l1, 31, %l4            ! Isolate bit in multiplier that determines negatives

iftest: 

	and	%l1, 1, %o0		! and the multiplier with 1, store into %o0, isolates right most bit
	cmp	%o0, 1			! Compare the result of the and with 1 to see if the last bit is a 1
	bne	shifter			! Branch to Shifter when the bit isnt a one
	nop
	add	%l0, %l2, %l0		! If the rightmost bit is 1, add multiplicand to product, store in product register %l0


shifter:
	and	%l0, 1, %o1		! and product with 1 to isolate rightmost bit, store in %o1
	srl	%l1, 1, %l1		! Shift multiplier over by 1 bit
	sll	%o1, 31, %o1		! Move bit in %o1 over to position 31 to or with position 31 multiplier
	or	%o1, %l1, %l1		! or register %o1 with multipplier. 0 or 1 = 1 and 0 or 0 = 0, place or result in position 1 of multiplier
	sra	%l0, 1, %l0		! Move product register over 1

loop:
	add	%l3, 1, %l3		! Add 1 to the bit tracker
	cmp	%l3, 32			! While the bit tracker is still less than 32
	bl	iftest			! Branch to if test
	nop
	cmp	%l4, 1			! Compare %l4 with 1 to see if the multiplier is negative
	bne	printReset		! If it isn't negative branch to print and reset label
	nop
	sub	%l0, %l2, %l0		! If it is negative, product -= product

printReset:
	
	set	product2, %o0		! Put the string for final product into %o0
	call	printf			! Print value of final product to the screen
	mov	%l0, %o1		! Move value of final product into %o1

	set	multiplier2, %o0	! Put final multplier string into %o0
	call	printf			! Print value of multiplier to the screen
	mov	%l1, %o1		! Move value of final multiplier into %o1

	set	multcand2, %o0		! Put final multiplicand value into %o0
	call	printf			! Print value of final multiplicand to the screen
	mov	%l2, %o1		! Put value of final multiplicand into %o1

	add	%l5, 1, %l5		! Add one to the set  counter 

	mov	0, %l0			! Set the product to zero

	cmp	%l5, 2			! Compare the set counter to 2
	be	posneg			! If it's equal to 2, do the positive negative multiplcation
	mov     -1, %l3                 ! Set the bit tracker to 0

	cmp	%l5, 3			! Compare the set counter to 3
	be	negneg			! If it is equal to 3, do the negative negative multiplication
	nop

	ba	end			! End of the program has been reached, go to exit request			
	nop

posneg:

	set	0x04ee67b7, %l2		! Set multiplicand for set 2
	set 	0xf8d17474, %l1		! Set multiplier for set 2

	set     product1, %o0           ! Set the initial product string into %o0
        call    printf                  ! Print the initial value of the product
        mov     %l0, %o1                ! Move the value of the product into %o1

	set     multiplier1, %o0        ! Set the initial multiplier string into %o0
        call    printf                  ! Print the initial value of the multiplier
        mov     %l1, %o1                ! Move the value of the multiplier into %o1

	set     multcand1, %o0          ! Set the initial multiplicand string into %o0
        call    printf                  ! Print the initial value of the muliplicand to the screen
        mov     %l2, %o1                ! Move the initial value of the multiplicand to %o1
	
	!srl	%l1, 31, %l4		! Isolate first bit of multiplier to detemrine if it's negative
		
	ba 	loop			! Always branch to loop
	srl     %l1, 31, %l4            ! Isolate first bit of multiplier to detemrine if it's negative

negneg: 
	set	0xfb119849, %l2		! Set multiplicand for set 3
	set	0xf8d17474, %l1		! Set multiplier for set 3

	set	product1, %o0		! Set initial product string into %o0
	call	printf			! Print the initial value of the product to the screen
	mov	%l0, %o1		! Move value of initial prodduct into %o1
	
	set	multiplier1, %o0	! Set initial multiplier string into %o0
	call	printf			! Print initial value of multiplier to the screen
	mov	%l1, %o1		! Move initial value of multipler into %o1
	

	set	multcand1, %o0		! Set initial multiplicand value string into %o0
	call	printf			! Print value of initial multiplicand to the screen
	mov	%l2, %o1		! Set inital value of multiplicand into %o1

	!srl	%l1, 31, %l4		! Isolate first bit of multiplier to determine negative
	ba 	loop			! Always branch to beginning of loop
	srl     %l1, 31, %l4            ! Isolate first bit of multiplier to determine negative


end:
	mov	1, %g1
	ta	0	

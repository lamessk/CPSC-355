/*
 /*Lamess Kharfan         Student Number: 10150607
 CPSC 355, Fall 2015     Leonard Manzara
 Assignment 2 - Part A. Create a 16 bit CCITT-CRC.
 Initialized to contain all 1's, the CCITT-CRC takes input
from 4 registers:
	%l4: 0xaaaa8c01
	%l5: 0xff001234
	%l6: 0x13579bdf
	%l7: 0xc8b4ae32
and loops through them from bit 31 to 0,(128 bits total). After printing
all of the initial values of inputs and the checksum, the program branches
to a loop to check if we are still at a bit below 32, then branches to a 
shifter which shifts the checksum left, takes the current bit being analyzed, 
shifts it into position 0 of the checksum, and if bit 15 of the checksum was a 1,
performs a xor on the checksum at 3 different points. (repeated for all bits).
The final checksum is then printed at the end of the program, which is expected to
be 0x668b after processing all 128 bits, stored in register %l0.
Version 1, Part B - no use of m4. 
*/

fmtChek1:	.asciz		"\nThe initial checksum is: 0x%x\n"	! String for initial checksum
		.align 4
fmtChek2:	.asciz		"\nThe final checksum is: 0x%x\n"	! String for final checksum
		.align 4
fmtIn:		.asciz 		"The data input is: 0x%x\n"		! String for inputs for checksum
		.align 4

/*
%l0 - checksum register
%l1 - temporary register
%l2 - bit tracker
%l3 - Registers tracker
%l4 - input data
%l5 - input data
%l6 - input data
%l7 - input data   */
.global main

main: 
	save %sp, -96, %sp

	/* Set all registers to have their specified inputs and output register */
	set	0xaaaa8c01, %l4		                  ! Input for %l4
	set	0xff001234, %l5		                  ! Input for %l5
	set 	0x13579bdf, %l6		                ! Input for %l6
	set	0xc8b4ae32, %l7		                  ! Input for %l7
	set	0xffffffff, %l0		                  ! Set checksum to all 1's residing in %l0
	mov	%l4, %l1		                        ! Temporary register for input values
	mov	1, %l3			                        ! Create a registers tracker
 	

	/* Use only the low order (First 16 bits of %l0) */
	set	0x0000ffff, %o0		                  ! Create bit mask for using only first 16 bits
	and	%l0, %o0, %l0		                    ! Use bit make to turn all 0's past bit 15 into 0
	
	/*Print initial checksum value*/
	set	fmtChek1, %o0	                    	! Move format string for initial CS to %o0
	call	printf			                      ! Print value of checksum to the screen
	mov     %l0, %o1                        ! Move checksum into %o1
	
	/*Print initial input value from %l4*/
	set	fmtIn, %o0                          ! Move format string for input into %o0
    	call    printf                      ! Print value of input in %l4 to screen
     	mov     %l4, %o1                    ! Move input in %l4 into %o1

	/*Print initial input value from %l5 */
	set	fmtIn, %o0		                      ! Move format string into %o0
	call	printf		                      	! Print input value in %l5 to screen
	mov     %l5, %o1                        ! Move input value in %l5 to %o1

	/*Print input value in %l6 */
	set 	fmtIn, %o0		                    ! Move format string into %o0
	call	printf		                      	! Print input value in %l6 to the screen
	mov     %l6, %o1                        ! Move value of %l6 into %o1
	
	/* Print input value in %l7 */
	set	fmtIn, %o0		                      ! Move format string into %o0
	call	printf	                      		! Print input value in %l7 to screen
	mov     %l7, %o1                        ! Move input value in %l7 into %o1
	
	ba 	loop	                          		! Always branch to the loop
	mov     0, %l2                          ! Create a bit tracker


shifter:

	mov	%l0, %o0                        		! Move the checksum into %o0
	srl	%o0, 15, %o2		                    ! Move the checksum right 15 bits to isolate bit 15
	and	%o2, 0x1, %o2		                    ! and bit 15 and 1 to check if the bit was a 1 or 0, store in %o2 

	mov	%l1, %o0		                        ! Move the input value into %o0
	srl	%o0, 31, %o0		                    ! Shift the input balue over 31 bits to isolate the 31st bit
	sll	%l0, 1, %l0		                      ! Shift the checksum left by 1 bit to make room for incoming data
	or	%l0, %o0, %l0		                    ! Move the incoming data into position 0 of the checksum

	cmp	%o2, 1			                        ! Compare bit 15 of the checksum to one
	bne	addOne		                        	! If the bit is not a one, add one to the bit tracker
	sll     %l1, 1, %l1                     ! Move input value 1 to the left to move onto the next bit

	set	0x1021, %o0	                       	! If the bit was a one, create a bitmask that matches the checksum
	xor	%l0, %o0, %l0		                    ! xor the checksum bitmask with the checksum to account for xor gates

addOne:	
	add	%l2, 1, %l2		                      ! Add one to the bit tracker
	
	
loop:

	cmp	%l2, 31		                            	! Compare the bit tracker to 32
	ble	shifter			                            ! If bit tracker is greater than 0 branch to shifter
	nop

	mov	0, %l2			                            ! Restore the bit tracker to 0
	add	%l3, 1, %l3	                          	! Add one to the registers tracker


	cmp	%l3, 2		                             	! Compares register tracker to 2
	be	loop		                              	! If the regsiter tracker = 2, branch shifter for %l5
	mov	%l5, %l1

	cmp	%l3, 3		                            	! Compare register tracker to 3
	be	loop			                              ! If register tracker =3, branch to shifter for %l6
	mov	%l6, %l1

	cmp	%l3, 4		                             	! Compare the register tracker to 4
	be	loop		                              	! If the register tracker=4, branch to shifter for %l7
	mov	%l7, %l1


	ba	printer			                            ! If we are done, branch to printer for final results
	nop

printer:
	set     0x0000ffff, %o0                      ! Bit mask for printing only the low order of the checksum
        and     %l0, %o0, %l0                  ! and the checksum and the bitmask to get only 0 before the after 15 bits
        set     fmtChek2, %o0                  ! Set the final checksum string into %o0
        call    printf                         ! Print the final value of the checksum to the screen
        mov     %l0, %o1                       ! Put the final value of the checksum into %o1

	set	fmtIn, %o0	                          	! Set the input value string into %o0
	call	printf			                          ! Print the value of input of %l4 to the screen
	mov	%l4, %o1		                            ! Move the value of %l4 into %o1

	set	fmtIn, %o0		                           ! Set print value string into %o0
	call	printf			                           ! Print the value of input %l5 to the screen
	mov	%l5, %o1		                             ! Move the value of %l5 into %o1

	set	fmtIn, %o0		                           ! Set input value string into %o0
	call	printf			                           ! Print the value of %l6 to the screen
	mov	%l6, %o1		                             ! The the input value of %l6 into %o1

	set	fmtIn, %o0		                            ! Set the input value string into %o0
	call	printf		                            	! Print the input value in %l7 to the screen
	mov	%l7, %o1		                              ! Move the value in %l7 into %o1
	
mov	1, %g1				                              ! End the program
ta	0

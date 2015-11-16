/*
Lamess Kharfan          Student Number: 10150607
CPSC 355, Fall 2015     Leonard Manzara
Assignment 1- Computes the minimum of the polynomial
        2x^3 - 18x^2 + 10x + 39
within the range of -2 through 11. This is accomplished by
stepping through the domain one by one and testing for a new
minimum value. Values of x, y, and the minimum are printed
after every iteration of the loop, value of the mimimum is stored
into %l0 at the end of the program.
Version 2- Use of macros and m4.
*/

.global main

fmty:   .asciz          "The value of y is %d\n"
fmtx:   .asciz          "The value of x is %d\n"
fmtm:   .asciz          "The value of the min is %d\n"

define(co0, 39)		! Constant of the polynomial
define(co1, 10)		! Coefficient to x in the polynomial
define(co2, -18)	! Coefficient to x^2 in the polynomial
define(co3, 2)		! Coefficient to x^3 in the polynomial

define(c, -2)		! Lower limit of the domain
define(b, -3)		! Starting point for program
define(e, 11)		! Upper limit of the domain

define(min, l0)		! Variable to hold the minimum value
define(x_r, l1)		! Variable to hold the x value being tested 
define(y_r, l2)		! Variable to hold the y value for different x values


main:
	save	%sp, -96, %sp

	ba	top		! Always start at the loop
	mov	b, %x_r		! Move first value of x into variable x
	clr	%y_r		! Set value of y to 0

calc:
	
	/* Add constant to y variable */
	
	mov	co0,%y_r	! Add 39 to the y variable

	/* Compute the -18x^2 portion of the polynomial */

	mov	%x_r, %o0	! Move value of x to %o0
	call	.mul		! Calculate value of x^2, store in %o0
	mov	%x_r, %o1	! Move value of x to %o1
	mov	%o0, %l3	! Store value of x^2 in %l3 for x^3 calculation
	call	.mul		! Calculate value of co2*x^2, store in %o0
	mov	co2, %o1	! Move value of co2 (-18) into %o1
	add	%o0, %y_r, %y_r	! Add value of -18x^2 in %o0 to y variable
	
	/* Compute 2x^3 part of the polynomial */

	
	mov	%l3, %o0	! Move stored x^2 value into %o0 from %l3
	call	.mul		! Calculate the value of x^3, store in %o0
	mov	%x_r, %o1	! Move x value into %o1
	call	.mul		! Calculate the value of co2*x^3, store in %o0
	mov	co3, %o1	! Move value of co3 (2) into %o1
	add	%o0, %y_r, %y_r	! Add the value of 2x^3 to y variable

	/* Compute 10x part of the polynomial */
	
	mov	co1, %o0	! Move value of co1 (10) into %o0
	call	.mul		! Calculate the value of co1*x, store into %o0
	mov	%x_r, %o1	! Move value of x into %o1
	add	%o0, %y_r, %y_r	! Add value of 10x to the y variable


	/*Check if this is the first calculation */
	bge	cmpy		! If this isn't the first calculation, go to cmpy
	mov     c, %o0          ! Move lower limit into %oO
	mov	%y_r, %min	! If this is the first calclation, replace min with y
	
cmpy:
	cmp	%y_r, %min	! Compare y value to the current min value
	bge	print		! If y is greater than min, go to print
	nop
	mov	%y_r, %min	! If y is less than min value, replace min with y value

print:

	set	fmtx, %o0	! Put the x string into %o0
	call	printf		! Print the value of x string to the screen
	mov	%x_r, %o1	! Put the x value into %o1

	set	fmty, %o0	! Put the y string into %o0
	call	printf		! Print the value of y string to the screen
	mov	%y_r, %o1	! Put the y value into %o1

	set	fmtm, %o0	! Put the minimum string into %o0
	call	printf		! Print the value of mimimum string to the screen
	mov	%min, %o1	! Put the mimimum value into %o1

top:
	cmp     %x_r, e         ! Compare x value to upper limit of 11
	bl	calc		! If x <= l1 then do the calculation for the new x value
	inc     %x_r            ! Increment x by 1

mov	1, %g1			! Exit request
ta	0			! Trap to system

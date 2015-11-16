/*Lamess Kharfan         Student Number: 10150607
CPSC 355, Fall 2015     Leonard Manzara
Assignment 3 - Sorting One - Dimenstional Arrays
Implements the following algorithm:

	#define  SIZE 40
	int main()
	{
		int v[SIZE];
		register int i, j, tmp;

		/*  Initialize array to random positive integers, mod 256  
		for (i = 0; i < SIZE; i++) {
			v[i] = rand() & 0xFF;
			printf(“v[%-d]: %d\n”, i, v[i]);
		}

		/*  Sort the array using an insertion sort  
		for (i = 1; i < SIZE; i++) {
			tmp = v[i];
			for (j = i; j > 0 && tmp < v[j-1]; j--)
				v[j] = v[j-1];
			v[j] = tmp;
		}

		/*  Print out the sorted array  
		printf(“\nSorted array:\n”);
		for (i = 0; i < SIZE; i++)
			printf(“v[%-d]: %d\n”, i, v[i]);
		}
Version 1- Use of m4.  
*/


define(SIZE, 40)                ! Size of array = 40 elements
define(tmp_r, %l3)              ! temp location for element values
define(i_r, %l2)                ! Index tracker for outer loop and adding elements
define(j_r, %l1)                ! Inner Loop tracker
define(n_r, %l0)                ! Temporary Register for holding the value of v[j-1]
define(a_r, %l5)				! Temporary register for holding value of[j - 1]
! %l4 for bitmask

define(local_var, `define(last_sym, 0)')
define(`var', `define(`last_sym', eval((last_sym - ifelse($3,,$2,$3)) & -$2))$1 = last_sym')

local_var
var(v_s, 4, 4 * SIZE)           ! Create array of size 40 with elements of size 4 

fmtStart:       .asciz          "The unsorted array:\n" ! String formatter for the start
                .align 4
fmtElement:     .asciz          "v[%-d] : %d\n"         ! String formatter for elements
                .align 4
fmtEnd:         .asciz          "The sorted array: \n"  ! String formatter for the end
                .align 4

        .global main
main:
        save    %sp, (-92 + last_sym) & -8, %sp

        set     fmtStart, %o0           ! Put the start string formatter into %o0
        call    printf                  ! Print the start string to the screen
        set     0xFF, %l4               ! Store the bit mask into %l4

        ba      arrayTest               ! Always branch to arrayTest
        mov     0, i_r					! Set i_r to 0 initially 

addElements:
       
        call    rand                    ! Call rand to get a random number, stores in %o0
        nop
        and     %o0, %l4, %o0           ! and random number with bitmask and store in %o0
        mov     %o0, tmp_r              ! Move element into temp location

        sll     i_r, 2, %o0             ! index * 4
        add     %fp, %o0, %o0           ! Add frame pointer
        st      tmp_r, [v_s + %o0]      ! Store element into array

        ld      [%o0 + v_s], n_r        ! Load current element into n_r
        set     fmtElement, %o0         ! Set element formatter into %o0
        mov     i_r, %o1                ! Move index value into %o1
        call    printf                  ! Print element at index value to screen
        mov     n_r, %o2                ! Move element value into %o2

        clr     %o0                     ! Clear %o0 for the next round
		inc		i_r						! Increment the value of index tracker by 1

arrayTest:
        cmp     i_r, SIZE               ! Compare the index to size
        bl      addElements             ! If we're at an idex < size, branch to fillArray
		nop
		
		clr		i_r						! Clear the value of i_r to 0	
		mov		1, i_r					! Move 1 into i_r for the loop
        ba      sortTest                ! Always branch to the sortTest
		clr		n_r						! Clear the value of n_r to 0

insertSort:
		sll     i_r, 2, %o0            	! i * 4
        add     %fp, %o0, %o0           ! Add frame pointer
        ld      [%o0 + v_s], tmp_r      ! Store value at index i into tmp

		mov		i_r, j_r				! Move the value of i_r into j_r
		cmp		j_r, 0					! Compare the value of j_r to 0
		ble		done					! If j >= 0 then branch to done to skip over tests
		nop												
		
		true1:
			add		j_r, -1, a_r			! If the condition fell through, sub 1 from j_r, store in a_r
			sll		a_r, 2, %o0				! a_r * 4 (j-1)*r
			add		%fp, %o0, %o0			! Add frame pointer
			ld		[%o0 + v_s], n_r		! load the value of v[j-1] into n_r
			cmp		tmp_r, n_r				! Compare tmp_r to a_r
			bge		done					! if tmp_r >= v[j-1] branch to done
			nop
				
		true2:
			add		j_r, -1, a_r			! If the condition fell through, sub 1 from j_r, store in a_r
			sll		a_r, 2, %o0				! j-1 * 4
			add		%fp, %o0, %o0			! Add frame pointer
			ld		[%o0 + v_s], a_r		! load the value of v[j-1] into a_r
				
			sll		j_r, 2, %o0				! j_r * 4
			add		%fp, %o0, %o0			! Add frame pointer
			st		a_r, [%o0 + v_s] 		! Store value of v[j-1] into v[j]
					
			cmp		j_r, 0					! compare new value of j to 0
			bg		true1					! branch to true1 to test 2nd branch if j > 0 
			add		j_r, -1, j_r			! Decrement j by 1
						
done:
	sll		j_r, 2, %o0						! j_r * 4
	add		%fp, %o0, %o0					! add frame pointer
	st		tmp_r, [v_s + %o0]				! Store value of temp into array
	inc		i_r								! Increment i_r by 1 for next loop iteration
	
sortTest:
		cmp		i_r, SIZE					! Compare i to size
		bl		insertSort					! If i_r < SIZE, branch to insertSort
		nop
		
		set		fmtEnd, %o0					! Set end string formatter into %o0
		call	printf						! Print end string formatter to screen
		mov		0, i_r						! Move 0 into i_r to reset 
		
		ba		printOutputTest				! Always branch to printOutPutTest loop
		nop
	
printOutput:
		sll		i_r, 2, %o0				! i_r * 4
		add		%fp, %o0, %o0			! Add frame pointer 
		ld      [%o0 + v_s], n_r        ! Load current element into n_r
        set     fmtElement, %o0         ! Set element formatter into %o0
        mov     i_r, %o1                ! Move index value in i_r into %o1
        call    printf                  ! Print element at index value to screen
        mov     n_r, %o2                ! Move element value in n_r into %o2
		inc		i_r						! Increment value of i_r by 1 for next loop iteration 
		
printOutputTest:
		cmp		i_r, SIZE				! Test if index i_r < SIZE
		bl		printOutput				! If i_r < SIZE then branch to print the element at that index
		nop
		
		mov		1, %g1					! Exit request
		ta		0						! Trap to system 

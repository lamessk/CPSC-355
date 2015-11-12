/*
Lamess Kharfan         	Student Number: 10150607
CPSC 355, Fall 2015    	Leonard Manzara
Tutorial: T08			TA: Cory Bloor
Assignment 4 - Structures and Subroutines:
Translates the following C Code into the equivalent assembly code
in order to create boxes, move boxes, expand boxes, print contents 
of boxes,and check if two boxes are equal using subroutines and structures:

#define FALSE  0
#define TRUE   1
struct point {
  int x, y;
};
struct dimension {
  int width, height;
};
struct box {
  struct point origin;
  struct dimension size;
  int area;
};
struct box newBox()
{
  struct box b;
  b.origin.x = 0;
  b.origin.y = 0;
  b.size.width = 1;
  b.size.height = 1;
  b.area = b.size.width * b.size.height;
  return b;
}
void move(struct box *b, int deltaX, int deltaY)
{
  b->origin.x += deltaX;
  b->origin.y += deltaY;
}
void expand(struct box *b, int factor)
{
  b->size.width *= factor;
  b->size.height *= factor;
  b->area = b->size.width * b->size.height;
}
void printBox(char *name, struct box *b)
{
  printf("Box %s origin = (%d, %d)  width = %d  height = %d  area = %d\n",
	 name, b->origin.x, b->origin.y, b->size.width, b->size.height,
	 b->area);
}
int equal(struct box *b1, struct box *b2)
{
  int result = FALSE;
  if (b1->origin.x == b2->origin.x) {
    if (b1->origin.y == b2->origin.y) {
      if (b1->size.width == b2->size.width) {
        if (b1->size.height == b2->size.height) {
          result = TRUE;
        }
      }
    }
  }
  return result;
}
int main()
{
  struct box first, second; 
  first = newBox();
  second = newBox();
  printf("Initial box values:\n");
  printBox("first", &first);
  printBox("second", &second);
  if (equal(&first, &second)) {
    move(&first, -5, 7);
    expand(&second, 3);
  }
  printf("\nChanged box values:\n");
  printBox("first", &first);
  printBox("second", &second);
}
*/

	include(macro_defs.m)
	define(FALSE, 0)
	define(TRUE, 1)

fmtStart:		.asciz		"\n The initial box values: \n"
				.align 4
fmtFirst:		.asciz		"First: "
				.align 4
fmtSecond:		.asciz		"Second: "
				.align 4
fmtChange:		.asciz		"\n Changed box values: \n"
				.align 4
fmtBox:			.asciz		"Box %s origin = (%d, %d)	width = %d		height = %d"
				.align 4				
fmtArea:		.asciz		"		area: %d\n"				
				.align 4
	
	! Define point struct
	begin_struct(point)												
	field(x, 4)													
	field(y, 4)														
	end_struct(point)
	
	! Define dimension struct
	begin_struct(dimension)									
	field(width, 4)													
	field(height, 4)												
	end_struct(dimension)											
										
	! Define box struct
	begin_struct(box)												
	field(origin, align_of_point, size_of_point)					 
	field(size, align_of_dimension, size_of_dimension)				
	field(area, 4)													
	end_struct(box)												

	local_var
	var(b, align_of_box, size_of_box)							! Create box variable
begin_fn(newBox)
	ld		[%fp + 64], %l0										! Calculate address of b
	
	mov		0, %o0												! Move value of b.origin.x into %o0
	st		%o0, [%fp + b + point_x + box_origin]				! Store value of b.origin.x at memory address  
	
	mov		0, %o0												! Move value of b.origin.y into %o0
	st		%o0, [%fp + b + box_origin + point_y]				! Store value of b.origin.y at memory address
	
	mov		1, %o0												! Move value of b.dimension.width into %o0
	st		%o0, [%fp + b + box_size + dimension_width]			! Store value of b.dimension.width at memory address
	
	mov		1, %o0												! Move value of b.dimension.height into %o0
	st		%o0, [%fp + b + box_size +dimension_height]			! Store value of b.dimension.height at memeory address
	
	ld		[%fp + b + box_size + dimension_width], %o0			! Move value of b.size.width into %o0
	ld		[%fp + b + box_size + dimension_height], %o1		! Move value of b.size.height into %o1
	smul	%o0, %o1, %o0										! Multiply values in %o0 and %o1, store into %o0
	st		%o0, [%fp + b + box_area]							! Store mutliplied value into box.area memory address
	
	ld		[%fp + b + box_origin + point_x], %o0				! Load b.origin.x into %o0
	st		%o0, [%l0 + box_origin + point_x]					! Write b.origin.x to main
	
	ld		[%fp + b + box_origin + point_y], %o0				! Load b.origin.y into %o0
	st		%o0, [%l0 + box_origin + point_y]					! Write b.origin.y to main
	
	ld		[%fp + b + dimension_width + box_size], %o0			! Load b.size.width into %o0
	st		%o0, [%l0 + dimension_width + box_size]				! Write b.size.width to main
	
	ld		[%fp + b + dimension_height + box_size], %o0		! Load b.origin.height into %o0
	st		%o0, [%l0 + dimension_height + box_size]			! Write b.origin.height to main
	
	ld		[%fp + b + box_area], %o0							! Load b.area into %o0
	st		%o0, [%l0 + box_area]								! Write b.area to main

end_fn(newBox)

.global move
move:
	save	%sp, -92, %sp										! Allocate memory on the stack for move
	ld		[%i0 + box_origin + point_x], %l0					! load b.origin.x into %l0 for box in %o0
	ld		[%i0 + box_origin + point_y], %l1					! load b.origin.y into %l1 for box in %o0
	add		%l0, %i1, %l0										! Add deltaX to b.origin.x
	add		%l1, %i2, %l1										! Add deltaY to b.origin.y
	st		%l0, [%i0 + box_origin + point_x]					! store value of deltaX + b.origin.x at memory address
	st		%l1, [%i0 + box_origin + point_y]					! store value of deltaY + b.origin.y at memory address
	ret															! Return and restore
	restore
	
.global expand
expand:
	save	%sp, -92, %sp										! Allocate memory on the stack for expand
	ld		[%i0 + box_size + dimension_width], %l0				! load b.size.width for box in %o0 into %l0
	ld		[%i0 + box_size + dimension_height], %l1			! load b.size.height for box in %o0 into %l1
	smul	%l0, %i1, %l0										! b.size.width  *= factor
	smul	%l1, %i1, %l1										! b.size.height *= factor
	smul	%l0, %l1, %l2										! area = b.size.width * b.size.height
	st		%l0, [%i0 + box_size + dimension_width]				! store new value of width into memory address
	st		%l1, [%i0 + box_size + dimension_height]			! store new value of height into memory address
	st		%l2, [%i0 + box_area]								! store new value of area into memory address
	ret															! Return and restore
	restore
	
.global printBox
printBox:
	save	%sp, -92, %sp										! Allocate enough memory on the stack for printBox
	set		fmtBox, %o0											! Set the box format string into %o0
	ld		[%i0 + box_origin + point_x], %o2					! Load the value of point x into %o2
	ld		[%i0 + box_origin + point_y], %o3					! Load the value of point y into %o3
	ld		[%i0 + box_size + dimension_width], %o4				! Load the value of width into %o4
	ld		[%i0 + box_size + dimension_height], %o5			! Load the value of height into %o5
	call	printf												! Print all of the values to the screen
	mov		%i1, %o1											! Move the name of the box into %o1

	set		fmtArea, %o0										! Set the area format string into %o0
	call	printf												! Print the value of area to the screen
	ld		[%i0 + box_area], %o1								! load the value of area into %o1
	
	ret															! Return and restore
	restore

local_var
var(result, 4)													! Create the result varaible
begin_fn(equal)									
	mov		FALSE, %l0											! Move value of FALSE into %l0
	mov		TRUE, %l1											! Move value of TRUE into %l1
	st		%l0, [%fp + result]									! Store true into result
	
	ld		[%i0 + box_origin + point_x], %o1					! Load value of point x for box1 into %o1
	ld		[%i1 + box_origin + point_x], %o2					! Load value of point x for box 2 into %o2
	cmp		%o1, %o2											! Compare point x of box 1 and box 2
	bne		notEqual											! Branch to notEqual if they are not equal
	ld		[%i0 + box_origin + point_y], %o1					! Load value of point y for box 1 into %o1

	ld		[%i1 + box_origin + point_y], %o2					! Load value of poiny y for box 2 into %o2
	cmp		%o1, %o2											! Compare point y for box 1 and box 2
	bne		notEqual											! Branch to notEqual if they're not equal
	ld		[%i0 + box_size + dimension_width], %o1				! Load value of width for box 1 into %o1

	ld		[%i1 + box_size + dimension_width], %o2				! Load value of width for box 2 into %o2
	cmp		%o1, %o2											! Compare width values for box 1 and box 2
	bne		notEqual											! Branch to notEqual if they're not equal
	ld		[%i0 + box_size + dimension_height], %o1			! Load value of height for box 1 into %o1
	
	ld		[%i1 + box_size + dimension_height], %02			! Load value of height for box 2 into %o2
	cmp		%o1, %o2											! Compare height values for box 1 and and box 2
	bne		notEqual											! Branch to notEqual if they're not equal
	st		%l1, [%fp + result]									! If all conditions are true, result = true

	ld		[%fp + result], %i4									! Store true into %i4
	
	ret															! Return and restore
	restore
	
notEqual:
	ld		[%fp + result], %i4									! If false, result = false
end_fn(equal)
	
	
local_var
var(first, align_of_box, size_of_box)							! Create first variable of type box
var(second, align_of_box, size_of_box)							! Create second variable of type box
.global main
main:
	save	%sp, (-92 + last_sym) & -8, %sp							
	
	add		%fp, first, %o0										! Calculate address of first, store into %o0
	call	newBox												! Call newBox to create first newBox
	st		%o0, [%sp + 64]										! Store address 
	
	add		%fp, second, %o0									! Calculate address of second, store into %o0
	call	newBox												! Call newBox to create second newBox
	st		%o0, [%sp + 64]										! store address
	
	set		fmtStart, %o0										! set start string into %o0
	call	printf												! Print start label to screen
	nop
	
	set		fmtFirst, %o1										! Move first format string into %o1
	call	printBox											! Call printBox to print contents of first to screen
	add 	%fp, first, %o0										! calculate address of first, store in %o0
	
	set		fmtSecond, %o1										! Set second format string into %o1
	call	printBox											! Call printBox to print contents of second to screen
	add		%fp, second, %o0									! Calculate address of second, store into %o0

	add		%fp, second, %o1									! Calculate address for second, store into %o1
	call	equal												! Call equal subroutine to test if boxes are equal
	add		%fp, first, %o0										! Calculate address for first, store into %o0
	
	cmp		%o4, TRUE											! compare result of equal subroutine to TRUE
	bne		printChange											! If not true then branche to printChange, otherwise, fall through
	nop				
	
	mov		7, %o2												! Move 7 into %o2
	call	move												! Call move subroutine
	mov		-5, %o1												! Move -5 into %o1
	
	mov		3, %o1												! Move 3 into %o1
	call	expand												! Call the expand subroutine
	add		%fp, second, %o0									! Calculate address of second and store into %o0
	
printChange:	
	set		fmtChange, %o0										! Set the change format string into %o0
	call	printf												! Print change format string to the screen
	nop
	add		%fp, first, %o0										! Calculate address of first, store into %o0
	set		fmtFirst, %o1										! Set first format string into %o1
	call	printBox											! Call printBox and print contents of first box
	add		%fp, first, %o0										! Calculate address of first, store into %o0										
		
	set		fmtSecond, %o1										! Set second format string into %o1
	call	printBox											! Call printBox and print contents of second box
	add		%fp, second, %o0									! Calculate address of second, store into %o0
	
	mov		1, %g1												! Exit request
	ta		0													! Trap to system
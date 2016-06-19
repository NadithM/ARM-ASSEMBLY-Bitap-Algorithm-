.text 
.global main

main:
		sub sp, sp, #4				@allocate stack to preserve lr
		str lr, [sp, #0]
@---------------------------------------------------------------
		sub 	sp,sp,#50			@allocate memory for pattern
										
		ldr 	r0,=print4pat		
		bl 		printf 
						
		ldr		r0,=getpat			@scanf for the pattern
		mov 	r1,sp
		bl		scanf 	
		mov 	r4,sp				@r4=pattern(the address of the base address of the pattern in r4)
		
		mov 	r0,sp 				@send parameters for the String length function
		bl		StringLen 	
		mov		r5,r0 				@get the length of the pattern to r5				
		
		
		cmp		r5,#31			@exit if pattern length greater 31			
		bgt		ExcdL
		
		@r4,r5 fixed
@-------------------------------------------------------------------
		sub 	sp,sp,#512 		@allocate memory for pattern mask array. each character mask need 4 bytes.since its ascii in between 0-127
	
		mov		r0,#0			@initialized a counter(increment by 4) and mask r1
		mvn		r1,#0				
				
LpPtin:
		cmp		r0,#512			
		bge		PtFill			@all the pattern mask are initialized
		
		str 	r1,[sp,r0]		@else.store the mask in each array element 
		add		r0,r0,#4 		
					
		b 		LpPtin	
		
		@r4,r5 fixed	
@-------------------------------------------------------------------		
PtFill:
		mov	r0,#0				@initialized a counter r0,constant r2,pattern base address in r3
		mov r2,#4
		mov r3,r4 	

LpPtFil:
		cmp 	r0,r5
		bge  	DonePF			@until r0< pattern length
		
	@creating the pattern mask	according to the pattern input	
@-------------------------------------
		mov		r6,#1			
		mvn		r6,r6,lsl r0			 
		add		r0,r0,#1 				
			
		ldrb 	r7,[r3],#1
		mul		r7,r2,r7 	
		ldr 	r8,[sp,r7] 		
		and 	r8,r8,r6  			
		str 	r8,[sp,r7]  	
		b		LpPtFil		
@-------------------------------------
		@		r4,r5 fixed
@----------------------------------------------------------------------	
DonePF:	
		sub 	sp,sp,#200 			@allcate memory for the text	

		ldr 	r0,=print4text
		bl 		printf 
		ldr		r0, =gettext		@scanf for text		
		mov 	r1, sp
		bl		scanf 	
				
		mov 	r6, sp				@r6=text(address)
		mov 	r11,sp				@r11=text
			
		add 	sp, sp, #200 		@realse the stack for text.sp again in pattern mask postion
		
		@		r4,r5,r11 are fixed
@----------------------------------------------------------------------------------------------------	

MaskCom:
	@	r6=r11 value also used.string text
		mov r7,#5 					@initilized bit array R in r1,counter r3 [i],constant r2,
		mvn	r1,#1 					@make sure r7 is not the terminator since r7 is the text[i]
		mov r2,#4
		mov r3,#0
		
LpMaskC:
		cmp 	r7,#0
		beq 	DoneMC				@if pattern is not found in the text 
		
		@else.comparing the each text character with the pattern masks created before
	@------------------------------  
		add 	r3,r3,#1			
		ldrb 	r7,[r6],#1
		mul		r8,r2,r7
		
		
		ldr 	r9,[sp,r8]
		orr 	r1,r9,r1  
		lsl		r1,r1,#1 				
					
		mov		r9,#1			@check for if the pattern is found yet	
		lsl		r9,r9,r5 	
		
		and		r9,r9,r1 			
				
		cmp		r9,#0 				
		beq		DoneAns			@found the pattern in the text
		
		b 		LpMaskC			@if not check for the rest
@---------------------------------------		
		@		r4,r5,r11 are fixed
@--------------------------------------------------------------------
DoneAns:

		@  		final r3 value is imported
		sub		r2,r3,r5		@finds the posistion of the pattern in the text
		mov 	r1, r4	
	
		mov 	r3,r11			@print for the answer
		ldr 	r0, =found			
		bl 		printf 			
		
		b 		DoneM
	
		@		nothing is need to be fixed
@--------------------------------------------------------------
DoneMC:	@prints that pattern is not found 
				
		ldr 	r0,=notf
		bl 		printf
		b 		DoneM

@---------------------------------------------------------	
@String length function.function

StringLen:
			sub 	sp, sp, #4
			str 	lr, [sp, #0]
			mov 	r1, #-1
	
LpStrnLen:
			ldrb	r2, [r0], #1
			cmp		r2, #0
			beq		DoneSL
			add 	r1, r1, #1
			b   	LpStrnLen

DoneSL:
			add		r1,r1,#1
			mov 	r0, r1
			ldr 	lr, [sp, #0]	
			add		sp, sp, #4
			mov 	pc, lr	

@-----------------------------------------------------------------------
ExcdL: @prints that pattern is too large
			ldr 	r0,=el
			bl 		printf
			b 		Done

debug: @for debug purpose
			ldr 	r0,=foo
			bl 		printf
		
DoneM:	@realse the stack used for pattern mask
			add		 sp, sp,#512 	

Done:	@release the stack used for lr
			add		sp, sp, #50
			ldr 	lr,[sp,#0]
			add 	sp,sp,#4
	
.data


print4pat:.asciz "Enter the pattern: "
getpat: .asciz "%s"
frmtdebug: .asciz "and %d of %d\n"
el: .asciz "The pattern is too long!\n"
print4text: .asciz "Enter the text: "
gettext: .asciz "%s"
found: .asciz "%s is at position %d in the text %s\n"
notf: .asciz "Pattern is not found in the text\n"
foo: .asciz "Its working\n"



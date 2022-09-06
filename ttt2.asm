    asect 0xf0
IOReg: dc 0b10000000# Gives the address 0xf3 the symbolic name IOReg
    asect 0xf1
CompTurn: 
    asect 0xf2
State:
	asect 0x00
start:
	ldi	 r0, IOReg
read_btn_press:
	do
		ld r0, r1
		tst r1
	until mi
	#in bits 0-1 we have the y coordinate, in 2-3 x coordinate
	ldi r2, 0x03
	and r1, r2 #y coord
	push r2 #push y coord on the stack
	ldi r2, 0x0c
	and r1, r2 #x coord
	shra r2
	shra r2
	push r2 #push x coord on the stack
		ldi r3, 1
		pop r1 #put the x coord in r1
		shla r1
		shla r1
		or r1, r3
		pop r1 #put the y coord in r1
		shla r1
		shla r1
		shla r1
		shla r1
		or r1, r3
		st r0, r3 #send the byte to our board
		jsr getState #check if the game is over
		tst r0
		bnz result #game is over, let's find out the result
		jsr comp_turn 
		jsr getState 
		tst r0
		bnz result
		br start #if game is not over, start from the beginning
		
getState: 
			ldi r0, State
			ld r0, r0
			rts
			
result: ldi r1, 0b00111100 #this way LLL chip doesn't react
		shr r0 #the state lies in the lowest 2 bits. we move them to the to 2 bits
		shr r0
		shr r0
		or r1, r0
		ldi r1, IOReg #send score to I Win  chip
		st r1, r0
		halt #the game is over
comp_turn:
			ldi r0, CompTurn
			ld r0, r0 #it the lowest 2 bits we have the coordinates
			          #of the best move
			shla r0
			shla r0
			ldi r1, 2
			or r1, r0
			ldi r1, IOReg
			st r1, r0
			rts
end

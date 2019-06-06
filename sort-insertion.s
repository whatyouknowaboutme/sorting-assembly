/* Sorting algorithm */
.data

.align 4
myarray:
  .word 9,4,8,1,6,5,15,12,3,19,14,20,7,17,18,10
printf_str:     .asciz      "a[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"

.text
.balign 4
.global main
main:
  ldr r1, =myarray @r1 <- &myarray
  mov r2, #0 @ r2 <- 0

OuterLoop:
  cmp r2, #16
  beq writedone @must go to output function when reaches 16
  add r4, r1, r2, LSL #2 @get address of current myarray value
  //add r3,r2,#1 @resets the iteration for OuterLoop
  mov r3, #15
  sub r3, r3, r2
  bl InnerLoop @call inner loop

InnerLoop:
  cmp r3, #0 @check to see if the loop has ended
  beq Iterate_OuterLoop @call the outer function when InnerLoop has ended
  add r5, r4, r3, LSL #2 @get base adress for an interation above r2
  ldr r6,[r5]
  ldr r7,[r4]
  cmp r7,r6
  bgt Swap
  bl Iterate_InnerLoop

Iterate_OuterLoop:
  add r2,r2,#1
  mov r6, #0
  mov r7, #0 
  bl OuterLoop

Iterate_InnerLoop:
  sub r3,r3,#1 
  bl InnerLoop

Swap:
  str r6,[r4]
  str r7,[r5]
  bl Iterate_InnerLoop

writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #16            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =myarray              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
    B _exit                 @ exit if done

_exit:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

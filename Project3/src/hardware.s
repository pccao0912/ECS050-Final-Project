    .section .text, "ax"
    .global OutputString, MoveCursor, ReadController, InitializeTimer, GetTimerTicks
	.text
	.globl	ScreenOffset,TimerTicks
	.section	.sdata,"aw"
	.align	2
	.type	ScreenOffset, @object
	.size	ScreenOffset, 4
ScreenOffset:
	.word	0
    .type	TimerTicks, @object
	.size	TimerTicks, 4
TimerTicks:
	.word	1
	.text
	.text
	.align	2

OutputString:
    la      a1, 0x500FE800  # load video address Text data
    lui     a5,%hi(ScreenOffset)  # load upper immediate
    lw      a3,%lo(ScreenOffset)(a5)  # load word
    add     a1,a1,a3
    j       OSL2
OSL1:
    sb      a2,0(a1)
    addi    a0,a0,1
    addi    a1,a1,1
    addi    a3,a3,1
OSL2: 
    lb      a2,0(a0)
    bnez    a2,OSL1
    sw      a3,%lo(ScreenOffset)(a5)
    ret

MoveCursor:
    slli    a1,a1,6
    add     a0,a0,a1
    lui     a5,%hi(ScreenOffset)
    sw      a0,%lo(ScreenOffset)(a5)
    ret

ReadController:
    la      a1, 0x40000018
    lw      a0, 0(a1)
    ret

InitializeTimer:
    #  Get the value that we should increment to mtimecmp and set mtimecmp initial value to it
    # la      a1, 0x40000040  # clock period addr
    # lw      a2, 0(a1)
    li      a1, 0x40000040
    la      a2, 0x40000010  # mtimecmp addr
    sw      zero, 0(a2)   # set mtimecmp to 0 at first
    sw      zero, 4(a2)   # set mtimecmp to 0 at first
    li      a3, 100000  # 100000
    div     a4, a3, a1  # increment value = 100000 / clock period  # set mtimecmp to 0
    sw      a4, 0(a2)   # set mtimecmp to increment value
    #  Enable
    li      a0, 0x8
    csrw    mstatus, a0
    li      a0, 0x80
    csrw    mie, a0
    ret

GetTimerTicks:
    lui     a5,%hi(TimerTicks)
    lw      a0,%lo(TimerTicks)(a5)
    ret
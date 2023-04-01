.section .text, "ax"
.global _interrupt_handler
_interrupt_handler:
    # Your ISR Here
    # From interrupt.s example
    addi	sp,sp,-40
    sw	    ra,36(sp)
    sw	    t0,32(sp)
    sw	    t1,28(sp)
    sw	    t2,24(sp)
    sw	    a0,20(sp)
    sw	    a1,16(sp)
    sw	    a2,12(sp)
    sw	    a3,8(sp)
    sw	    a4,4(sp)
    sw	    a5,0(sp)

    la      a1, 0x40000040  # clock period addr
    lw      a2, 0(a1)  # a2 hold the value of a period time
    li      a3, 100000
    div     a3, a3, a2  # a3 holds the value we need to increment (100000/period)
    la      a4, 0x40000010  # mtimecmp addr
    lw      a5, 0(a4)  # a5 hold the first half of current mtimecmp
    lw      t0, 4(a4)  # t0 hold the last half of current mtimecmp

    add     a5, a5, a3  # a5 = a5 + a3
    sltu    t2, a5, a3
    add     t0, t0, t2
    sw      a5, 0(a4)
    sw      t0, 4(a4)

    lui     t1, %hi(TimerTicks)
    lw      a0, %lo(TimerTicks)(t1)
    addi    a0, a0, 1
    sw      a0, %lo(TimerTicks)(t1)
    # From interrupt.s exmaple
    lw	    ra,36(sp)
    lw	    t0,32(sp)
    lw	    t1,28(sp)
    lw	    t2,24(sp)
    lw	    a0,20(sp)
    lw	    a1,16(sp)
    lw	    a2,12(sp)
    lw	    a3,8(sp)
    lw	    a4,4(sp)
    lw	    a5,0(sp)
    addi    sp,sp,40
    mret

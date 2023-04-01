916835301
Pengcheng Cao

For this project, the mainly source I used is from canvas-discussion folder.

Based on code that professor provided on discussion, I mainly implement ReadController, InitializeTimer, and _interrupt_handler

For ReadController, it is just read the Multi-button register, since there's while loop that check each button in main function, so I only read it from register address 
and return it.

For InitializeTimer, I did two things here. First thing is initialize the mtimecmp to set a "bound" for mtime, and since it would interrupt once mtime hit the mtimecmp
The value I set is 100000 divided by the value in Machine Clock Period Register, which is a cycle time.

As _interrupt_handler, in this part, I also mainly do two things. First thing is increment mtimecmp once get into this function, and increment amount is still 
100000/value in Machine Clock Period Register. Another thing I did is increment Timerticks.

After my test, all function works well except little problem(my forth line goes a little bit faster than the first line)

The source I used for this project is: http://blog.chinaaet.com/weiqi7777/p/5100064544 , I used the method in it like how to use sltu and how to do 64 bits operations in riscv 
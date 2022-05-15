# CompArchFinal
To implement the idea of an 8 bit computer, we first had to implement an ISA. We decided early on that we wanted to follow a design similar to the Ottobit CPU. Therefore, we decided to use a 16 bit instruction length, with 3 bit register addressing and a 3 bit opcode. To do this, we began with Professor Marano's MIPS single cycle 32 bit cpu code, and attempted to pare it down to 8 bits with a smaller instruction length and addressing width. Below you will find datapath and control diagrams for the general case and for each of the 3 operation types. As we were unable to get the CPU to work, having trouble with minor errors at the end of the proect, we have included sample code and the theoretical timing diagrams for this code if it were to be run.

![image](https://user-images.githubusercontent.com/38709917/168491497-818d51da-2a32-4af2-8163-f6bd138633d0.png)
![image](https://user-images.githubusercontent.com/38709917/168491518-1eccc44f-420f-46e3-a463-1e0e23fd22e8.png)

R type operations are the simplest to handle. The opcode is simply 000, so once the control unit sees that, it passes on the function  to the alu, which then performs the operation denoted in the two source registers and stores the result in the destination register.
![image](https://user-images.githubusercontent.com/38709917/168491536-6f74e0a3-f978-4419-b288-65a839cb0ff4.png)

This is a J type operation. The opcode for this is 101, this jumps the PC to that point in memory.
![image](https://user-images.githubusercontent.com/38709917/168492324-63a10723-6691-46bc-b898-b7e9516a61a1.png)

This is an I type operation. The specific opcode for this one is 101, which is used to set a flag.

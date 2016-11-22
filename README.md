Instruction fetch (state 0)
ir <-- AND(PC, r0) //This instruction is used to put PC in bus A

control word

addrA = 1110 //This is the PC address
addrB = 0000 //B is irrelevant since data comes from main memory
addrD = 1111 //the instruction register is the destination
d = 1 //Data is load from main memory
rw = 1 //The instruction register is written
opcode = 0000 //Opcode of the and operation

1110 0000 1111 1 1 0000

***************************************************************************

Instruction decode (state 1)
if       ir[15] goto CALL
else if ~ir[14] &  ir[13] &  ir[12] &  goto MEM
else if  ir[14] & ~ir[13] & ~ir[12] &  ir[11] goto JUMP
else if  ir[14] & ~ir[13] &  ir[12] & ~ir[11] goto SETLOW
else if  ir[14] & ~ir[13] &  ir[12] &  ir[11] goto SETHI
else goto MICROOP

control word

In the decode state, the datapath does not process data, so any instruction not modifying the file register is correct here 
addrA = 0000 //T
addrB = 0000 //B is irrelevant since data comes from main memory
addrD = 000 //the instruction register is the destination
d = 0 //Data is load from main memory
rw = 0 //The instruction register is written
opcode = 0000 //Opcode of the and operation

0000 0000 0000 0 0 0000

***************************************************************************

Operand fetch in microoperation (state 2)
if ~ir[4]
  temp0 <-- AND(rs2, rs2)
else
  temp0 <-- AND(ir, pimm4) when ~ir[3], otherwise
             OR(ir, nimm)

control word (first case, general purpose register)
addrA = 0xxx  //general purpose register
addrB = 0xxx  //general purpose register
addrD = 1101  //temp0 address
rw = 1        //the file register is written
d = 0         //Result is stored in the file register
opcode = 0000 //first case when a register transfer takes place

0xxx 0xxx 1101 1 0 0000

control word (second case, positive 4-bit two-complement constant)
addrA = 1111  //instruction register
addrB = 1010  //pimm4
addrD = 1101  //temp0 address
rw = 1        //the file register is written
d = 0         //Result is stored in the file register
opcode = 0000 //AND(ir, pimm4)

1111 1010 1101 1 0 0000

control word (second case, negative 4-bit two-complement constant)
addrA = 1111  //instruction register
addrB = 1011  //nimm4
addrD = 1101  //temp0 address
rw = 1        //the file register is written
d = 0         //Result is stored in the file register
opcode = 0001 //OR(ir, nimm4)

1111 1011 1101 1 0 0001

***************************************************************************

Instruction execution in microoperation (state 3)

rd <-- microop(rs1, temp0, opcode2)
write psr when ir[3]

control word

addrA = 0xxx  //a general purpose register
addrB = 1101  //temp0 register
addrD = 0xxx  //a general purpose register
rw = 1        //the file register is written
d = 0         //Result is stored in the file register
opcode = xxxx //a microoperation

0xxx 1101 0xxx 1 0 xxxx

***************************************************************************

Operand fetch in load and store instruction (state 4)
In this state, the temp0 register is load with the memory address of the data to be load

temp0 <-- rs1+rs2 when ~ir[4], otherwise
          rs1-rs2
//psr <-- status when ~ir[4] & ir[3]

control word (first case, addition)
addrA = 0xxx // a general purpose register is used
addrB = 0xxx // a general purpose register is used
addrD = 1101 // destination is the temp0 register
rw = 1  // file register is written
d = 0 // result is stored in the file register
opcode = 0100 //An addition is perform to get the data address

0xxx 0xxx 1101 1 0 0100

control word (second case, substraction)
addrA = 0xxx // a general purpose register is used
addrB = 0xxx // the instruction register is used
addrD = 1101 // destination is the temp0 register
rw = 1  // file register is written
d = 0 // result is stored in the file register
opcode = 0101 //A  substration is perform to get the data address

0xxx 0xxx 1101 1 0 0101

***************************************************************************

Instruction execution/writeback in store/load instruction (state 5)

rd <-- AND(temp0, rd)
set rw when ir[11]

control word (first case, store (ir[11]))
addrA = 1101  //The temp0 register to indicate the address
addrB = 0xxx  //A general purpose register
addrD = 0000  //The destination does not care
rw = 0        //File register is not written
d = 0         // The file register is not written; the result does not care
opcode = 0000 //An AND operation is perform; the result does not care

1101 0xxx 0xxx 0 0 0000

control word (second case, load (~ir[11]))
addrA = 1101  //The temp0 register to indicate the address
addrB = 0xxx  //A general purpose register, this operand does not care
addrD = 0xxx  //A general purpose register 
rw = 1        //File register is written
d = 1         //Data comes from main memory
opcode = 0000 //An AND operation is perform; the result does not care

1101 0xxx 0xxx 1 1 0000

***************************************************************************

Fetch operand in jmpl/branch instruction (state 6)

temp0 <-- ADD(link, const2) when ~(ir[10] & ir[9] & ir[8]), otherwise
          AND(ir, maskL) 

control word (first cast, jump)
addrA = 0111  //The link register
addrB = 1100  //The const2 register
addrD = 1101  //The destination is the temp0 register
rw = 1        //File register is written
d = 0         //A register transfer is performed
opcode = 0100 //An ADD operation is performed to increment the link address

0111 1100 1101 1 0 0100

control word (second case, branch)
addrA = 1111  //An 8-bit even binary number from the ir register
addrB = 1001  //A mask 0x00FF is used to get the displacement
addrD = 1101  //The destination is the temp0 register
rw = 1        //File register is written
d = 0         //Result is stored in the file register
opcode = 0000 //An AND operation is performed to get the displacement

1111 1001 1101 1 0 0000

***************************************************************************

Instruction execution in jump/branch instruction (state 7)

displacement <-- SUB(pc, temp0) when ~(ir[10] | ir[9] | ir[8])
                 else AND(temp0, temp0) when (~ir[7]) otherwise
                 SUB(r0, temp0) //gets two's complement

set status[4] when ~ir[10] & ~ir[9] & ~ir[8] | //jmpl
                   ~ir[10] & ~ir[9] &  ir[8] | //ba
              ~Z & ~ir[10] &  ir[9] & ~ir[8] | //bne
               Z & ~ir[10] &  ir[9] &  ir[8] | //be
   ~Z & ~(N ^ V) &  ir[10] & ~ir[9] & ~ir[8] | //bg
    Z |  (N ^ V) &  ir[10] & ~ir[9] &  ir[8] | //ble
        ~(N ^ V) &  ir[10] &  ir[9] & ~ir[8] | //bge
         (N ^ V) &  ir[10] &  ir[9] &  ir[8] | //bl

control word (first cast, jump)
addrA = 1110  //The pc register
addrB = 1101  //The temp0 register, which contains the operand B
addrD = 1000  //The destination is the displacement register
rw = 1        //File register is written
d = 0         //Result is stored in the displacement register
opcode = 0101 //A SUB operation is performed to compute the displacement

1110 1101 1000 1 0 0101

control word (second case, branch)
addrA = 1101  //The temp0 register
addrB = 1101  //The temp0 register
addrD = 1000  //The destination is the displacement register
rw = 1        //File register is written
d = 0         //Result is stored in the file register
opcode = 0000 //An AND operation is performed to get the displacement

1101 1101 1000 1 0 0000

***************************************************************************

Operand fetch in set constant instruction (state 8)

temp0 <-- AND(ir, maskL) when ~ir[11], otherwise
          AND(pimm4, nimm4)//get 8

control word (first case, setlow)
addrA = 1111  //The instruction register
addrB = 1001  //The mask register
addrD = 1101  //The temp0 register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0000 //The AND operation is performed

1111 1001 1101 1 0 0000

control word (second case, sethi)
addrA = 1010  //The pimm4 register
addrB = 1011  //The nimm4 register
addrD = 1101  //The temp0 register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 1100 //The AND operation is performed temp0 <— 8

1010 1011 1101 1 0 0000

***************************************************************************

Instruction execution in set constant instruction (state 9)

rd <-- AND(temp0, temp0) when ~ir[11], otherwise
       SLL(ir, temp0)

control word (first case, setlow)
addrA = 1101  //The temp0 register
addrB = 1101  //The temp0 register
addrD = 0xxx  //A general purpose register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0000 //The AND operation is performed to do a register transfer

1101 1101 0xxx 1 0 0000

control word (second case, sethi)
addrA = 1111  //The ir register
addrB = 1101  //The temp0 register
addrD = 0xxx  //A general purpose register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 1100 //The SLL operation

1111 1101 0xxx 1 0 1100

***************************************************************************

Link PC (state 10)

r7 <-- AND(PC, PC)

control word
addrA = 1110  //The program counter register
addrB = 1110  //The program counter register
addrD = 0111  //The r7 register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0000 //Program counter is move to r7

1110 1110 0111 1 0 0000

***************************************************************************

Compute address in call instruction (state 11)

set displacemet
displacement <-- add(ir, ir)

control word
addrA = 1111  //The ir register
addrB = 1111  //The ir register
addrD = 1101  //The temp0 register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0100 //The instruction multiply by two (x+x)

1111 1111 1101 1 0 0100

***************************************************************************

Program counter update (state 12)

pc <-- ADD(pc, const2) when ~psr[4], otherwise
       ADD(pc, displacement)

control word (first case, const2)
addrA = 1110  //The program counter register
addrB = 1101  //The const2 register
addrD = 1110  //The program counter register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0100 //Program counter is incremented

1110 1101 1110 1 0 0100

control word (second case, displacement)
addrA = 1110  //The program counter register
addrB = 1000  //The const2 register
addrD = 1100  //The program counter register
rw = 1        //The file register is written
d = 0         //Functional unit result is stored
opcode = 0100 //Program counter is incremented

1110 1100 1110 1 0 0100

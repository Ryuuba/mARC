setlow 64, %r1
sethi 1, %r2
call Max ;call 0xF004
sethi 8, %r6
st %r3, %r6
...

Max:  cmp %r1, %r2, %r0
      ble L1;ble 3
      mov %r1, %r3
      ba L2;ba 2
L1:   mov %r2, %r3
L2:   jmp %r7
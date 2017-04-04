main: setlow 29, %r1
      ld %r1, %r1
      setlow 30, %r2
      ld %r2, %r2
      call Max
      setlow 31, %r1
      st %r3, %r1
      nop

max:  cmp %r1, %r2
      ble L1
      mv %r1, %r3
      ba L2
L1:   mv %r2, %r3
L2:   jump %r7


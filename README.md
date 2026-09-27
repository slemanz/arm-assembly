# ARM Assembly Dump

1. **[First Simple Program](01-simple/)**
2. **[Introduction to ARM Architecture](02-intro/)**
3. **[Assembler Rules](03-assembler-rules/)**
4. **[Load-Store Instructions](04-load-store/)**
5. **[Constants and Literals](05-constants-literals/)**
6. **[Arithmetic and Logic Instructions](06-arith-logic/)**
7. **[Branch and Loop Instructions](07-branch-loop/)**
8. **[Stack](08-stack/)**
9. **[GPIO Driver](09-gpio/)**
10. **[ADC Driver](10-adc/)**
11. **[UART Driver](11-uart/)**
12. **[Systick Driver](12-systick/)**
13. **[Timers Driver](13-timers//)**
14. **[Data Structures](14-data_structures/)**
15. **[State Machines](15-state_machines/)**

- [simple codes](simple_codes/)

---

## Important Notes

### APSR

`APSR = nzcvq` means these 5 status flags in ARM Cortex-M:

- n - Negative = Result's top bit is 1 (number is negative)
- z - Zero = Result equals exactly zero
- c - Carry = Unsigned math overflowed 
- v - oVerflow = Signed math overflowed 
- q - Saturated = Value hit maximum/minimum and got stuck there

They will show big in JLINK when set, for cmp instruction:

`CMP R1, R3`

**Equal:** Z=1 (result was zero) -> R1 == R3

**Unsigned numbers:**

- C == 1 -> R1 >= R3
- C == 0 -> R1 < R3

**Signed numbers:**

- N == V -> R1 >= R3
- N != V -> R1 < R3

**Common branches:**

- BEQ = branch if Z=1 (equal)
- BNE = branch if Z=0 (not equal)
- BHS/BLO = unsigned higher/lower
- BGE/BLT = signed greater/less

---
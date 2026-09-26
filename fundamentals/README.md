# Fundamentals

- **[Data Structures](data_structures/)**
- **[State Machines](state_machines/)**

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
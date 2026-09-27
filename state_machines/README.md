# State Machines

**Moore FSM:** Output value depends on only current state.

**Mealy FSM:** Output value depends On both current state and inputs.

**Moore FSM Sequence:**

1. Get inputs
2. Go to the next state, this depends on the inputs and the current state.
3. Perform output, this depends on current state.
4. Wait for prescribed amount of time(optional)
5. 1 again

**Mealy FSM Sequence:**

1. Wait for prescribed amount of time(optional)
2. Get inputs
3. Perform output, this depends on current state and the inputs
4. Go to the next state, this depends on the inputs and the current state.
5. 1 again


## The State Graph

- Defines high-level behavior of the system.
- States are drawn as circles
- Arrows are drawn from one state to another, and labeled with the input value
causing that state transition.

## Choosing between Moore FSM and Mealy FSM

**Moore FSM:**
- Output is necessary to be a state.

**Mealy FSM:**
- No specific output value is necessary to be a state.
- Output is required to Transition the machine from one state to the next.

## FSM Implementation

- We use a linked structure with fixed size
- There should be one-to-one mapping between the FSM state graph and the data
structure.

## Designing Traffic Light System using Moore FSM

**3 Steps:**

1. Define what a state is. E.g. Light patterns
2. Make a list of various states in which system might exist.
3.  Add outputs and inputs to enable the system to affect external environment
and collect Information about environment.

**Key points about the system:**

- State describes which road has authority to cross the intersection.
- Light pattern defines which road has right of way over the other.

**Step 1: Inputs**

- PCO: East car sensor
- PC1: North car sensor

| PCO   | PC1   | Meaning |
|---|---|---|
| 0     | 0     | No cars exist on either road  |
| 0     | 1     | Cars are on the east road     |
| 1     | 0     | Cars are on the north road    |
| 1     | 1     | Cars are on both roads        |

**Step 2: States (and outputs):**

Create state and give each state a symbolic name.

|           | PA9   | PA8   | PA7   | PA6   | PA5   | PA4   |       |
|---        | ---   | ---   | ---   | ---   | ---   | ---   | ---   |
| go_north  | 1     | 0     | 0     | 0     | 0     | 1     | 0x210 |
| wait_north | 1    | 0     | 0     | 0     | 1     | 0     | 0x220 |
| go_east   | 0     | 0     | 1     | 1     | 0     | 0     | 0x0C0 |
| wait_east | 0     | 1     | 0     | 1     | 0     | 0     | 0x140 |

**Decision rules:**

1. If no cars are coming stay in green state
2. To change from green to red implement yellow for exactly 5 seconds.
3. Green lights should last for at least 30 seconds
4. If cars are only coming in one direction, move to that direction and stay in green.
5. If cars are coming in both directions cycle through all 4 states.

**Map FSM Graph unto data structure:**

```C
struct State{
    uint32_t Out; //E.g 180001
    uint32_t Time;//E. 30
    const struct state * Next [4]; //E.g. gon, waith, gon, wat tN
}
```

[State machines in c](state_in_c.c)
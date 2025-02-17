# Final Project (Logic Networks Project)

## Project Description
This repository contains the code and documentation related to the **Final Project (Logic Networks Project)**, developed as part of the Bachelor's Thesis in **Computer Engineering** at Politecnico di Milano during the **2023-2024** academic year.

### Authors:
- **Matteo Civitillo** (Student ID: 984313)
- **Alessandro Paolo Gianni Callegari** (Student ID: 980921)

**Advisor:** Prof. William Fornaciari

## Project Objective
The objective of this project is the implementation of an **error correction code decoder** focusing on data correction management within a **RAM module**. The implemented component allows:
- Reading stored words from RAM
- Replacing any "zero" values with the last valid value read
- Assigning a **credibility value** to corrected data, indicating the probability that the substituted value is accurate

The design is based on a **finite state machine** to optimize processing and reduce signal latency.

## Repository Structure
The repository is organized as follows:

```
├── docs/                  # Documentation
│   ├── Final_Document.pdf # Project report
│   └── specifications/    # Specifications of the project
│
├── src/                   # Project source code
│   ├── rtl/               # Hardware modules (VHDL/Verilog)
│   ├── tb/                # Testbench and simulation scripts
│
├── README.md              # Main documentation (this file)
```

## System Operation
The component operates based on **15 main states**, divided into four categories:
1. **Managing the first value read and zero verification**
2. **Evaluating the read value and handling state transitions**
3. **Processing a valid non-zero value**
4. **Replacing zeros and decrementing credibility**

Each processing cycle follows these main phases:
1. Reading a word from RAM
2. Replacing any zero values
3. Writing the credibility value
4. Updating the current value and advancing the read address

## Experimental Results
Post-synthesis tests were conducted to verify the correct operation of the system. Key analyzed scenarios include:
- **Reset during an incomplete read operation**
- **Handling sequences with consecutive initial zeros**
- **Credibility value decrementing to zero**
- **Operation with minimal sequences (K=1)**
- **Execution without explicit reset between two consecutive runs**

The **synthesis and timing** analysis reveals:
- **Maximum propagation time**: 14ns out of 20ns available
- **No latch usage** and a minimal number of flip-flops to ensure clock synchronization


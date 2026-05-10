# Spread-Time CDMA Transceiver Digital Blocks

This repository contains part of my BSc thesis project in Electrical Engineering at Sharif University of Technology.

In this project, I designed and implemented the digital baseband (BB) blocks of a Spread-Time CDMA (ST-CDMA) transceiver in Verilog. The system was first implemented on a Xilinx Spartan-6 FPGA using Xilinx ISE under very strict resource constraints, later upgraded to a Xilinx Zynq-7000 FPGA platform using Vivado, and finally prepared for future ASIC implementation alongside the analogue RF blocks on the same IC.

For the sake of keeping the final project confidential, I have only included the fully functional FPGA baseband codes used together with our RF front-end on a custom-designed PCB operating at 433 MHz. The original project also contained custom FIR filters, FFT modules, and DDS implementations. In this repository, I have instead demonstrated equivalent implementations utilizing FPGA IP cores while keeping the main architecture and synchronization logic untouched.

The repository mainly demonstrates the FPGA digital baseband side of the transceiver system.

---

# System Overview

## Transmitter (TX)

The transmitter baseband architecture begins with an input bitstream which gets multiplied by a predefined code sequence for encoding purposes. The encoded signal then passes through a mixer/multiplier block which adjusts the bitrate to the appropriate rate required by the RF transmitter chain.

The final digital outputs are connected to a DAC, which interfaces directly with the RF side of the transmitter implemented on our PCB.

The transmitted RF signal propagates through a ~10 meter air channel before being received by the receiver side.

---

## Receiver (RX)

After RF processing on the receiver PCB, the received analogue signal is converted back into digital form through an ADC, which acts as the input to the FPGA receiver baseband blocks.

The received signal is then divided into I/Q (In-phase and Quadrature) branches by mixing the signal with:

- sin(fBB + fPLL)
- cos(fBB + fPLL)

These signals are generated using DDS modules whose frequencies are controlled by a Digital PLL.

The resulting I and Q branches pass through two FIR filters with:
- 16:1 decimation
- 8:1 decimation

This filtering stage both removes unwanted frequency components and reduces the bitrate by a total factor of 128.

Why not use a single FIR filter with 128:1 decimation?

Because implementing such a filter on the Spartan-6 FPGA would require an extremely large number of taps/stages, consuming most of the available FPGA resources. Splitting the filtering into multiple stages significantly reduced hardware utilization while preserving functionality.

The outputs of the FIR filters and the decoder operate at different bitrates, therefore a PISO (Parallel-In Serial-Out) block was implemented to properly synchronize and match timing between modules.

The synchronized data is then processed using:
- FFT blocks
- code-sequence multiplication
- accumulation/summation stages

Every 128 outputs are summed together to produce the final decoded signal.

An alternative approach would have been implementing another FIR-based convolution block instead of FFT-based decoding. Although this could significantly improve speed, it would also dramatically increase hardware complexity and resource usage on the Spartan-6 FPGA.

The I and Q branches both independently pass through these decoding stages.

---

# Digital PLL and Decision Blocks

The decoded I and Q outputs are then processed through a Digital PLL which locks the receiver baseband frequency onto the transmitter frequency.

Typically:
- one branch approaches zero once lock is achieved
- the other branch contains the main decoded information

Finally, the signal passes through decision-making blocks which determine whether each decoded symbol corresponds to:
- +1
- or -1 (0)

---

# Repository Contents

This repository includes:
- Transmitter baseband Verilog modules
- Receiver baseband Verilog modules
- Timing synchronization/control logic
- PISO modules
- FPGA-compatible FFT/DDS/FIR examples (IP Cores)
- System block diagrams
- Example simulation and implementation files

The block diagrams of:
- the transmitter baseband
  <img width="895" height="457" alt="Screenshot 1405-02-20 at 14 00 47" src="https://github.com/user-attachments/assets/62bcf674-28d0-47a8-83f8-fc062b3055d4" />

- A simplified RF receiver overview
  <img width="1087" height="518" alt="Screenshot 1405-02-20 at 14 01 08" src="https://github.com/user-attachments/assets/9e9431af-4ea7-46ae-8091-4cb4c45f801c" />
  
- receiver baseband
  <img width="1156" height="573" alt="Screenshot 1405-02-20 at 14 01 25" src="https://github.com/user-attachments/assets/158f0943-3960-4b9a-a17d-ab84c867e211" />
  
- Digital PLL
  <img width="1156" height="468" alt="Screenshot 1405-02-20 at 14 01 35" src="https://github.com/user-attachments/assets/74908785-ded1-4e2b-8656-bebeed039494" />



are provided above.

## Repository Structure and File Descriptions

### 1. Transmitter

This folder contains the simulation-ready baseband transmitter modules for the ST-CDMA system.

#### Files

- `Top.v`  
  Main transmitter module.

- `Inputs.v`  
  Generates the input bitstream for simulation.

- `Code_RAM.v`  
  Stores the encoding code sequence. The numbers inside this RAM were generated in MATLAB after simulating and validating the complete system behaviour.

- `Top_tb.v`  
  Testbench for the transmitter.

- `My_DDS.v`  
  Example DDS module that can be used instead of the DDS IP Core.

By uncommenting the `Extention_Header` outputs and commenting the `To_DAC` outputs, the design can be realised on a Spartan-6 FPGA board after assigning the FPGA pins and generating the bitstream file. The output of the digital blocks can then be monitored directly through ChipScope.

---

### 2. Receiver

This folder contains the simulation-ready baseband receiver modules.

#### Files

- `Overall_Top.v`  
  Main receiver module.

- `Overall_Top_tb.v`  
  Receiver testbench.

- `PISO.v`  
  One of the main timing adjustment blocks between different bitrate stages.

- `RAM_Decoding.v`  
  Stores the decoding sequence. Similar to `Code_RAM.v`, these values were generated through MATLAB simulations of the complete transceiver.

- `Reset_module.v`  
  A small workaround module used to solve one of the persistent IP Core reset-related bugs during implementation.

- `My_DDS.v`  
  Example DDS implementation generated by storing one period of a sine/cosine waveform.

- `Integrator_DDS.v`  
  Accumulates the decoded FFT outputs.

- `Dot_Product_Multiplier.v`  
  Lightweight multiplier module used instead of a heavier multiplier IP Core.

- `Adder.v`  
  Simple adder module used for packet generation and accumulation operations.

---

### 3. Project Outcome

This folder contains several photos from the final implemented system and measurements.

#### Files

- `PCB and FPGA`  
  Final custom PCB connected to the FPGA board.

- `Overall System and Spectrum Analyzer`  
  Complete setup during measurements.

- `Baseband in Spectrum Analyzer`  
  Captured baseband signal in the spectrum analyser.

# 🚀 Custom DDR4 Memory Controller

This project implements a custom DDR4 memory controller system in Verilog, designed for high-speed data transactions between a processor and DDR4 SDRAM modules. The architecture includes three key modules: the DDR Controller, the DDR PHY Interface (DFI), and the DDR4 Memory Module.

## 📌 Overview

The goal of this project is to design and simulate a DDR4-based memory subsystem tailored for high-performance computing environments. This includes command management, address decoding, and reliable signal timing based on DDR4 standards.

### 🧠 Key Features

* **DDR Controller**: Manages read/write operations, command handling, and FSM-based sequencing for reliable memory access.
* **DFI Interface**: Translates controller signals into DDR4-compliant PHY signals and manages clocking and data synchronization.
* **DDR4 Memory Module**: Simulates the actual SDRAM chip, handling bank operations, row/column access, and burst transfers.

---

## 🏗️ Architecture

```
Processor ↔ DDR Controller ↔ DFI (PHY Interface) ↔ DDR4 Memory Module
```

### 1. **DDR Controller**

* Generates memory access signals: `RAS`, `CAS`, `CS`, `WE`
* Uses FSM states: `IDLE`, `ACTIVATE`, `READ`, `WRITE`, `PRECHARGE`
* Controls timing and synchronization for efficient data flow

### 2. **DFI (DDR PHY Interface)**

* Converts high-level controller commands to physical layer signals
* Handles `dfi_wrdata`, `dfi_wrdata_mask`, and signal alignment
* Ensures proper clocking (`cke`, `clk`) and ODT management

### 3. **DDR4 Memory Module**

* Organized into 4 Bank Groups × 4 Banks = 16 Banks
* Supports burst types: Sequential / Interleaved
* Uses pipelined read/write operations with burst lengths (BL4/BL8)

---

## 🔁 FSM Logic

The controller FSM handles transitions between the following states:

* `IDLE`: Waits for read/write commands
* `ACTIVATE`: Selects row based on address
* `READ/WRITE`: Performs data operations
* `PRECHARGE`: Closes row before next access

---


## ⚙️ Mode Register Settings

* Only **MR0** is implemented.
* Configurable options include:

  * **CAS Latency**
  * **Burst Type** (Sequential / Interleaved)
  * **Burst Length** (BL4 / BL8)

---

## 🕒 Timing Diagrams

Timing diagrams for **READ** and **WRITE** operations demonstrate clock synchronization, data strobe alignment (DQS), and command sequencing based on burst-oriented transfers.


## 📌 Conclusion

This project showcases the design and simulation of a functional DDR4 memory subsystem. The modular architecture, compliant signal interfacing, and FSM-driven controller logic provide a robust foundation for memory-intensive applications in embedded and VLSI systems.

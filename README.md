# RISC-V3 Synthesis and Physical Implementation

RTL synthesis, place-and-route, and sign-off implementation of a RISC processor using **SystemVerilog**, **Cadence Genus**, **Cadence Innovus**, and the **Sky130** technology library.

# Project Overview

This project demonstrates the complete digital implementation flow of a RISC processor from synthesizable RTL through physical design and post-route sign-off.

The main objectives were to:

- Synthesize the processor using Cadence Genus
- Map the design to the Sky130 standard-cell library
- Perform floorplanning, placement, clock-tree synthesis, and routing in Cadence Innovus
- Perform post-route timing and power analysis
- Compare synthesis and PnR sign-off results

# Implementation Flow
```text
SystemVerilog RTL
        ↓
Cadence Genus
        ↓
Logic Synthesis
        ↓
Technology Mapping — Sky130
        ↓
Gate-Level Netlist
        ↓
Cadence Innovus
        ↓
Floorplanning
        ↓
Placement
        ↓
Clock Tree Synthesis
        ↓
Routing
        ↓
Post-Route Sign-off

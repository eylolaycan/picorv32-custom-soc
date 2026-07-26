# Physical Design Implementation

## RTL Integration

The project started from Verilog RTL modules describing the processor, memory, and peripheral subsystem.

## Logic Synthesis

RTL synthesis was performed using the OpenLane synthesis flow targeting the SKY130 HD standard-cell library.

## Floorplanning

The floorplan was manually adjusted to accommodate the three hard macros while maintaining routing resources and power distribution.

## Power Distribution Network

A hierarchical PDN was generated for the complete design.

During development, PDN generation initially failed because one macro exported Metal5 power pins that conflicted with the top-level power grid. The macro LEF was modified to expose the correct power connections, allowing successful PDN generation.

## Placement

Standard cells were placed after fixing the macro locations. Placement optimization minimized congestion around the macro boundaries.

## Clock Tree Synthesis

Clock buffering was automatically generated using OpenROAD CTS.

## Routing

Global routing and detailed routing completed successfully.

The final routed design produced zero routing DRC violations.

## GDSII Generation

After physical verification, the final GDSII database was generated for fabrication.

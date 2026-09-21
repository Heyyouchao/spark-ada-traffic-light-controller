# SPARK Ada Traffic Light Controller

A safety-critical traffic light controller developed in **SPARK Ada** as
part of my Critical Systems coursework at Swansea University.

The system models a junction with a **main road, side road and
pedestrian crossing**, using formal contracts and GNATprove to verify
its safety properties.

**Coursework result: 92%**

------------------------------------------------------------------------

## 🚦 Overview

The program simulates a traffic-light controller for a road junction.

The user acts as the junction's sensors by indicating whether:

-   a car is waiting on the main road;
-   a car is waiting on the side road; or
-   a pedestrian is waiting to cross.

The controller uses these inputs to determine the appropriate
traffic-light sequence while maintaining the safety requirements of the
junction.

The project separates the safety-critical control logic from the user
interaction:

-   **`Traffic_Control`** contains the traffic-light state,
    decision-making logic and safety requirements.
-   **`Main`** handles user input and displays each stage of the
    traffic-light sequence.

------------------------------------------------------------------------

## 🛡️ Safety Requirements

Because a traffic-light controller is safety-critical, the system
defines rules that must always be maintained.

The key safety requirements include:

-   The main road and side road must never be green at the same time.
-   Pedestrians may only cross when both roads are red.
-   A road may only receive a green signal when the conflicting road and
    pedestrian signal are red.
-   The controller can return the junction to an all-red safe state.

These requirements are represented within the SPARK implementation so
they can be checked formally rather than relying only on runtime
testing.

------------------------------------------------------------------------

## 🔄 Traffic-Light Behaviour

The controller provides separate sequences for the pedestrian crossing,
main road and side road.

### Pedestrian Crossing

``` text
Main Road: Red
Side Road: Red
Pedestrian: Green
        ↓
All Red
```

The pedestrian signal can only become green when both roads are red.

### Main Road

``` text
Amber → Green → Amber → Red
```

During this sequence, the side road and pedestrian signal remain red.

### Side Road

``` text
Amber → Green → Amber → Red
```

During this sequence, the main road and pedestrian signal remain red.

If no traffic or pedestrian request requires a change, the junction can
remain in the all-red state.

------------------------------------------------------------------------

## ✅ Formal Verification

A major part of this project was using **SPARK Ada** to express and
verify the expected behaviour of the controller.

The implementation uses SPARK contracts including:

-   `Pre` conditions
-   `Post` conditions
-   `Global` contracts
-   `Depends` contracts
-   a junction-wide `Safe` predicate

The `Safe` predicate represents conditions that must hold for the
traffic lights to be considered safe.

Contracts are then used around the traffic-control operations to
describe their expected behaviour and resulting state.

**GNATprove** was used during development to analyse the implementation,
including checking for run-time errors and verifying the specified
safety properties.

This provides stronger assurance than relying only on testing individual
traffic-light scenarios.

------------------------------------------------------------------------

## 🏗️ Project Structure

The main implementation is organised around the traffic controller and
the interactive simulation.

``` text
code/
├── main.adb
├── main.gpr
├── traffic_control.ads
├── traffic_control.adb
├── as_io_wrapper.ads
├── as_io_wrapper.adb
├── spark.ads
├── spark-text_io.ads
├── spark-text_io.adb
├── spark-text_io-integer_io.ads
└── spark-text_io-integer_io.adb
```

### `traffic_control.ads`

Defines the traffic-light types, junction state, safety predicate and
SPARK contracts used to specify the expected behaviour of the
controller.

### `traffic_control.adb`

Contains the implementation of the traffic-control operations, including
the main-road, side-road, pedestrian and all-red behaviour.

### `main.adb`

Provides the interactive simulation. It reads the simulated sensor
inputs from the user and displays the traffic-light sequence produced by
the controller.

### `main.gpr`

GNAT project configuration used to build the Ada application.

------------------------------------------------------------------------

## 🧰 Technologies

-   **Ada**
-   **SPARK Ada**
-   **GNAT**
-   **GNATprove**
-   Formal verification
-   Design by Contract

------------------------------------------------------------------------

## 💡 What I Learned

This project introduced me to a different approach to software
development where safety requirements are specified as part of the
program rather than being checked only through conventional testing.

Through the project, I gained experience with:

-   modelling system state in Ada;
-   implementing safety-critical control logic;
-   defining explicit safety properties;
-   writing preconditions and postconditions;
-   using `Global` and `Depends` contracts;
-   separating safety-critical logic from user interaction;
-   using GNATprove to analyse SPARK code; and
-   reasoning about whether unsafe system states can occur.

One of the main lessons from the project was that testing individual
examples is not always enough for safety-critical software. Formal
specifications can be used to describe what must always be true and
allow verification tools to analyse whether the implementation maintains
those properties.

------------------------------------------------------------------------

## 🎓 Academic Context

This project was developed as coursework for the **Critical Systems**
module at **Swansea University**.

**Result: 92%**

The repository is retained as a portfolio and learning record of my own
coursework implementation.

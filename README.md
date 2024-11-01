# EE2026-Project-No.4


# Top_Student Game Module

## Table of Contents
- [Overview](#overview)
- [Modules](#modules)
  - [Top_Student](#top_student)
  - [flexi_clk](#flexi_clk)
  - [Oled_Display](#oled_display)
  - [debounce](#debounce)
  - [HealthBar](#healthbar)
- [Game States](#game-states)
- [Usage Instructions](#usage-instructions)

## Overview
The `Top_Student` module implements a state machine that manages game states and interactions based on user inputs. It includes features such as score tracking, health management, and visual output to an OLED display.

## Modules

### Top_Student
**Description:** Main module orchestrating game logic.

- **Inputs:**
  - `clk`: System clock signal.
  - `btnC`, `btnL`, `btnR`, `btnU`, `btnD`: Button inputs for user interaction.
  - `reset`: Signal to reset the game state.

- **Outputs:**
  - `JB[7:0]`: Outputs to the OLED display.
  - `seg[6:0]`: Seven-segment display output for scoring.
  - `an[3:0]`: Anode control for the seven-segment display.
  - `led[9:0]`: LED output for health status.

### flexi_clk
**Description:** Generates various clock frequencies used throughout the module.

- **Inputs:**
  - `clk`: Main clock input.
  - Frequency divider values (e.g., `32'd1249999`).

- **Outputs:**
  - Various clock signals (`clk_40hz`, `clk_6p25mhz`, etc.).

### Oled_Display
**Description:** Manages pixel data and rendering for the OLED display.

- **Inputs:**
  - Clock signal (`clk_6p25mhz`).
  - Control signals (`frame_begin`, `sending_pixels`, etc.).

- **Outputs:**
  - Data to be displayed on the OLED (`oled_data`).

### debounce
**Description:** Debounces button inputs to prevent false triggering from mechanical noise.

- **Inputs:**
  - Button signals (`btnU`, `btnC`, etc.).
  - Clock signal (`clk`).

- **Outputs:**
  - Debounced button signals (`btnU_d`, `btnC_d`, etc.).

### HealthBar
**Description:** Manages health status and visual representation on LEDs.

- **Inputs:**
  - Health value (`health`).
  - Clock signal (`clk`).

- **Outputs:**
  - LED outputs representing health status.

## Game States
The module operates through various states defined by a state machine:
- **IDLE**: Waiting for user input to start the game.
- **SQUARE, TRIANGLE, CIRCLE, STAR, RING**: Game states where the player interacts with falling shapes.
- **HOLD**: State where the player must hold a button to maintain score.
- **MISSED**: State indicating a missed interaction, leading to score updates.

## Usage Instructions

### Initialization
1. Ensure all connections are made properly, including clock signals and button inputs.

### Button Configuration
- **Button C**: Starts the game (transitions from `IDLE` to `SQUARE`).
- **Buttons U, D, L, R**: Used during different game states to interact with shapes.

### Clock Signals
The module generates several clock signals for timing purposes. Ensure that these are correctly routed to their respective modules.

### Display Output
The OLED display will show different colors based on the current game state. Ensure it is powered and connected properly.

### Health Management
The health bar is managed automatically based on interactions with shapes. Health decreases based on missed interactions or incorrect button presses.



### Milestones
Milestone 1: user input (btnL, btnC, btnR) is checked against expected button sequence and hold duration. A simple count of correct inputs is implemented (5 days) 
Milestone 2: Implement player score calculation based on correct sequence and duration (5 days)
Milestone 3: Implement high score system to maintain current device high score (5 days)
Milestone 4: Establish UART communication across boards for cross-board high scores (5 days)				
Milestone 5: Implement global high score system to maintain high score across boards (5 days)
Milestone 6: Add health and win fail system (5 days)
Milestone 7: Add option for custom song received through UART (5 days)
Milestone 8: Add VGA to mirror oled screen to an external monitor (3 days)

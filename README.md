# VHDL Ping Pong Game (FPGA)

A simple two-player ping-pong style game implemented in **VHDL** for an FPGA board.  
Two players use **switches/buttons** to “hit” the ball when it reaches their side. The **LEDs** represent the current ball position.

## How the Game Works
- A row of LEDs represents the ball traveling back and forth.
- Each player has one input switch/button.
- When the ball reaches the LED closest to a player, that player must press their switch to return the ball.
- If a player misses the other player scores / the round resets.

## Hardware / I/O
- **Inputs:** 2× switches/buttons (Player 1, Player 2)
- **Outputs:** LED array (ball position)  

## Project Structure (suggested)
- `src/` — VHDL source files
- `constraints/` — pin assignments / XDC / QSF / UCF (depending on FPGA tool)
- `sim/` — testbenches (if any)
- `media/` — demo video / images
- `README.md`

## Build / Program
Open the project in your FPGA toolchain (Vivado / Quartus / etc.), synthesize, implement, and program the board.

## Demo Video
- **Demo:** [Watch the FPGA demo video](media/demo.mp4)

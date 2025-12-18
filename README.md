# CPE 487: Final Project - Guitar Hero

**By: Anuj Sanvatsarkar and Emre Cosgun

This project is a recreation of the classic Guitar Hero games implemented on the Nexys A7-100T FPGA using VHDL, featuring automatic song playback and animated visual effects.

![Guitar Hero Logo](images/poster.png)

### Gameplay Demo
![Song Mode Demo](images/song_mode.gif)


## 1. Project Overview

Our project aims to recreate the classic Guitar Hero experience by attempting to replicate its core gameplay mechanics, and emulate its art style. When the game is started, notes of four different colors, green, red, pink, and blue begin falling down from the top of the screen into four respective columns, and players must press the corresponding keypad buttons when the notes reach the target zone at the bottom of the screen in order to score points. The game features both a **manual practice mode** and an **automatic song mode** that a plays an automatically progressing map tied to a melody.

### References: Original Guitar Hero and Past Labs/Projects

![Guitar Hero Reference](images/guitar_hero_reference.jpg)

### Key Features

- *Four Note Columns* 
- *Dual Game Modes* | Manual (practice) and Automatic (song) modes |
- *Audio Feedback* | PWM-generated musical tones (C major chord) |
- *Visual Effects* | Animated flames, hit flashes, circular notes |
- *Real-time Scoring* 
- *Keypad Input*

### How to Play

The goal of the game is to match the rythm of the track and catch the notes at the right time to score as many points as possible during the level.

**When SW0 is OFF (Practice Mode):**
- Press buttons (BTNL, BTND, BTNR, BTNU) to spawn notes
- Use keypad keys (0, F, E, D) to catch notes in the target zone
- Each successful hit increments your score

**When SW0 is ON (Song Mode):**
- Press BTNC to start the automatic song
- Notes fall automatically in a musical pattern
- Catch the notes with the keypad to score points
- Press BTNC again to restart after the song ends

## 2. Expected Behavior

1. **Notes spawn** at the top of the screen (manually via buttons, or automatically via song mode)
2. **Notes fall** down their respective colored columns toward target circles
3. **Target zone** displays circular buttons at the bottom of each lane
4. **Player presses** the corresponding keypad key when notes align with targets
5. **On successful hit:**
   - Note disappears from screen
   - Score increments on 7-segment display
   - Musical tone plays through audio output
   - White flash effect appears on target circle
6. **Visual feedback:**
   - Target circles light up when keys are pressed
   - Animated flames flicker on screen edges
   - Blue lane dividers and header bar

## 3. Required Hardware

- Nexys A7-100T FPGA Board
  
   ![Image](https://github.com/user-attachments/assets/5edc58a6-ec5b-46bc-b1d2-0fd3e77aa8ad)))

- Monitor & VGA-HDMI Connection
  
![Image](https://github.com/user-attachments/assets/04e7c01e-27d8-45ec-ad87-3c862c14134a)
![Image](https://github.com/user-attachments/assets/5c04fbfa-f294-402c-a5bc-fcfe01581eb6)

- Pmod 4x4 Keypad (Connected to JA Header)
 
![Image](https://github.com/user-attachments/assets/510206a9-0853-4641-a737-f5f39d70fc10)

- Speaker via 3.5mm Audio Jack
  
![Image](https://github.com/user-attachments/assets/53574b85-e8af-4d09-97da-558682b76f4f)

## 4. Setup Instructions

### Step 1: Download Files

Download all source files from this repository:

**VHDL Source Files:**
- `vga_top.vhd` - Top-level module
- `ball.vhd` - Note column logic
- `buttonTracker.vhd` - Hit detection and scoring
- `songPlayer.vhd` - Automatic song playback
- `toneGenerator.vhd` - PWM audio generation
- `vgaCombiner.vhd` - Graphics rendering
- `keypad.vhd` - Keypad input scanning
- `leddec16.vhd` - 7-segment display driver
- `vga_sync.vhd` - VGA timing generator
- `clk_wiz_0.vhd` - Clock wizard wrapper
- `clk_wiz_0_clk_wiz.vhd` - Clock wizard implementation

**Constraints File:**
- `vga_top.xdc` - Pin assignments

### Step 2: Create Vivado Project

1. Open **AMD Vivado Design Suite**
2. Create a new RTL project
3. Add all `.vhd` files as design sources
4. Add `vga_top.xdc` as constraints
5. Select **Nexys A7-100T** as target board

### Step 3: Build and Program

1. Click **Run Synthesis** (wait for completion)
2. Click **Run Implementation** (wait for completion)
3. Click **Generate Bitstream**
4. Open **Hardware Manager**
5. Click **Open Target** → **Auto Connect**
6. Click **Program Device**

### Step 4: Connect Hardware

1. Connect VGA cable from board to monitor
2. Connect Pmod keypad to JA header
3. Connect speaker to audio jack
4. Power on the board via USB

### Step 5: Play!

- The game beings in practice mode, set SW0 to ON for song mode, and back to SW0 for practice mode
- Press BTNC to start song (in song mode)
- Use keypad bottom row (0, F, E, D) to hit notes

## 5. System Architecture

### Block Diagram

```
                        ┌─────────────────────────────────┐
                        │           vga_top               │
                        │                                 │
     Buttons ───────────┼──▶ noteColumn 1 ──▶ Colors ────┼──▶ VGA
     Keypad ────────────┼──▶ noteColumn 2 ──▶            │
     Switch ────────────┼──▶ noteColumn 3 ──▶ Combiner ──┼──▶ Display
     Clock ─────────────┼──▶ noteColumn 4 ──▶            │
                        │          │                      │
                        │          ▼                      │
                        │   buttonTrackers ──▶ Score ────┼──▶ 7-Segment
                        │          │                      │
                        │          ▼                      │
                        │   toneGenerator ───────────────┼──▶ Audio
                        │                                 │
                        │   songPlayer ──▶ Note Patterns  │
                        └─────────────────────────────────┘
```

### Module Overview

| Module | File | Description |
|--------|------|-------------|
| **vga_top** | `vga_top.vhd` | Top-level module connecting all components |
| **noteColumn** | `ball.vhd` | Manages falling notes using 600-bit shift register |
| **buttonTracker** | `buttonTracker.vhd` | Detects hits in target zone, updates score |
| **songPlayer** | `songPlayer.vhd` | Plays pre-programmed song patterns |
| **toneGenerator** | `toneGenerator.vhd` | Generates PWM audio at musical frequencies |
| **colorCombiner** | `vgaCombiner.vhd` | Combines all visual elements for display |
| **keypad** | `keypad.vhd` | Scans 4x4 matrix keypad for input |
| **leddec16** | `leddec16.vhd` | Drives 8-digit 7-segment display |
| **vga_sync** | `vga_sync.vhd` | Generates VGA timing signals (800×600@60Hz) |
| **clk_wiz** | `clk_wiz_0.vhd` | Converts 100MHz to 40MHz pixel clock |

---

## 6. Inputs and Outputs

### `vga_top.vhd` - Top-Level Entity

```vhdl
ENTITY vga_top IS
    PORT (
        clk_in     : IN STD_LOGIC;                      -- 100 MHz system clock
        vga_red    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);  -- VGA red channel
        vga_green  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);  -- VGA green channel
        vga_blue   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  -- VGA blue channel
        vga_hsync  : OUT STD_LOGIC;                     -- Horizontal sync
        vga_vsync  : OUT STD_LOGIC;                     -- Vertical sync
        SEG7_anode : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);  -- 7-segment anodes
        SEG7_seg   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- 7-segment segments
        bt_clr     : IN STD_LOGIC;                      -- Center button (start/reset)
        bt_strt    : IN STD_LOGIC;                      -- Left button (green note)
        bt_strt1   : IN STD_LOGIC;                      -- Down button (red note)
        bt_strt2   : IN STD_LOGIC;                      -- Right button (purple note)
        bt_strt3   : IN STD_LOGIC;                      -- Up button (blue note)
        KB_col     : OUT STD_LOGIC_VECTOR(4 DOWNTO 1);  -- Keypad columns
        KB_row     : IN STD_LOGIC_VECTOR(4 DOWNTO 1);   -- Keypad rows
        SW         : IN STD_LOGIC;                      -- Mode switch (SW0)
        LED        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Debug LEDs
        AUD_PWM    : OUT STD_LOGIC;                     -- Audio PWM output
        AUD_SD     : OUT STD_LOGIC                      -- Audio shutdown (active low)
    );
END vga_top;
```

### `ball.vhd` - Note Column Entity

```vhdl
ENTITY noteColumn IS
    PORT (
        clk            : IN STD_LOGIC;                       -- System clock
        v_sync         : IN STD_LOGIC;                       -- Vertical sync
        pixel_row      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);   -- Current pixel row
        pixel_col      : IN STD_LOGIC_VECTOR(10 DOWNTO 0);   -- Current pixel column
        horiz          : IN STD_LOGIC_VECTOR(10 DOWNTO 0);   -- Column X position
        note_input     : IN STD_LOGIC;                       -- Spawn note signal
        hit_signal_in  : IN STD_LOGIC;                       -- Clear note signal
        color          : IN STD_LOGIC_VECTOR(2 DOWNTO 0);    -- Note color (RGB)
        keypress       : IN STD_LOGIC;                       -- Key pressed
        hit_signal_out : OUT STD_LOGIC;                      -- Hit feedback
        note_col_out   : OUT STD_LOGIC_VECTOR(599 DOWNTO 0); -- Note positions
        red            : OUT STD_LOGIC;                      -- Red output
        green          : OUT STD_LOGIC;                      -- Green output
        blue           : OUT STD_LOGIC                       -- Blue output
    );
END noteColumn;
```

### `songPlayer.vhd` - Song Player Entity

```vhdl
ENTITY songPlayer IS
    PORT (
        clk           : IN  STD_LOGIC;                      -- System clock
        reset         : IN  STD_LOGIC;                      -- Reset signal
        start         : IN  STD_LOGIC;                      -- Start song signal
        note_out_1    : OUT STD_LOGIC;                      -- Column 1 note output
        note_out_2    : OUT STD_LOGIC;                      -- Column 2 note output
        note_out_3    : OUT STD_LOGIC;                      -- Column 3 note output
        note_out_4    : OUT STD_LOGIC;                      -- Column 4 note output
        song_position : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);   -- Current position
        song_playing  : OUT STD_LOGIC;                      -- Playing status
        song_done     : OUT STD_LOGIC                       -- Song finished flag
    );
END songPlayer;
```

### `toneGenerator.vhd` - Audio Generator Entity

```vhdl
ENTITY toneGenerator IS
    PORT (
        clk       : IN  STD_LOGIC;                     -- 100 MHz clock
        hit_green : IN  STD_LOGIC;                     -- Green note hit
        hit_red   : IN  STD_LOGIC;                     -- Red note hit
        hit_purple: IN  STD_LOGIC;                     -- Purple note hit
        hit_blue  : IN  STD_LOGIC;                     -- Blue note hit
        audio_out : OUT STD_LOGIC                      -- PWM audio output
    );
END toneGenerator;
```

---

## 7. Modifications from Starter Code

This project builds upon the Pong lab, particularly the ball.vhd module, as well as the ideas explored in the Fall 2024 Guitar Hero project highilghted in the project rubric. We made **extensive modifications** to stater code, as well as drafting our own key modules in order to create a fully functional Guitar Hero gameplay experience.

### Summary of Changes

| Component | Original | Our Version |
|-----------|----------|-------------|
| Note Columns | 2 working | 4 fully functional |
| Note Shape | Rectangular | Circular |
| Song Mode | Not implemented | Full automatic playback |
| Audio | None | PWM tones (C major chord) |
| Visual Effects | Basic white background | Flames, dark theme, hit flashes |
| Mode Selection | None | SW0 toggle for manual/song mode |
| Target Buttons | Ovals | Perfect circles with press feedback |

### New Files Created

#### `songPlayer.vhd` - Automatic Song Playback
This module was created from scratch to enable automatic song mode:

```vhdl
-- Song patterns stored as 256-bit constants
-- Each bit represents a time step (~84ms)
CONSTANT SONG_COL1 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
    X"00000000000000008080000000008080808000000000808080800000000080FF";
    
-- State machine controls playback
IF playing_reg = '0' THEN
    -- Wait for start button
    IF start_rising THEN
        playing_reg <= '1';
        position_reg <= 0;
    END IF;
ELSE
    -- Advance through pattern on tempo ticks
    IF tempo_rising THEN
        note_out_1 <= SONG_COL1(255 - position_reg);
        position_reg <= position_reg + 1;
    END IF;
END IF;
```

**Key Feature:** Notes are held HIGH for 5.2ms to ensure the note column samples them (it samples every 2.6ms).

#### `toneGenerator.vhd` - PWM Audio Generation
Created from scratch to provide audio feedback:

```vhdl
-- Musical note frequencies (C major chord)
CONSTANT TONE_GREEN  : INTEGER := 190839;  -- C4 (262 Hz)
CONSTANT TONE_RED    : INTEGER := 151515;  -- E4 (330 Hz)
CONSTANT TONE_PURPLE : INTEGER := 127551;  -- G4 (392 Hz)
CONSTANT TONE_BLUE   : INTEGER := 95602;   -- C5 (523 Hz)

-- PWM generation: toggle output at calculated frequency
IF tone_counter < current_divider THEN
    tone_counter <= tone_counter + 1;
ELSE
    tone_counter <= 0;
    pwm_out <= NOT pwm_out;  -- Creates square wave
END IF;
```

### Major Modifications to Existing Files

#### `ball.vhd` - Complete Rewrite for Circular Notes

**Original:** Rectangular notes, no disappear logic
**Modified:** Circular notes that vanish after passing target zone

```vhdl
-- Circular note drawing (replaces rectangular)
FOR offset IN -NOTE_RADIUS TO NOTE_RADIUS LOOP
    row_check := pixel_row_int + offset;
    IF note_col(row_check) = '1' THEN
        dx := pixel_col_int - horiz_int;
        dy := offset;
        dist_sq := dx * dx + dy * dy;
        IF dist_sq <= radius_sq THEN
            note_on <= '1';  -- Inside circle
        END IF;
    END IF;
END LOOP;

-- Notes disappear after target zone
IF pixel_row_int < NOTE_DISAPPEAR_Y THEN
    -- Draw note
END IF;
```

#### `vgaCombiner.vhd` - Enhanced Graphics Engine

**Original:** Simple white background
**Modified:** Dark theme with animated flames, lane dividers, and hit effects

```vhdl
-- Animated flame effect (cycles through 8 phases)
IF anim_counter < 5000000 THEN
    anim_counter <= anim_counter + 1;
ELSE
    anim_counter <= 0;
    flame_phase <= (flame_phase + 1) MOD 8;
END IF;

-- Render priority system
IF note_pixel THEN
    -- Draw note (highest priority)
ELSIF in_header THEN
    r_out <= '0'; g_out <= '0'; b_out <= '1';  -- Blue header
ELSIF flash_active AND in_circle THEN
    r_out <= '1'; g_out <= '1'; b_out <= '1';  -- White hit flash
ELSIF keypress AND in_circle THEN
    -- Colored keypress feedback
ELSIF flame_intensity > 0 THEN
    -- Red/yellow flames on edges
ELSE
    r_out <= '0'; g_out <= '0'; b_out <= '0';  -- Black background
END IF;
```

#### `vga_top.vhd` - Mode Selection and Audio Integration

**Added:** Mode switch, song player integration, audio output

```vhdl
-- Mode selection multiplexer
note_input1 <= song_note1 WHEN (SW = '1' AND song_playing = '1') ELSE bt_strt1;

-- Audio integration
sound_gen : toneGenerator
PORT MAP(
    clk => clk_in,
    hit_green => hit_signals_out(0),
    hit_red => hit_signals_out(1),
    hit_purple => hit_signals_out(2),
    hit_blue => hit_signals_out(3),
    audio_out => AUD_PWM
);

AUD_SD <= '1';  -- Enable audio amplifier
```

#### `vga_top.xdc` - New Pin Assignments

**Added:** Mode switch, debug LEDs, audio output pins

```tcl
## Mode Switch
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { SW }];

## Audio Output
set_property -dict { PACKAGE_PIN A11 IOSTANDARD LVCMOS33 } [get_ports { AUD_PWM }];
set_property -dict { PACKAGE_PIN D12 IOSTANDARD LVCMOS33 } [get_ports { AUD_SD }];

## Debug LEDs
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN J13 IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN N14 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
```

---

## 8. Challenges and Solutions

### Challenge 1: Song Mode Notes Not Appearing

**Problem:** Song was running (LED confirmed), but no notes appeared on screen.

**Root Cause:** Timing mismatch - songPlayer output notes for only 10ns, but noteColumn samples every 2.6ms.

**Solution:** Added pulse duration to hold notes HIGH for 5.2ms:
```vhdl
IF pulse_counter < 524288 THEN  -- Hold for 2^19 cycles
    note_out_1 <= SONG_COL1(position);
    pulse_counter <= pulse_counter + 1;
END IF;
```

### Challenge 2: Synthesis Taking 20+ Minutes

**Problem:** Vivado would hang during synthesis optimization.

**Root Cause:** Drawing loop checked all 600 rows for every pixel (821,400 parallel comparators).

**Solution:** Only check rows within note radius (37 iterations instead of 600):
```vhdl
-- Before: FOR note_y IN 0 TO 599 LOOP (BAD)
-- After:
FOR offset IN -18 TO 18 LOOP  -- Only check nearby rows
```

**Result:** Synthesis time reduced from 20+ minutes to ~3 minutes.

### Challenge 3: Notes Not Clearing After Hit

**Problem:** Same note could be hit multiple times, inflating score.

**Solution:** Added hit_signal feedback to clear notes from shift register:
```vhdl
IF hit_signal_in = '1' THEN
    note_col(580 DOWNTO 550) <= (OTHERS => '0');
END IF;
```

### Challenge 4: No Audio Output

**Problem:** No sound from audio jack.

**Root Cause:** AUD_SD pin (amplifier enable) wasn't set; frequency divider was incorrect.

**Solution:** 
```vhdl
AUD_SD <= '1';  -- Enable amplifier
-- Fixed divider: 100MHz / (2 × frequency)
```

---

## 9. Timing Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| System Clock | 100 MHz | Board oscillator |
| Pixel Clock | 40 MHz | VGA timing |
| Note Fall Speed | 2^18 cycles (~2.6ms) | Per-pixel movement |
| Song Tempo | 2^23 cycles (~84ms) | Per-beat timing |
| Note Pulse Duration | 2^19 cycles (~5.2ms) | Signal hold time |
| Hit Zone | Rows 550-580 | 30-pixel window |
| Column Positions | 160, 320, 480, 640 | X coordinates |

### Musical Notes (Audio)

| Column | Color | Note | Frequency | PWM Divider |
|--------|-------|------|-----------|-------------|
| 1 | Green | C4 | 262 Hz | 190,839 |
| 2 | Red | E4 | 330 Hz | 151,515 |
| 3 | Purple | G4 | 392 Hz | 127,551 |
| 4 | Blue | C5 | 523 Hz | 95,602 |

---

## 10. Summary and Contributions

### Caleb Romero
- Designed `buttonTracker.vhd` (hit detection and scoring)
- Designed `vgaCombiner.vhd` (visual effects and rendering)
- Implemented flame animations and hit flash effects
- Debugged timing synchronization issues

### Jose Martinez-Ponce
- Designed `songPlayer.vhd` (automatic song playback)
- Designed `toneGenerator.vhd` (PWM audio generation)
- Created song patterns ("Ode to Joy" adaptation)
- GitHub documentation and README

### Joint Effort
- `ball.vhd` modifications (circular notes, note disappearing)
- `vga_top.vhd` integration (mode selection, signal routing)
- Testing and debugging
- Hardware setup and demonstrations

### Timeline

| Date | Milestone |
|------|-----------|
| Week 1 | Project planning, reviewed starter code |
| Week 2 | Extended to 4 working columns, basic functionality |
| Week 3 | Added song mode, audio generation |
| Week 4 | Visual enhancements, debugging, optimization |
| Final Week | Testing, documentation, presentation |

---

## 11. Future Improvements

If given more time, we would implement:

1. **More Songs** - Add song selection via switches
2. **Difficulty Levels** - Adjustable note speed
3. **Miss Detection** - Penalty for missed notes
4. **Combo System** - Score multiplier for consecutive hits
5. **Background Music** - Full audio track playback
6. **Better Graphics** - Sprites instead of simple shapes
7. **Two-Player Mode** - Split screen competition


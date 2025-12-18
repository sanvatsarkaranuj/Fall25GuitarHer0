# CPE 487: Final Project - Guitar Hero

**By: Anuj Sanvatsarkar and Emre Cosgun

This project is a recreation of the classic Guitar Hero games implemented on the Nexys A7-100T FPGA using VHDL, featuring automatic song playback and animated visual effects.

<img width="612" height="448" alt="Image" src="https://github.com/user-attachments/assets/a8c2b02a-7f0f-4320-a923-29bcb2b0c1c5" />

### Gameplay Demo

https://github.com/user-attachments/assets/097b2fa6-f99b-4719-93e8-59f337e5834c

## 1. Project Overview

Our project aims to recreate the classic Guitar Hero experience by attempting to replicate its core gameplay mechanics, and emulate its art style. When the game is started, notes of four different colors, green, red, pink, and blue begin falling down from the top of the screen into four respective columns, and players must press the corresponding keypad buttons when the notes reach the target zone at the bottom of the screen in order to score points. The game features both a **manual practice mode** and an **automatic song mode** that a plays an automatically progressing map tied to a melody.

![Image](https://github.com/user-attachments/assets/06480f36-90ae-4178-9232-adf2df269e99)

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

<img width="2370" height="1505" alt="Image" src="https://github.com/user-attachments/assets/22215055-5227-423d-8c8a-6f55f4794b3d" />

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

## 7. Modifications from Starter Code and Module Design

This project builds upon the Pong lab, particularly the ball.vhd module, as well as the ideas explored in the Fall 2024 Guitar Hero project highlighted in the project rubric. We made extensive modifications to stater code files, as well as drafting our own key modules in order to create a fully functional Guitar Hero gameplay experience.


#### `songPlayer.vhd` - Automatic Song Playback
This module was created from scratc enable automatic song mode plays a 256-step song pattern.

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

#### `toneGenerator.vhd` - PWM Audio Generation
This module was created from scratch to provide audio feedback and generates musical tones when notes are hit.

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

#### `vgaCombiner.vhd` - Graphics Processor
This module was created from scratch to manage the visual effects:
- Adds animated flame effects on screen edges
- Adds circle-shaped keypress feedback
- Adds hit flash effects
- Changes background from white to black

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

### Major Modifications/Logic Implementations

`vga_top.vhd` - Top-Level Integration

The top-level module connects all components and handles mode selection.

#### Mode Selection Multiplexer
This is the key logic that switches between manual and song mode:

```vhdl
-- SW = '1' (ON): Song mode - use song notes
-- SW = '0' (OFF): Manual mode - use button inputs
note_input1 <= song_note1 WHEN (SW = '1' AND song_playing = '1') ELSE bt_strt1;
note_input2 <= song_note2 WHEN (SW = '1' AND song_playing = '1') ELSE bt_strt;
note_input3 <= song_note3 WHEN (SW = '1' AND song_playing = '1') ELSE bt_strt2;
note_input4 <= song_note4 WHEN (SW = '1' AND song_playing = '1') ELSE bt_strt3;
```

When `SW = '1'` (switch up) AND the song is actively playing, notes come from `songPlayer`. Otherwise, notes come from button presses.

#### Song Start Logic
The song starts when BTNC is pressed in song mode:

```vhdl
-- Song start: directly pass button when in song mode (SW=1)
song_start <= bt_clr AND SW;

-- Song reset only when SW is OFF (manual mode) and BTNC pressed
song_reset <= (NOT SW) AND bt_clr;
```

This ensures BTNC starts the song when in song mode, but resets the score when in manual mode.

#### Score Calculation
All four column scores are summed in real-time:

```vhdl
ck_proc : process(clk_in)
BEGIN
    IF rising_edge(clk_in) THEN
        cnt <= cnt + 1;
        total_score <= blue_score + red_score + green_score + purple_score;
    END IF;
END PROCESS;
```

#### Note Column Instantiation
Each column is instantiated with a unique X position and color:

```vhdl
-- Note column 1: Green (leftmost) - position 160
green_note : noteColumn
PORT MAP(
    clk        => clk_in,
    v_sync     => S_vsync, 
    pixel_row  => S_pixel_row, 
    pixel_col  => S_pixel_col, 
    horiz      => conv_std_logic_vector(160, 11),  -- X position
    note_input => note_input1,                      -- From MUX
    hit_signal_in => hit_signals_out(0),
    note_col_out  => note_column1,
    color      => "010",  -- Green = RGB 010
    keypress   => keypresses(0),
    hit_signal_out => hit_signals_back(0),
    red        => S_red1, 
    green      => S_green1, 
    blue       => S_blue1
);
```

---

`ball.vhd` (noteColumn) - Note Column Logic

This module manages falling notes using a 600-bit shift register and draws circular notes.

![Note Column Architecture](images/block_diagram_notecolumn.png)

#### Key Constants

```vhdl
CONSTANT NOTE_RADIUS : INTEGER := 18;         -- Radius of circular note
CONSTANT TARGET_Y : INTEGER := 565;           -- Y position of target circle
CONSTANT CIRCLE_RADIUS : INTEGER := 28;       -- Radius of target circle
CONSTANT NOTE_DISAPPEAR_Y : INTEGER := 540;   -- Notes vanish below this
CONSTANT FALL_SPEED_BITS : INTEGER := 18;     -- 2^18 cycles = 2.6ms per pixel
```

#### 600-Bit Shift Register
The core data structure storing note positions:

```vhdl
SIGNAL note_col : STD_LOGIC_VECTOR(599 DOWNTO 0) := (OTHERS => '0');
```

Each bit represents one pixel row. A '1' means a note exists at that row.

#### Note Movement Process
Notes fall by shifting the register down every 2.6ms:

```vhdl
mcolumn : PROCESS(clk)
BEGIN
    IF rising_edge(clk) THEN
        IF hit_signal_in = '1' THEN
            -- Clear notes in hit zone when hit detected
            note_col(580 DOWNTO 550) <= (OTHERS => '0');
            hit_signal_out <= '1';
        ELSE
            hit_signal_out <= '0';
            
            -- Shift on rising edge of local clock (every 2^18 cycles)
            IF local_clk = '1' AND local_clk_prev = '0' THEN
                -- Shift everything down by 1
                note_col(599 DOWNTO 1) <= note_col(598 DOWNTO 0);
                -- Add new note at top (if input is '1')
                note_col(0) <= note_input;
            END IF;
        END IF;
    END IF;
END PROCESS;
```

**Key Points:**
- `note_col(599 DOWNTO 1) <= note_col(598 DOWNTO 0)` shifts all bits down
- `note_col(0) <= note_input` adds new note at top
- On hit, bits 550-580 are cleared to remove the note

#### Circular Note Drawing
Uses distance formula to draw circles efficiently:

```vhdl
ndraw : PROCESS (pixel_row_int, pixel_col_int, horiz_int, note_col)
    VARIABLE dx, dy : INTEGER;
    VARIABLE dist_sq : INTEGER;
    VARIABLE radius_sq : INTEGER;
BEGIN
    temp_note_on := '0';
    radius_sq := NOTE_RADIUS * NOTE_RADIUS;  -- 18² = 324
    
    -- Only check if within horizontal bounds
    IF pixel_col_int >= horiz_int - NOTE_RADIUS AND 
       pixel_col_int <= horiz_int + NOTE_RADIUS THEN
        
        dx := pixel_col_int - horiz_int;  -- Horizontal distance to center
        
        -- Check rows within ±18 pixels of current row
        FOR offset IN -NOTE_RADIUS TO NOTE_RADIUS LOOP
            row_check := pixel_row_int + offset;
            IF note_col(row_check) = '1' THEN
                dy := offset;
                dist_sq := dx * dx + dy * dy;
                IF dist_sq <= radius_sq THEN
                    temp_note_on := '1';  -- Inside circle!
                    EXIT;
                END IF;
            END IF;
        END LOOP;
    END IF;
    
    note_on <= temp_note_on;
END PROCESS;
```

Instead of checking all 600 rows (which caused 20+ minute synthesis times), we only check ±18 rows around the current pixel. This reduces iterations from 600 to 37.

---

`songPlayer.vhd` - Automatic Song Playback

This module plays a pre-programmed 256-step song pattern.

#### Song Pattern Storage
Patterns are stored as 256-bit constants (64 hex characters each):

```vhdl
-- "Ode to Joy" adapted for 4 notes
CONSTANT SONG_COL1 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
    X"00000000000000008080000000008080808000000000808080800000000080FF";
CONSTANT SONG_COL2 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
    X"8800008800880088008800880000880088000088008800880000880000008800";
CONSTANT SONG_COL3 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
    X"0088880000000000008888000000000000888800000000000088880000000000";
CONSTANT SONG_COL4 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
    X"0000000000008000000000000000800000000000000080000000000000008000";
```

Each bit represents one time step (~84ms). A '1' spawns a note in that column.

#### Timing Constants

```vhdl
CONSTANT TEMPO_BITS : INTEGER := 23;   -- 2^23 / 100MHz = ~84ms per beat
CONSTANT PULSE_BITS : INTEGER := 19;   -- 2^19 = ~5.2ms pulse duration
```

#### Critical: Pulse Duration
This was our biggest bug fix. Notes must be held long enough for `noteColumn` to sample them:

```vhdl
-- Note outputs: output latched values while pulse is active
note_out_1 <= note1_latch WHEN pulse_active = '1' ELSE '0';
note_out_2 <= note2_latch WHEN pulse_active = '1' ELSE '0';
note_out_3 <= note3_latch WHEN pulse_active = '1' ELSE '0';
note_out_4 <= note4_latch WHEN pulse_active = '1' ELSE '0';

-- In the main process:
IF tempo_rising THEN
    -- Get notes at current position
    idx := 255 - position_reg;
    note1_latch <= SONG_COL1(idx);
    note2_latch <= SONG_COL2(idx);
    note3_latch <= SONG_COL3(idx);
    note4_latch <= SONG_COL4(idx);
    
    -- Start pulse (hold notes for 2^19 cycles = 5.2ms)
    pulse_counter <= 524288;
    pulse_active <= '1';
    
    -- Advance song position
    position_reg <= position_reg + 1;
END IF;
```

The `noteColumn` samples its input every 2^18 cycles (2.6ms). By holding the note for 5.2ms, we guarantee at least one sample.

#### State Machine

```vhdl
IF playing_reg = '0' THEN
    -- IDLE: Wait for start button
    IF start_rising THEN
        playing_reg <= '1';
        position_reg <= 0;
    END IF;
ELSE
    -- PLAYING: Output notes on tempo ticks
    IF tempo_rising THEN
        IF position_reg < SONG_LENGTH THEN
            -- Output notes and advance
        ELSE
            -- Song finished
            playing_reg <= '0';
        END IF;
    END IF;
END IF;
```

---

`toneGenerator.vhd` - PWM Audio Generation

This module generates square wave audio via PWM when notes are hit.

#### Frequency Calculation

```vhdl
-- Formula: divider = 100MHz / (2 * desired_frequency)
CONSTANT TONE_GREEN  : INTEGER := 190839;  -- C4 (262 Hz)
CONSTANT TONE_RED    : INTEGER := 151515;  -- E4 (330 Hz)
CONSTANT TONE_PURPLE : INTEGER := 127551;  -- G4 (392 Hz)
CONSTANT TONE_BLUE   : INTEGER := 95602;   -- C5 (523 Hz)
```

Together, C-E-G-C forms a **C major chord**.

#### PWM Generation

```vhdl
-- Generate tone if active
IF tone_active = '1' THEN
    IF duration_counter < TONE_DURATION THEN
        duration_counter <= duration_counter + 1;
        
        -- Square wave generation
        IF tone_counter < current_tone THEN
            tone_counter <= tone_counter + 1;
        ELSE
            tone_counter <= 0;
            pwm_out <= NOT pwm_out;  -- Toggle creates square wave
        END IF;
    ELSE
        -- Tone finished
        tone_active <= '0';
        pwm_out <= '0';
    END IF;
END IF;
```

**How it works:** 
1. Count clock cycles up to the divider value
2. Toggle the output pin
3. Repeat for the tone duration (150ms)
4. The toggling at specific frequencies creates audible tones

#### Hit Detection (Edge Triggered)

```vhdl
-- Check for new hits (rising edge detection)
IF hit_green = '1' AND hit_green_prev = '0' THEN
    current_tone <= TONE_GREEN;
    tone_active <= '1';
    duration_counter <= 0;
ELSIF hit_red = '1' AND hit_red_prev = '0' THEN
    current_tone <= TONE_RED;
    -- ... etc
END IF;
```

---

`buttonTracker.vhd` - Hit Detection & Scoring

This module detects when a player successfully hits a note.

#### Hit Zone Definition

```vhdl
CONSTANT ZERO_VECTOR : STD_LOGIC_VECTOR(580 downto 530) := (OTHERS => '0');
```

The hit zone spans rows 530-580 (50 pixels ≈ 130ms timing window).

#### Hit Detection Logic

```vhdl
hit_tracker : process(clk)
begin
    if rising_edge(clk) then
        -- Edge detection for keypress
        keypress_prev <= keypress;
        
        if keypress = '1' and keypress_prev = '0' then
            keypress_edge <= '1';
        else
            keypress_edge <= '0';
        end if;
        
        -- Check for keypress and handle scoring
        if keypress_edge = '1' and timeout_active = '0' then
            -- Check if there's a note in the hit zone
            if note_col_1(580 downto 530) /= ZERO_VECTOR then
                -- Note hit! Add score
                total_score <= total_score + conv_std_logic_vector(256, 32);
            end if;
            -- Send hit signal to clear notes
            hit_sig <= '1';
            timeout_active <= '1';
        end if;
    end if;
end process;
```

**Key Logic:**
1. Detect rising edge of keypress (prevents holding key)
2. Check if ANY bit in rows 530-580 is '1' (note present)
3. If yes, increment score by 256
4. Send hit signal to clear the note
5. Start timeout to prevent double-hits

#### Timeout Counter

```vhdl
-- Timeout counter to prevent double-hits
if timeout_active = '1' then
    if timeout_count < 10000000 then  -- ~100ms
        timeout_count <= timeout_count + 1;
    else
        timeout_count <= 0;
        timeout_active <= '0';
    end if;
end if;
```

---

`vgaCombiner.vhd` - Graphics Rendering

This module combines all visual elements with a priority-based rendering system.

#### Screen Layout Constants

```vhdl
CONSTANT HEADER_HEIGHT : INTEGER := 40;
CONSTANT COL1_X : INTEGER := 160;   -- Green
CONSTANT COL2_X : INTEGER := 320;   -- Red
CONSTANT COL3_X : INTEGER := 480;   -- Purple
CONSTANT COL4_X : INTEGER := 640;   -- Blue
CONSTANT TARGET_Y : INTEGER := 565;
CONSTANT FLAME_LEFT_END : INTEGER := 80;
CONSTANT FLAME_RIGHT_START : INTEGER := 720;
```

#### Flame Animation

```vhdl
-- Animation counter cycles through 8 phases
IF anim_counter < 5000000 THEN
    anim_counter <= anim_counter + 1;
ELSE
    anim_counter <= 0;
    IF flame_phase < 7 THEN
        flame_phase <= flame_phase + 1;
    ELSE
        flame_phase <= 0;
    END IF;
END IF;

-- Flame pattern calculation
IF in_left_flame THEN
    IF ((row + flame_phase * 20) MOD 80) < 40 THEN
        IF col < (FLAME_LEFT_END - ((row + flame_phase * 20) MOD 40)) THEN
            flame_intensity := 2;  -- Yellow (bright)
        ELSIF col < FLAME_LEFT_END THEN
            flame_intensity := 1;  -- Red (dim)
        END IF;
    END IF;
END IF;
```

The flame effect uses modular arithmetic to create a triangular wave pattern that "flickers" as the phase changes.

#### Render Priority System

```vhdl
-- === RENDER PRIORITY (highest to lowest) ===

-- 1. Notes (falling circles)
IF note_pixel THEN
    r_out <= note_color_r;
    g_out <= note_color_g;
    b_out <= note_color_b;

-- 2. Header bar (blue)
ELSIF in_header THEN
    r_out <= '0'; g_out <= '0'; b_out <= '1';

-- 3. Hit flash effects (white circles)
ELSIF in_circle_1 AND flash_active_1 THEN
    r_out <= '1'; g_out <= '1'; b_out <= '1';

-- 4. Keypress feedback (colored circles)
ELSIF in_circle_1 AND keypress_signals(0) = '1' THEN
    r_out <= '0'; g_out <= '1'; b_out <= '0';  -- Green glow

-- 5. Target zone lines
ELSIF in_lane AND (row = TARGET_ZONE_TOP) THEN
    r_out <= '1'; g_out <= '1'; b_out <= '1';

-- 6. Lane dividers
ELSIF on_divider THEN
    r_out <= '0'; g_out <= '0'; b_out <= '1';

-- 7. Flames
ELSIF flame_intensity = 2 THEN
    r_out <= '1'; g_out <= '1'; b_out <= '0';  -- Yellow
ELSIF flame_intensity = 1 THEN
    r_out <= '1'; g_out <= '0'; b_out <= '0';  -- Red

-- 8. Background (black)
ELSE
    r_out <= '0'; g_out <= '0'; b_out <= '0';
END IF;
```

---

`vga_top.xdc` - Pin Assignments

Mode switch, debug LEDs, audio output pins, scoreboard

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

## 9. Future Improvements

If given more time, we would implement:

1. **More Songs** - Add song selection via switches
2. **Difficulty Levels** - Adjustable note speed
3. **Miss Detection** - Penalty for missed notes
4. **Combo System** - Score multiplier for consecutive hits
5. **Background Music** - Full audio track playback
6. **Better Graphics** - Sprites instead of simple shapes
7. **Two-Player Mode** - Split screen competition

---

## 10. Summary and Contributions

### Anuj Sanvatsarkar
- Designed `buttonTracker.vhd` (hit detection and scoring)
- Designed `vgaCombiner.vhd` (visual effects and rendering)
- Implemented flame animations and hit flash effects
- Debugged timing synchronization issues

### Emre Cosgun
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

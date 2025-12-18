LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY songPlayer IS
    PORT (
        clk           : IN  STD_LOGIC;
        reset         : IN  STD_LOGIC;
        start         : IN  STD_LOGIC;
        note_out_1    : OUT STD_LOGIC;
        note_out_2    : OUT STD_LOGIC;
        note_out_3    : OUT STD_LOGIC;
        note_out_4    : OUT STD_LOGIC;
        song_position : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
        song_playing  : OUT STD_LOGIC;
        song_done     : OUT STD_LOGIC
    );
END songPlayer;

ARCHITECTURE Behavioral OF songPlayer IS
    
    CONSTANT SONG_LENGTH : INTEGER := 256;
    
    -- Tempo: how often to advance to next note in song
    -- 23 bits = 2^23 / 100MHz = ~84ms per step
    CONSTANT TEMPO_BITS : INTEGER := 23;
    
    -- Note pulse duration: how long to hold note output HIGH
    -- Must be longer than noteColumn's sample rate (2^18 cycles)
    -- Using 2^19 = 524288 cycles = ~5.2ms - ensures at least one sample
    CONSTANT PULSE_BITS : INTEGER := 19;
    
    -- Song patterns
    CONSTANT SONG_COL1 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
        X"00000000000000008080000000008080808000000000808080800000000080FF";
    CONSTANT SONG_COL2 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
        X"8800008800880088008800880000880088000088008800880000880000008800";
    CONSTANT SONG_COL3 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
        X"0088880000000000008888000000000000888800000000000088880000000000";
    CONSTANT SONG_COL4 : STD_LOGIC_VECTOR(255 DOWNTO 0) := 
        X"0000000000008000000000000000800000000000000080000000000000008000";
    
    -- State registers
    SIGNAL playing_reg : STD_LOGIC := '0';
    SIGNAL position_reg : INTEGER RANGE 0 TO 511 := 0;
    
    -- Timing counter
    SIGNAL counter : STD_LOGIC_VECTOR(25 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tempo_bit_last : STD_LOGIC := '0';
    
    -- Start edge detection
    SIGNAL start_last : STD_LOGIC := '0';
    
    -- Latched note values (held during pulse)
    SIGNAL note1_latch, note2_latch, note3_latch, note4_latch : STD_LOGIC := '0';
    
    -- Pulse counter to hold notes
    SIGNAL pulse_counter : INTEGER RANGE 0 TO 600000 := 0;
    SIGNAL pulse_active : STD_LOGIC := '0';
    
BEGIN
    
    -- Output assignments
    song_playing <= playing_reg;
    song_position <= conv_std_logic_vector(position_reg, 10);
    song_done <= '1' WHEN position_reg >= SONG_LENGTH ELSE '0';
    
    -- Note outputs: output latched values while pulse is active
    note_out_1 <= note1_latch WHEN pulse_active = '1' ELSE '0';
    note_out_2 <= note2_latch WHEN pulse_active = '1' ELSE '0';
    note_out_3 <= note3_latch WHEN pulse_active = '1' ELSE '0';
    note_out_4 <= note4_latch WHEN pulse_active = '1' ELSE '0';
    
    PROCESS(clk)
        VARIABLE idx : INTEGER;
        VARIABLE tempo_rising : BOOLEAN;
        VARIABLE start_rising : BOOLEAN;
    BEGIN
        IF rising_edge(clk) THEN
            
            -- Increment main counter
            counter <= counter + 1;
            
            -- Edge detection
            tempo_rising := (counter(TEMPO_BITS) = '1') AND (tempo_bit_last = '0');
            start_rising := (start = '1') AND (start_last = '0');
            
            -- Save for edge detection
            tempo_bit_last <= counter(TEMPO_BITS);
            start_last <= start;
            
            -- Pulse counter countdown
            IF pulse_counter > 0 THEN
                pulse_counter <= pulse_counter - 1;
                pulse_active <= '1';
            ELSE
                pulse_active <= '0';
            END IF;
            
            IF reset = '1' THEN
                playing_reg <= '0';
                position_reg <= 0;
                pulse_active <= '0';
                pulse_counter <= 0;
                note1_latch <= '0';
                note2_latch <= '0';
                note3_latch <= '0';
                note4_latch <= '0';
                
            ELSIF playing_reg = '0' THEN
                -- NOT PLAYING - wait for start button
                IF start_rising THEN
                    playing_reg <= '1';
                    position_reg <= 0;
                    -- Reset counter to sync tempo
                    counter <= (OTHERS => '0');
                    tempo_bit_last <= '0';
                END IF;
                
            ELSE
                -- PLAYING - output notes on tempo ticks
                IF tempo_rising THEN
                    IF position_reg < SONG_LENGTH THEN
                        -- Get notes at current position
                        idx := 255 - position_reg;
                        note1_latch <= SONG_COL1(idx);
                        note2_latch <= SONG_COL2(idx);
                        note3_latch <= SONG_COL3(idx);
                        note4_latch <= SONG_COL4(idx);
                        
                        -- Start pulse (hold notes for 2^19 cycles)
                        pulse_counter <= 524288;
                        pulse_active <= '1';
                        
                        -- Advance song position
                        position_reg <= position_reg + 1;
                    ELSE
                        -- Song finished
                        playing_reg <= '0';
                        pulse_active <= '0';
                        note1_latch <= '0';
                        note2_latch <= '0';
                        note3_latch <= '0';
                        note4_latch <= '0';
                    END IF;
                END IF;
            END IF;
            
        END IF;
    END PROCESS;
    
END Behavioral;
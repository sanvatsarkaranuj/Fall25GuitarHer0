LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY toneGenerator IS
    PORT (
        clk         : IN  STD_LOGIC;  -- 100MHz system clock
        reset       : IN  STD_LOGIC;  -- Reset signal
        
        -- Hit signals from each column (directly from buttonTracker)
        hit_green   : IN  STD_LOGIC;  -- Column 1 hit
        hit_red     : IN  STD_LOGIC;  -- Column 2 hit
        hit_purple  : IN  STD_LOGIC;  -- Column 3 hit
        hit_blue    : IN  STD_LOGIC;  -- Column 4 hit
        
        -- Audio output
        audio_pwm   : OUT STD_LOGIC;  -- PWM audio signal
        audio_sd    : OUT STD_LOGIC   -- Audio shutdown (active low, directly under seven-segment display)
    );
END toneGenerator;

ARCHITECTURE Behavioral OF toneGenerator IS

    -- Tone frequencies (as clock divider values)
    -- Formula: divider = 100MHz / (2 * desired_frequency)
    -- C4 = 262Hz -> 190839
    -- E4 = 330Hz -> 151515
    -- G4 = 392Hz -> 127551
    -- C5 = 523Hz -> 95602
    
    CONSTANT TONE_GREEN  : INTEGER := 190839;  -- C4 (~262 Hz)
    CONSTANT TONE_RED    : INTEGER := 151515;  -- E4 (~330 Hz)
    CONSTANT TONE_PURPLE : INTEGER := 127551;  -- G4 (~392 Hz)
    CONSTANT TONE_BLUE   : INTEGER := 95602;   -- C5 (~523 Hz)
    CONSTANT TONE_SILENT : INTEGER := 0;
    
    -- Duration of tone in clock cycles
    -- 100MHz * 0.15 seconds = 15,000,000 cycles
    CONSTANT TONE_DURATION : INTEGER := 15000000;
    
    -- Internal signals
    SIGNAL tone_counter    : INTEGER RANGE 0 TO 200000 := 0;
    SIGNAL duration_counter: INTEGER RANGE 0 TO 20000000 := 0;
    SIGNAL current_tone    : INTEGER RANGE 0 TO 200000 := 0;
    SIGNAL tone_active     : STD_LOGIC := '0';
    SIGNAL pwm_out         : STD_LOGIC := '0';
    
    -- Edge detection for hit signals
    SIGNAL hit_green_prev  : STD_LOGIC := '0';
    SIGNAL hit_red_prev    : STD_LOGIC := '0';
    SIGNAL hit_purple_prev : STD_LOGIC := '0';
    SIGNAL hit_blue_prev   : STD_LOGIC := '0';
    
BEGIN

    -- Always enable audio output (directly under seven-segment display active low)
    audio_sd <= '1';
    
    -- Main audio process
    audio_proc : PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Edge detection registers
            hit_green_prev  <= hit_green;
            hit_red_prev    <= hit_red;
            hit_purple_prev <= hit_purple;
            hit_blue_prev   <= hit_blue;
            
            IF reset = '1' THEN
                tone_active <= '0';
                duration_counter <= 0;
                tone_counter <= 0;
                pwm_out <= '0';
                current_tone <= 0;
                
            ELSE
                -- Check for new hits (rising edge detection)
                -- Priority: Green > Red > Purple > Blue
                IF hit_green = '1' AND hit_green_prev = '0' THEN
                    current_tone <= TONE_GREEN;
                    tone_active <= '1';
                    duration_counter <= 0;
                    tone_counter <= 0;
                ELSIF hit_red = '1' AND hit_red_prev = '0' THEN
                    current_tone <= TONE_RED;
                    tone_active <= '1';
                    duration_counter <= 0;
                    tone_counter <= 0;
                ELSIF hit_purple = '1' AND hit_purple_prev = '0' THEN
                    current_tone <= TONE_PURPLE;
                    tone_active <= '1';
                    duration_counter <= 0;
                    tone_counter <= 0;
                ELSIF hit_blue = '1' AND hit_blue_prev = '0' THEN
                    current_tone <= TONE_BLUE;
                    tone_active <= '1';
                    duration_counter <= 0;
                    tone_counter <= 0;
                END IF;
                
                -- Generate tone if active
                IF tone_active = '1' THEN
                    -- Duration counter
                    IF duration_counter < TONE_DURATION THEN
                        duration_counter <= duration_counter + 1;
                        
                        -- Tone generation (square wave via PWM)
                        IF current_tone > 0 THEN
                            IF tone_counter < current_tone THEN
                                tone_counter <= tone_counter + 1;
                            ELSE
                                tone_counter <= 0;
                                pwm_out <= NOT pwm_out;  -- Toggle for square wave
                            END IF;
                        END IF;
                    ELSE
                        -- Tone duration finished
                        tone_active <= '0';
                        pwm_out <= '0';
                        duration_counter <= 0;
                    END IF;
                ELSE
                    pwm_out <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    -- Output assignment
    audio_pwm <= pwm_out;
    
END Behavioral;

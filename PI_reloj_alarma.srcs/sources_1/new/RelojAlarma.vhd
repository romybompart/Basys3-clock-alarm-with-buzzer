----------------------------------------------------------------------------------
-- Company: FIME
-- Engineer: Romy Domingo Bompart Ballache
-- 
-- Create Date: 11/10/2020 08:20:48 PM
-- Design Name: Proyecto integrador 
-- Module Name: RelojAlarma - Behavioral
-- Project Name: Clase de VHDL
-- Target Devices: BASYS 3
-- Tool Versions: VIVADO 2020
-- Description: Reloj Configuraable con alarma configurable, funcionalidad de cuenta
--  rapida por 1000 o por 100 usando switches  SW0 y SW1. Usar boton central para entrar
--  en modo de configuracion, usar boton derecho e izquierdo para seleccionar digito
--  seleccionar boton hacia arriba para incrementar digito. 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Instructor M.C. Ronald V.M. Lopez Gomez 
--
---------------------------------------- Instructions ---------------------------------------- 
-- ############### THE BUZZER ###############
-- Connect the buzzer to JA4
-- ############### THE LEDS ###############
-- When LED 0 and LED 1 are OFF the data displayed is the current clock 
-- When LED 0 is ON and LED 1 is OFF the data displayed is the new clock to set
-- ############### THE BUTTONS ###############
-- 1. When LED 0 is OFF and LED 1 is ON the data displayed is the alarm
-- 2. To enter in setting mode, to configure or check the new clock or alarm data
-- press the center button (BTNC). 
-- 3. To select a digit from the 7 segment display it is neccesary to use the right
-- button (BTNR). When the digit is selected it will be blinking at 500ms.
-- 4. To change the digit value, it is neccesary to use the up button (BTNU).
-- 5. To set the new clock into the current clock it is neccesary to press left and 
-- down button (BTNL and BTND) at the same time for 1 second. 
-- ############### THE SWITCHES ###############
-- 1. When SW0 and SW1 are ON or OFF, the current clock will count every second
-- 2. When SW0 is ON and SW1 is OFF, the counter will increase 10 time faster (every
-- 100 milisecond)
-- 3. When SW0 is OFF and SW1 is ON, the counter will increase 100 time faster (every
-- 10 milisecond)
-- ############### THE DISPLAY ###############
-- The display has 4 digits and 1 dot, from left to right, the first digit is the
-- ten digit for the hour, the second digit is the unit digit for hour, the thrid digit
-- is the ten digit for minutes, the fourth digit is the unit digit for minutes
-- the dot is blinking accordingly to the selected clock using the SW0 and SW1, thus
-- it might be indicating seconds.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- entity
    --interface of the module
entity RelojAlarma is
    Port ( btnU : in STD_LOGIC;												-- Up button
           btnD : in STD_LOGIC;												-- Donw button
           btnL : in STD_LOGIC;												-- Left button
           btnR : in STD_LOGIC;												-- Right button
           btnC : in STD_LOGIC;												-- Center button
           clk : in STD_LOGIC;												-- clock input
           sw: in std_logic_vector ( 5 downto 0);							-- switch inputs
           led : out STD_LOGIC_VECTOR (15 downto 0):= (others => '0');		-- led ouputs
           seg : out STD_LOGIC_VECTOR (6 downto 0):= "1111111";				-- 7 segments output
           an : out STD_LOGIC_VECTOR (3 downto 0):= "1111";					-- anode output
           dp : out STD_LOGIC := '1';										-- display point anode
           buzzer : out STD_LOGIC := '1'                                    -- PWM for buzzer
           );
end RelojAlarma;
-----------------------------------------------------------------------------------------------------------------------------
-- architecture
architecture Behavioral of RelojAlarma is
    -------------------------------------------------------------------------------------------------------------------------
    -- Signal definition ----------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------------------------------- 
    --signal for the clock execution
    signal clk_1sec: std_logic:= '0';   -- used to provide 1 sec signal 
    signal clk_500ms: std_logic:= '0';  -- used to provide 500 mili sec signal
    signal clk_10ms: std_logic:= '0';   -- used to provide 10 mili selec signal 
    signal clk_1ms: std_logic:= '0';    -- used to provide 1 mili sec signal 
    signal clk_selected: std_logic:= '0';   -- clock source to the tick process (the one that increments the clock counter)
    -- signals for the clock counter
    -- minutes
    signal min_clock: std_logic_vector (6 downto 0):= (others => '0');        -- used to storage the minute count in binary code
    signal min_bcd: std_logic_vector (7 downto 0):= (others => '0');          -- used to provide the bcd data of the minutes binary count
    signal min_7seg: std_logic_vector(13 downto 0):= (others => '0');         -- used to provide the 7 segment data of the minutes
    signal min_adj:  std_logic_vector (6 downto 0):= (others => '0');         -- used to storage the new minute data to latch in the current minute in binary
    signal min_adj_bcd : std_logic_vector (7 downto 0):= (others => '0');     -- used to provide the bcd data of the new minute
    signal min_adj_7seg : std_logic_vector(13 downto 0):= (others => '0');    -- used to provide the 7 segment data of the new minute 
    signal min_alarm:  std_logic_vector (6 downto 0):= (others => '0');       -- used to provide the alarm count in binary
    signal min_alarm_bcd : std_logic_vector (7 downto 0):= (others => '0');   -- used to provide the alarm minuntes bcd count
    signal min_alarm_7seg : std_logic_vector(13 downto 0):= (others => '0');  -- used to provide the 7 segment data of the alarm minutes
    -- hours
    signal hora_clock: std_logic_vector (6 downto 0):= (others => '0');       -- used to storage the hours count in binary code
    signal hora_bcd: std_logic_vector (7 downto 0):= (others => '0');         -- used to provide the bcd data of the hours binary count
    signal hora_7seg: std_logic_vector(13 downto 0):= (others => '0');        -- used to provide the 7 segment data of the hours
    signal hora_adj: std_logic_vector(6 downto 0):= (others => '0');          -- used to storage the new hours data to latch in the current hours in binary
    signal hora_adj_bcd : std_logic_vector (7 downto 0):= (others => '0');    -- used to provide the bcd data of the new hours
    signal hora_adj_7seg : std_logic_vector(13 downto 0):= (others => '0');   -- used to provide the 7 segment data of the new minute
    signal hora_alarm:  std_logic_vector (6 downto 0):= (others => '0');      -- used to provide the alarm hour count in binary
    signal hora_alarm_bcd : std_logic_vector (7 downto 0):= (others => '0');  -- used to provide the bcd data of the alarm hour
    signal hora_alarm_7seg : std_logic_vector(13 downto 0):= (others => '0'); -- used to provide the  7 segment data of the alarm hour
    -- seconds
    signal sec_clock: std_logic_vector (6 downto 0):= (others => '0');        -- to count seconds
    signal ledx : std_logic:= '1';                          -- to provide a turn on and a turn off for the second led inthe 7 segment
    -- signal for the button for the components
    signal buttons: std_logic_vector ( 4 downto 0):= "00000"; -- vector to detect the button after they pass through the debouncer
    -- signal for alarm
    signal turn_on_alarm : std_logic:= '0';                   -- to indicate when the alarm is on
    signal selection_digit: std_logic_vector ( 3 downto 0) :=  "0000"; -- signal to provide the anode that will be blinking, because the digit is selected
    signal setting_detected: std_logic:= '0';               -- to determine when the clock is in setting mode
    signal display_data: std_logic_vector (1 downto 0):="00"; -- to determine what info is display in the 7seg > clock, new clock, alarm. 
    signal selection: std_logic_vector (3 downto 0):= "0000"; -- to count in binary what is the digit in the 7 segment that is going to be changed
    signal select_blinking : std_logic := '1';                -- this signal will take 500 mili seconds to togle the anode pin that is selected 
    signal latch_reg: std_logic_vector (1 downto 0):= "00";   -- latch reg is the register used to implement a latch
    signal latch_event : std_logic := '0';                    -- latch output signal
    -- anode buffer, to help during the intermitation
    signal anode_state : std_logic_vector (7 downto 0) := "11110000"; -- anothe state uses 8 bits to determine which digit in the 7 seg will blink
    -- to animated the clock
    signal animated: std_logic_vector (5 downto 0) := "000001"; -- signal to animate the leds.
    -- to generate the sound
    signal pulse_enable: std_logic := '0';                      -- 50% pulse to enable the pulse
    signal pulse_tone: std_logic := '0';                        -- 50% pulse to produce the tone
    ------------------------------------------------------------------------------------------------------------------------- 
    -- defining components---------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    -- clock source to feed the clock and display swept
    component clock_mult_div is
        port (
            inPulse: in std_logic;
            OutPulse_1sec , OutPulse_500ms , OutPulse_10ms, OutPulse_1ms : out std_logic
        );
    end component clock_mult_div;
    -- Decoder from binary to bcd
    component Deco_bin2bcd is
        port ( 
            clk : in std_logic;
            in_binary : in STD_LOGIC_VECTOR (6 downto 0);
            out_bcd : out STD_LOGIC_VECTOR (7 downto 0)
            );
    end component Deco_bin2bcd;
    -- Decoder from bcd to 7 segment display
    component Deco_bcd27seg is
         port ( 
            clk : in std_logic;
            in_bcd : in STD_LOGIC_VECTOR (3 downto 0);
            out_7seg : out STD_LOGIC_VECTOR (6 downto 0)
            );
    end component Deco_bcd27seg;
    -- Debouncer for buttons
    component debouncer
          port ( 
           InPulse, button : in STD_LOGIC;
           OutPulse : out STD_LOGIC
           );
    end component debouncer;
    ------------------------------------------------------------------------------------------------------------------------- 
    --                              Function to add 1 or 10 to the time                                                    --         
    -------------------------------------------------------------------------------------------------------------------------
    -- description: the function has the capability to add number in binary in steps of 1 (for the low digit) and 10 for the 
    -- high digit, to cut the number in 59 or 23 it is neccesary to provide the min_hour flag = 1 for hour and 0 for minutes.
    function adding_time(    
                            time_m_h : std_logic_vector (6 downto 0):= "0000000"; 
                            adding : std_logic_vector (6 downto 0):= "0000000";
                            min_hour : std_logic := '0'
                        ) 
    return std_logic_vector is
        variable timeOut : std_logic_vector (6 downto 0) := "0000000";
    begin   
        if ( min_hour = '0') then --- for minutes
            timeOut := time_m_h + adding;  
            if timeOut > 59 then 
                timeOut := (others => '0');
            end if;
        else                       --- for hours
            timeOut := time_m_h + adding;
            if timeOut > 23 then 
                timeOut :=  (others => '0');
             end if;
        end if;       

        return timeOut;
    end adding_time; 
    ------------------------------------------------------------------------------------------------------------------------- 
    --                              Function to substract 1 or 10 to the time                                              --         
    -------------------------------------------------------------------------------------------------------------------------
    -- description: the function has the capability to add number in binary in steps of 1 (for the low digit) and 10 for the 
    -- high digit, to cut the number in 59 or 23 it is neccesary to provide the min_hour flag = 1 for hour and 0 for minutes.
--    function substracting_time(    
--                            time_m_h : std_logic_vector (6 downto 0):= "0000000"; 
--                            substracting : std_logic_vector (6 downto 0):= "0000000";
--                            min_hour : std_logic := '0'
--                        ) 
--    return std_logic_vector is
--        variable timeOut : std_logic_vector (6 downto 0) := "0000000";
--    begin   
--        if ( min_hour = '0') then --- for minutes  
--            if time_m_h > substracting then 
--                timeOut := time_m_h - substracting;
--            else
--                timeOut := conv_std_logic_vector (59,timeOut'length) - substracting;
--            end if;
--        else                       --- for hours
--            if time_m_h > substracting then 
--                 timeOut := time_m_h - substracting;
--            else
--                timeOut :=  conv_std_logic_vector (23,timeOut'length) - substracting;
--             end if;
--        end if;       

--        return timeOut;
--    end substracting_time;  
--------------------------------------------------------------------------------------------------------------------------- 
-- Main process for the clock system
begin
   -------------------------------------------------------------------------------------------------------------------------
   -- first instance of the debouncer
    debounce_1: debouncer port map
        (
            InPulse => clk,
            button => btnU,
            OutPulse => buttons(0)
        );
    -- Second instance of the debouncer
    debounce_2: debouncer port map
        (
            InPulse => clk,
            button => btnR,
            OutPulse => buttons(1)
        );
    -- Third instance of the debouncer    
    debounce_3: debouncer port map
        (
            InPulse => clk,
            button => btnL,
            OutPulse => buttons(2)
        );
    -- Fourth instance of the debouncer    
    debounce_4: debouncer port map
        (
            InPulse => clk,
            button => btnD,
            OutPulse => buttons(3)
        );
    -- Fifth instance of the debouncer 
    debounce_5: debouncer port map
        (
            InPulse => clk,
            button => btnC,
            OutPulse => buttons(4)
        );
    -- The clock to refresh the data at the display and count the seconds for the clock
    clk_source: clock_mult_div port map
    (
            inPulse=> clk,
            OutPulse_1sec => clk_1sec, 
            OutPulse_500ms => clk_500ms,
            OutPulse_10ms => clk_10ms,
            OutPulse_1ms => clk_1ms
    );
    -- Decoder from bin to bcd clock
    bin2bcd_min: Deco_bin2bcd port map
    (   
        clk => clk,
        in_binary => min_clock, 
        out_bcd =>  min_bcd 
    );
    bin2bcd_hour: Deco_bin2bcd port map
    (
        clk => clk,
        in_binary => hora_clock, 
        out_bcd =>  hora_bcd 
    );
    -- deco bin to bcd adjust clock
    bin2bcd_min_adj: Deco_bin2bcd port map
    (
        clk => clk,
        in_binary => min_adj, 
        out_bcd =>  min_adj_bcd 
    );
    bin2bcd_hour_adj: Deco_bin2bcd port map
    (
        clk => clk,
        in_binary => hora_adj, 
        out_bcd =>  hora_adj_bcd 
    );
    -- deco bin to bcd adjust alarm
    bin2bcd_min_alarm: Deco_bin2bcd port map
    (
        clk => clk,
        in_binary => min_alarm, 
        out_bcd =>  min_alarm_bcd 
    );
    bin2bcd_hour_alarm: Deco_bin2bcd port map
    (
        clk => clk,
        in_binary => hora_alarm, 
        out_bcd =>  hora_alarm_bcd 
    );
    -- Decoder from bcd to 7seg - clock
    -- low side min
    bcd27seg_min_l: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_bcd(3 downto 0),
        out_7seg => min_7seg (6 downto 0)  
    );
    -- high side min
    bcd27seg_min_h: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_bcd(7 downto 4),
        out_7seg => min_7seg (13 downto 7)   
    );
    -- low side hora
    bcd27seg_hora_l: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_bcd(3 downto 0),
        out_7seg => hora_7seg (6 downto 0)   
    );
    -- high side hora
    bcd27seg_hora_h: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_bcd(7 downto 4),
        out_7seg => hora_7seg  (13 downto 7) 
    );
    -- Decoder from bcd to 7seg clock adjust
    -- low side min
    bcd27seg_min_l_adj: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_adj_bcd(3 downto 0),
        out_7seg => min_adj_7seg (6 downto 0)  
    );
    -- high side min
    bcd27seg_min_h_adj: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_adj_bcd(7 downto 4),
        out_7seg => min_adj_7seg (13 downto 7)   
    );
    -- low side hora
    bcd27seg_hora_l_adj: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_adj_bcd(3 downto 0),
        out_7seg => hora_adj_7seg (6 downto 0)   
    );
    -- high side hora
    bcd27seg_hora_h_adj: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_adj_bcd(7 downto 4),
        out_7seg => hora_adj_7seg  (13 downto 7) 
    );
    -- Decoder from bcd to 7seg clock adjust
    -- low side min
    bcd27seg_min_l_alarm: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_alarm_bcd(3 downto 0),
        out_7seg => min_alarm_7seg (6 downto 0)  
    );
    -- high side min
    bcd27seg_min_h_alarm: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => min_alarm_bcd(7 downto 4),
        out_7seg => min_alarm_7seg (13 downto 7)   
    );
    -- low side hora
    bcd27seg_hora_l_alarm: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_alarm_bcd(3 downto 0),
        out_7seg => hora_alarm_7seg (6 downto 0)   
    );
    -- high side hora
    bcd27seg_hora_h_alarm: Deco_bcd27seg port map
    (
        clk => clk,
        in_bcd => hora_alarm_bcd(7 downto 4),
        out_7seg => hora_alarm_7seg  (13 downto 7) 
    );
    ------------------------------------------------------------------------------------------------------------------------- 
    -------------------------------------------------------------------------------------------------------------------------
    -- wiring signals -------------------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------------------------------------
    --- selection drives the selection digit --------------------------------------------------------------------------------                                   
    with selection select
            selection_digit <= "0000" when "0000",
                               "0001" when "0001",
                               "0010" when "0010",
                               "0100" when "0011",
                               "1000" when "0100",
                               "1111" when "1111",
                               "0000" when others;  
    -- anode state from 0 to 3, to indicate which digit is going to blink.
    -- select blinking is a 500ms clock signal, selection digit depends on the select input signal
    -- and turn on alarm is to indicate the alarm is on 
    anode_state( 3 downto 0) <= (   select_blinking and (selection_digit(0) or turn_on_alarm), 
                                    select_blinking and (selection_digit(1) or turn_on_alarm), 
                                    select_blinking and (selection_digit(2) or turn_on_alarm), 
                                    select_blinking and (selection_digit(3) or turn_on_alarm)
                                 );
    --anode    --- controled by 16ms signal -- and 1sec during the setting time or alarm --- 
    an <= (     anode_state(7) or anode_state(3),
                anode_state(6) or anode_state(2),
                anode_state(5) or anode_state(1),
                anode_state(4) or anode_state(0)
    ); 
    --- Clk selected
    clk_selected <= (clk_1sec   and (   not sw(1) and not sw(0))) or 
                    (clk_10ms   and (   not sw(1) and  sw(0))   ) or 
                    (clk_1ms    and (   sw(1) and not sw(0))    ) or 
                    (clk_1sec   and (   sw(1) and sw(0) ) );
    --- latch time is to load the new clock register into the current clock              
    latch_event <= latch_reg(0) and (not latch_reg(1)); 
    --- buzzer output 
    buzzer <= turn_on_alarm and pulse_enable and pulse_tone;
    --- led indicator and animation
    led (1 downto 0 ) <= display_data;       	                -- what is displaying the 7 segment 
    led (14 downto 9) <= animated;                              -- decoration
    led (2) <= turn_on_alarm and pulse_enable and pulse_tone;   -- to indicate the alarm is on
    ------------------------------------------------------------------------------------------------------------------------- 
    -- Process ---------------------------------------------------------- ---------------------------------------------------                                
    ------------------------------------------------------------------------------------------------------------------------- 
    -- tick process in charge of count and incrrement the clock data or in a case of the latch event load the new clock
    -- into the currnet count.
    ticks: process (clk_selected, latch_event )
    begin      
       
        if latch_event = '1' then
            -- adding the new clock to the current clock
            hora_clock <= hora_adj;
            min_clock <= min_adj;
        elsif clk_selected'event and clk_selected = '1' then
        
            -- verify if the alarm needs to be activated
            if (min_clock = min_alarm and hora_clock = hora_alarm) then
                turn_on_alarm <= '1';
            else
                turn_on_alarm <= '0';
            end if;
            -- counting every clk_select
            -- toogle
            ledx <= not ledx;
            -- increment seconds if not 59
            if sec_clock = 59 then
                -- if sec is 59, then clear seconds and increment minutes
                sec_clock <= (others => '0');
                -- increment minutes if not 59
                if min_clock = 59 then
                    -- if min is 59, then clear minutes and increment hours
                    min_clock <= (others => '0');
                    -- increment hours if not 23
                    if hora_clock = 23 then
                        -- if hours is 23, then clear hours
                        hora_clock <= (others => '0');
                    else
                        -- incrementing hours
                        hora_clock <= hora_clock + 1;
                    end if;
                else
                    -- incrementing minutes
                    min_clock <= min_clock + 1;
                end if;
            else
                -- incrementing seconds
                sec_clock <= sec_clock + 1;
            end if;
        end if;               
    end process ticks;
    -------------------------------------------------------------------------------------------------------------------------
    -- display process responsable to display the information into the display each 1ms or 1khz
    -- depending o the display data it will display the clcok , the new clock or the alarm.
    -- the point led in the segment number 2 works as a second indicator. 
    display: process (clk_1ms) 
    begin
        if (clk_1ms'event and clk_1ms = '1' ) then
           
            case anode_state(7 downto 4) is
          
                when "1110" =>
                    -- min 2nd digit
                    if display_data = "00" then
                        seg <=  min_7seg (13 downto 7) ;
                    elsif display_data = "01" then
                        seg <=  min_adj_7seg (13 downto 7) ;
                    elsif display_data = "10" then
                        seg <=  min_alarm_7seg (13 downto 7) ;
                    end if;
                    
                    dp <= '1';
                    anode_state ( 7 downto 4) <= "1101";
                when "1101" =>
                    -- hour 1st digit
                    if display_data = "00" then
                        seg <= hora_7seg  (6 downto 0);
                    elsif display_data = "01" then
                        seg <=  hora_adj_7seg (6 downto 0) ;
                    elsif display_data = "10" then
                        seg <=  hora_alarm_7seg (6 downto 0) ;
                    end if;
                    
                    dp <= ledx;
                    anode_state ( 7 downto 4) <= "1011";
                when "1011" =>
                    -- hour 2nd digit
                    if display_data = "00" then
                        seg <= hora_7seg  (13 downto 7);
                    elsif display_data = "01" then
                        seg <=  hora_adj_7seg (13 downto 7) ;
                    elsif display_data = "10" then
                        seg <=  hora_alarm_7seg (13 downto 7) ;
                    end if;
                    
                    anode_state ( 7 downto 4) <= "0111";
                    dp <= '1';
                when others =>
                    -- min 1st digit
                    if display_data = "00" then
                        seg <= min_7seg  (6 downto 0);
                    elsif display_data = "01" then
                        seg <=  min_adj_7seg (6 downto 0) ;
                    elsif display_data = "10" then
                        seg <=  min_alarm_7seg (6 downto 0) ;
                    end if;
                    dp <= '1';
                    anode_state ( 7 downto 4) <= "1110";
            end case;
  
        end if;
    end process display;
    ------------------------------------------------------------------------------------------------------------------------- 
    -- setting process responsable listen the buttons to interact with the data and the information of the clock
    setting_ctrl: process (buttons)    
    begin
        
        -- if center button is pressed
        if buttons(4) = '1' and buttons(4)'event then
            if display_data = "10" then
                setting_detected <= '0';
                selection <= "0000";
                display_data <= "00";
            else
                -- setting detected is set
                setting_detected <= '1';
                -- selection digit 1
                --selection <= "0001";
                -- display data : alarm or new clock
                display_data <= display_data + '1';
            end if;           
        end if;


        -- if right button is pressed
        if setting_detected = '0' then
            selection <="0000";
        elsif buttons(1) = '1' and buttons(1)'event then 
            -- if setting is detected
            if setting_detected = '1' then
                if selection = "0100" then 
                    selection <="0001";
                else
                    selection <= selection + '1';
                end if;
            end if;
        end if;
        -- if up button is pressed
        if buttons(0)='1' and buttons(0)'event then 
            -- if setting is detected
            if setting_detected = '1' then
                if display_data = 1 then -- is it new time?
                    if selection = "0001" then -- what digit is selected
                        -- hour digit 2
                        hora_adj <= adding_time( hora_adj, "0001010", '1');
                    elsif selection = "0010" then
                        -- hour digiti 1
                        hora_adj <= adding_time( hora_adj, "0000001", '1');
                    elsif selection = "0011" then
                        -- min digit 2
                        min_adj <= adding_time( min_adj, "0001010", '0');
                    elsif selection = "0100" then
                        -- min digit 1
                        min_adj <= adding_time( min_adj, "0000001", '0');
                    end if;
                elsif  display_data = 2 then -- or is it alarm?
                    if selection = "0001" then -- what digit is selected
                        -- hour digit 2
                        hora_alarm <= adding_time( hora_alarm, "0001010", '1');
                    elsif selection = "0010" then
                        -- hour digiti 1
                        hora_alarm <= adding_time( hora_alarm, "0000001", '1');
                    elsif selection = "0011" then
                        -- min digit 2
                        min_alarm <= adding_time( min_alarm , "0001010", '0');
                    elsif selection = "0100" then
                        -- min digit 1
                        min_alarm <= adding_time( min_alarm , "0000001", '0');
                    end if;
                end if;
            end if;
        end if;
        
    end process setting_ctrl;
   ------------------------------------------------------------------------------------------------------------------------- 
   -- setting_blinking process responsable to toogle the select_blinking signal used to blink the anode that will be 
   -- indicating wich digit is selected 
   setting_blinking: process (clk_500ms) 
   begin
    if clk_500ms'event and clk_500ms = '1' then 
        select_blinking <= not select_blinking;
    end if;
   end process setting_blinking;
   -------------------------------------------------------------------------------------------------------------------------  
     -- latch_time process find the falling edge of the setting_detected i a fram window of 500ms. 
    latch_time: process (clk_500ms)
    begin
        if clk_500ms'event and clk_500ms='1' then
            latch_reg (0) <= not ( buttons(3) and buttons(2));
            latch_reg (1) <= latch_reg (0);
        end if;
    end process latch_time;
   -------------------------------------------------------------------------------------------------------------------------  
   -- animated leds decoration for the led ticks
   led_animated: process (clk_10ms)
    variable counter: integer range 0 to 5 := 1;
    variable direction : std_logic := '0';
   begin
   
        if clk_10ms'event and clk_10ms = '1' then 
            counter := counter + 1;
            
            if counter = 0 then 
                if direction = '0' then
                    animated <= animated(animated'left - 1 downto 0) & '0'; -- left shift
                else
                    animated <= '0' & animated(animated'left downto 1); -- right shift
                end if;
            end if;
            
            if animated = 0 then 

                if direction = '0' then 
                    animated <= "100000";
                else
                    animated <= "000001";
                end if;
                
                direction := not direction;
            end if;
       end if;
        
   end process;
   -------------------------------------------------------------------------------------------------------------------------  
   -- alarm sound generation process is used to generate a pulse of 100Hz that will be activated by 500ms
   -- and turned off by another 500 ms. 
   -- This pulse will be enabled into the buzzer pin when the alarm is activated. 
   -- The 100Hz is approximately the G#2/Ab2 scale note.
    alarm_sound_gen: process (clk_500ms, clk_10ms)
    begin
        if clk_500ms = '1' and clk_500ms'event then
            pulse_enable <= not pulse_enable;
        end if;
        
        if clk_10ms = '1' and clk_10ms'event then
            pulse_tone <= not pulse_tone;
        end if;
        
    end process alarm_sound_gen;
   ------------------------------------------- Debuggin interface ----------------------------------------------------------
	--led for debuggin purposes
	--led (9 downto 6 ) <= selection;             --- what number the selection has
    --led (5 downto 2 ) <= selection_digit;    	--- what digit the user is changing
    --led (6) <= select_blinking;              	--- the blinking period during the selection of the digit
    --led (7) <= latch_event;                  	--- latch when the clock has changed.
    --led (8) <= ledx;                         	--- clck selected
    --led (11 downto 9) <= selection( 2 downto 0);          
    --led (15 downto 12) <= buttons(3 downto 0);
    --selection digit signal is made of switches
    --selection <= (sw(5),sw(4),sw(3),sw(2));--(sw(2) , sw (3) , sw (4) , sw(5));

   
end Behavioral;
    ------------------------------------------- Fin de VHDL ----------------------------------------------------------------
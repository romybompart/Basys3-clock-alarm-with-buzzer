# Basys3-clock-alarm-with-buzzer
Digital clock implemented in vhdl for the Basys 3 Board from Digilent. 

# Instructions
 ############### THE BUZZER ###############
 
 Connect the buzzer to JA4
 
 ############### THE LEDS ###############
 
 When LED 0 and LED 1 are OFF the data displayed is the current clock 
 When LED 0 is ON and LED 1 is OFF the data displayed is the new clock to set
 
 ############### THE BUTTONS ###############
 
 1. When LED 0 is OFF and LED 1 is ON the data displayed is the alarm
 
 2. To enter in setting mode, to configure or check the new clock or alarm data
 press the center button (BTNC). 
 
 3. To select a digit from the 7 segment display it is neccesary to use the right
 button (BTNR). When the digit is selected it will be blinking at 500ms.
 
 4. To change the digit value, it is neccesary to use the up button (BTNU).
 
 5. To set the new clock into the current clock it is neccesary to press left and 
 down button (BTNL and BTND) at the same time for 1 second. 
 
 ############### THE SWITCHES ###############
 
 1. When SW0 and SW1 are ON or OFF, the current clock will count every second
 
 2. When SW0 is ON and SW1 is OFF, the counter will increase 10 time faster (every
 100 milisecond)
 
 3. When SW0 is OFF and SW1 is ON, the counter will increase 100 time faster (every
 10 milisecond)
 
 ############### THE DISPLAY ###############
 
 The display has 4 digits and 1 dot, from left to right, the first digit is the
 ten digit for the hour, the second digit is the unit digit for hour, the thrid digit
 is the ten digit for minutes, the fourth digit is the unit digit for minutes
 the dot is blinking accordingly to the selected clock using the SW0 and SW1, thus
 it might be indicating seconds.
 

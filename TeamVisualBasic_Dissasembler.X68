*-----------------------------------------------------------
* Title      :  Team Visual Basic's Disassembler
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  ?
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Main Driver File
*-----------------------------------------------------------
    
START       ORG         $1000               ;Start @ address $1000
            JSR         DISP_INTRO          ;Display Intro Message
            JSR         INPUT_ADDR          ;Take start and ending address as user input
            JSR         CNVRT_ADDR
            JSR         MAIN_LOOP           ;Meat of the program: Check for validity, OPCODE match, and print to screen
            
            BRA         END                 ;If loop improperly terminated, base case BRA to END program         
*-Intro Message---------------------------------------------
DISP_INTRO  LEA         M_INTRO,A1          ;Load intro msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15    
    
            RTS                             ;Return to main START section
*-Take Start and End Address as Input-----------------------
INPUT_ADDR  LEA         M_INPUT_S,A1        ;Load input request msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            LEA         START_ADDR,A1
            MOVE.B      #2,D0               ;Read string from keyboard and store in (A1)
            TRAP        #15
            
            LEA         M_INPUT_E,A1        ;Load input request msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            LEA         END_ADDR,A1
            MOVE.B      #2,D0               ;Read string from keyboard and store in (A1)
            TRAP        #15
            
            RTS                             ;Return to main START section


*-Convert User Input into Hex Address-----------------------
CNVRT_ADDR                  

*-Main Loop-------------------------------------------------
MAIN_LOOP   
    
*-END-------------------------------------------------------
END         MOVE.B      #9,D0               ;End program
            TRAP        #15     
*-Files-----------------------------------------------------
            INCLUDE     'Jump_Table.X68'    ;Include Jump Table File
            
*-Variables and constants-----------------------------------
CR          EQU         $0D
LF          EQU         $0A

START_ADDR  DS.B        20                  ;Machine code start address stored here
END_ADDR    DS.B        20                  ;Machine code end address stored here
            


*-Strings---------------------------------------------------
M_INTRO     DC.B        'Team Visual Basic',CR,LF
            DC.B        'Motorola 68000 Disassembler',CR,LF
            DC.B        'By Austin Abeyta, Dylan Desmond, and Henry Hong',CR,LF,CR,LF,0 
            
M_INPUT_S   DC.B        'Please Input the Starting Address: ',CR,LF,0
M_INPUT_E   DC.B        'Please Input the Ending Address: ',CR,LF,0
                    
            END         START               ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

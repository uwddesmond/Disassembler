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
            JSR         INPUT_ADDR          ;Take start address as user input

*-IntroMsg-----------------------------------------------------
DISP_INTRO  LEA         M_INTRO,A1          ;Load intro msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15        
            RTS

INPUT_ADDR  LEA         M_INPUT,A1          ;Load input request msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
        
    
            SIMHALT                         ; halt simulator

*-Variables and constants here---------------------------------
            ;INCLUDE     'insert_filename_here.x68'     ;To include a file
            
CR          EQU         $0D
LF          EQU         $0A

M_INTRO     DC.B        'Team Visual Basic',CR,LF
            DC.B        'Motorola 68000 Disassembler',CR,LF,0
            DC.B        'By Austin Abeyta, Dylan Desmond, and Henry Hong',CR,LF,0 
            
M_INPUT     DC.B        'Please Input a Starting Address: ',CR,LF,0
                    
            END         START               ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

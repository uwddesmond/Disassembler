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
            JSR         MAIN_LOOP           ;Meat of the program: Check for validity, OPCODE match, and print to screen
                                                        
            BRA         END                 ;If loop improperly terminated, base case BRA to END program         
*-Intro Message---------------------------------------------
DISP_INTRO  LEA         M_INTRO,A1          ;Load intro msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15                     
    
            RTS                             ;Return to main START section
            
*-Main Loop-------------------------------------------------
MAIN_LOOP   
            JSR         BUILD_STR           ;Build and accumulate the 0xADDR OPCODE $OPERAND string into memory @ OP_ADDR                            
            JSR         PRINT_OP            ;Print the built string to console           
            JSR         LOOP_COND           ;
            
            
            
            BRA         MAIN_LOOP
            
            
*-Loop Condition Logic--------------------------------------
LOOP_COND   ADD.W       D7,A5               ;Increment current address (A5) by the length of the last OPCODE+OPERAND stored in D7
            CLR.L       D7                  ;Reset opcode length var D7
            CMP.W       A5,A6               ;If current address (A5) is now equal to end address (A6), end
            BEQ         END
            
            RTS
            
*-Print OPCODE STRING---------------------------------------
PRINT_OP    MOVE.W      #OP_ADDR,A1         ;Move the OPCODE's beginning addr to A1
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            MOVE.W      #M_NEWLINE,A1       ;Print a new line after this OPCODE line is finished
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            RTS
            
    
*-END-------------------------------------------------------
END         MOVE.B      #9,D0               ;End program
            TRAP        #15                      
            
*-Variables and constants-----------------------------------
CR          EQU         $0D
LF          EQU         $0A

BYTE        EQU         $2
WORD        EQU         $4
LONG        EQU         $8

START_ADDR  DS.B        30                  ;Machine code start address stored here
END_ADDR    DS.B        30                  ;Machine code end address stored here

OP_ADDR     DS.B        30                  ;Storage to accumulate OPCODE address, name, and data string at            


*-Strings---------------------------------------------------
M_INTRO     DC.B        'Team Visual Basic',CR,LF
            DC.B        'Motorola 68000 Disassembler',CR,LF
            DC.B        'By Austin Abeyta, Dylan Desmond, and Henry Hong',CR,LF,CR,LF,0 

M_IN_RULES  DC.B        'Please limit address input to numeric (0-9) and/or ALL CAPS alphabet A-F',CR,LF
            DC.B        'Please limit address input to a range of [00005000-FFFFFFFF]!',CR,LF
            DC.B        'Input less than 8 digits will be padded on left',CR,LF    
            DC.B        'Input greater than 8 digits will be truncated on the right',CR,LF,CR,LF0
            
M_INPUT_S   DC.B        'Please Input the Starting Address (test code is ORG @ 7F00): ',CR,LF,0
M_INPUT_E   DC.B        'Please Input the Ending Address: ',CR,LF,0

M_IN_WAIT   DC.B        'Press Enter to Continue'


M_INV_INPUT DC.B        'Input address is invalid! Please re-enter: ',CR,LF,CR,LF,0

M_ERR_ADDR1 DC.B        'ERR: START address > END address',CR,LF,0
M_ERR_ADDR2 DC.B        'ERR: START address too low, danger of overwriting program logic',CR,LF,0
M_ERR_ADDR3 DC.B        'ERR: ODD START address',CR,LF,0
M_ERR_ADDR4 DC.B        'ERR: ODD END address',CR,LF,0

M_NEWLINE   DC.B        '',CR,LF,0
                    
            

*-Files-----------------------------------------------------
            INCLUDE     'TeamVisualBasic_Disassembler_Input.X68'            ;Include Input class file
            INCLUDE     'TeamVisualBasic_Disassembler_OutputBuilder.X68'    ;Include OutputBuilder class file
            INCLUDE     'TeamVisualBasic_JumpTable.X68'                     ;Include Jump Table file
            
            END         START               ;last line of source












*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~

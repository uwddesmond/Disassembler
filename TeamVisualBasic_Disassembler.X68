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
            
*-Press Enter to Continue message---------------------------            
DISP_WAIT   LEA         M_WAIT,A1           ;Load wait message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            MOVE.B      #5,D0               ;Trap Task 5 takes in a single character input (aka press enter)
            TRAP        #15
            
            MOVE.B      #11,D0              ;Clear screen
            MOVE.W      #$FF00,D1
            TRAP        #15

            RTS        
            
*-Main Loop-------------------------------------------------
MAIN_LOOP   JSR         DISP_WAIT           ;Display Press Enter to Continue msg
            MOVE.B      #26,D4              ;D4 loop var - print 26 lines per page
            
NEXT_OP     JSR         BUILD_STR           ;Build and accumulate the 0xADDR OPCODE $OPERAND string into memory @ OP_ADDR                            
            JSR         PRINT_OP            ;Print the built string to console 
            
            JSR         LOOP_COND           ;Check if address is still valid. END program if it isnt
  
            SUBI        #1,D4               ;Decrement counter
            CMP.B       #0,D4               ;Is counter == 0?
            BEQ         MAIN_LOOP           ;Then print the next page
            
            BRA         NEXT_OP             ;Otherwise, in the same page, print the next OP         

            
*-Loop Condition Logic--------------------------------------
LOOP_COND   ADD.L       D6,A5            ;Increment current address (A5) by the length of the last instruction + operand data (D6)
            CMPA.W      A5,A6            ;If current address (A5) is now equal to or greater than end address (A6), end
            BLT         DSMBL_DONE           ;<---------- check conditional
            
            RTS            
           
*-Print OPCODE STRING---------------------------------------
PRINT_OP    MOVE.W      #OP_ADDR,A1         ;Move the OPCODE's beginning addr to A1
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            MOVE.W      #M_NEWLINE,A1       ;Print a new line after this OPCODE line is finished
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            RTS
            
*-Print to user DONE message--------------------------------
DSMBL_DONE  LEA         M_DONE,A1           ;Print DONE message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15 
            
            JSR         PROMPT_NEW          ;Ask user if they want to restart
            
*-Ask user if they want to start program again--------------            
PROMPT_NEW  LEA         M_NPROMPT,A1        ;Ask user if they would like to run program again
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15                     
            
            CLR.L       D1                  ;Clear D1
            MOVE.B      #5,D0               ;Read user input into D1
            TRAP        #15
            
            CMP.B       #'y',D1             ;Is input y
            BEQ         P_RESTART           ;if so restart program
            
            CMP.B       #'Y',D1             ;Is input Y capital
            BEQ         P_RESTART           ;if so restart program
            
      

            CMP.B       #'n',D1             ;Is input n
            BEQ         END                 ;if so restart program
            
            CMP.B       #'N',D1             ;Is input N capital
            BEQ         END                 ;if so restart program
            
            LEA         M_ERR_GEN,A1        ;Input is invalid! Prompt again
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15 
            
            BRA         PROMPT_NEW          ;Re prompt            

P_RESTART   JSR         DISP_WAIT
            BRA         START 
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

M_IN_RULES  DC.B        'Please limit address input to numeric (0-9) and/or alphabet A-F',CR,LF
            DC.B        'Please limit address input to a range of [00005000-FFFFFFFF]!',CR,LF
            DC.B        'Input less than 8 digits will be padded on left',CR,LF    
            DC.B        'Input greater than 8 digits will be truncated on the right',CR,LF,CR,LF,0
            
M_INPUT_S   DC.B        'Please Input the Starting Address (test code is ORG @ 7F00): ',CR,LF,0
M_INPUT_E   DC.B        'Please Input the Ending Address: ',CR,LF,0

M_WAIT      DC.B        CR,LF,'Press Enter to Continue!',CR,LF,0

M_INV_INPUT DC.B        'Input address is invalid! Please re-enter: ',CR,LF,CR,LF,0

M_ERR_ADDR1 DC.B        'ERR: START address > END address',CR,LF,0
M_ERR_ADDR2 DC.B        'ERR: START address too low, danger of overwriting program logic',CR,LF,0
M_ERR_ADDR3 DC.B        'ERR: ODD START address',CR,LF,0
M_ERR_ADDR4 DC.B        'ERR: ODD END address',CR,LF,0

M_NPROMPT   DC.B        'Would you like to run program again @ another address? (y/n)',CR,LF,0
M_ERR_GEN   DC.B        CR,LF,'Invalid input!',CR,LF,0  
M_DONE      DC.B        'Done!',CR,LF,0  

M_NEWLINE   DC.B        '',CR,LF,0
                    
            

*-Files-----------------------------------------------------
            INCLUDE     'TeamVisualBasic_Disassembler_Input.X68'            ;Include Input class file
            INCLUDE     'TeamVisualBasic_Disassembler_OutputBuilder.X68'    ;Include OutputBuilder class file
            INCLUDE     'TeamVisualBasic_JumpTable.X68'                     ;Include Jump Table file
            
            END         START               ;last line of source




















*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~

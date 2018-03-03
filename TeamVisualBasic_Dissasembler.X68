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
*-Take Start and End Address as Input-----------------------
INPUT_ADDR  LEA         M_IN_RULES,A1       ;Load input restriction and rules msg
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15                 

            LEA         M_INPUT_S,A1        ;Load input request msg
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
            
            JSR         CNVRT_ADDR          ;Convert user ASCII input into usable hex addresses

            RTS                             ;Return to main START section


*-Convert User Input into Hex Address-----------------------
CNVRT_ADDR  LEA         START_ADDR,A0       ;Load start address into A0
            MOVE.B      #8,D3               ;Load counter var into D3. Count down from 8
            JSR         C_LOOP
            MOVE.L      D2,A5               ;Save start address in A5
            
            LEA         END_ADDR,A0         ;Load end address into A0
            MOVE.B      #8,D3               ;Load counter var into D3. Count down from 8
            CLR.L       D2
            JSR         C_LOOP
            MOVE.L      D2,A6               ;Save end address in A6 
            
            BRA         CNVRT_DONE          ;Finish by RTSing back  
            
C_LOOP      MOVE.B      (A0)+,D0            ;Load the ascii digit into D0
            CMP.B       #$FF,D0             ;If value is $FF, there is no digit
            BEQ         C_INVALID
            CMP.B       #$00,D0             ;If value is $00, then probably done
            BEQ         CNVRT_DONE              

            SUBI.B      #1,D3               ;Decrement counter var
            
            ;Determine whether num, upper, or lower case ascii a-f                                    
            CMP.B       #$30,D0             ;If <30, not a number
            BLT         C_INVALID           
            CMP.B       #$46,D0             ;If >46, it's possibly a lowercase letter 
            BGT         C_IS_LC             ;Check if it's a valid lower ascii letter
            
            CMP.B       #$39,D0             ;If <39, must be number
            BLT         C_NUMERIC
            CMP.B       #$41,D0             ;If >41, must be upper case ascii
            BGT         C_ALPHA_U

            BRA         C_INVALID           ;If none of the above, the input is not valid 
            
C_IS_LC     CMP.B       #$61,D0             ;If >61, input is invalid
            BLT         C_INVALID
            CMP.B       #$66,D0             ;If >66, input is invalid
            BGT         C_INVALID
            
            BRA         C_ALPHA_L           ;Else must be a valid lowercase input

C_NUMERIC   SUBI.B      #$30,D0             ;Subtract 0x30 to convert to hex
            LSL.L       #4,D2               ;Shift by 1 digit to make room for next digit
            ADD.B       D0,D2               ;Accumulate digits into D2
            BRA         C_LOOP  


C_ALPHA_U   SUBI.B      #$37,D0             ;Subtract 0x37 to convert to hex
            LSL.L       #4,D2               ;Shift by 1 digit to make room for next digit
            ADD.B       D0,D2               ;Accumulate digits into D2
            BRA         C_LOOP

C_ALPHA_L   SUBI.B      #$57,D0             ;Subtract 0x57 to convert to hex
            LSL.L       #4,D2               ;Shift by 1 digit to make room for next digit
            ADD.B       D0,D2               ;Accumulate digits into D2
            BRA         C_LOOP
        
                        
                                 
C_INVALID   MOVE.B      #11,D0              ;Clear screen
            MOVE.W      #$FF00,D1
            TRAP        #15
            
            LEA         M_INV_INPUT,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         START 
 
CNVRT_DONE  CMP.B       #8,D3               ;If no input, invalid
            BEQ         C_INVALID           
            
            RTS                             ;Else, done

*-Main Loop-------------------------------------------------
MAIN_LOOP   
    
*-END-------------------------------------------------------
END         MOVE.B      #9,D0               ;End program
            TRAP        #15     
            
*-Variables and constants-----------------------------------
CR          EQU         $0D
LF          EQU         $0A

START_ADDR  DS.B        20                  ;Machine code start address stored here
END_ADDR    DS.B        20                  ;Machine code end address stored here
            


*-Strings---------------------------------------------------
M_INTRO     DC.B        'Team Visual Basic',CR,LF
            DC.B        'Motorola 68000 Disassembler',CR,LF
            DC.B        'By Austin Abeyta, Dylan Desmond, and Henry Hong',CR,LF,CR,LF,0 

M_IN_RULES  DC.B        'Please limit address input to numeric (0-9) and/or ALL CAPS alphabet A-F',CR,LF
            DC.B        'Please limit address input to a range of [0010000-FFFFFFFF]!',CR,LF
            DC.B        'Input less than 8 digits will be padded on left, and truncated on right',CR,LF,0    
         
M_INPUT_S   DC.B        'Please Input the Starting Address: ',CR,LF,0
M_INPUT_E   DC.B        'Please Input the Ending Address: ',CR,LF,0

M_INV_INPUT DC.B        'Input address is invalid! Please re-enter: ',CR,LF,0
                    
            

*-Files-----------------------------------------------------
            ;INCLUDE     'TeamVisualBasic_JumpTable.X68'    ;Include Jump Table File
            
            END         START               ;last line of source







*~Font name~Courier New~
*~Font size~11~
*~Tab type~1~
*~Tab size~4~

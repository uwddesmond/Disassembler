*-----------------------------------------------------------
* Title      :  Team Visual Basic's Disassembler: Input 
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Input Class
*-----------------------------------------------------------

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
CNVRT_ADDR  LEA         START_ADDR,A1       ;Load start address into A1
            MOVE.B      #8,D3               ;Load counter var into D3. Count down from 8
            JSR         C_LOOP
            MOVE.L      D2,A5               ;Save converted input in (A5)
            
            CLR.L       D2                  ;Clear accumulator
            LEA         END_ADDR,A1         ;Load end address into A1
            MOVE.B      #8,D3               ;Load counter var into D3. Count down from 8
            JSR         C_LOOP
            MOVE.L      D2,A6               ;Save converted input in (A6)
                
            JSR         C_VALIDATE          ;Make sure input is not ODD and end addr is not before start
            RTS                             ;Finish by RTSing back to main dissasembler file
 
*-Main convert loop logic-----------------------------------            
C_LOOP      MOVE.B      (A1)+,D0            ;Load the ascii digit into D0
            CMP.B       #$FF,D0             ;If value is $FF, there is no digit
            BEQ         C_INVALID
            CMP.B       #$00,D0             ;If value is $00, then probably done
            BEQ         CNVRT_DONE              
            
            CMP.B       #0,D3               ;If counter var == 0
            BEQ         CNVRT_DONE
            SUBI.B      #1,D3               ;Else, decrement counter var
            
            ;Determine whether num, upper, or lower case ascii a-f                                    
            CMP.B       #$30,D0             ;If <30, not a number
            BLT         C_INVALID           
            CMP.B       #$46,D0             ;If >46, it's possibly a lowercase letter 
            BGT         C_IS_LC             ;Check if it's a valid lower ascii letter
            
            CMP.B       #$40,D0             ;If <40, must be number
            BLT         C_NUMERIC
            CMP.B       #$41,D0             ;If >41, must be upper case ascii
            BGT         C_ALPHA_U

            BRA         C_INVALID           ;If none of the above, the input is not valid 
            
*-Helper logic to determine the ascii type and convert to hex            
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
        
                       
*-Helper logic for loop-------------------------------------                                            
CNVRT_DONE  CMP.B       #8,D3               ;If no input, invalid
            BEQ         C_INVALID           
            
            RTS                             ;Else, done
            

*-Final validation logic that rejects certain address patterns         
C_VALIDATE  CMPA.L      A5,A6               ;If end address < start address     
            BLT         C_ERR1
                                              
            CMPA.L      #$00005000,A5       ;If start address is <0x5000
            BLT         C_ERR2
            
            MOVE.L      A5,D0               ;Check rightmost input address bit
            BTST        #0,D0               ;If rightmost (least sig) bit is 1 (aka ODD address)
            BNE         C_ERR3           
            
            MOVE.L      A6,D0               ;Check rightmost input address bit
            BTST        #0,D0               ;If rightmost (least sig) bit is 1 (aka ODD address)
            BNE         C_ERR4
            
            RTS                             ;If none of the above, input is valid
            
*-Convert error subroutines---------------------------------
C_INVALID   JSR         C_ERR_BASE1         ;Clear screen and clear registers
            BRA         C_ERR_BASE2         ;Print generic error msg and branch to start

C_ERR1      JSR         C_ERR_BASE1         ;Clear screen and registers
            LEA         M_ERR_ADDR1,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         C_ERR_BASE2         ;Print generic err msg, then go back to input loop and ask for new input

C_ERR2      JSR         C_ERR_BASE1         ;Clear screen and registers
            LEA         M_ERR_ADDR2,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         C_ERR_BASE2         ;Print generic err msg, then go back to input loop and ask for new input


            
C_ERR3      JSR         C_ERR_BASE1         ;Clear screen and registers
            LEA         M_ERR_ADDR3,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         C_ERR_BASE2         ;Print generic err msg, then go back to input loop and ask for new input

C_ERR4      JSR         C_ERR_BASE1         ;Clear screen and registers
            LEA         M_ERR_ADDR4,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         C_ERR_BASE2         ;Print generic err msg, then go back to input loop and ask for new input


C_ERR_BASE1 MOVE.B      #11,D0              ;Clear screen
            MOVE.W      #$FF00,D1
            TRAP        #15
            
            CLR.L       D2
            CLR.L       D5
                              

            MOVE.L      #$FFFFFFFF,(START_ADDR)        
            MOVE.L      #$FFFFFFFF,(END_ADDR)
            MOVEA.L     #$00000000,A5       ;Clear registers
            MOVEA.L     #$00000000,A6 
     
            RTS

C_ERR_BASE2 LEA         M_INV_INPUT,A1      ;Load error message
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            BRA         START 
           



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*-----------------------------------------------------------
* Title      :  Team Visual Basic's Dissassembler: Jump Table
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  2/27/2018
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Determines the OPCODE and Effective Addressing from an input
*-----------------------------------------------------------

*-----------------------------------------------------------
*-Start Section
*-Start determining OPCODE based off the first four bits,
*-then Branch off into 16 bin possibilities
*-----------------------------------------------------------

JT_START    MOVE.W      #$4E71,(A7)         *Load test for Nop into (A7)
            
            MOVE.W      (A0),D2             *move op code into d2 to bit shift
            LSR.W       #4,D2               *Shift right 4 bits
            LSR.W       #4,D2               *shift right 4 bits
            LSR.W       #4,D2               *shift right 4 bits
            
            CMPI.W      #0,D2               *check if it falls into 0 bin
            BEQ         BIN_0
    
            CMPI.W      #1,D2               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #2,D2               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #3,D2               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #4,D2               *check if it falls into 4 bin
            BEQ         BIN_4

            CMPI.W      #5,D2               *check if it falls into 5 bin
            BEQ         BIN_5

            CMPI.W      #6,D2               *check if it falls into 6 bin
            BEQ         BIN_6

            CMPI.W      #7,D2               *check if it falls into 7 bin
            BEQ         BIN_7

            CMPI.W      #8,D2               *check if it falls into 8 bin
            BEQ         BIN_8

            CMPI.W      #9,D2               *check if it falls into 9 bin
            BEQ         BIN_9

            CMPI.W      #10,D2              *check if it falls into 10 bin
            BEQ         BIN_10

            CMPI.W      #11,D2              *check if it falls into 11 bin
            BEQ         BIN_11

            CMPI.W      #12,D2              *check if it falls into 12 bin
            BEQ         BIN_12

            CMPI.W      #13,D2              *check if it falls into 12 bin
            BEQ         BIN_13

            CMPI.W      #14,D2              *check if it falls into 14 bin
            BEQ         BIN_14

            CMPI.W      #15,D2              *check if it falls into 15 bin
            BEQ         BIN_15

*--------------------------------------------------------------
*-Bin 0 Possible OPCODES:
*-CMPI, ORI, BCLR(immediate and register)
*--------------------------------------------------------------    
BIN_0       MOVE.W      (A0),D2             *reload opcode
            LSR.W       #8,D2               *shift bits to the right 8
            AND.W       #$0F,D2             *Isolate the last 4 bits
            
            CMPI.W      #12,D2              *Check if the bit is C
            BEQ         CMPI                *if CMPI go to the subroutine
            
            CMPI.W      #0,D2               *Check if the bit is a 0
            BEQ         ORI                 *if ORI go to the subroutine
            
            CMPI.W      #8,D2               *Check if the bit is an 8
            BEQ         BCLR                *if BCLR immediate go to subroutine
            
            AND.W       #$01,D2             *isolate the last bit
            CMPI.W      #1,D2               *Check if the bit is a 1
            BEQ         BCLR                *if BCLR register go to subroutine
            
            *BRA         DATA           

*--------------------------------------------------------------
*-BIN_MOVE (Bins 1, 2, and 3) Possible OPCODES: 
*-MOVE, MOVEA
*--------------------------------------------------------------     
BIN_MOVE    MOVE.W      (A0),D2             *reload opcode
            LSR.W       #6,D2               *shift bits to the right 6
            AND.W       #$07,D2             *isolate the last 3 bits
            CMPI.W      #1,D2               *check if the bits are 001
            BEQ         MOVEA               *if MOVEA go to SUB
            
            *CMPI.W      #7,D2              *check if the bits are 111
            *BEQ         DATA               *if 111 must be DATA
            BRA         MOVE                *otherwise must be MOVE
            
*--------------------------------------------------------------            
*-BIN 4 Possible OPCODES:
*-NOP, RTS, JSR, NEG, LEA, MOVEM
*--------------------------------------------------------------
BIN_4       MOVE.W      (A0),D2             *reload opcode
            CMPI.W      #$4E71,D2           *check for no-op value
            BEQ         NOP                 *if NOP go to SUB
            
            CMPI.W      #$4E75,D2           *Compare with a constant value for RTS      
            BEQ         RTS                 *if RTS go to RTS subroutine
            
            LSR.W       #4,D2               *shift right 4 bits
            LSR.W       #4,D2               *shift right 4 bits
            AND.W       #$0F,D2             *bitmask first 4 bits  
            CMPI.W      #$E,D2              *compare final masked bits
            BEQ         JSR                 *if it equals E it is JSR
            
            CMPI.W      #$4,D2              *check for defining bits
            BEQ         NEG                 *branch to NEG routine
            
            AND.W       #$1,D2
            CMPI.W      #1,D2
            BEQ         LEA
            
            CMPI.W      #0,D2
            BEQ         MOVEM
            
*--------------------------------------------------------------            
*-BIN 5 Possible OPCODES:
*-SUBQ
*--------------------------------------------------------------    
BIN_5       BRA         SUBQ                *SUBQ is the only option for this bin so branch to SUB

*--------------------------------------------------------------            
*-BIN 6 Possible OPCODES:
*-Bcc(CS, GE, LT, VC)
*--------------------------------------------------------------    
BIN_6       MOVE.W      (A0),D2             *reload fresh op code
            LSR.W       #4,D2               *shift right 4
            LSR.W       #4,D2               *shift right 4
            AND.W       #$0F,D2             *Finds the condition code of the branch statement through bitmask
            CMPI.W      #4,D2
            BEQ         BCC                 *branch to BCC code     ;<-------------------Not correct, B(cc) isn't a standalone OPCODE
                                                                 ;<--- Also BLT is missing 
                                                                             
            CMPI.W      #8,D2
            BEQ         BVC                 *branch to BVC code
            
            CMPI.W      #5,D2
            BEQ         BCS                 *branch to BCS code
            
            CMPI.W      #$C,D2
            BEQ         BGE                 *branch to BGE code

*--------------------------------------------------------------            
*-BIN 7 Possible OPCODES:
*-N/a - DATA
*--------------------------------------------------------------  
BIN_7       *BRA        DATA                *If it goes into this bin it is DATA

*--------------------------------------------------------------            
*-BIN 8 Possible OPCODES:
*-DIVS, OR
*--------------------------------------------------------------       
BIN_8       MOVE.W      (A0),D2
            LSR.W       #6,D2
            AND.W       #$07,D2   
            CMPI.W      #7,D2
            BEQ         DIVS
            
            BRA         OR  
            
*--------------------------------------------------------------            
*-BIN 9 Possible OPCODES:
*-SUB
*--------------------------------------------------------------     
BIN_9       BRA         SUB                 *SUB is the only option for this bin so branch to SUB

*--------------------------------------------------------------            
*-BIN 10 Possible OPCODES:
*-N/a - DATA
*--------------------------------------------------------------     
BIN_10      *BRA        DATA                *If it goes into this bin it is DATA

*--------------------------------------------------------------            
*-BIN 11 Possible OPCODES:
*-EOR, CMP
*--------------------------------------------------------------     
BIN_11      MOVE.W      (A0),D2             *reload opcode into D2
            LSR.W       #4,D2               *shift bits to the right 4
            LSR.W       #4,D2               *Shift bits to the right 4
            AND.W       #$01,D2             *isolate the last bit
            CMPI.W      #1,D2               *check if the bit is a 1
            BEQ         EOR                 *if EOR go to the SUB
            
            CMPI.W      #0,D2               *check if the bit is a 0
            BEQ         CMP                 *if CMP go to the SUB
            
            *BRA        DATA                *if neither EOR or CMP must be DATA
            
*--------------------------------------------------------------            
*-BIN 12 Possible OPCODES:
*-MULS
*--------------------------------------------------------------     
BIN_12      BRA         MULS                *MULS is the only option for this bin so branch to SUB

*--------------------------------------------------------------            
*-BIN 13 Possible OPCODES:
*-ADD, ADDA, SUB
*--------------------------------------------------------------    
BIN_13      MOVE.W      (A0),D2             *reload opcode into D2
            LSR.W       #6,D2               *shift bits to the right 6
            AND.W       #$07,D2             *isolate the last 3 bits
            CMPI.W      #$3,D2              *check if the bits are 011
            BEQ         ADDA                *if ADDA go to SUB              ;<---------- One of these branches is not correct
            
            CMPI.W      #$7,D2              *check if the bits are 111
            BEQ         ADDA                *if ADDA go to SUB              ;<---------- One of these branches is not correct
                                                        
            BRA         ADD                 *if bits are not ADDA must be ADD and go to SUB
            
*--------------------------------------------------------------            
*-BIN 14 Possible OPCODES:
*-LS(L/R), AS(L/R), RO(L/R)
*--------------------------------------------------------------      
BIN_14      MOVE.W      (A0),D2             *Reload the opcode
            LSR.W       #3,D2               *shift bits down
            AND.W       #$07,D2             *mask bits
            CMP.W       #1,D2               *determin which kind of shift it is
            BEQ         LOGICSHIFT          *bra to logic shift
            
            CMP.W       #0,D2
            BEQ         ARITH_SHIFT         *bra to arthimetic shift
            
            CMP.W       #3,D2
            BEQ         ROTATE              *bra to rotate      ;<---- Is there a distinction between Left and right rotate?
            
                                                                ; <--------- There should be a base case here
                                                                

*--------------------------------------------------------------            
*-BIN 15 Possible OPCODES:
*-N/a - DATA
*--------------------------------------------------------------       
BIN_15      *BRA        DATA                *IF it goes into this bin it is DATA
                                                                                             


*-PRINT OP-----------------------------

PRINT_OP    MOVE.B      #14,D0
            TRAP        #15

            


*--------------------------------------------------------------
*-Decode table
*-Part 2 of the Jump Table
*-OPCODE Effective addressing and EA Mode decoding
*--------------------------------------------------------------

 
*-BIN 0--------------------------------------------------------           
ORI         LEA         S_ORI,A1
            MOVE.B      #14,D0
            TRAP        #15
            
            
CMPI        LEA         S_CMPI,A1
            MOVE.B      #14,D0
            TRAP        #15
            
            
BCLR        LEA         S_BCLR,A1
            MOVE.B      #14,D0
            TRAP        #15
            

*-BIN_MOVE (Bins 1, 2, and 3)---------------------------------- 
           
MOVE        LEA         S_MOVE,A1
            MOVE.B      #14,D0
            TRAP        #15
            
MOVEA       LEA         S_MOVEA,A1
            MOVE.B      #14,D0
            TRAP        #15
            

*-BIN 4--------------------------------------------------------


NOP         LEA         S_NOP,A1
            JSR         PRINT_OP
            
            
RTS         LEA         S_RTS,A1
            JSR         PRINT_OP       
            
LEA         LEA         S_LEA,A1
            JSR         PRINT_OP
            
MOVEM       LEA         S_MOVEM,A1
            JSR         PRINT_OP
            
JSR         LEA         S_JSR,A1
            JSR         PRINT_OP
            
NEG         LEA         S_NEG,A1
            JSR         PRINT_OP
             
            
*-BIN 5--------------------------------------------------------

SUBQ        LEA         S_SUBQ,A1
            MOVE.B      #14,D0
            TRAP        #15
                       
*-BIN 6--------------------------------------------------------

BGE         LEA         S_BGE,A1
            JSR         PRINT_OP
            
            
BCS         LEA         S_BCS,A1
            JSR         PRINT_OP
            
BVC         LEA         S_BVC,A1  
            JSR         PRINT_OP
            
BCC         LEA         S_BCC,A1
            JSR         PRINT_OP
            
*-BIN 8--------------------------------------------------------

DIVS        LEA         S_DIVS,A1
            JSR         PRINT_OP
            
OR          LEA         S_OR,A1
            JSR         PRINT_OP  

*-BIN 9---------------------------------------------------------

SUB         LEA         S_SUB,A1
            MOVE.B      #14,D0
            TRAP        #15
            
*-BIN 11--------------------------------------------------------  
         
EOR         LEA         S_EOR,A1
            MOVE.B      #14,D0
            TRAP        #15
            

CMP         LEA         S_CMP,A1
            MOVE.B      #14,D0
            TRAP        #15
            

*-BIN 12---------------------------------------------------------

MULS        LEA         S_MULS,A1
            MOVE.B      #14,D0
            TRAP        #15
            
*-BIN 13---------------------------------------------------------

ADD         LEA         S_ADD,A1
            MOVE.B      #14,D0
            TRAP        #15
            

ADDA        LEA         S_ADDA,A1
            MOVE.B      #14,D0
            TRAP        #15
            
     
*-BIN 14-------------------------------------------------------

LOGICSHIFT  LEA         S_LEFT,A1
            JSR         PRINT_OP
            BRA         RIGHTORLEFT             
              
RIGHTORLEFT MOVE.W      (A0),D2                 *reload op
            LSL.W       #8,D2                   *shift until dr bit is reached
            CMP.W       #0,D2                   *check if left
            BEQ         LEFT
            
            CMP.W       #1,D2                   *check if right
            BEQ         RIGHT  
                                    
ARITH_SHIFT LEA         S_AS,A1
            JSR         PRINT_OP
            BRA         RIGHTORLEFT
                
ROTATE      LEA         S_RO,A1
            JSR         PRINT_OP
            BRA         RIGHTORLEFT
            
LEFT        LEA         S_LEFT,A1
            JSR         PRINT_OP                       
           
           
RIGHT       LEA         S_RIGHT,A1
            JSR         PRINT_OP 
           
           
*-STRINGS------------------------------------------------------

            JSR         PRINT_OP    
            

*-OPCODE Names-------------------------------------------------
S_NOP       DC.B        'NOP',0   
S_EOR       DC.B        'EOR',0
S_CMP       DC.B        'CMP',0
S_MULS      DC.B        'MULS',0
S_ADD       DC.B        'ADD',0
S_ADDA      DC.B        'ADDA',0
S_ORI       DC.B        'ORI',0
S_CMPI      DC.B        'CMPI',0
S_BCLR      DC.B        'BCLR',0
S_MOVE      DC.B        'MOVE',0
S_MOVEA     DC.B        'MOVEA',0
S_BGE       DC.B        'BGE',0
S_BCS       DC.B        'BCS',0
S_BVC       DC.B        'BVC',0
S_BCC       DC.B        'BCC',0                       
S_RTS       DC.B        'RTS',0
S_LEA       DC.B        'LEA',0
S_NEG       DC.B        'NEG',0 
S_MOVEM     DC.B        'MOVEM',0
S_SUBQ      DC.B        'SUB.Q',0
S_DIVS      DC.B        'DIVS',0
S_OR        DC.B        'OR',0
S_SUB       DC.B        'SUB',0
S_JSR       DC.B        'JSR',0
S_LS        DC.B        'LS',0
S_AS        DC.B        'AS',0
S_RO        DC.B        'R0',0
S_LEFT      DC.B        'L',0
S_RIGHT     DC.B        'R',0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

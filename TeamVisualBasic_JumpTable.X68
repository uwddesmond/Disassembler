*-----------------------------------------------------------
* Title      :Dissambler 
* Written by :Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :2/27/2018
* Description:Using the first 4 bytes  (A7)
*-----------------------------------------------------------
    ORG    $1000
START:      MOVE.W      #$4E71,(A7)     *Load test for Nop into (A7)
            MOVE.W      (A0),D2         *move op code into d2 to bit shift
            LSR.W       #4,D2           *Shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #2,D2           *shift right 2 bits to check if
            CMPI.W      #0,D2           *check if it falls into 0 bin
            BEQ         BIN_0
            
            MOVE.W      (A0),D2         *reload op code into d2 to bit shift
            LSR.W       #4,D2           *Shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            CMPI.W      #1,D2           *check if it falls into 1 bin
            BEQ         BIN_1
            CMPI.W      #2,D2           *check if it falls into 2 bin
            BEQ         BIN_2
            CMPI.W      #3,D2           *check if it falls into 3 bin
            BEQ         BIN_3
            CMPI.W      #4,D2           *check if it falls into 4 bin
            BEQ         BIN_4
            CMPI.W      #5,D2           *check if it falls into 5 bin
            BEQ         BIN_5
            CMPI.W      #6,D2           *check if it falls into 6 bin
            BEQ         BIN_6
            CMPI.W      #7,D2           *check if it falls into 7 bin
            BEQ         BIN_7
            CMPI.W      #8,D2           *check if it falls into 8 bin
            BEQ         BIN_8
            CMPI.W      #9,D2           *check if it falls into 9 bin
            BEQ         BIN_9
            CMPI.W      #10,D2          *check if it falls into 10 bin
            BEQ         BIN_10
            CMPI.W      #11,D2          *check if it falls into 11 bin
            BEQ         BIN_11
            CMPI.W      #12,D2          *check if it falls into 12 bin
            BEQ         BIN_12
            CMPI.W      #13,D2          *check if it falls into 12 bin
            BEQ          BIN_13
            CMPI.W      #14,D2          *check if it falls into 14 bin
            BEQ         BIN_14
            CMPI.W      #15,D2          *check if it falls into 15 bin
            BEQ          BIN_15
    
BIN_0
    SIMHALT
BIN_1
    SIMHALT
BIN_2
    SIMHALT
BIN_3
    SIMHALT
BIN_4       MOVE.W      (A0),D2         *reload opcode
            CMPI.W      #$4E71,D2       *check for no-op value
            BEQ         NOP             *if NOP go to SUB
            CMPI.W      #$4E75,D2       *Compare with a constant value for JSR
            BEQ           RTS             *if jsr go to jsr function
            
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            AND.W       #$0F,D2         *bitmask first 4 bits  
            CMPI.W      #$E,D2          *compare final masked bits
            BEQ       JSR             *if it equals E it is
            
            CMPI.W      #$4,D2          *check for defining bits
            BEQ       NEG             *branch to NEG routine
            AND.W       #$1,D2
            CMPI.W      #1,D2
            BEQ       LEA
            CMPI.W      #0,D2
            BEQ       MOVEM
    SIMHALT
BIN_5
    SIMHALT
BIN_6       MOVE.W      (A0),D2         *reload fresh op code
            LSR.W       #4,D2           *shift right 4
            LSR.W       #4,D2           *shift right 4
            AND.W       #$0F,D2          *Finds the condition code of the branch statement through bitmask
            CMPI.W      #4,D2
            BEQ         BCC             *branch to BCC code
            CMPI.W      #8,D2
            BEQ         BVC             *branch to BVC code
            CMPI.W      #5,D2
            BEQ         BCS             *branch to BCS code
            CMPI.W      #$C,D2
            BEQ         BGE             *branch to BGE code
    SIMHALT
BIN_7
    SIMHALT  
BIN_8       MOVE.W      (A0),D2         *load op string
            LSR.W       #6,D2           *shift bits to bits that determine op
            AND.W       #$07,D2         *mask out random bits
            CMPI.W      #7,D2           *check if bits match div
            BEQ         DIVS            *branch to div
            BRA         OR              *check if bits mack OR
    SIMHALT
BIN_9
    SIMHALT
BIN_10
    SIMHALT
BIN_11
    SIMHALT
BIN_12
    SIMHALT
BIN_13
    SIMHALT
BIN_14
    SIMHALT
BIN_15
            MOVE.W      (A0),D2         *Reload the opcode
            LSR.W       #3,D2           *shift bits down
            AND.W       #$07,D2         *mask bits
            CMP.W       #1,D2           *determin which kind of shift it is
            BEQ         LOGICSHIFT      *bra to logic shift
            CMP.W       #0,D2
            BEQ         ARITHMETICSHIFT *bra to arthimetic shift
            CMP.W       #3,D2
            BEQ         ROTATE          *bra to rotate
    SIMHALT   


*-------BIN 4 op codes and sub rountines-----------------
NOP
            LEA         S_NOP,A1
            JSR         PRINT_OP
PRINT_OP
            MOVE.B      #14,D0
            TRAP        #15
            
RTS         LEA         S_RTS,A1
            JSR         PRINT_OP       
            
LEA
            LEA         S_LEA,A1
            JSR         PRINT_OP
MOVEM
            LEA         S_MOVEM,A1
            JSR         PRINT_OP
JSR
            LEA         S_JSR,A1
            JSR         PRINT_OP
NEG
            LEA         S_NEG,A1
            JSR         PRINT_OP
            
*------------BIN 6 ---------------
BGE
            LEA         S_BGE,A1
            JSR         PRINT_OP
            
BCS         LEA         S_BCS,A1
            JSR         PRINT_OP
            
BVC         LEA         S_BVC,A1  
            JSR         PRINT_OP
            
BCC         LEA         S_BCC,A1
            JSR         PRINT_OP
*-------------BIN 8----------------
DIVS        LEA         S_DIVS,A1
            JSR         PRINT_OP
            
OR          LEA         S_OR,A1
            JSR         PRINT_OP       
*-------------BIN 15-------------
LOGICSHIFT  LEA         S_LEFT,A1
            JSR         PRINT_OP
            BRA         RIGHTORLEFT
              
RIGHTORLEFT   MOVE.W  (A0),D2       *reload op
              LSL.W   #8,D2         *shift until dr bit is reached
              CMP.W   #0,D2         *check if left
              BEQ     LEFT
              CMP.W   #1,D2         *check if right
              BEQ     RIGHT  
ARITHMETICSHIFT LEA         S_AS,A1
                JSR         PRINT_OP
                BRA         RIGHTORLEFT
                
ROTATE      LEA         S_RO,A1
            JSR         PRINT_OP
            BRA         RIGHTORLEFT
            
LEFT                    
           LEA          S_LEFT,A1
           JSR          PRINT_OP
           
RIGHT      LEA          S_RIGHT,A1
           JSR          PRINT_OP 
S_BGE   DC.B    'BGE',0
S_BCS   DC.B    'BCS',0
S_BVC   DC.B    'BVC',0
S_BCC   DC.B    'BCC',0                       
S_NOP   DC.B    'NOP',0  
S_RTS   DC.B    'RTS',0
S_LEA   DC.B    'LEA',0
S_NEG   DC.B    'NEG',0 
S_MOVEM DC.B    'MOVEM',0
S_DIVS  DC.B    'DIVS',0
S_OR    DC.B    'OR',0
S_JSR   DC.B    'JSR',0
S_LS    DC.B    'LS',0
S_AS    DC.B    'AS',0
S_RO    DC.B    'R0',0
S_LEFT  DC.B    'L',0
S_RIGHT DC.B    'R',0

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

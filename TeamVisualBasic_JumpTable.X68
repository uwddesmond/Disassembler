*-----------------------------------------------------------
* Title      :Dissambler 
* Written by :Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :2/27/2018
* Description:Using the first 4 bytes  (A7)
*-----------------------------------------------------------
    ORG    $1000
START:      MOVE.W      #$D0C0,(A7)     *Load test for Nop into (A7)
            MOVE.W      (A0),D2         *move op code into d2 to bit shift
            LSR.W       #4,D2           *Shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #2,D2           *shift right 2 bits to check if
            CMPI.W      #0,D2           *check if it falls into 0 bin
            BEQ       BIN_0
            
            MOVE.W      (A0),D2         *reload op code into d2 to bit shift
            LSR.W       #4,D2           *Shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            CMPI.W      #1,D2           *check if it is a MOVE
            BEQ       BIN_MOVE
            CMPI.W      #2,D2           *check if it is a MOVE
            BEQ       BIN_MOVE
            CMPI.W      #3,D2           *check if it is a MOVE
            BEQ       BIN_MOVE
            CMPI.W      #4,D2           *check if it falls into 4 bin
            BEQ       BIN_4
            CMPI.W      #5,D2           *check if it falls into 5 bin
            BEQ       BIN_5
            CMPI.W      #6,D2           *check if it falls into 6 bin
            BEQ       BIN_6
            CMPI.W      #7,D2           *check if it falls into 7 bin
            BEQ       BIN_7
            CMPI.W      #8,D2           *check if it falls into 8 bin
            BEQ       BIN_8
            CMPI.W      #9,D2           *check if it falls into 9 bin
            BEQ       BIN_9
            CMPI.W      #10,D2          *check if it falls into 10 bin
            BEQ       BIN_10
            CMPI.W      #11,D2          *check if it falls into 11 bin
            BEQ       BIN_11
            CMPI.W      #12,D2          *check if it falls into 12 bin
            BEQ       BIN_12
            CMPI.W      #13,D2          *check if it falls into 12 bin
            BEQ       BIN_13
            CMPI.W      #14,D2          *check if it falls into 14 bin
            BEQ       BIN_14
            CMPI.W      #15,D2          *check if it falls into 15 bin
            BEQ       BIN_15
    
BIN_0       MOVE.W      (A0),D2         *reload opcode
            LSR.W       #8,D2           *shift bits to the right 8
            AND.W       #$0F            *Isolate the last 4 bits
            CMPI.W      #12,D2          *Check if the bit is C
            BEQ.S       CMPI            *if CMPI go to the SUB
            CMPI.W      #0,D2           *Check if the bit is a 0
            BEQ.S       ORI             *if ORI go to the SUB
            CMPI.W      #8,D2           *Check if the bit is an 8
            BEQ.S       BCLR            *if BCLR immediate go to SUB
            AND.W       #$01,D2         *isolate the last bit
            CMPI.W      #1,D2           *Check if the bit is a 1
            BEQ.S       BCLR            *if BCLR register go to SUB
            *BRA         DATA           
    SIMHALT
BIN_MOVE    MOVE.W      (A0),D2         *reload opcode
            LSR.W       #6,D2           *shift bits to the right 6
            AND.W       #$07,D2         *isolate the last 3 bits
            CMPI.W      #1,D2           *check if the bits are 001
            BEQ.S       MOVEA           *if MOVEA go to SUB
            *CMPI.W      #7,D2           *check if the bits are 111
            *BEQ.S       DATA            *if 111 must be DATA
            BRA         MOVE            *otherwise must be MOVE
    SIMHALT
BIN_4       MOVE.W      (A0),D2         *reload opcode
            CMPI.W      #$4E71,D2       *check for no-op value
            BEQ.S       NOP             *if NOP go to SUB
    SIMHALT
BIN_5
    SIMHALT
BIN_6
    SIMHALT
BIN_7
    SIMHALT  
BIN_8
    SIMHALT
BIN_9
    SIMHALT
BIN_10
    SIMHALT
BIN_11      MOVE.W      (A0),D2         *reload opcode into D2
            LSR.W       #4,D2           *shift bits to the right 4
            LSR.W       #4,D2           *Shift bits to the right 4
            AND.W       #$01,D2         *isolate the last bit
            CMPI.W      #1,D2           *check if the bit is a 1
            BEQ.S       EOR             *if EOR go to the SUB
            CMPI.W      #0,D2           *check if the bit is a 0
            BEQ.S       CMP             *if CMP go to the SUB
            *BRA        DATA             *if neither EOR or CMP must be DATA
    SIMHALT
BIN_12
    SIMHALT
BIN_13      MOVE.W      (A0),D2         *reload opcode into D2
            LSR.W       #6,D2           *shift bits to the right 6
            AND.W       #$07,D2         *isolate the last 3 bits
            CMPI.W      #$3,D2          *check if the bits are 011
            BEQ.S       ADDA            *if ADDA go to SUB
            CMPI.W      #$7,D2          *check if the bits are 111
            BEQ.S       ADDA            *if ADDA go to SUB
            BRA         ADD             *if bits are not ADDA must be ADD and go to SUB
            
    SIMHALT
BIN_14
    SIMHALT
BIN_15
    SIMHALT   
    
*----------------------------------------OpCode Sub routnines
NOP
            LEA         S_NOP,A1
            MOVE.B      #14,D0
            TRAP        #15
            
EOR
            LEA         S_EOR,A1
            MOVE.B      #14,D0
            TRAP        #15

CMP
            LEA         S_CMP,A1
            MOVE.B      #14,D0
            TRAP        #15

ADD
            LEA         S_ADD,A1
            MOVE.B      #14,D0
            TRAP        #15

ADDA
            LEA         S_ADDA,A1
            MOVE.B      #14,D0
            TRAP        #15
            
ORI
            LEA         S_ORI,A1
            MOVE.B      #14,D0
            TRAP        #15
            
CMPI
            LEA         S_CMPI,A1
            MOVE.B      #14,D0
            TRAP        #15
            
BCLR
            LEA         S_BCLR,A1
            MOVE.B      #14,D0
            TRAP        #15
            
MOVE
            LEA         S_MOVE,A1
            MOVE.B      #14,D0
            TRAP        #15
MOVEA
            LEA         S_MOVEA,A1
            MOVE.B      #14,D0
            TRAP        #15
            
            SIMHALT
S_NOP   DC.B    'NOP',0   
S_EOR   DC.B    'EOR',0
S_CMP   DC.B    'CMP',0
S_ADD   DC.B    'ADD',0
S_ADDA  DC.B    'ADDA',0
S_ORI   DC.B    'ORI',0
S_CMPI  DC.B    'CMPI',0
S_BCLR  DC.B    'BCLR',0
S_MOVE  DC.B    'MOVE',0
S_MOVEA DC.B    'MOVEA',0
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*-----------------------------------------------------------
* Title      :Dissambler 
* Written by :Austin Abeyta, Dylan
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
            BEQ.S       BIN_0
            
            MOVE.W      (A0),D2         *reload op code into d2 to bit shift
            LSR.W       #4,D2           *Shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            LSR.W       #4,D2           *shift right 4 bits
            CMPI.W      #1,D2           *check if it falls into 1 bin
            BEQ.S       BIN_1
            CMPI.W      #2,D2           *check if it falls into 2 bin
            BEQ.S       BIN_2
            CMPI.W      #3,D2           *check if it falls into 3 bin
            BEQ.S       BIN_3
            CMPI.W      #4,D2           *check if it falls into 4 bin
            BEQ.S       BIN_4
            CMPI.W      #5,D2           *check if it falls into 5 bin
            BEQ.S       BIN_5
            CMPI.W      #6,D2           *check if it falls into 6 bin
            BEQ.S       BIN_6
            CMPI.W      #7,D2           *check if it falls into 7 bin
            BEQ.S       BIN_7
            CMPI.W      #8,D2           *check if it falls into 8 bin
            BEQ.S       BIN_8
            CMPI.W      #9,D2           *check if it falls into 9 bin
            BEQ.S       BIN_9
            CMPI.W      #10,D2          *check if it falls into 10 bin
            BEQ.S       BIN_10
            CMPI.W      #11,D2          *check if it falls into 11 bin
            BEQ.S       BIN_11
            CMPI.W      #12,D2          *check if it falls into 12 bin
            BEQ.S       BIN_12
            CMPI.W      #13,D2          *check if it falls into 12 bin
            BEQ.S       BIN_13
            CMPI.W      #14,D2          *check if it falls into 14 bin
            BEQ.S       BIN_14
            CMPI.W      #15,D2          *check if it falls into 15 bin
            BEQ.S       BIN_15
    
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
BIN_11
    SIMHALT
BIN_12
    SIMHALT
BIN_13
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
            
            SIMHALT
S_NOP   DC.B    'NOP',0   
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

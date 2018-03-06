*-----------------------------------------------------------
* Title      :Op-Code decoder
* Written by :Austin Abeyta
* Date       :3/4/2018
* Description:Using different opcode type, deconstructs the op code and prints the register or address bits
*-----------------------------------------------------------
    ORG    $1000
    

START:                  ; first instruction of program
        JSR     PREPARE_OP
        MOVEA.W     #TESTFILE1,A5
        MOVE.W  #10,D7
*------------Test------------------------------------
TESTLOOP
        CMP.W   #0,D7
        BEQ     DONE
        JSR     PREPARE_OP
        MOVE.W  (A5),D4
        JSR     deCodeOp1
        JSR     printTest
        ADDA.W  #2,A5
        SUB.W   #1,D7
        BRA     TESTLOOP
DONE
    SIMHALT
        
PREPARE_OP  MOVE.W      #OP_ADDR,A4         ;Define a location in memory to write an OPCODE string to
            RTS
            
*-Print OPCODE----------------------------------------------
PRINT_OP    MOVE.W      #OP_ADDR,A1         ;Move the OPCODE's beginning addr to A1
            MOVE.W      (A1),D4
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            MOVE.W      #M_NEWLINE,A1       ;Print a new line after this OPCODE line is finished
            MOVE.B      #14,D0              ;Trap Task 14 displays null terminated string
            TRAP        #15
            
            RTS

        
printTest
        MOVE.B  #0,(A4)+
        JSR     PRINT_OP
        RTS
DeCodeOp1
    MOVE.W      (A5),D2
    LSR.W       #3,D2           *shift left to grab source mode
    AND.W       #$0007,D2       *Mask out other bits
    JSR         FINDSOURCEMODE
    MOVE.B      #',',(A4)+
    MOVE.W      (A5),D2
    LSR.W       #6,D2
    AND.W       #$0007,D2
    JSR         FINDDESTMODE
    RTS
    *--------------determine which mode and send to appropiate sub routine----------------
    *pre load = source mode bits saved into d2 register
FINDSOURCEMODE
    CMP.W       #0,D2
    BEQ         SregMode        *register mode ---Dn
    CMP.W       #1,D2
    BEQ         SaddMode        *address mode ---An
    CMP.W       #2,D2
    BEQ         SaddINmode      *addres indirect mode ---(An)
    CMP.W       #3,D2
    BEQ         SaddINpreMode   *addess indirect pre dec ----(An)
    CMP.W       #4,D2
    BEQ         SaddINpostMode  *address indirect post inc --- (An)+
    CMP.W       #5,D2
    BEQ         S16An           *source number of word size --- (d16,An)
    CMP.W       #6,D2
    BEQ         S8AnXn          *source number byte size --- (d8,An,Xn)

FINDDESTMODE
    CMP.W       #0,D2
    BEQ         DregMode        *register mode ---Dn
    CMP.W       #1,D2
    BEQ         DaddMode           *address mode ---An
    CMP.W       #2,D2
    BEQ         DaddINmode      *addres indirect mode ---(An)
    CMP.W       #3,D2
    BEQ         DaddINpreMode   *addess indirect pre dec ----(An)
    CMP.W       #4,D2
    BEQ         DaddINpostMode  *address indirect post inc --- (An)+
    CMP.W       #5,D2
    BEQ         D16An           *source number of word size --- (d16,An)
    CMP.W       #6,D2
    BEQ         D8AnXn          *source number byte size --- (d8,An,Xn)
  
*---------------Source Helper Functions-------------------------------
SregMode
    MOVE.B      #'D',(A4)+
    JSR         OpType1GrabSreg
    JSR         PrintD5Number   
    RTS     
SaddMode
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabSreg
    JSR         PrintD5Number
    RTS
    
    
SaddInMode
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabSreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    RTS
SaddINpreMode
    MOVE.B      #'-',(A4)+
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabSreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    RTS
SaddINpostMode
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabSreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    MOVE.B      #'+',(A4)+
    RTS
S16An
S8AnXn

*--------------Destination helper functions------------------
DregMode
    MOVE.B      #'D',(A4)+
    JSR         OpType1GrabDreg
    JSR         PrintD5Number   
    RTS     
DaddMode
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabDreg
    JSR         PrintD5Number
    RTS
    
    
DaddInMode
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabDreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    RTS
DaddINpreMode
    MOVE.B      #'-',(A4)+
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabDreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    RTS
DaddINpostMode
    MOVE.B      #'(',(A4)+
    MOVE.B      #'A',(A4)+
    JSR         OpType1GrabDreg
    JSR         PrintD5Number
    MOVE.B      #')',(A4)+
    MOVE.B      #'+',(A4)+
    RTS
D16An
D8AnXn
    *-----------helper subroutines--------------
    
OpType1GrabSreg
    MOVE.W      (A5),D2         *recopy op code
    AND.W       #$0007,D2       *mask other bits
    MOVE.W      D2,D5           *copy D2 to D5
    RTS
OpType1GrabDreg
    MOVE.W      (A5),D2
    LSR.W       #6,D2
    LSR.W       #3,D2
    AND.W       #$0007,D2
    MOVE.W      D2,D5
    RTS
PrintD5Number   
    CMP.B       #0,D5
    BEQ         PRINT0
    CMP.B       #1,D5
    BEQ         PRINT1
    CMP.B       #2,D5
    BEQ         PRINT2
    CMP.B       #3,D5
    BEQ         PRINT3
    CMP.B       #4,D5
    BEQ         PRINT4
    CMP.B       #5,D5
    BEQ         PRINT5
    CMP.B       #6,D5
    BEQ         PRINT6
    CMP.B       #7,D5
    BEQ         PRINT7
    CMP.B       #8,D5
    BEQ         PRINT8
    
PRINT0
    MOVE.B      #'0',(A4)+
    RTS
PRINT1
    MOVE.B      #'1',(A4)+
    RTS
PRINT2
    MOVE.B      #'2',(A4)+
    RTS
PRINT3
    MOVE.B      #'3',(A4)+
    RTS
PRINT4
    MOVE.B      #'4',(A4)+
    RTS
PRINT5
    MOVE.B      #'5',(A4)+
    RTS
PRINT6
    MOVE.B      #'6',(A4)+
    RTS
PRINT7
    MOVE.B      #'7',(A4)+
    RTS     
PRINT8
    MOVE.B      #'8',(A4)+
    RTS

ERROR
    SIMHALT   
      
    SIMHALT             ; halt simulator


S_0 DC.B        '0'
S_1 DC.B        '1'
S_2 DC.B        '2'
S_3 DC.B        '3'
S_4 DC.B        '4'
S_5 DC.B        '5'
S_6 DC.B        '6'
S_7 DC.B        '7'
S_8 DC.B        '8'
S_9 DC.B        '9'
S_A DC.B        'A'
S_B DC.B        'B'
S_C DC.B        'C'
S_D DC.B        'D'
S_E DC.B        'E'
S_F DC.B        'F'
OP_ADDR     DS.B        20
M_NEWLINE   DC.B        '',CR,LF,0
CR          EQU         $0D
LF          EQU         $0A


TESTFILE1   MOVEA.W     A4,A2
            MOVE.W      (A2),D2
            MOVE.W      -(A2),D2
            MOVE.W      (A2)+,D2
            MOVE.W      D1,D1
            MOVE.W      D2,D2
            MOVE.W      D3,D3
            MOVE.W      D4,D4
            MOVE.W      D5,D5
            MOVE.W      D6,D6
            MOVE.W      D7,D7
            
    
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

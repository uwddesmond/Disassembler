*-----------------------------------------------------------
* Title      :  Team Visual Basic's Disassembler
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               OP Decoder File
*               Using different opcode type, deconstructs the op code 
*               and prints the register or addr
*-----------------------------------------------------------

*-----------------------------------------------------------
*-Starting Point: Branch into one of many OPCODE Types 
*-Size bits are not handled here, that is handled in the jump table
*-
*-Bit Format:
*-15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
*-Most Significant    Least Significant   
*-----------------------------------------------------------

*-OPCODE Decode Type A--------------------------------------
*-OPCODEs: MOVE,
*-xxxx Dest Reg(3) Dest Mode(3) Src Mode(3) Src Reg(3)  

DECODE_A    MOVE.W      (A5),D2             *Copy OPCODE into D2
            LSR.W       #3,D2               *Shift right 3 - isolate Src Mode
            AND.W       #$0007,D2           *Mask out other bits
            JSR         GET_SRCMODE         *Append SRC string to (A4)          
            MOVE.B      #',',(A4)+
            
            MOVE.W      (A5),D2             *Recopy OPCODE into D2  
            LSR.W       #6,D2               *Shift right 6 - isolate Dest Mode
            AND.W       #$0007,D2           *Mask out other bits
            JSR         GET_DSTMODE         *Append DST string to (A4)
            
            RTS                             *Return back to jump table

*-OPCODE Decode Type B--------------------------------------
*-OPCODEs: 
*-xxxx Register(3) OP Mode(3) EA Mode(3) EA Reg(3)  
               
DECODE_B


*-OPCODE Decode Type C--------------------------------------
*-OPCODEs: 
*-xxxx Count/Reg(3) dr(1) Size(2) i/r(1) 01 Register(3)       
  
DECODE_C


*-OPCODE Decode Type D--------------------------------------
*-OPCODEs: 
*-xxxx Register(3) x Size(2) EA Mode(3) EA Reg(3)       
   
DECODE_D


*-OPCODE Decode Type E--------------------------------------
*-OPCODEs: 
*-xxxx Condition(4) 8 Bit Displacement       
  
DECODE_E


*-OPCODE Decode Type F--------------------------------------
*-OPCODEs: 
*-xxxx Data(3) 1 Size(2) EA Mode(3) EA Reg(3)       
  
DECODE_F


   

*-SRC_MODE--------------------------------------------------
*-Determines SRC Mode from bits 5,4,3, and branch to appropriate subroutine
*-Assumption is that the SRC Mode bits are pre-isolated in D2

GET_SRCMODE CMP.W       #0,D2
            BEQ         SregMode        *register mode: Dn
            CMP.W       #1,D2
            BEQ         SaddMode        *address mode ---An
            CMP.W       #2,D2
            BEQ         SaddINmode      *addres indirect mode ---(An)
            CMP.W       #3,D2
            BEQ         SaddINpre       *addess indirect pre dec ----(An)
            CMP.W       #4,D2
            BEQ         SaddINpost      *address indirect post inc --- (An)+
            CMP.W       #5,D2
            BEQ         S16An           *source number of word size --- (d16,An)
            CMP.W       #6,D2
            BEQ         S8AnXn          *source number byte size --- (d8,An,Xn)
    
*-DST_MODE--------------------------------------------------
*-Determines DST Mode from bits 8,7,6, and branch to appropriate subroutine
*-Assumption is that the DST Mode bits are pre-isolated in D2

GET_DSTMODE CMP.W       #0,D2
            BEQ         DregMode        *register mode ---Dn
            CMP.W       #1,D2
            BEQ         DaddMode        *address mode ---An
            CMP.W       #2,D2
            BEQ         DaddINmode      *addres indirect mode ---(An)
            CMP.W       #3,D2
            BEQ         DaddINpre       *addess indirect pre dec ----(An)
            CMP.W       #4,D2
            BEQ         DaddINpost      *address indirect post inc --- (An)+
            CMP.W       #5,D2
            BEQ         D16An           *source number of word size --- (d16,An)
            CMP.W       #6,D2
            BEQ         D8AnXn          *source number byte size --- (d8,An,Xn)
    
 
*----------------------------------------------------------- 
*-Source Helper Functions
*-Adds Source Register numbers to (A4) string
*-----------------------------------------------------------
SregMode    MOVE.B      #'D',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Number   
            RTS  
        
SaddMode    MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Number
            RTS
    
    
    
SaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
S16An
S8AnXn


*----------------------------------------------------------- 
*-Destination Helper Functions
*-Adds Destination Register numbers to (A4) string
*-----------------------------------------------------------
DregMode    MOVE.B      #'D',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Number   
            RTS
         
DaddMode    MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Number
            RTS
    
    
    
DaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Number
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
D16An
D8AnXn


*----------------------------------------------------------- 
*-Assorted(?) Helper Functions
*-add Description here
*-----------------------------------------------------------
    
T1_GrabSreg MOVE.W      (A5),D2         *recopy op code
            AND.W       #$0007,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5
            RTS
    
T1_GrabDreg MOVE.W      (A5),D2
            LSR.W       #6,D2
            LSR.W       #3,D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            RTS
    
PrintD5Num  CMP.B       #0,D5
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
    
    
PRINT0      MOVE.B      #'0',(A4)+
            RTS
    
PRINT1      MOVE.B      #'1',(A4)+
            RTS
    
PRINT2      MOVE.B      #'2',(A4)+
            RTS
    
PRINT3      MOVE.B      #'3',(A4)+
            RTS
    
PRINT4      MOVE.B      #'4',(A4)+
            RTS
    
PRINT5      MOVE.B      #'5',(A4)+
            RTS

PRINT6      MOVE.B      #'6',(A4)+
            RTS
    
PRINT7      MOVE.B      #'7',(A4)+
            RTS  
       
PRINT8      MOVE.B      #'8',(A4)+
            RTS
    



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

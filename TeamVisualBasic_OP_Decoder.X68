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
*-OPCODEs: MOVE,MOVEA,
*-xxxx Dest Reg(3) Dest Mode(3) Src Mode(3) Src Reg(3)  

DECODE_A    MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *Copy OPCODE into D2
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
*-OPCODEs: LSL/LSR,ASL/ASR,ROL/ROR
*-xxxx Register(3) OP Mode(3) EA Mode(3) EA Reg(3)  
               
DECODE_B    MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2
            LSR.W       #6,D2
            AND.W       $0003,D2
            CMP.W       #3,D2
            BEQ         B_ADDMODE
            MOVE.W      (A5),D2             
            LSR.W       #5,D2
            AND.W       #$0003,D2
            CMP.W       #1,D2
            BEQ         B_SCOUNT
            CMP.W       #2,D2
            BEQ         B_DATAREG
            MOVE.B      #'D',(A4)+
            MOVE.W      (A5),D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            JSR         PrintD5Num
            RTS

*-------------------------------------------------------
*Shift on address is occuring           
B_ADDMODE
           MOVE.W       (A5),D2
           LSR.W        #3,D2
           AND.W        #$0007,D2
           JSR          GET_DSTMODE
           MOVE.W       (A5),D2
           AND.W        #$0007,D2
           MOVE.W       D2,D5
           JSR          PrintD5Num
           RTS
            
            
*-----------------------------------------------------------
*-OPTYPE_B HELPER FUNCTIONS
*Helps determine the size of shifts or registers
*-----------------------------------------------------------

*-----------------------------------------------------------
*Value stored in cont/reg is a number of bits to shift
*Display as #number
B_SCOUNT    MOVE.W      (A5),D2
            LSR.W       #6,D2
            LSR.W       #3,D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            MOVE.B      #'#',(A4)+
            JSR         PrintD5Num
            RTS
   
*------------------------------------------------------------
*Display proper register number
B_DATAREG   MOVE.B      #'D',(A4)+
            MOVE.W      (A5),D2
            LSR.W       #6,D2
            LSR.W       #3,D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            JSR         PrintD5Num
            RTS
       


*-OPCODE Decode Type C--------------------------------------
*-OPCODEs:ADDI,SUBI 
*-xxxxxxxx Size2, Ea mode(3) Ea Reg(3)
*STILL NEED TO PRINT DATA THAT FOLLOWS FIRST       
  
DECODE_C    MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2
            *ENTER PRINT DATA CODE HERE
            JSR         C_SRC
            


*-----------------------------------------------------------
*-OPTYPE_c HELPER FUNCTIONS
*Helps print second argument
*-----------------------------------------------------------

C_SRC       MOVE.W      (A5),D2
            LSR.W       #3,D2
            AND.W       #$0007,D2
            JSR         GET_DSTMODE
            MOVE.W      (A5),D2
            AND.W       #$0007,D2
            JSR         GET_SRCMODE
            RTS


*-OPCODE Decode Type D--------------------------------------
*-OPCODEs: 
*-xxxx Register(3) x Size(2) EA Mode(3) EA Reg(3)       
   
DECODE_D    MOVE.W      #2,D6               *Initilize opcode length to 2   
            MOVE.B      #'#',D6
            MOVE.B      #'$',D6     
            MOVE.W      #2,D2               *move counter to 2 since only 2 HEX values used
            LSL.W       #8,D2               *set up data for printers
            JSR         GD_LOOP             *print hex the 2 bits
            RTS

*-OPCODE Decode Type E--------------------------------------
*-OPCODEs: 
*-xxxx Condition(4) 8 Bit Displacement       
  
DECODE_E    MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2
            LSL.W       #3,D2               *GRAB SOURCE MODE BITS
            AND.W       #$0007,D2           *Mask out other bits
            JSR         GET_SRCMODE         *Append SRC string to (A4)          
            MOVE.B      #',',(A4)+          *Addd comma for out put
            MOVE.W      (A5),D2
            LSL.W       #6,D2               *logical shift left to get data bits to d2
            LSL.W       #3,D2
            AND.W       $0007,D2            *mask out other bits
            MOVE.B      #'D',(A4)+          *Push D into register
            MOVE.W      D2,D5
            JSR         PrintD5Num          *print register number
                  


*-OPCODE Decode Type F--------------------------------------
*-OPCODEs: 
*-xxxx Reg(3) OPMode(3) EAMode(3) EAReg(3)       
  
DECODE_F    MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *Copy opcode into d2
            LSL.W       #6,D2               *Shift to grab op mode
            AND.W       #$0007,D2           *Mask other bits
            JSR         F_OPMODE
            MOVE.W      (A5),D2             *Recopy OPCODE into D2  
            LSR.W       #6,D2               *Shift right 6 - isolate Dest Mode
            AND.W       #$0007,D2           *Mask out other bits
            JSR         GET_DSTMODE         *Append DST string to (A4)
            
*-----------------------------------------------------------
*-OPTYPE_F HELPER FUNCTIONS
*Helps determine the OPTYPE
*-----------------------------------------------------------
F_OPMODE

*-OPS WITHOUT TYPE------------------------------------------
*-OPCODES: MOVEQ

D_MOVEQ     MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D0             *grab op code from a5
            MOVE.B      #'#',(A4)+          *preload source string for literal
            MOVE.B      #'$',(A4)+          *preload source string for hex
            MOVE.W      #2,D2               *move 8 to counter since this si long data 8 hex values are required
            LSL.W       #8,D2               *shift over 8 so bits in high order for print
            JSR         GD_LOOP
            JSR         B_DATAREG           *grabs and prints data reg 
            RTS

D_ADDQ      MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D0             *grab op code from a5
            MOVE.B      #'#',(A4)+          *preload source string for literal
            MOVE.B      #'$',(A4)+          *preload source string for hex
            MOVE.W      #1,D2               *move counter to 1 since only 1 bit is used
            LSL.W       #2,D2               *set up data for printer
            ADD.W       #$C000,D2           *mask out first bits
            JSR         GD_LOOP             *print hex the 2 bits
            MOVE.W      (A5),D2             *reload op code from a5
            LSL.W       #3,D2               *shift so source mode is in LSBs  
            AND.W       #$0007,D2           *mask out other bits
            JSR         GET_SRCMODE         *print source mode
            RTS
            
D_JSR       MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload op code from a5
            LSL.W       #3,D2               *shift so source mode is in LSBs  
            AND.W       #$0007,D2           *mask out other bits
            JSR         GET_SRCMODE         *print source mode
            RTS


            
            
          
            
             

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
            CMP.W       #7,D2
            BEQ         S_DATA_MODE     *immediate data
    
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
            CMP.W       #7,D2           
            BEQ         D_DATA_MODE     *Source is immediate data following the opcode
    
 
*----------------------------------------------------------- 
*-Source Helper Functions
*-Adds Source Register numbers to (A4) string
*-----------------------------------------------------------
SregMode    MOVE.B      #'D',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Num   
            RTS  
        
SaddMode    MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Num
            RTS
    
    
    
SaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabSreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
S16An
S8AnXn
S_DATA_MODE JSR         T1_GrabDreg
            CMPI.W      #1,D5
            BEQ         LONG_DATA
            CMPI.W      #2,D5
            BEQ         LONG_DATA
            CMP.W       #0,D5  
            BEQ         WORD_DATA

*----------------------------------------------------------- 
*-Destination Helper Functions
*-Adds Destination Register numbers to (A4) string
*-----------------------------------------------------------
DregMode    MOVE.B      #'D',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Num   
            RTS
         
DaddMode    MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Num
            RTS
    
    
    
DaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         T1_GrabDreg
            JSR         PrintD5Num
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
D16An
            
D8AnXn

D_DATA_MODE JSR         T1_GrabDreg
            CMPI.W      #1,D5
            BEQ         LONG_DATA
            CMPI.W      #0,D5
            BEQ         WORD_DATA
            CMPI.W      #7,D5
            *BEQ         DATA_SIZE
            
*D_SIZE      


*----------------------------------------------------------- 
*-Assorted(?) Helper Functions
*-add Description here
*-----------------------------------------------------------
LONG_DATA   MOVE.B      #'$',(A4)+       *prepare the string for a long hex value
            MOVE.L      A5,A3    
            ADD.L       D6,A3           *Add opcode data length
            MOVE.L      (A3),D0
            MOVE.W      #8,D2           *move 8 to counter since this si long data 8 hex values are required
            JSR         GD_LOOP
            ADD.W       #4,D6           *since it is long data increment the address by 4 bits *d6 is opcode length counter
            RTS

WORD_DATA   MOVE.B      #'$',(A4)+       *prepare the string for a long hex value
            MOVE.L      A5,A3    
            ADD.L       D6,A3           *Add opcode data length
            MOVE.L      (A3),D0         *Add correct data into d0 register for printing
            MOVE.W      #4,D2           *move 8 to counter since this si long data 8 hex values are required
            LSL.L       #8,D0           *shift data over 8 bits for rotate in print to hex function
            JSR         GD_LOOP
            ADD.W       #2,D6           *since it is long data increment the address by 4 bits *d6 is opcode length counter
            RTS

T1_GrabSreg MOVE.W      (A5),D2         *recopy op code
            AND.W       #$0007,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5
            RTS
    
T1_GrabDreg MOVE.W      (A5),D2         *type one grab register bits
            LSR.W       #6,D2           *shift bits over
            LSR.W       #3,D2           
            AND.W       #$0007,D2       *mask so only relevent bits left
            MOVE.W      D2,D5           *move to d5 for printing
            RTS
    
PrintD5Num  CMP.B       #0,D5           *print the numeber in d5
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
    
GD_LOOP     JSR         HEX_2_ASCII
            SUBI        #1,D2
            CMP.B       #0,D2
            BGT         GD_LOOP
            RTS



    
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

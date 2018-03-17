*-----------------------------------------------------------
* Title      :  Team Visual Basic's Disassembler
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               OP Decoder File
*               Using different opcode type, deconstructs the op code 
*               prints the register or addr
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

DECODE_A    MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *Copy OPCODE into D2
            JSR         GRABx5_3            *Grab source mode
            MOVE.W      D5,D2               *put source mode in D2
            JSR         GET_SRCMODE         *Append SRC string to (A4)          
            MOVE.B      #',',(A4)+
            
            MOVE.W      (A5),D2             *Recopy OPCODE into D2  
            JSR         GRABx8_6            *grab dest mode bits
            MOVE.W      D5,D2               *Move dest mode into D2
            JSR         GET_DSTMODE         *Append DST string to (A4)
            
            RTS                             *Return back to jump table

*-OPCODE Decode Type B--------------------------------------
*-OPCODEs: LSL/LSR,ASL/ASR,ROL/ROR
*-xxxx Register(3) OP Mode(3) EA Mode(3) EA Reg(3)  
               
DECODE_B    MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload op code
            
            JSR         GRABx7_6            *grab SIZE bits and put them in D2
            CMP.W       #3,D2
            BEQ         B_ADDMODE           *this shift is an address variant
            
            MOVE.W      (A5),D5             *otherwise this shift is a register variant  
            LSR.W       #5,D5               *logical shift left to get i/r
            AND.W       #$0001,D5           
            CMP.W       #0,D5               *if i/r bit is 0, bits are COUNT
            BEQ         B_SCOUNT            
            CMP.W       #1,D5               *if i/r bit is 1, bits are REGISTER
            BEQ         B_DATAREG           
            RTS

*-OPCODE Decode Type C--------------------------------------
*-OPCODEs: ADDI, SUBI, NEG, ORI, CMPI, 
*-xxxxxxxx Size2, Ea mode(3) Ea Reg(3)
*STILL NEED TO PRINT DATA THAT FOLLOWS FIRST       
  
DECODE_C    MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            
            JSR         PRINT_DATA          *Append immediate data to string
            JSR         B_SRC_DMODE         *Append ,D(reg num) to string

            RTS
            
*-OPCODE Decode Type D--------------------------------------
*-OPCODEs: MOVEQ, EOR, CMP, BCLR (immediate and register)
*-xxxx Register(3) x Size(2) EA Mode(3) EA Reg(3)       
   
DECODE_D    MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2   
            MOVE.B      #'#',D6
            MOVE.B      #'$',D6     
            MOVE.W      #2,D2               *move counter to 2 since only 2 HEX values used
            LSL.W       #8,D2               *set up data for printers
            JSR         GD_LOOP             *print hex the 2 bits
            RTS

*-OPCODE Decode Type E--------------------------------------
*-OPCODEs: BCC (BCC, BLT, BGE, BCS, BVC), BRA
*-xxxx Condition(4) 8 Bit Displacement       
  
DECODE_E    MOVE.B      #9,(A4)+          *tab after op code
            MOVE.B      #9,(A4)+          *2tabs since bra is short
DECODE_E    MOVE.B      #9,(A4)+            *tab after op code
            MOVE.B      #9,(A4)+            *2tabs since bra is short
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2
            
            *--What source mode bits is it grabbing and why? Condition is only for figuring out
            *what type of branch it is (BCS, BLT, BGE, etc.). Only thing that matters in DECODE_E
            *is the 8 bit displacement because that is where the branch is suppose to be connected to
            
            JSR         D_BRA               *Go to decode BRA sub routine
            RTS
            
                  

D_BRA       MOVE.W      (A5),D2             *Load op and store in D2
            AND.W       #$00FF,D2           *Get displacement bits by masking
            CMP.W       #$0000,D2
            BGT         BRA_BYTE_
            
            MOVE.W      (A5),D2             *Load op and store in D2
            AND.W       #$00FF,D2           *Get displacement bits by masking
            CMP.W       #$0000,D2
            BEQ         BRA_WORD         
            
            MOVE.W      (A5),D2             *Load op and store in D2
            AND.W       #$00FF,D2           *Get displacement bits by masking
            CMP.W       #$00FF,D2
            BEQ         BRA_LONG            *branch long displacement
            RTS
            

            
BRA_WORD    JSR         WORD_DATA
            RTS
            
BRA_LONG    JSR         LONG_DATA
            RTS
            
BRA_BYTE_   CMP.W       #$FF,D2
            BLT         BRA_BYTE
            RTS

BRA_BYTE    MOVE.W      (A5),D0             *LOAD OP CODE
            AND.W       #$00FF,D0           *And to get displacement
            ROR.L       #8,D0
            MOVE.B      #',',(A4)+
            *MOVE.L      A5,D5              *move the address into D5
            *ADD.L       D0,D5              *add the displacement to the address
            *MOVE.L      D5,D0              *move the new addres into the D0
            MOVE.W      #2,D2              *set the loop counter to 32 to print full address
            JSR         GD_LOOP
            RTS     
            

*-----------displacement sub routines---------------------       
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
F_OPMODE    CMP.W       #7,D2               *Check if opcode type falls into the opmode 11 ,divs,mul
            BEQ         F_111_MODE          *Branch to handle 111 Modes
            CMP.W       #7,D2
            BLT         F_OPMODE2
            BGT         F_OPMODE2
            RTS
            
F_OPMODE2   MOVE.W      (A5),D2             *Reload opcode into D2
            LSR.W       #6,D2
<<<<<<< HEAD
            LSR.W       #2,D2
            AND.W       #$0001,D2            *Shift to get opmode bits into the final 3 LSB
=======
            LSR.W       #5,D2
            AND.W       $0001,D2            *Shift to get opmode bits into the final 3 LSB
>>>>>>> 45f59fdcb58efa92aae3a67d4f13c4dddd995cab
            CMP.W       #1,D2
            BEQ         F_DN_EA             *Branch to handle when op codes are Dn+<ea> -- Dn
            CMP.W       #0,D2
            BEQ         F_EA_DN             *Branch to handle when op code are Dn + <ea - <Ea>
            RTS
            
F_DN_EA     MOVE.W      (A5),D2             *Reload opcode into D2
            JSR         GRABX8_6            *GRAB BITS 8_5 plce into D5
            AND         #$0003,D5
            CMP.W       #0,D5
            BEQ         BYTE_DATA
            CMP.W       #1,D5
            BEQ         WORD_DATA
            CMP.W       #2,D5
            BEQ         LONG_DATA
<<<<<<< HEAD
            *-------------------PRINT DESTINATION REG----------------------------
=======
            
>>>>>>> 45f59fdcb58efa92aae3a67d4f13c4dddd995cab
            MOVE.B      'D',(A4)+           *Must be a data register for dest
            MOVE.W      (A5),D2             *Re load op code
            JSR         GRABx11_9           *grab register bits and store in d5
            JSR         PrintD5Num
            RTS
                 
F_EA_DN     MOVE.B      'D',(A4)+           *Must be a data register for dest
            MOVE.W      (A5),D2             *Re load op code
            JSR         GRABx11_9           *grab register bits and store in d5
            JSR         PrintD5Num
            RTS
                       

*------------------------------------------------------------
*Handles when op mode bits are 111
F_111_MODE  MOVE.W      (A5),D2
            JSR         GRABx5_3
            MOVE.W      D5,D2
            JSR         GET_SRCMODE
            RTS                                         
           
            
*-----------------------------------------------------------
*-OPTYPE_B HELPER FUNCTIONS
*Helps determine the size of shifts or registers
*-----------------------------------------------------------
*-------------------------------------------------------
*Shift on address is occuring    
*print address by using EA Mode and EA Reg bits at end of op
*DECODE TYPE SPECIFIC FUNCTION       
B_ADDMODE  MOVE.W       (A5),D2
           LSR.W        #3,D2
           AND.W        #$0007,D2
           JSR          GET_DSTMODE
           MOVE.W       (A5),D2
           AND.W        #$0007,D2
           MOVE.W       D2,D5
           JSR          PrintD5Num
           RTS          GET_SRC_MODE
           
           
*-----------------------------------------------------------
*Value stored in cont/reg is a number of bits to shift
*Display as #number
*DECODE TYPE SPECIFIC FUNCTION
B_SCOUNT    MOVE.W      (A5),D2
            LSR.L       #6,D2
            LSR.L       #3,D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            MOVE.B      #'#',(A4)+
            JSR         PrintD5Num
            JSR         B_SRC_DMODE
            RTS
   
*------------------------------------------------------------
*Display proper register number found at the 12 - 9 bits
*DECODE TYPE SPECIFIC FUNCTION
B_DATAREG   MOVE.B      #'D',(A4)+
            MOVE.W      (A5),D2
            LSR.W       #6,D2
            LSR.W       #3,D2
            AND.W       #$0007,D2
            MOVE.W      D2,D5
            JSR         PrintD5Num
            JSR         B_SRC_DMODE
            RTS
*---------------------------------------------------------
*display the register number that's in bits 2-1-0
*DECODE TYPE SPECIFIC(?) FUNCTION

B_SRC_DMODE MOVE.W      (A5),D2             *reload op
            MOVE.B      #',',(A4)+          *add comma to printer
            MOVE.B      #'D',(A4)+          *D for data register
            AND.W       #0007,D2            *mask out other bits
            MOVE.W      D2,D5               *move register number to d5
            JSR         Printd5Num          *print register numebr
            RTS
            
                                

*-OPS WITHOUT TYPE------------------------------------------
*-OPCODES: MOVEQ

D_MOVEQ     MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D0             *grab op code from a5
            MOVE.B      #'#',(A4)+          *preload source string for literal
            MOVE.B      #'$',(A4)+          *preload source string for hex
            MOVE.W      #2,D2               *move 8 to counter since this si long data 8 hex values are required
            LSL.W       #8,D2               *shift over 8 so bits in high order for print
            JSR         GD_LOOP
            JSR         B_DATAREG           *grabs and prints data reg 
            RTS

D_ADDQ      MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D0             *grab op code from a5
            MOVE.B      #'#',(A4)+          *preload source string for literal
            MOVE.B      #'$',(A4)+          *preload source string for hex
            MOVE.W      #1,D2               *move counter to 1 since only 1 bit is used
            LSL.W       #2,D2               *set up data for printer
            JSR         GRABx11_9           *grab bits at index 11_9
            JSR         PrintD5num          *Print number in D5
            MOVE.B      #',',(A4)+          *Print comma
            MOVE.W      (A5),D2             *reload op code from a5
            LSL.W       #3,D2               *shift so source mode is in LSBs  
            AND.W       #$0007,D2           *mask out other bits
            JSR         GET_SRCMODE         *print source mode
            RTS
            
D_JSR       MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload op code from a5
            LSR.W       #3,D2               *shift so source mode is in LSBs  
            AND.W       #$0007,D2           *mask out other bits
            JSR         GET_SRCMODE         *print source mode
            RTS
*-Neg Implementation----------------------------------------
D_NEG       MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload op code from a5          
            
            LSR.L       #3,D2               *isolate EA mode
            ANDI.L      #$00000007,D2       
            
            CMP.B       #0,D2               *if == 0, Dn
            BEQ         DregMode            
            
            CMP.B       #2,D2               *if == 2, (An)
            BEQ         DaddINMode
            
            CMP.B       #3,D2               *if == 3, (An)+
            BEQ         DaddINpost
            
            CMP.B       #4,D2               *if == 4, -(An)
            BEQ         DaddINpre 

            CMP.B       #7,D2               *if == 7, -(An)
            BEQ         NEG_PRINT
            BRA         RTS_BACK
            
NEG_PRINT   MOVE.W      (A5),D2             *reload op code from a5
            ANDI.L      #$00000007,D2       *isolate register bits
            
            CMP.B       #0,D2               *If == 0, its (xxx).W
            BEQ         WORD_DATA
            
            CMP.B       #1,D2               *If == 1, its (xxx).W
            BEQ         LONG_DATA                                                                                                                               
            RTS
            

D_MOVEM     MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
                                         
            ;JSR         MM_FLAG             *If -(An), set D4 to 1. Otherwise[(An), (An)+}], set D4 to 0            
            
            ;MOVE.W      (A5),D2             *reload op code from a5
            ;ROL.L       #6,D2               *get dr bit on the LSB position
            ;ANDI.L      #$00000001,D2       *isolate dr bit
            
            ;CMP.B       #0,D2               *if bit is 0 
            ;BEQ         MM_R2M              *branch to register to memory
            ;BRA         MM_M2R              *otherwise, branch to memory to register  
            
            *Before this line is the MOVEM Implementation Attempt
            *--------------------------------------------------------------------
            *Immediately after up to MM_LONG is the quick fix for turn-in
            
            MOVE.W      (A5),D2             *reload op code from a5  
            ASR.L       #3,D2               *get dr bit on the LSB position
            ANDI.L      #$00000007,D2       *isolate EA mode bit
            
            CMP.B       #7,D2               *is there (xxx).W (xxx).L extra data?
            BEQ         MM_DATA
            RTS
            
MM_DATA     CMP.B       #6,D7               *If D7 signifies MOVEM.W, Set D6 to 4
            BEQ         MM_WORD
            BRA         MM_LONG
            
MM_WORD     MOVE.L      #6,D6
            RTS
MM_LONG     MOVE.L      #8,D6
            RTS
               
*-Handles printing the EA mode
MM_MODE     MOVE.W      (A5),D2             *reload op code from a5  
            ASR.L       #3,D2               *get dr bit on the LSB position
            ANDI.L      #$00000007,D2       *isolate EA mode bit

            CMP.B       #2,D2               *if mode == 2; (An) 
            BEQ         DaddInMode         
            CMP.B       #3,D2               *if mode == 3; (An)+ 
            BEQ         DaddInpost
            CMP.B       #2,D2               *if mode == 4; -(An) 
            BEQ         DaddINpre
            CMP.B       #2,D2               *if mode == 7; (xxx).W or (xxx).L 
            BEQ         MM_GETADDR             
            
*-Flag code for determining which direction to read the Register Mask
MM_FLAG     MOVE.W      (A5),D2             *reload op code from a5  
            ASR.L       #3,D2               *Isolate EA MODE bits
            ANDI.L      #$00000003,D2 
            CMP.B       #4,D2               *Is predecrement? -(An)
            BEQ         MM_FLAG_SET
            
            MOVE.L      #0,D4               *Otherwise Flag var D4 is 0 ((An), (An)+)
            RTS

          
D_ADDA      MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload opcode in D2
            JSR         GRABx5_3            *grab bits index 5_3
            MOVE.W      D5,D2               *Move bits grabbed into D2
            JSR         GET_SRCMODE         *get destination mode
            
            MOVE.W      (A5),D2             *reload opcode into D5
            MOVE.B      '9',(A4)+           *load tab into string
            MOVE.B      #',',(A4)+          *load comma into string
            MOVE.B      #'A',(A4)+          *print a for address
            JSR         GRABx11_9           *grab bits
            JSR         PrintD5Num          *print d5 number
            RTS
                      
D_LEA       MOVE.B      #9,(A4)+            *tab after op code
            MOVE.B      #9,(A4)+            *2nd tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D2             *reload opcode in D2
            JSR         GRABx5_3            *grab bits index 5_3
            MOVE.W      D5,D2               *Move bits grabbed into D2
            JSR         GET_SRCMODE         *get destination mode
            
            MOVE.W      (A5),D2             *reload opcode into D5
            MOVE.B      '9',(A4)+           *load tab into string
            MOVE.B      #',',(A4)+          *load comma into string
            MOVE.B      #'A',(A4)+          *print a for address
            JSR         GRABx11_9           *grab bits
            JSR         PrintD5Num          *print d5 number
            RTS
            
D_SUBQ      MOVE.B      #9,(A4)+            *tab after op code
            MOVE.W      #2,D6               *Initilize opcode length to 2
            MOVE.W      (A5),D0             *grab op code from a5
            MOVE.B      #'#',(A4)+          *preload source string for literal
            MOVE.B      #'$',(A4)+          *preload source string for hex
            MOVE.W      #1,D2               *move counter to 1 since only 1 bit is used
            LSL.W       #2,D2               *set up data for printer
            JSR         GRABx11_9           *grab bits at index 11_9
            JSR         PrintD5num          *Print number in D5
            MOVE.B      #',',(A4)+          *Print comma
            MOVE.W      (A5),D2             *reload op code from a5
            LSL.W       #3,D2               *shift so source mode is in LSBs  
            AND.W       #$0007,D2           *mask out other bits
            JSR         GET_SRCMODE         *print source mode
            RTS

              


MM_FLAG_SET MOVE.L      #1,D4               *Flag var D4. 1 means -(An) predecrement
            RTS
            
*-Handles getting the immediate data    
MM_GETADDR  ADDA        #4,A5               *Get immediate data @ 2 words after address
            CMP.B       #6,D7               *if size == 6, read in a word
            BEQ         MM_GOTO_W           *Branch to subroutine that'll read in a word of immediate data
            
            JSR         LONG_DATA           *else branch to subroutine that'll read in a long of immediate data
            SUBA        #4,A5               *Return A5 ptr
            RTS
  
MM_GOTO_W   JSR         WORD_DATA
            SUBA        #4,A5               *Return A5 ptr
            RTS
                
*-SRC_MODE--------------------------------------------------
*-Assumption is that the SRC Mode bits are pre-isolated in D2
*DECODE TYPE SPECIFIC FUNCTION
GET_SRCMODE CMP.W       #0,D2
            BEQ         SregMode        *register mode: Dn
            CMP.W       #1,D2
            BEQ         SaddMode        *address mode ---An
            CMP.W       #2,D2
            BEQ         SaddINmode      *addres indirect mode ---(An)
            CMP.W       #3,D2
            BEQ         SaddINpost      *addess indirect pre dec --- (An)+
            CMP.W       #4,D2
            BEQ         SaddINpre       *address indirect post inc --- -(An)
            CMP.W       #5,D2
            BEQ         S16An           *source number of word size --- (d16,An)
            CMP.W       #6,D2
            BEQ         S8AnXn          *source number byte size --- (d8,An,Xn)
            CMP.W       #7,D2
            BEQ         S_DATA_MODE     *immediate data
    
*-DST_MODE--------------------------------------------------
*-Assumption is that the DST Mode bits are pre-isolated in D2
*DECODE TYPE SPECIFIC FUNCTION
GET_DSTMODE CMP.W       #0,D2
            BEQ         DregMode        *register mode ---Dn
            CMP.W       #1,D2
            BEQ         DaddMode        *address mode ---An
            CMP.W       #2,D2
            BEQ         DaddINmode      *addres indirect mode ---(An)
            CMP.W       #3,D2
            BEQ         DaddINpost      *addess indirect post inc --- (An)+
            CMP.W       #4,D2
            BEQ         DaddINpre       *address indirect post inc --- -(An)
            CMP.W       #5,D2
            BEQ         D16An           *source number of word size --- (d16,An)
            CMP.W       #6,D2
            BEQ         D8AnXn          *source number byte size --- (d8,An,Xn)
            CMP.W       #7,D2           
            BEQ         D_DATA_MODE     *Source is immediate data following the opcode
    
*-EA_MODE----------------------------------------------------
*-Assumption is that the EA Mode bits are pre-isolated in D2

GET_EAMODE  

 
*----------------------------------------------------------- 
*-Source Helper Functions
*-Adds Source Register numbers to (A4) string
*-----------------------------------------------------------
SregMode    MOVE.B      #'D',(A4)+
            JSR         GRABx2_0
            JSR         PrintD5Num   
            RTS  
        
SaddMode    MOVE.B      #'A',(A4)+
            JSR         GRABx2_0
            JSR         PrintD5Num
            RTS
    
    
    
SaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx2_0         *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP 
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx2_0         *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP 
            MOVE.B      #')',(A4)+
            RTS
    
SaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx2_0         *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP 
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
S16An       RTS
            *BRA         DATA
S8AnXn      RTS
            *BRA         DATA

S_DATA_MODE JSR         GRABx2_0         *get least sig 3 bits 
            CMPI.W      #1,D5               
            BEQ         LONG_DATA
            
            CMP.W       #0,D5  
            BEQ         D_SIZE
            
            CMP.W       #4,D5               *This branch is invalid in the case of DECODE_C. Probably okay tho
            BEQ         IMMEDIATE_D           

             
*----------------------------------------------------------- 
*-Destination Helper Functions
*-Adds Destination Register numbers to (A4) string
*-----------------------------------------------------------
DregMode    MOVE.B      #'D',(A4)+
            JSR         GRABx11_9
            JSR         PrintD5Num   
            RTS
         
DaddMode    MOVE.B      #'A',(A4)+
            JSR         GRABx11_9
            JSR         PrintD5Num
            RTS
    
    
    
DaddInMode  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx11_9         *put reg num into D5
            JSR         GRABx11_9           *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP           
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpre   MOVE.B      #'-',(A4)+
            MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx11_9         *put reg num into D5
            JSR         GRABx11_9           *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP 
            MOVE.B      #')',(A4)+
            RTS
    
DaddINpost  MOVE.B      #'(',(A4)+
            MOVE.B      #'A',(A4)+
            JSR         GRABx11_9         *put reg num into D5
            JSR         GRABx11_9           *put reg num into D5
            JSR         A7toSP              *if reg num is 7, replace w/ SP 
            MOVE.B      #')',(A4)+
            MOVE.B      #'+',(A4)+
            RTS
    
D16An       BRA         DATA
            
D8AnXn      BRA         DATA

D_DATA_MODE JSR         GRABx11_9
            CMPI.W      #1,D5
            BEQ         LONG_DATA
            CMPI.W      #0,D5
            BEQ         D_SIZE          *Determine if we gotta branch to WORD_DATA or BYTE_DATA off of D7


D_SIZE      CMP.B       #6,D7
            BEQ         WORD_DATA
            CMP.B       #4,D7
            BEQ         BYTE_DATA


*----------------------------------------------------------- 
*-Assorted(?) Helper Functions
*-add Description here
*-----------------------------------------------------------
            
*---------------IMMEDIATE_DATA-------------------------            
*Reached when an opcode has immediate data afterwards
*The length of this immedite data depends on the opcode length
*That value is stored in the d7 register by the jump table 
*DECODE TYPE AGNOSTIC FUNCTION           
IMMEDIATE_D MOVE.B      #'#',(A4)+              *add the # to data string to immediate data
            BRA         PRINT_DATA


*----------------------------------------------------------
*Grab bits found at indes 2 to 0 and stores values into D5            
GRABx2_0    MOVE.W      (A5),D2         *recopy op code
            ANDI.W       #$0007,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5
            RTS 
*----------------------------------------------------------
*Grab bits found at indes 5 to 3 and stores values into D5            
GRABx5_3    MOVE.W      (A5),D2         *recopy op code
            LSR.W       #3,D2           *shift so 5 to 3 bits are the LSB
            AND.W       #$0007,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5
            RTS 
*----------------------------------------------------------
*Grab bits found at indes 8 to 6 and stores values into D5            
GRABx8_6    MOVE.W      (A5),D2         *recopy op code
            LSR.W       #3,D2           *shift so 8 to 6 bits are the LSB
            LSR.W       #3,D2           *shift so 8 to 6 bits are the LSB
            AND.W       #$0007,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5
            RTS
            
*----------------------------------------------------------
*Grab bits found at indes 7 to 6 and stores values into D5            
GRABx7_6    MOVE.W      (A5),D2         *recopy op code
            LSR.W       #3,D2           *shift so 8 to 6 bits are the LSB
            LSR.W       #3,D2           *shift so 8 to 6 bits are the LSB
            AND.W       #$0003,D2       *mask other bits
            MOVE.W      D2,D5           *copy D2 to D5            
            RTS
            
*----------------------------------------------------------------           
*Grab bits found at index 11 throu 9 and stores values into D5   
GRABx11_9   MOVE.W      (A5),D2         *type one grab register bits
            LSR.W       #6,D2           *shift bits over
            LSR.W       #3,D2           
            AND.W       #$0007,D2       *mask so only relevent bits left
            MOVE.W      D2,D5           *move to d5 for printing
            RTS            
            
*-A7 to SP special case-------------------------------------
*DECODE TYPE AGNOSTIC FUNCTION
A7toSP      CMP.B       #7,D5           *If Address register (num stored in D5) is A7
            BEQ         A7toSP_repl     *then branch to subroutine that replaces A7 string with SP   
            BRA         A7toSP_nA7      *else, branch normally and print A0-A6

A7toSP_nA7  JSR         PrintD5Num
            RTS

A7toSP_repl SUBA        #1,A4           *move the A4 string back by a digit
            MOVE.B      #'S',(A4)+      *replace string with SP
            MOVE.B      #'P',(A4)+      
            RTS

*-Size helper------------------------------------------------
*DECODE TYPE AGNOSTIC FUNCTION         
PRINT_DATA  CMP.B       #2,D7           *If there is no additional data, go back
            BEQ         RTS_BACK

            CMP.B       #4,D7
            BEQ         BYTE_DATA      
 
            CMP.B       #6,D7
            BEQ         WORD_DATA    
            
            CMP.B       #10,D7
            BEQ         LONG_DATA
            
            BRA         DATA            *Base case: catastrophic failure        

BYTE_DATA   MOVE.B      #'$',(A4)+       *prepare the string for a long hex value
            MOVE.L      A5,A3    
            
            ADD.L       D6,A3           *Add opcode data length to incement past opcode and data
            MOVE.L      (A3),D0         *Add correct data into d0 register for printing
            
            MOVE.W      #2,D2           *move 2 to counter since this is byte data 2 hex values are required
            LSL.L       #8,D0           *shift data over 4 bits so beginning of byte is in the highest order
            JSR         GD_LOOP
            ADD.W       #2,D6           *since it is byte data increment the address by 4 bits *d6 is opcode length counter
            RTS
            
WORD_DATA   MOVE.B      #'$',(A4)+       *prepare the string for a long hex value
            MOVE.L      A5,A3    
            
            ADD.L       D6,A3           *Add opcode data length to incement past opcode and data
            MOVE.L      (A3),D0         *Add correct data into d0 register for printing
            
            MOVE.W      #4,D2           *move 4 to counter since this it word data 4 hex values are required
            
            JSR         GD_LOOP
            ADD.W       #2,D6           *since it is word data increment the address by 4 bits *d6 is opcode length counter
            RTS            
            
LONG_DATA   MOVE.B      #'$',(A4)+      *prepare the string for a long hex value
            MOVE.L      A5,A3
    
            ADD.L       D6,A3           *Add opcode data length this increments the address past the op code and existing data
            MOVE.L      (A3),D0
            
            MOVE.W      #8,D2           *move 8 to counter since this si long data 8 hex values are required
            JSR         GD_LOOP
            ADD.W       #4,D6           *since it is long data increment the address by 4 bits *d6 is opcode length counter
            RTS     
 
RTS_BACK    RTS                         *GO BACK 
*----------------------------------------------------------   
*DECODE TYPE AGNOSTIC FUNCTION    
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


*Used to print data to a hex value from bits
*----Requires a preload---------------------------------------------------------------
*D0 =  must be loaded with bits to be printed, starts from highest order bit
*D2 = how many bits it will convert to hex starting with the highest order bit in d0
*Therefore bits wanting to be printed should be shifter or rotated to the highest order in d0
*HEX_2_ASCII exists in the Print builder file
*------------------------------------------------------------------------------------------    
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
    



<<<<<<< HEAD











































=======
>>>>>>> 45f59fdcb58efa92aae3a67d4f13c4dddd995cab
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

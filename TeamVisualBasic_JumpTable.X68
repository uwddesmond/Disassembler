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
JT_START    MOVE.L      #2,D7               *All OPCODEs takes up a 2 bytes of space, save this into length counter D7
            CLR.L       D6                  *Clear the D6 address increment counter
            MOVE.W      (A5),D0             *Move OPCODE into D0 to bit shift
            
            LSR.W       #4,D0               *Shift right 4 bits
            LSR.W       #4,D0               *shift right 4 bits
            LSR.W       #4,D0               *shift right 4 bits
            
            CMPI.W      #0,D0               *check if it falls into 0 bin
            BEQ         BIN_0
    
            CMPI.W      #1,D0               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #2,D0               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #3,D0               *check if it is a MOVE
            BEQ         BIN_MOVE
            
            CMPI.W      #4,D0               *check if it falls into 4 bin
            BEQ         BIN_4

            CMPI.W      #5,D0               *check if it falls into 5 bin
            BEQ         BIN_5

            CMPI.W      #6,D0               *check if it falls into 6 bin
            BEQ         BIN_6

            CMPI.W      #7,D0               *check if it falls into 7 bin
            BEQ         BIN_7

            CMPI.W      #8,D0               *check if it falls into 8 bin
            BEQ         BIN_8

            CMPI.W      #9,D0               *check if it falls into 9 bin
            BEQ         BIN_9

            CMPI.W      #10,D0              *check if it falls into 10 bin
            BEQ         BIN_10

            CMPI.W      #11,D0              *check if it falls into 11 bin
            BEQ         BIN_11

            CMPI.W      #12,D0              *check if it falls into 12 bin
            BEQ         BIN_12

            CMPI.W      #13,D0              *check if it falls into 12 bin
            BEQ         BIN_13

            CMPI.W      #14,D0              *check if it falls into 14 bin
            BEQ         BIN_14

            CMPI.W      #15,D0              *check if it falls into 15 bin
            BEQ         BIN_15

*--------------------------------------------------------------
*-Bin 0 Possible OPCODES:
*-CMPI, ORI, BCLR(immediate and register), ADDI, SUBI
*--------------------------------------------------------------    
BIN_0       MOVE.W      (A5),D0             *reload opcode
            LSR.W       #8,D0               *shift bits to the right 8
            AND.W       #$0F,D0             *Isolate the last 4 bits
            
            CMPI.W      #12,D0              *Check if the bit is C
            BEQ         CMPI                *if CMPI go to the subroutine
            
            CMPI.W      #0,D0               *Check if the bit is a 0
            BEQ         ORI                 *if ORI go to the subroutine
            
            CMPI.W      #6,D0               *Check if the bits == 6
            BEQ         ADDI                *if ADDI go to the subroutine
            
            CMPI.W      #4,D0               *Check if the bits == 4
            BEQ         SUBI                *if SUBI go to the subroutine
            
            CMPI.W      #8,D0               *Check if the bit is an 8
            BEQ         BCLR_IM             *if BCLR immediate go to subroutine
            
            AND.W       #$01,D0             *isolate the last bit
            CMPI.W      #1,D0               *Check if the bit is a 1
            BEQ         BCLR_REG            *if BCLR register go to subroutine
            
            BRA         DATA           

*--------------------------------------------------------------
*-BIN_MOVE (Bins 1, 2, and 3) Possible OPCODES: 
*-MOVE, MOVEA
*--------------------------------------------------------------     
BIN_MOVE    MOVE.W      (A5),D0             *reload opcode
            LSR.W       #6,D0               *shift bits to the right 6
            AND.W       #$07,D0             *isolate the last 3 bits
            CMPI.W      #1,D0               *check if the bits are 001
            BEQ         MOVEA               *if MOVEA go to SUB
            
            BRA         MOVE                *otherwise must be MOVE
            
*--------------------------------------------------------------            
*-BIN 4 Possible OPCODES:
*-NOP, RTS, JSR, NEG, LEA, MOVEM
*--------------------------------------------------------------
BIN_4       MOVE.W      (A5),D0             *reload opcode
            CMPI.W      #$4E71,D0           *check for no-op value
            BEQ         NOP                 *if NOP go to SUB
            
            CMPI.W      #$4E75,D0           *Compare with a constant value for RTS      
            BEQ         RTS                 *if RTS go to RTS subroutine
            
            LSR.W       #4,D0               *shift right 4 bits
            LSR.W       #4,D0               *shift right 4 bits
            
            AND.W       #$0F,D0             *bitmask first 4 bits  
            CMPI.W      #$E,D0              *compare final masked bits
            BEQ         JSR                 *if it equals E it is JSR
            
            CMPI.W      #$4,D0              *check for defining bits
            BEQ         NEG                 *branch to NEG routine
            
            AND.W       #$1,D0
            CMPI.W      #1,D0
            BEQ         LEA
            
            CMPI.W      #0,D0
            BEQ         MOVEM
            
*--------------------------------------------------------------            
*-BIN 5 Possible OPCODES:
*-SUBQ, ADDQ
*--------------------------------------------------------------    
BIN_5       MOVE.W      (A5),D0             *reload opcode into D0
            LSR.W       #4,D0               *shift bits to the right 4
            LSR.W       #4,D0               *Shift bits to the right 4
            AND.W       #$01,D0             *isolate the last bit
            CMPI.W      #1,D0               *check if the bit is a 1
            BEQ         SUBQ                *if SUBQ go to the SUB
            
            ;CMPI.W      #0,D0               *check if the bit is a 0
            ;BEQ         ADDQ                *if ADDQ go to the SUB
            
            BRA         DATA                *if neither SUBQ or ADDQ must be DATA

*--------------------------------------------------------------            
*-BIN 6 Possible OPCODES:
*-Bcc(BCC, BCS, BGE, BLT, BVC), BRA
*-Extra Bcc(BEQ, BGT, BLS, BNE, BHI, BVS, BPL, BMI, BLE) 
*--------------------------------------------------------------    
BIN_6       MOVE.W      (A5),D0             *reload fresh op code
            LSR.W       #4,D0               *shift right 4
            LSR.W       #4,D0               *shift right 4
            AND.W       #$0F,D0             *Finds the condition code of the branch statement through bitmask
            
            CMPI.W      #0,D0               *check if the 4 bits == 0000
            BEQ         BRA_SUB             *branch to BRA SUB
            
            CMPI.W      #2,D0
            BEQ         BHI                 *branch to BHI SUB
            
            CMPI.W      #3,D0
            BEQ         BLS                 *branch to BLS SUB
            
            CMPI.W      #4,D0
            BEQ         BCC                 *branch to BCC code

            CMPI.W      #5,D0
            BEQ         BCS                 *branch to BCS SUB

            CMPI.W      #6,D0
            BEQ         BNE                 *branch to BNE SUB 
            
            CMPI.W      #7,D0
            BEQ         BEQ_SUB             *branch to BEQ SUB
            
            CMPI.W      #8,D0
            BEQ         BVC                 *branch to BVC code

            CMPI.W      #9,D0
            BEQ         BVS                 *branch to BVS code
            
            CMPI.W      #$A,D0
            BEQ         BPL                 *branch to BPL code
            
            CMPI.W      #$B,D0
            BEQ         BMI                 *branch to BMI code
            
            CMPI.W      #$C,D0
            BEQ         BGE                 *branch to BGE code
                                                                     
            CMPI.W      #$D,D0
            BEQ         BLT                 *branch to BLT SUB            
            
            CMPI.W      #$E,D0
            BEQ         BGT                 *branch to BGT code
            
            CMPI.W      #$F,D0
            BEQ         BLE                 *branch to BLE code

*--------------------------------------------------------------            
*-BIN 7 Possible OPCODES:
*-MOVEQ
*--------------------------------------------------------------  
BIN_7       BRA        MOVEQ                *MOVEQ is the only option for this bin so branch to SUB

*--------------------------------------------------------------            
*-BIN 8 Possible OPCODES:
*-DIVS, OR, DIVU
*--------------------------------------------------------------       
BIN_8       MOVE.W      (A5),D0             *reload opcode into D0
            LSR.W       #6,D0               *shift bits to the right 6
            AND.W       #$07,D0             *isolate the last 3 bits
   
            CMPI.W      #7,D0               *check if the bits == 7
            BEQ         DIVS_W              *if DIVS word go to the subroutine
            
            CMPI.W      #3,D0               *check if the bits == 3
            BEQ         DIVU_W              *if DIVU word go to the subroutine
            
            BRA         OR                  *if neither DIVS or DIVU it must be OR
            
*--------------------------------------------------------------            
*-BIN 9 Possible OPCODES:
*-SUB
*--------------------------------------------------------------     
BIN_9       BRA         SUB                 *SUB is the only option for this bin so branch to SUB

*--------------------------------------------------------------            
*-BIN 10 Possible OPCODES:
*-N/a - DATA
*--------------------------------------------------------------     
BIN_10      BRA         DATA                *If it goes into this bin it is DATA

*--------------------------------------------------------------            
*-BIN 11 Possible OPCODES:
*-EOR, CMP
*--------------------------------------------------------------     
BIN_11      MOVE.W      (A5),D0             *reload opcode into D0
            LSR.W       #4,D0               *shift bits to the right 4
            LSR.W       #4,D0               *Shift bits to the right 4
            AND.W       #$01,D0             *isolate the last bit
            CMPI.W      #1,D0               *check if the bit is a 1
            BEQ         EOR                 *if EOR go to the SUB
            
            CMPI.W      #0,D0               *check if the bit is a 0
            BEQ         CMP                 *if CMP go to the SUB
            
            BRA         DATA                *if neither EOR or CMP must be DATA
            
*--------------------------------------------------------------            
*-BIN 12 Possible OPCODES:
*-MULS (word), AND
*--------------------------------------------------------------     
BIN_12      MOVE.W      (A5),D0             *reload opcode into D0
            LSR.W       #6,D0               *shift bits to the right 6
            AND.W       #$07,D0             *isolate the last 3 bits
            
            CMPI.W      #7,D0               *check if the bits == 7
            BEQ         MULS_W              *if MULS word go to SUB 
            
*            CMPI.W      #3,D0               *check if the bits == 011
*            BEQ         DATA                *if they do it is DATA branch to SUB
                                                        
            BRA         DATA                *default case: data

*--------------------------------------------------------------            
*-BIN 13 Possible OPCODES:
*-ADD
*--------------------------------------------------------------    
BIN_13      MOVE.W      (A5),D0             *reload opcode into D0
            LSR.W       #6,D0               *shift bits to the right 6
            AND.W       #$07,D0             *isolate the last 3 bits
            CMPI.W      #$3,D0              *check if the bits are 011
            BEQ         ADDA                *if ADDA go to SUB        
            
            CMPI.W      #$7,D0              *check if the bits are 111
            BEQ         ADDA                *if ADDA go to SUB 
                                                        
            BRA         ADD                 *if bits are not ADDA must be ADD and go to SUB
            
*--------------------------------------------------------------            
*-BIN 14 Possible OPCODES:
*-LS(L/R), AS(L/R), RO(L/R)
*--------------------------------------------------------------      
BIN_14      MOVE.W      (A5),D0             *Reload the opcode
            LSR.W       #3,D0               *shift bits down
            AND.W       #$03,D0             *mask bits
            CMPI.W      #1,D0               *determin which kind of shift it is
            BEQ         LOGIC_REG           *bra to logic shift register mode
            
            CMPI.W      #0,D0
            BEQ         ARITH_REG           *bra to arthimetic shift register mode
            
            CMPI.W      #3,D0
            BEQ         ROTATE_REG          *bra to rotate register mode  

            MOVE.W      (A5),D0             *Reload the opcode
            LSR.W       #4,D0               *shift bits down
            LSR.W       #5,D0               *shift bits a total of 9
            AND.W       #$07,D0             *mask bits
            CMPI.W      #1,D0               *determin which kind of shift it is
            BEQ         LOGIC_MEM           *bra to logic shift memory mode
            
            CMPI.W      #0,D0
            BEQ         ARITH_MEM           *bra to arthimetic shift memory mode
            
            CMPI.W      #3,D0
            BEQ         ROTATE_MEM          *bra to rotate MEM mode    
            
            BRA         DATA                *if not a shift must be DATA 
                                                                

*--------------------------------------------------------------            
*-BIN 15 Possible OPCODES:
*-N/a - DATA
*--------------------------------------------------------------       
BIN_15      BRA        DATA                *IF it goes into this bin it is DATA
                                                                                             

*--------------------------------------------------------------
*-Decode table
*-Part 2 of the Jump Table
*-OPCODE Effective addressing and EA Mode decoding
*--------------------------------------------------------------

*-BIN 0--------------------------------------------------------           
ORI         MOVE.B      #'O',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'R',(A4)+
            MOVE.B      #'I',(A4)+
            
            JSR         GET_SIZE_67
            JSR         DECODE_C            *jump to decoder SUB C
         
            RTS                             *Return to OutputBuilder file
            
CMPI        MOVE.B      #'C',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'M',(A4)+
            MOVE.B      #'P',(A4)+
            MOVE.B      #'I',(A4)+
            
            JSR         GET_SIZE_67 
            JSR         DECODE_C            *jump to decoder SUB C
   
            RTS                             *Return to OutputBuilder file
            
ADDI        MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'D',(A4)+
            MOVE.B      #'D',(A4)+
            MOVE.B      #'I',(A4)+
            
            JSR         GET_SIZE_67 
            JSR         DECODE_C            *jump to decoder SUB C
   
            RTS                             *Return to OutputBuilder file

SUBI        MOVE.B      #'S',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'U',(A4)+
            MOVE.B      #'B',(A4)+
            MOVE.B      #'I',(A4)+
            
            JSR         GET_SIZE_67 
            JSR         DECODE_C            *jump to decoder SUB C
   
            RTS                             *Return to OutputBuilder file
            
BCLR_IM     MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'C',(A4)+
            MOVE.B      #'L',(A4)+
            MOVE.B      #'R',(A4)+
            
            JSR         D_BCLRI             *jump to decoder SUB D
            
            RTS                             *Return to OutputBuilder file
            
BCLR_REG    MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'C',(A4)+
            MOVE.B      #'L',(A4)+
            MOVE.B      #'R',(A4)+
            
            JSR         D_BCLR             *jump to decoder SUB D
            
            RTS                             *Return to OutputBuilder file


*-BIN_MOVE (Bins 1, 2, and 3)---------------------------------- 
MOVE        MOVE.B      #'M',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'V',(A4)+
            MOVE.B      #'E',(A4)+
            
            JSR         MOVE_SIZE           *Append size
            JSR         DECODE_A            *Append Decode information
            
            RTS                             *Return to OutputBuilder file
           
            
MOVEA       MOVE.B      #'M',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'V',(A4)+
            MOVE.B      #'E',(A4)+
            MOVE.B      #'A',(A4)+
            
            MOVE.W      (A5),D0             *reload OPCODE into D0
            LSR.W       #4,D0               *Isolate leftmost hex digit
            LSR.W       #4,D0
            LSR.W       #4,D0               *shift bits a total of 12 right
            AND.W       #$03,D0             *isolate the last 2 bits
            
            CMPI.W      #1,D0               *If == 1, invalid OPCODE
            BEQ         DATA                *Operation not supported for MOVEA
            
            JSR         MOVE_SIZE           *Append size
            JSR         DECODE_A            *Append Decode information

            RTS                             *Return to OutputBuilder file

*-BIN 4--------------------------------------------------------
NOP         MOVE.B      #'N',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'P',(A4)+
            
            MOVE.L      #2,D6
            ADDI        #2,D7               *NOP is 2 Bytes; Increment length var by
            
            RTS                             *Return to OutputBuilder file
                        
RTS         MOVE.B      #'R',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'T',(A4)+
            MOVE.B      #'S',(A4)+ 

            MOVE.L      #2,D6               *Increment the size counter D6 by a WORD 
            MOVE.L      #2,D7               *Increment the size counter D7 by a WORD           
            
            RTS                             *Return to OutputBuilder file
            
LEA         MOVE.B      #'L',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'E',(A4)+
            MOVE.B      #'A',(A4)+   

            JSR         D_LEA               *jump to LEA in the decoder

        
            RTS                             *Return to OutputBuilder file
            
MOVEM       MOVE.B      #'M',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'V',(A4)+   
            MOVE.B      #'E',(A4)+
            MOVE.B      #'M',(A4)+

            JSR         MOVEM_SIZE          *Append size
            JSR         D_MOVEM             *jump to MOVEM in the decoder
            
            RTS                             *Return to OutputBuilder file
            
JSR         MOVE.B      #'J',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'S',(A4)+
            MOVE.B      #'R',(A4)+   
        
            JSR         D_JSR               *jump to JSR in the decoder

            RTS                             *Return to OutputBuilder file
            
NEG         MOVE.B      #'N',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'E',(A4)+
            MOVE.B      #'G',(A4)+   
        
            JSR         GET_SIZE_67         *Append size
            JSR         D_NEG               *jump to decoder SUB C
            
            RTS                             *Return to OutputBuilder file
             
            
*-BIN 5--------------------------------------------------------
SUBQ        MOVE.B      #'S',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'U',(A4)+
            MOVE.B      #'B',(A4)+   
            MOVE.B      #'Q',(A4)+ 
                                       
            JSR         GET_SIZE_67         *Append size
            JSR         D_SUBQ           *jump to decoder SUB C
            
            RTS                             *Return to OutputBuilder file
            
*ADDQ        MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
*            MOVE.B      #'D',(A4)+
*            MOVE.B      #'D',(A4)+   
*            MOVE.B      #'Q',(A4)+ 
*                                       
*            JSR         GET_SIZE_67         *Append size
*            JSR         D_ADDQ              
*            
*            RTS                             *Return to OutputBuilder file
            
           
*-BIN 6--------------------------------------------------------
BHI         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'H',(A4)+
            MOVE.B      #'I',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BLS         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'L',(A4)+
            MOVE.B      #'S',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BCC         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'C',(A4)+
            MOVE.B      #'C',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BCS         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'C',(A4)+
            MOVE.B      #'S',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BNE         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'N',(A4)+
            MOVE.B      #'E',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BEQ_SUB     MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'E',(A4)+
            MOVE.B      #'Q',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file
            
BVC         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'V',(A4)+
            MOVE.B      #'C',(A4)+ 

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E   
        
            RTS                             *Return to OutputBuilder file
            
BVS         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'V',(A4)+
            MOVE.B      #'S',(A4)+ 

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E   
        
            RTS                             *Return to OutputBuilder file
            
BPL         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'P',(A4)+
            MOVE.B      #'L',(A4)+ 

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E   
        
            RTS                             *Return to OutputBuilder file
            
BMI         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'M',(A4)+
            MOVE.B      #'I',(A4)+ 

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E   
        
            RTS                             *Return to OutputBuilder file
            
BGE         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'G',(A4)+
            MOVE.B      #'E',(A4)+  

            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E 
        
            RTS                             *Return to OutputBuilder file
            
BLT         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'L',(A4)+
            MOVE.B      #'T',(A4)+   
            
            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E 
        
            RTS                             *Return to OutputBuilder file
            
BGT         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'G',(A4)+
            MOVE.B      #'T',(A4)+   
            
            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E 
        
            RTS                             *Return to OutputBuilder file
            
BLE         MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'L',(A4)+
            MOVE.B      #'E',(A4)+   
            
            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E 
        
            RTS                             *Return to OutputBuilder file

BRA_SUB     MOVE.B      #'B',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'R',(A4)+
            MOVE.B      #'A',(A4)+  
            
            JSR         BRANCH_SIZE        *append the size of the branch
            JSR         DECODE_E           *jump to decoder SUB E  
        
            RTS                             *Return to OutputBuilder file

*-BIN 7-------------------------------------------------------
MOVEQ       MOVE.B      #'M',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'V',(A4)+   
            MOVE.B      #'E',(A4)+
            MOVE.B      #'Q',(A4)+
            
            JSR         D_MOVEQ             *jump to MOVEQ in the decoder 
                        
            RTS                             *Return to OutputBuilder file
            
*-BIN 8--------------------------------------------------------
DIVS_W      MOVE.B      #'D',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'I',(A4)+
            MOVE.B      #'V',(A4)+   
            MOVE.B      #'S',(A4)+
            
            JSR         APPND_WORD
            JSR         DECODE_F           *jump to decoder SUB F 
        
            RTS                             *Return to OutputBuilder file
            
DIVU_W      MOVE.B      #'D',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'I',(A4)+
            MOVE.B      #'V',(A4)+   
            MOVE.B      #'U',(A4)+
            
            JSR         APPND_WORD
            JSR         DECODE_F           *jump to decoder SUB F
        
            RTS                             *Return to OutputBuilder file
            
OR          MOVE.B      #'O',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'R',(A4)+
           
            JSR         SIZE_678            *Append size
            JSR         DECODE_F           *jump to decoder SUB F
            
            RTS                             *Return to OutputBuilder file
            
*-BIN 9---------------------------------------------------------
SUB         MOVE.B      #'S',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'U',(A4)+
            MOVE.B      #'B',(A4)+   

            JSR         SIZE_678            *Append size
            JSR         DECODE_F           *jump to decoder SUB F
            
            RTS                             *Return to OutputBuilder file
            
*-BIN 11--------------------------------------------------------          
EOR         MOVE.B      #'E',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
            MOVE.B      #'R',(A4)+   

            JSR         GET_SIZE_67         *Append size
            JSR         D_EOR               *jump to decoder D_EOR
            
            RTS                             *Return to OutputBuilder file

CMP         MOVE.B      #'C',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'M',(A4)+
            MOVE.B      #'P',(A4)+   

            JSR         GET_SIZE_67         *Append size
            JSR         DECODE_D            *jump to decoder SUB D
            
            RTS                             *Return to OutputBuilder file

*-BIN 12---------------------------------------------------------
MULS_W      MOVE.B      #'M',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'U',(A4)+
            MOVE.B      #'L',(A4)+   
            MOVE.B      #'S',(A4)+
            
            JSR         APPND_WORD
            JSR         DECODE_F           *jump to decoder SUB F
            
            RTS                             *Return to OutputBuilder file
            
*AND         MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
*            MOVE.B      #'N',(A4)+
*            MOVE.B      #'D',(A4)+   
*            
*            JSR         SIZE_678            *Append size
*            JSR         DECODE_F           *jump to decoder SUB F
*            
*            RTS                             *Return to OutputBuilder file
            
*-BIN 13---------------------------------------------------------
ADD         MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'D',(A4)+
            MOVE.B      #'D',(A4)+   
            
            JSR         SIZE_678            *Append size
            JSR         DECODE_F           *jump to decoder SUB F
            
            RTS                             *Return to OutputBuilder file
            


ADDA        MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'D',(A4)+
            MOVE.B      #'D',(A4)+
            MOVE.B      #'A',(A4)+   
            
            JSR         ADDA_SIZE           *add size
                        
            
            JSR         D_ADDA              *jump to decoder SUB F
                
            RTS                             *Return to OutputBuilder file
            

     
*-BIN 14-------------------------------------------------------                                                                  
LOGIC_REG   MOVE.B      #'L',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'S',(A4)+
                   
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         GET_SIZE_67         *Append Size
            JSR         DECODE_B           *jump to decoder SUB B
            
            RTS                             *Return to OutputBuilder file           

ARITH_REG   MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'S',(A4)+
            
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         GET_SIZE_67         *Append Size
            JSR         DECODE_B           *jump to decoder SUB B

            RTS         
                
ROTATE_REG  MOVE.B      #'R',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
          
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         GET_SIZE_67         *Append Size
            JSR         DECODE_B           *jump to decoder SUB B
            
            RTS
            
LOGIC_MEM   MOVE.B      #'L',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'S',(A4)+
                   
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         APPND_WORD          *only supports word sized operations on memory
            JSR         DECODE_B           *jump to decoder SUB B
            
            RTS                             *Return to OutputBuilder file           

ARITH_MEM   MOVE.B      #'A',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'S',(A4)+
            
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         APPND_WORD          *only supports word sized operations on memory
            JSR         DECODE_B           *jump to decoder SUB B

            RTS         
                
ROTATE_MEM  MOVE.B      #'R',(A4)+          *Load OPCODE string into (A4)
            MOVE.B      #'O',(A4)+
          
            JSR         RIGHTORLEFT         *Append (L/R)
            JSR         APPND_WORD          *only supports word sized operations on memory
            JSR         DECODE_B           *jump to decoder SUB B
            
            RTS
              
RIGHTORLEFT MOVE.W      (A5),D0             *reload op
            LSR.L       #8,D0               *shift until dr bit is reached
            AND.L       #$00000001,D0       *isolate dr bit
            CMP.B       #0,D0               *check if left
            BEQ         RIGHT
            
            CMP.B       #1,D0               *check if right
            BEQ         LEFT  
                                              
LEFT        MOVE.B      #'L',(A4)+          *Load directional string 'L' into (A4)
            RTS                      
                     
RIGHT       MOVE.B      #'R',(A4)+          *Load directional string 'R' into (A4)
            RTS
                                  
*-DATA---------------------------------------------------------
DATA        MOVE.B      #'D',(A4)+          *Write DATA into string
            MOVE.B      #'A',(A4)+          
            MOVE.B      #'T',(A4)+          
            MOVE.B      #'A',(A4)+         
            MOVE.B      #09,(A4)+           *Write a tab into string
            
            ADD.B       #2,D6               *Increment the size counter D6 by a word 
            JSR         WRITE_DATA          *Write D7 worth of OPCODE data that couldn't be decoded
                                  
            RTS                             *Return program flow back to Dissasembler file
            
*--------------------------------------------------------------            
*-Print Operand DATA
*--------------------------------------------------------------
P_OPERAND   SUBI.B      #2,D7               *Subtract 2 from D7 size counter to account for and skip OPCODE's data 
            ADDA        #2,A5               *Increment current address pointer to skip over OPCODE
            JSR         WRITE_DATA          *WRITE_DATA writes everything after the OPCODE to (A4)
            
            ADDI.B      #2,D7               *Add the 2 back to D7 size counter
            SUBA        #2,A5               *Decrement current address point to point to the start of opcode again
            
            RTS
            
*-Print/Data Helper Methods------------------------------------
*-Don't access these methods directly, use P_OPERAND instead
WRITE_DATA  MOVE.L      D6,D3               *D3 is counter var. Same size as the length specified in D6
WRITE_LOOP  CMPI.B      #0,D3               *is D3 == 0?
            BEQ         WRITE_DONE          *then we are done writing the string 
            
            SUBI        #1,D3               *Decrement counter var by 1                       

            MOVE.B      (A5),D2             *Move 1 byte of OPCODE/OPERAND data into D2                   
            LSR.W       #4,D2               *Isolate left 4 bits of first byte in D1             
            JSR         WRITE_DIGIT         *Save the left 4 bits in the byte as an ascii char
        
            MOVE.B      (A5),D2             *Move 1 byte of OPCODE/OPERAND data into D2   
            ANDI.B      #$0F,D2             *Isolate right 4 of the first byte in D2                                     
            JSR         WRITE_DIGIT         *Save the right 4 bits in the byte as an ascii char
            
            ADDA        #1,A5               *Increment A5
            
            BRA         WRITE_LOOP          *Go to start of loop, and write the next bytes worth of digits          
                   
WRITE_DIGIT CMP.B       #$09,D2             *Is D2 alphabet or number?
            BGT         W_ALPHA             *If D2 > #$09, it's alphabet
            BRA         W_NUM               *Else its numeric             
            
W_ALPHA     JSR         CNVRT_ALPHA         *Convert the half byte to ascii, and write to string
            RTS                             *Go back to write_loop

W_NUM       JSR         CNVRT_ALPHA         *Convert the half byte to ascii, and write to string
            RTS                             *Go back to write_loop           
            
CNVRT_ALPHA ADDI.B      #$37,D2             *Convert to ASCII
            MOVE.B      D2,(A4)+            *Write to string
            RTS

CNVRT_NUM   ADDI.B      #$30,D2             *Convert to ASCII
            MOVE.B      D2,(A4)+            *Write to string
            RTS           
            
WRITE_DONE  SUB.W       D7,A5               *Bring A5 pointer back to where it was before writing the DATA
            RTS                             *Finished writing       

*--------------------------------------------------------------     
*-Size Subroutines
*-This helper is applicable for: 
*-NEG, ORI, CMPI, LSL/LSR, ASL/ASR, ROL/ROR, EOR, CMP, SUBQ
*--------------------------------------------------------------

GET_SIZE_67 MOVE.W      (A5),D0             *reload OPCODE into (A5)
            LSR.W       #6,D0               *shift bits right 6
            AND.W       #$03,D0             *Isolate last 2 bits
            CMPI.W      #0,D0
            BEQ         APPND_BYTE          *Is a Byte operation
            CMPI.W      #1,D0
            BEQ         APPND_WORD          *Is a Word operation
            CMPI.W      #2,D0
            BEQ         APPND_LONG          *Is a Long operation
            BRA         DATA                *Not a valid size must be data 

MOVEM_SIZE  MOVE.W      (A5),D0             *reload OPCODE into (A5)
            LSR.W       #6,D0               *shift bits right 6
            AND.W       #$01,D0             *isolate last bit
            CMPI.W      #0,D0
            BEQ         APPND_WORD          *is a word operation
            CMPI.W      #1,D0
            BEQ         APPND_LONG          *is a long operation
            BRA         DATA
            
MOVE_SIZE   MOVE.W      (A5),D0             *reload OPCODE into (A5)
            LSR.W       #4,D0               *shift bits right 4
            LSR.W       #4,D0
            LSR.W       #4,D0               *shift bits a total of 12 right
            AND.W       #$03,D0             *isolate the last 2 bits
            CMPI.W      #1,D0               
            BEQ         APPND_BYTE          *is a byte operation
            CMPI.W      #3,D0               
            BEQ         APPND_WORD          *is a word operation
            CMPI.W      #2,D0               
            BEQ         APPND_LONG          *is a long operation
            BRA         DATA
            
SIZE_678    MOVE.W      (A5),D0             *reload OPCODE into (A5)
            LSR.W       #6,D0               *shift the bits right 6
            AND.W       #$07,D0             *isolate the last 3 bits
            CMPI.W      #0,D0               
            BEQ         APPND_BYTE          *is a byte operation
            CMPI.W      #4,D0
            BEQ         APPND_BYTE          *is a byte operation
            CMPI.W      #1,D0               
            BEQ         APPND_WORD          *is a word operation
            CMPI.W      #5,D0               
            BEQ         APPND_WORD          *is a word operation
            CMPI.W      #2,D0
            BEQ         APPND_LONG          *is a long operation
            CMPI.W      #6,D0
            BEQ         APPND_LONG          *is a long operation
            BRA         DATA                *is not one of the supported sizes
            
ADDA_SIZE   MOVE.W      (A5),D0             *reload OPCODE into (A5)
            LSR.W       #6,D0               *shift the bits right 6
            AND.W       #$07,D0             *isolate the last 3 bits
            CMPI.W      #3,D0
            BEQ         APPND_WORD          *is a word operation
            CMPI.W      #7,D0
            BEQ         APPND_LONG          *is a long operation
            BRA         DATA                *is not one of the supported sizes
            
BRANCH_SIZE MOVE.W      (A5),D0             *reload OPCODE into (A5)
            AND.W       #$00FF,D0           *isolate the last 8 bits
            CMPI.B      #$00,D0             *checking if the last 8 bits are $00
            BEQ         APPND_WORD          *is a word operation    
            CMPI.B      #$FF,D0             *checking if the last 8 bits are $FF
            BEQ         APPND_LONG          *is a long operation
            BRA         APPND_BYTE          *otherwise is a byte
                   

APPND_BYTE  MOVE.B      #'.',(A4)+
            MOVE.B      #'B',(A4)+          *load size into (A4)
            ADDI.B      #2,D7               *add OPCODE length to D7
            RTS

APPND_WORD  MOVE.B      #'.',(A4)+
            MOVE.B      #'W',(A4)+          *load size into (A4)
            ADDI.B      #4,D7               *add OPCODE length to D7
            RTS

APPND_LONG  MOVE.B      #'.',(A4)+
            MOVE.B      #'L',(A4)+          *load size into (A4)
            ADDI.B      #8,D7               *add OPCODE length to D7
            RTS                
            
*-FILES--------------------------------------------------------
            INCLUDE     'TeamVisualBasic_OP_Decoder.X68'    ;Helper file for jump table
            







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

*-----------------------------------------------------------
* Title      :  Team Visual Basic's Dissasembler: Testing File
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018   
* Description:  CSS 422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Testing file provides data for the dissasembler to test upon
*-----------------------------------------------------------
    
START       ORG         $00007F00            ; first instruction of program

*-DECODE_E test-------------------------------------------------
*-BCC (BCC, BLT, BGE, BCS, BVC), BRA

            BRA     JUMP
            
JUMP        BCC     JUMP2
JUMP2       BLT     JUMP3
JUMP3       BGE     JUMP4
JUMP4       BCS     JUMP5
JUMP5       BVC     JUMP6
JUMP6

*-DECODE_C test--------------------------------------------------
*-ADDI,SUBI,NEG,ORI,CMPI,ADDI
            ADDI.B      #$12,D0
            *ADDI.B      #$12,A0            *not allowed
            ADDI.W      #$1234,D7
            ADDI.L      #$12345678,D0
            
            SUBI.B      #$12,D0
            SUBI.W      #$1234,D7
            SUBI.L      #$12345678,D0
            
            ORI.B       #$12,D0
            ORI.W       #$1234,D7
            ORI.L       #$12345678,D0
            
            CMPI.B      #$12,D0
            CMPI.W      #$1234,D7
            CMPI.L      #$12345678,D0
            
            
            ;NEG?
            


*-Shift test-----------------------------------------------------
            LSL.W       #$4,D3              *demolished
            LSL.B       #$2,D3              *obliterated
            LSL.L       #$6,D3              *slapped
            LSL.W       D4,D3
            LSR.W       D5,D6  
            
            
            LSL.B       #$01,D0
            LSL.B       #$02,D1
            LSL.B       #$03,D2
            LSL.B       #$04,D3
            LSL.B       #$05,D4
            LSL.B       #$06,D5
            LSL.B       #$07,D6
            LSL.B       D0,D7    
            LSL.B       D1,D7  
            LSL.B       D2,D7    
            LSL.B       D3,D7 
            LSL.B       D4,D7    
            LSL.B       D5,D7
            LSL.B       D6,D7    
            LSL.B       D7,D7   

            LSL.W       #$01,D0
            LSL.W       #$02,D1
            LSL.W       #$03,D2
            LSL.W       #$04,D3
            LSL.W       #$05,D4
            LSL.W       #$06,D5
            LSL.W       #$07,D6
            LSL.W       D0,D7    
            LSL.W       D1,D7  
            LSL.W       D2,D7    
            LSL.W       D3,D7 
            LSL.W       D4,D7    
            LSL.W       D5,D7
            LSL.W       D6,D7    
            LSL.W       D7,D7     
            
            ;LSL.W       $ABCD1234
            ;LSL.W       $20(A0)
*
*            LSL.W       (A0)            
*            LSL.W       -(A0)           
*            LSL.W       (A0)+
*            LSL.W       (A1)            
*            LSL.W       -(A1)           
*            LSL.W       (A1)+
*            LSL.W       (A2)            
*            LSL.W       -(A2)           
*            LSL.W       (A2)+
*            LSL.W       (A3)            
*            LSL.W       -(A3)           
*            LSL.W       (A3)+
*            LSL.W       (A4)            
*            LSL.W       -(A4)           
*            LSL.W       (A4)+
*            LSL.W       (A5)            
*            LSL.W       -(A5)           
*            LSL.W       (A5)+
*            LSL.W       (A6)            
*            LSL.W       -(A6)           
*            LSL.W       (A6)+
*            LSL.W       (A7)            
*            LSL.W       -(A7)           
*            LSL.W       (A7)+


            LSL.L       #$01,D0
            LSL.L       #$02,D1
            LSL.L       #$03,D2
            LSL.L       #$04,D3
            LSL.L       #$05,D4
            LSL.L       #$06,D5
            LSL.L       #$07,D6
            LSL.L       D0,D7    
            LSL.L       D1,D7  
            LSL.L       D2,D7    
            LSL.L       D3,D7 
            LSL.L       D4,D7    
            LSL.L       D5,D7
            LSL.L       D6,D7    
            LSL.L       D7,D7 

            LSR.B       #$01,D0
            LSR.B       #$02,D1
            LSR.B       #$03,D2
            LSR.B       #$04,D3
            LSR.B       #$05,D4
            LSR.B       #$06,D5
            LSR.B       #$07,D6
            LSR.B       D0,D7    
            LSR.B       D1,D7  
            LSR.B       D2,D7    
            LSR.B       D3,D7 
            LSR.B       D4,D7    
            LSR.B       D5,D7
            LSR.B       D6,D7    
            LSR.B       D7,D7   

            LSR.W       #$01,D0
            LSR.W       #$02,D1
            LSR.W       #$03,D2
            LSR.W       #$04,D3
            LSR.W       #$05,D4
            LSR.W       #$06,D5
            LSR.W       #$07,D6
            LSR.W       D0,D7    
            LSR.W       D1,D7  
            LSR.W       D2,D7    
            LSR.W       D3,D7 
            LSR.W       D4,D7    
            LSR.W       D5,D7
            LSR.W       D6,D7    
            LSR.W       D7,D7  

            ;LSR.W       $ABCD1234
            ;LSR.W       $20(A0)

*            LSR.W       (A0)            
*            LSR.W       -(A0)           
*            LSR.W       (A0)+
*            LSR.W       (A1)            
*            LSR.W       -(A1)           
*            LSR.W       (A1)+
*            LSR.W       (A2)            
*            LSR.W       -(A2)           
*            LSR.W       (A2)+
*            LSR.W       (A3)            
*            LSR.W       -(A3)           
*            LSR.W       (A3)+
*            LSR.W       (A4)            
*            LSR.W       -(A4)           
*            LSR.W       (A4)+
*            LSR.W       (A5)            
*            LSR.W       -(A5)           
*            LSR.W       (A5)+
*            LSR.W       (A6)            
*            LSR.W       -(A6)           
*            LSR.W       (A6)+
*            LSR.W       (A7)            
*            LSR.W       -(A7)           
*            LSR.W       (A7)+   

            LSR.L       #$01,D0
            LSR.L       #$02,D1
            LSR.L       #$03,D2
            LSR.L       #$04,D3
            LSR.L       #$05,D4
            LSR.L       #$06,D5
            LSR.L       #$07,D6
            LSR.L       D0,D7    
            LSR.L       D1,D7  
            LSR.L       D2,D7    
            LSR.L       D3,D7 
            LSR.L       D4,D7    
            LSR.L       D5,D7
            LSR.L       D6,D7    
            LSR.L       D7,D7  

            ASL.B       #$01,D0
            ASL.B       #$02,D1
            ASL.B       #$03,D2
            ASL.B       #$04,D3
            ASL.B       #$05,D4
            ASL.B       #$06,D5
            ASL.B       #$07,D6
            ASL.B       D0,D7    
            ASL.B       D1,D7  
            ASL.B       D2,D7    
            ASL.B       D3,D7 
            ASL.B       D4,D7    
            ASL.B       D5,D7
            ASL.B       D6,D7    
            ASL.B       D7,D7   

            ASL.W       #$01,D0
            ASL.W       #$02,D1
            ASL.W       #$03,D2
            ASL.W       #$04,D3
            ASL.W       #$05,D4
            ASL.W       #$06,D5
            ASL.W       #$07,D6
            ASL.W       D0,D7    
            ASL.W       D1,D7  
            ASL.W       D2,D7    
            ASL.W       D3,D7 
            ASL.W       D4,D7    
            ASL.W       D5,D7
            ASL.W       D6,D7    
            ASL.W       D7,D7   

            ;ASL.W       $ABCD1234
            ;ASL.W       $20(A0)

*            ASL.W       (A0)            
*            ASL.W       -(A0)           
*            ASL.W       (A0)+
*            ASL.W       (A1)            
*            ASL.W       -(A1)           
*            ASL.W       (A1)+
*            ASL.W       (A2)            
*            ASL.W       -(A2)           
*            ASL.W       (A2)+
*            ASL.W       (A3)            
*            ASL.W       -(A3)           
*            ASL.W       (A3)+
*            ASL.W       (A4)            
*            ASL.W       -(A4)           
*            ASL.W       (A4)+
*            ASL.W       (A5)            
*            ASL.W       -(A5)           
*            ASL.W       (A5)+
*            ASL.W       (A6)            
*            ASL.W       -(A6)           
*            ASL.W       (A6)+
*            ASL.W       (A7)            
*            ASL.W       -(A7)           
*            ASL.W       (A7)+  

            ASL.L       #$01,D0
            ASL.L       #$02,D1
            ASL.L       #$03,D2
            ASL.L       #$04,D3
            ASL.L       #$05,D4
            ASL.L       #$06,D5
            ASL.L       #$07,D6
            ASL.L       D0,D7    
            ASL.L       D1,D7  
            ASL.L       D2,D7    
            ASL.L       D3,D7 
            ASL.L       D4,D7    
            ASL.L       D5,D7
            ASL.L       D6,D7    
            ASL.L       D7,D7     

            ASR.B       #$01,D0
            ASR.B       #$02,D1
            ASR.B       #$03,D2
            ASR.B       #$04,D3
            ASR.B       #$05,D4
            ASR.B       #$06,D5
            ASR.B       #$07,D6
            ASR.B       D0,D7    
            ASR.B       D1,D7  
            ASR.B       D2,D7    
            ASR.B       D3,D7 
            ASR.B       D4,D7    
            ASR.B       D5,D7
            ASR.B       D6,D7    
            ASR.B       D7,D7   

            ASR.W       #$01,D0
            ASR.W       #$02,D1
            ASR.W       #$03,D2
            ASR.W       #$04,D3
            ASR.W       #$05,D4
            ASR.W       #$06,D5
            ASR.W       #$07,D6
            ASR.W       D0,D7    
            ASR.W       D1,D7  
            ASR.W       D2,D7    
            ASR.W       D3,D7 
            ASR.W       D4,D7    
            ASR.W       D5,D7
            ASR.W       D6,D7    
            ASR.W       D7,D7   

            ;ASR.W       $ABCD1234
            ;ASR.W       $20(A0)

*            ASR.W       (A0)            
*            ASR.W       -(A0)           
*            ASR.W       (A0)+
*            ASR.W       (A1)            
*            ASR.W       -(A1)           
*            ASR.W       (A1)+
*            ASR.W       (A2)            
*            ASR.W       -(A2)           
*            ASR.W       (A2)+
*            ASR.W       (A3)            
*            ASR.W       -(A3)           
*            ASR.W       (A3)+
*            ASR.W       (A4)            
*            ASR.W       -(A4)           
*            ASR.W       (A4)+
*            ASR.W       (A5)            
*            ASR.W       -(A5)           
*            ASR.W       (A5)+
*            ASR.W       (A6)            
*            ASR.W       -(A6)           
*            ASR.W       (A6)+
*            ASR.W       (A7)            
*            ASR.W       -(A7)           
*            ASR.W       (A7)+    

            ASR.L       #$01,D0
            ASR.L       #$02,D1
            ASR.L       #$03,D2
            ASR.L       #$04,D3
            ASR.L       #$05,D4
            ASR.L       #$06,D5
            ASR.L       #$07,D6
            ASR.L       D0,D7    
            ASR.L       D1,D7  
            ASR.L       D2,D7    
            ASR.L       D3,D7 
            ASR.L       D4,D7    
            ASR.L       D5,D7
            ASR.L       D6,D7    
            ASR.L       D7,D7

            ROL.B       #$01,D0
            ROL.B       #$02,D1
            ROL.B       #$03,D2
            ROL.B       #$04,D3
            ROL.B       #$05,D4
            ROL.B       #$06,D5
            ROL.B       #$07,D6
            ROL.B       D0,D7    
            ROL.B       D1,D7  
            ROL.B       D2,D7    
            ROL.B       D3,D7 
            ROL.B       D4,D7    
            ROL.B       D5,D7
            ROL.B       D6,D7    
            ROL.B       D7,D7     

            ROL.W       #$01,D0
            ROL.W       #$02,D1
            ROL.W       #$03,D2
            ROL.W       #$04,D3
            ROL.W       #$05,D4
            ROL.W       #$06,D5
            ROL.W       #$07,D6
            ROL.W       D0,D7    
            ROL.W       D1,D7  
            ROL.W       D2,D7    
            ROL.W       D3,D7 
            ROL.W       D4,D7    
            ROL.W       D5,D7
            ROL.W       D6,D7    
            ROL.W       D7,D7  
            
            ;ROL.W       $ABCD1234
            ;ROL.W       $20(A0)

*            ROL.W       (A0)            
*            ROL.W       -(A0)           
*            ROL.W       (A0)+
*            ROL.W       (A1)            
*            ROL.W       -(A1)           
*            ROL.W       (A1)+
*            ROL.W       (A2)            
*            ROL.W       -(A2)           
*            ROL.W       (A2)+
*            ROL.W       (A3)            
*            ROL.W       -(A3)           
*            ROL.W       (A3)+
*            ROL.W       (A4)            
*            ROL.W       -(A4)           
*            ROL.W       (A4)+
*            ROL.W       (A5)            
*            ROL.W       -(A5)           
*            ROL.W       (A5)+
*            ROL.W       (A6)            
*            ROL.W       -(A6)           
*            ROL.W       (A6)+
*            ROL.W       (A7)            
*            ROL.W       -(A7)           
*            ROL.W       (A7)+  

            ROL.L       #$01,D0
            ROL.L       #$02,D1
            ROL.L       #$03,D2
            ROL.L       #$04,D3
            ROL.L       #$05,D4
            ROL.L       #$06,D5
            ROL.L       #$07,D6
            ROL.L       D0,D7    
            ROL.L       D1,D7  
            ROL.L       D2,D7    
            ROL.L       D3,D7 
            ROL.L       D4,D7    
            ROL.L       D5,D7
            ROL.L       D6,D7    
            ROL.L       D7,D7  

            ROR.B       #$01,D0
            ROR.B       #$02,D1
            ROR.B       #$03,D2
            ROR.B       #$04,D3
            ROR.B       #$05,D4
            ROR.B       #$06,D5
            ROR.B       #$07,D6
            ROR.B       D0,D7    
            ROR.B       D1,D7  
            ROR.B       D2,D7    
            ROR.B       D3,D7 
            ROR.B       D4,D7    
            ROR.B       D5,D7
            ROR.B       D6,D7    
            ROR.B       D7,D7     

            ROR.W       #$01,D0
            ROR.W       #$02,D1
            ROR.W       #$03,D2
            ROR.W       #$04,D3
            ROR.W       #$05,D4
            ROR.W       #$06,D5
            ROR.W       #$07,D6
            ROR.W       D0,D7    
            ROR.W       D1,D7  
            ROR.W       D2,D7    
            ROR.W       D3,D7 
            ROR.W       D4,D7    
            ROR.W       D5,D7
            ROR.W       D6,D7    
            ROR.W       D7,D7 

            ;ROR.W       $ABCD1234
            ;ROR.W       $20(A0)

*            ROR.W       (A0)            
*            ROR.W       -(A0)           
*            ROR.W       (A0)+
*            ROR.W       (A1)            
*            ROR.W       -(A1)           
*            ROR.W       (A1)+
*            ROR.W       (A2)            
*            ROR.W       -(A2)           
*            ROR.W       (A2)+
*            ROR.W       (A3)            
*            ROR.W       -(A3)           
*            ROR.W       (A3)+
*            ROR.W       (A4)            
*            ROR.W       -(A4)           
*            ROR.W       (A4)+
*            ROR.W       (A5)            
*            ROR.W       -(A5)           
*            ROR.W       (A5)+
*            ROR.W       (A6)            
*            ROR.W       -(A6)           
*            ROR.W       (A6)+
*            ROR.W       (A7)            
*            ROR.W       -(A7)           
*            ROR.W       (A7)+  

            ROR.L       #$01,D0
            ROR.L       #$02,D1
            ROR.L       #$03,D2
            ROR.L       #$04,D3
            ROR.L       #$05,D4
            ROR.L       #$06,D5
            ROR.L       #$07,D6
            ROR.L       D0,D7    
            ROR.L       D1,D7  
            ROR.L       D2,D7    
            ROR.L       D3,D7 
            ROR.L       D4,D7    
            ROR.L       D5,D7
            ROR.L       D6,D7    
            ROR.L       D7,D7


*--------------------------Test the MOVE Op Code-----------------
label1      MOVE.B      $12,D6
            MOVE.W      $1234,D5
            MOVE.L      $12345678,D7
            MOVE.L      D2,$12345676
            MOVE.W      D3,$1234
            MOVE.B      D4,$12
            
            MOVE.L      A7,$12340012
            MOVE.W      A6,$1234

            MOVE.B      #$12,D5             *destroyed
            MOVE.W      #$1234,D5           *conqoured
            MOVE.L      #$12345678,D5       *decoded
            MOVE.W      D4,D5               *vaporized
            MOVE.L      D7,D5               *liqudated
            MOVEA.L     $1000AAAA,A2        *extinguished
            MOVEA.L     A5,A5               *merc'd
            MOVE.L      (A5)+,D2            *headshot
            MOVE.L      -(A5),D2            *crushed
            MOVE.W      D5,A5
            MOVE.L      A5,D6
            MOVE.W      D6,(A5)
            MOVE.L      D2,(A5)+
            MOVE.W      D2,-(A5)
            MOVE.W      D2,-(SP)
            MOVE.W      (SP),D5
            MOVE.W      -(SP),D5
            MOVE.W      (SP)+,D5
            MOVE.W      D5,(SP)
            MOVE.W      D5,(SP)+
                    
            ;MOVE.L      $00012346,$00345678
            ;MOVE.L      A2,$12345678
            ;MOVE.L      $12345678,A2
            ;MOVE.W      (A2),D2
            ;MOVE.W      -(A2),D2
            ;MOVE.W      (A2)+,D2
            ;MOVE.W      D1,D1
            ;MOVE.B      D2,D2
            ;MOVE.B      D3,D3
            ;MOVE.W      D4,D4
            ;MOVE.B      $78,D5
            ;MOVE.W      D6,D6
            ;MOVE.W      D7,D7
*---------------------------testing the <#data> type--------------
            ;MOVE.L      #$12345678,D2
            ;MOVE.W      #$1234,D5
            ;MOVE.B      #$12,D7
*---------------------------Test the MOVEA op Code-------------------
            ;MOVEA.L     A2,A4
            ;MOVEA.L     #$12345678,A6



            SIMHALT                     ; halt simulator
            END         START                ; last line of source
    
    
    



























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

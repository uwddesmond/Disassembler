*-----------------------------------------------------------
* Title      :  Team Visual Basic's Dissasembler: Testing File
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018   
* Description:  CSS 422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Testing file provides data for the dissasembler to test upon
*-----------------------------------------------------------
    
START       ORG         $00007F00            ; first instruction of program

*--------------------------Test the MOVE Op Code-----------------
label1      MOVE.B      $12,D6
            MOVE.W      $1234,D5
            MOVE.L      $12345678,D7
            MOVE.L      D2,$12345676
            MOVE.W      D3,$1234
            MOVE.B      D4,$12

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
            MOVE.W      D6,(A5)
            MOVE.L      D2,(A5)+
            MOVE.W      D2,-(A5)
            MOVE.W      D2,-(SP)
            MOVE.W      (SP),D5
            MOVE.W      -(SP),D5
            MOVE.W      (SP)+,D5
            MOVE.W      D5,(SP)
            MOVE.W      D5,(SP)+
            
*--------------------------MOVE has been defeated-----------------
            LSL.W       #$4,D3              *demolished
            LSL.B       #$2,D3              *obliterated
            LSL.L       #$6,D3              *slapped
            LSL.W       D4,D3
            LSR.W       D5,D6          
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

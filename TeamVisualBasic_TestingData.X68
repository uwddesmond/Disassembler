*-----------------------------------------------------------
* Title      :  Team Visual Basic's Dissasembler: Testing File
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/4/2018   
* Description:  CSS 422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Testing file provides data for the dissasembler to test upon
*-----------------------------------------------------------
    
START       ORG         $00007F00            ; first instruction of program

            NOP                         
            NOP
            NOP
            NOP
            JSR         label1
            RTS
            MOVE.L      #$22222222,D7
            MOVE.L      #$22222,D7
            MOVE.L      #$2222,D7
            MOVE.W      #$2222,D7
            ;MOVE.W      #$22222,D7


label1      NOP

            SIMHALT                     ; halt simulator
            END         START                ; last line of source
    
    
    



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
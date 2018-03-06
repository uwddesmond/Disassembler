*-----------------------------------------------------------
* Title      :  Team Visual Basic's Disassembler: Output Builder
* Written by :  Henry Hong, Dylan Desmond, Austin Abeyta
* Date       :  3/6/2018
* Description:  CSS422 Final Project
*               Machine code to Motorola 68000 Assembly
*               Output Builder generates the 
*                   0xADDR OPCODE $OPERAND
*               Sequence in order for printing purpose
*-----------------------------------------------------------

BUILD_STR   JSR         PREPARE_OP          ;Define a location in memory to write an OPCODE string to
            JSR         GET_ADDR            ;Accumulate the OPCODE's address into the A4 string [0xADDR]
            JSR         JT_START            ;Send OPCODE to jump table for decoding [OPCODE $OPERAND]
            
            RTS                             ;Return back to main disassembler loop

*-Prepare OPCODE REG----------------------------------------
PREPARE_OP  MOVE.W      #OP_ADDR,A4         ;Define a location in memory to write an OPCODE string to
            RTS
            
*-Accumulate the 0xADDR Into String-------------------------
GET_ADDR    MOVE.L      A5,D0               ;Save the address pointer into D0
            CLR.L       D2                  ;Clear D2
            MOVE.B      #8,D2               ;Counter var starts at 8
            
GA_LOOP     JSR         HEX_2_ASCII         ;Convert the hex to ascii for printing
            SUBI        #1,D2               ;Decrement counter var
            CMP.B       #0,D2               ;Is counter var == 0?
            BGT         GA_LOOP             ;If not, loop         
            
            MOVE.B      #' ',(A4)+           ;Otherwise, we are done. Append a space
            RTS                             ;Return back to main disassembler loop    

*-Accumulate the 0xADDR Into String-------------------------
HEX_2_ASCII ROL.L       #4,D0               ;Get the most significant hex digit into the right 4 bits
            MOVE.B      D0,D1               ;Save that byte into D1
            ANDI        #$0F,D1             ;Isolate the hex digit 
            
            CMP.B       #$9,D1              ;If hex digit is > 9
            BGT         APPND_ALPHA         ;It is an alphabet ascii char. Branch
            BRA         APPND_NUM           ;Else it is a numeric ascii char. Branch
            
APPND_ALPHA ADDI.B      #$37,D1             ;Add $37 to make it a ascii alphabet char
            MOVE.B      D1,(A4)+            ;Append this character to string
            RTS           

APPND_NUM   ADDI.B      #$30,D1             ;Add $30 to make it a ascii numeric char
            MOVE.B      D1,(A4)+            ;Append this character to string
            RTS
       

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

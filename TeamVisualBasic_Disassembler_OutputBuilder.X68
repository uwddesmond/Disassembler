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
            JSR         HEX_2_ASCII         ;Convert the hex to ascii for printing
            RTS          

*-Accumulate the 0xADDR Into String-------------------------
ASCII_2_HEX 
 
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~

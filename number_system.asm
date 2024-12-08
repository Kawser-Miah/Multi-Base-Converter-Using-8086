MSGPRINT MACRO STR 
MOV DX,OFFSET STR 
MOV AH,9 
INT 21H 
ENDM

MULTIPLE_DIGIT_PRINT MACRO MM, N,INTERFACE
    MOV AX,0
    
    MOV AL,MM
    MOV BX,0
    MOV BL,N
    MOV CX,0
    MOV SI,3
    
    MMOUTPUT&INTERFACE:
       DIV BL
       MOV DX,0
       MOV CL,AH
       MOV DL,AL
       ADD DL,30H
       
       MOV AH,2
       INT 21H
       
       MOV AX,0
       MOV AL,BL
       MOV DL,10
       DIV DL
       MOV BL,AL
       
       MOV AX,0       
       MOV AL,CL
       
       DEC SI       
       CMP SI,0
       JE END_MMLOOP&INTERFACE
       JMP MMOUTPUT&INTERFACE
       
       END_MMLOOP&INTERFACE:
    
    ENDM

DECIMAL_TO_BASE MACRO VALUE,N,INTERFACE
    MOV AX,0
    MOV AL,VALUE
    MOV BX,0
    MOV BL,N
    MOV SI,0
    
    DEVIDE&INTERFACE:
    DIV BL
    MOV ARRAY[SI],AH
    INC SI
    
    CMP AL,0
    JE ENDLOOP&INTERFACE
    MOV AH,0
    JMP DEVIDE&INTERFACE
    
    
    ENDLOOP&INTERFACE:
        
    
    
ENDM

BASE_TO_DECIMAL MACRO N,INTERFACE
    MOV SI,0
    MOV CX,0
    MOV CL,8
    ;MOV DI,7
    MOV DX,0
    MOV DL,0
    
    WHILE&INTERFACE:
    MOV AX,0
    MOV AL,INPUT_ARRAY[SI]
    CMP AL,0
    JE BR&INTERFACE
    
    MOV BX,0
    MOV BL,N    
    MULTIPLY BL,CX,INTERFACE
    MOV BX,0
    MOV BL,INPUT_ARRAY[SI]
    
    MUL BL
    ADD DL,AL
       
    
    BR&INTERFACE:
    INC SI
    
    LOOP WHILE&INTERFACE:
    
   
    MOV DECIMALINPUT,DL  
      
    
    
ENDM

MULTIPLY MACRO BASE,N,INTERFACE
    
    MOV AX,0
    MOV AL,BASE
    MOV DI,N
    ;MOV CX,N
    MOV BX,0
    MOV BL,AL
    
    DEC DI
    CMP DI,0
    JE EN1&INTERFACE
    CMP DI,1
    JE EN&INTERFACE
    DEC DI
    
    LOOPM&INTERFACE:
    MUL BL
    DEC DI
    
    CMP DI,0
    JE EN&INTERFACE 
    JMP LOOPM&INTERFACE
    
    
    EN1&INTERFACE:
    MOV AX,0
    MOV AX,1
    
    EN&INTERFACE:
    ENDM

ARAYPRINT MACRO N,INTERFACE 
    MOV CX,0
    MOV CL,N
    MOV SI,N
    DEC SI
    
    FORL&INTERFACE:
    MOV DX,0
    MOV DL,ARRAY[SI]
    CMP DL,9
    JG ADD37H&INTERFACE
    ADD DL,30H
    JMP PRINT&INTERFACE
    
    ADD37H&INTERFACE:    
    ADD DL,37H
    
    PRINT&INTERFACE:
    MOV AH,2
    INT 21H
    
    DEC SI
    
    LOOP FORL&INTERFACE:
     
    ENDM

.MODEL SMALL
.STACK 100H
.DATA

INP DB 0  ; HELP TO TAKE DECIMAL INPUT

DECIMALINPUT DB ?
ARRAY DB 8 (?)
INPUT_ARRAY DB 8 (?)

CHOICE DB "Please enter your choice: $"
DECIMAL DB "1.Decimal$"
BINARY DB "2.Binary$"
HEXA DB "3.HexaDecimal$"
OCTAL DB "4.OCTAL$"

INVATIDINPUT DW "You enter invalid input!!$"
DIN DW "Enter a Decimal Value: $"
BIN DW "Enter a Binary number(only 0 AND 1): $"
HIN DW "Enter a HexaDecimal number(only 0 AND 9,A,B,C,D,E,F): $"
OIN DW "Enter a Octal number(only 0 AND 7): $"

DM DW "Decimal: $"
BM DW "Binary: $"
HM DW "Hexa Decimal: $"
OM DW "Octal: $"

SELECT DB ?

.CODE
MAIN PROC
    MOV AX,@DATA
    MOV DS,AX   
          
    
    MSGPRINT DECIMAL
    CALL NEWLINE
    MSGPRINT BINARY
    CALL NEWLINE
    MSGPRINT HEXA
    CALL NEWLINE
    MSGPRINT OCTAL
    CALL NEWLINE
    MSGPRINT CHOICE
        
    CALL SINGLE_INPUT
    MOV SELECT,AL
    CMP AL,1
    JE _DECIMAL
    JL _ERROR
    CMP AL,2
    JE _BINARY
    CMP AL,3
    JE _HEXA
    CMP AL,4
    JE _OCTAL
    JG _ERROR
    
    _DECIMAL:
    CALL NEWLINE
    MSGPRINT DIN
    CALL MULTIPLE_INPUT
    
    MOV AL,INP
    MOV DECIMALINPUT,AL
    
    
    _SHORT:
    CALL NEWLINE
    CALL NEWLINE
    MSGPRINT DM
    MULTIPLE_DIGIT_PRINT DECIMALINPUT,100
    
    CALL ZERO ;INITILIZE ARRY AS 0
    DECIMAL_TO_BASE DECIMALINPUT,2,B ;CONVERT DECIMAL TO BINARY
    CALL NEWLINE
    MSGPRINT BM             
    ARAYPRINT 8,B
    
    CALL ZERO ;INITILIZE ARRY AS 0
    DECIMAL_TO_BASE DECIMALINPUT,16,H ;CONVERT DECIMAL TO HEXA
    CALL NEWLINE
    MSGPRINT HM
    ARAYPRINT 2,H
            
    CALL ZERO ;INITILIZE ARRY AS 0
    DECIMAL_TO_BASE DECIMALINPUT,8,O ;CONVERT DECIMAL TO OCTAL
    CALL NEWLINE
    MSGPRINT OM
    ARAYPRINT 3,O
    
    
    JMP _BREAK
    
    _BINARY:
   
    CALL NEWLINE
    MSGPRINT BIN
    CALL ZERO
    CALL ZERO2
    CALL BINARY_INPUT
   
    
    BASE_TO_DECIMAL 2,B
    
    JMP _SHORT
    ;CALL NEWLINE
   ; CALL NEWLINE
    ;MSGPRINT DM
    ;MULTIPLE_DIGIT_PRINT DECIMALINPUT,100,B_TO_D
    
    ;CALL ZERO ;INITILIZE ARRY AS 0
    ;DECIMAL_TO_BASE DECIMALINPUT,16,B_TO_H ;CONVERT DECIMAL TO HEXA
    ;CALL NEWLINE
   ; MSGPRINT HM
    ;ARAYPRINT 2,B_TO_H
    
    ;CALL ZERO ;INITILIZE ARRY AS 0
    ;DECIMAL_TO_BASE DECIMALINPUT,8,B_TO_O ;CONVERT DECIMAL TO OCTAL
    ;CALL NEWLINE
    ;MSGPRINT OM
    ;ARAYPRINT 3,B_TO_O
    
    
    
    
    JMP _BREAK
    
    _HEXA:
    CALL NEWLINE
    MSGPRINT HIN
    CALL ZERO
    CALL ZERO2
    CALL HEXA_INPUT
    BASE_TO_DECIMAL 16,H
    JMP _SHORT
    JMP _BREAK
    
    _OCTAL:
    CALL NEWLINE
    MSGPRINT OIN
    CALL ZERO
    CALL ZERO2
    CALL OCTAL_INPUT
    
    BASE_TO_DECIMAL 8,O
    JMP _SHORT
    JMP _BREAK
    
    _ERROR:
    CALL NEWLINE
    MSGPRINT INVATIDINPUT
    
    _BREAK:
    
   
    
    
    
    MOV AH, 4CH
    MOV AL,00
    INT 21H
    MAIN ENDP
NEWLINE PROC
    
    MOV AH,2
    MOV DL, 13
    INT 21H
    MOV DL,10
    INT 21H
    
    RET
    NEWLINE ENDP

SINGLE_INPUT PROC
    
    MOV AH,01
    INT 21H
    
    SUB AL,30H
    RET
    SINGLE_INPUT ENDP

MULTIPLE_INPUT PROC
    
    MOV BX,0
    MOV BL,10
    MOV CX,0
    MOV SI,3
    
    MOV INP,0
    INPUT_LOOP:
    CMP SI,0
    JE  END_LOOP ;CHECK FOR OVERFLOW
    MOV AH,01
    INT 21H
    
    CMP AL,13 ;IF FIND (ENTER) THEN IT WILL OFF TAKE INPUT
    JE END_LOOP
    
    SUB AL,30H
    MOV CL,AL
    MOV AL,INP
    MUL BL
    ADD AL,CL
    MOV INP,AL
    
    DEC SI
    
    JMP INPUT_LOOP
    
    
    END_LOOP:
    RET
    MULTIPLE_INPUT ENDP


BINARY_INPUT PROC
    MOV SI,0
    
    
    BYNARY_LOOP:
    CMP SI,8
    JE END_LOOP_B
    MOV AH,1
    INT 21H
    
    CMP AL,13
    JE END_LOOP_B
    SUB AL,30H
    CMP AL,1
    JG BYNARY_LOOP
    
    MOV ARRAY[SI],AL    
    INC SI
    JMP BYNARY_LOOP
    
    
    END_LOOP_B:
    
    MOV CX,0
    MOV CX,SI 
    
    DEC SI
    MOV DI,7
    
    COPY_B:
    MOV AX,0
    MOV AL,ARRAY[SI]
    MOV INPUT_ARRAY[DI],AL
    DEC SI
    DEC DI
    
    LOOP COPY_B:
    
    MOV AX,0FFFFH
    
    
   CMP DI,AX
   JE RETN
   MOV CX,0
   MOV CX,DI
   INC CL
   
   ZEROL:
   MOV INPUT_ARRAY[DI],0
   DEC DI
   LOOP ZEROL:
   
   
   RETN:    
    RET
    BINARY_INPUT ENDP

HEXA_INPUT PROC
    MOV SI,0
    
    
    HEXA_LOOP:
    CMP SI,2
    JE END_LOOP_H
    MOV AH,1
    INT 21H
    
    CMP AL,13
    JE END_LOOP_H
    CMP AL,57
    JG SUB37H
    SUB AL,30H
    JMP CONTI
    SUB37H:
    SUB AL,37H
    
    CONTI:
    CMP AL,15
    JG HEXA_LOOP
    
    MOV ARRAY[SI],AL    
    INC SI
    JMP HEXA_LOOP
    
    
    END_LOOP_H:
    
    MOV CX,0
    MOV CX,SI 
    
    DEC SI
    MOV DI,7
    
    COPY_H:
    MOV AX,0
    MOV AL,ARRAY[SI]
    MOV INPUT_ARRAY[DI],AL
    DEC SI
    DEC DI
    
    LOOP COPY_H:
    
    MOV AX,0FFFFH
    
    
   CMP DI,AX
   JE RETN_H
   MOV CX,0
   MOV CX,DI
   INC CL
   
   ZEROL_H:
   MOV INPUT_ARRAY[DI],0
   DEC DI
   LOOP ZEROL_H:
   
   
   RETN_H:    
    RET
    HEXA_INPUT ENDP


OCTAL_INPUT PROC
    MOV SI,0
    
    
    OCTAL_LOOP:
    CMP SI,3
    JE END_LOOP_O
    MOV AH,1
    INT 21H
    
    CMP AL,13
    JE END_LOOP_O
    SUB AL,30H
    CMP AL,7
    JG OCTAL_LOOP
    
    MOV ARRAY[SI],AL    
    INC SI
    JMP OCTAL_LOOP
    
    
    END_LOOP_O:
    
    MOV CX,0
    MOV CX,SI 
    
    DEC SI
    MOV DI,7
    
    COPY_O:
    MOV AX,0
    MOV AL,ARRAY[SI]
    MOV INPUT_ARRAY[DI],AL
    DEC SI
    DEC DI
    
    LOOP COPY_O:
    
    MOV AX,0FFFFH
    
    
   CMP DI,AX
   JE RETN_O
   MOV CX,0
   MOV CX,DI
   INC CL
   
   ZEROL_O:
   MOV INPUT_ARRAY[DI],0
   DEC DI
   LOOP ZEROL_O:
   
   
   RETN_O:    
    RET
    OCTAL_INPUT ENDP
    


ZERO PROC        ;MAKE ZERO ARRAY
    MOV CX,0
    MOV CL,8
    MOV SI,0
    
    A:
    MOV ARRAY[SI],0
    INC SI
    LOOP A:
    RET
    ZERO ENDP 

ZERO2 PROC     ;MAKE ZERO ARRAYINPUT ARRAY
    MOV CX,0
    MOV CL,8
    MOV SI,0
    
    ARRAYIN:
    MOV INPUT_ARRAY[SI],0
    INC SI
    LOOP ARRAYIN:
    RET
    ZERO2 ENDP






END MAIN 
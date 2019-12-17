TITLE "GPA Calculator"
INCLUDE Irvine32.inc

.DATA              
    ; Declaring some string and variables in order to use further...
     newline DB 0DH,0AH,"$",0
     welcome DB "********** Welcome to the GPA Calculator ***********$",0
     thanks DB 0DH,0AH,0DH,0AH,"Thanks for using our program. See you again... $",0 
     ask DB 0DH,0AH,0DH,0AH,"Now What you want to do?"
          DB 0DH,0AH,"1- GPA "
          DB 0DH,0AH,"2- Exit ",0DH,0AH,"Choose an Option: $",0
     invalid_ DB 0DH,0AH,"Your input is not valid. Please enter a valid input $",0
     subject DB 0DH,0AH,0DH,0AH,"How many subjects do you have in your semester?",0DH,0AH," $",0
     grade DB 0DH,0AH,0DH,0AH,"Enter the grade of subject $",0
     invalidG DB 0DH,0AH,"The grade you entered is invalid. Please enter a valid grade  $" ,0
     invalid DB 0DH,0AH,"Your input is not valid please enter a valid input from 1 to 9.",0DH,0AH," $",0
     creditHour DB 0DH,0AH,"Now enter the credit hours of that subject",0DH,0AH,"$",0
	 nSub DB ?
     show DB 0AH,0DH,"Your GPA is :  ",0
     
	 numArray REAL8 1 DUP(4.0,3.7,3.3,3.0,2.7,2.3,2.0,1.7,1.3,1.0,0.0)
	 i DB ?
     var REAL4 ?,?     
     total REAL4 0.0
     tch REAL4 0.0
     result REAL4 ?,?
	 temp REAL4 ?
	 filename BYTE "newfile.txt",0
	 fileHandler dword ?
	msg1 byte 13 dup(?)
	msg byte "GPA",0
     
.CODE
main PROC
   ; Display welcome string
     mov edx,offset welcome
     call writeString 
     
   ; Calculating the GPA...
     GPA: 
		mov i,0
      ; Asking for number of subjects
        lea dx,subject
        call displayString
        TakeS:
        call readInt
      ; Saving number of subjects in cl for comparasion of loop
        mov cl,al
		mov i,al
        cmp cl,0               ; 0 is an invalid value
        JE not_valid
        cmp cl,9               ; value greater than 9 is also invalid
        JG not_valid 
        Next:  
          ; Asking for grade
            lea dx,grade
            call displayString
            mov dl,i
            add dl,30h
            lea dx,newline       ; newline
            call displayString
            call readChar
			call displayChr
          ; moving grade into bl and computing its gpa value
            mov bl,al
            call compute 
            
          ; Taking number of credit hours of subject
            lea dx,creditHour
            call displayString
            
            takeC:
                call readInt
                cmp al,0               ; 0 is an invalid value
                JE notvalid
                cmp al,9               ; value greater than 9 is also invalid
                JG notvalid 

            add tch,eax  ; Adding to total credit hours
            mov bl,al
			mov temp,eax

            fild temp
			fmul
			fild total
			fadd
			fst total
			
          ; Multiply subjects grade with credit hours
            ;call multiply
            
          ; add subject gpa to total
            ;call sum
            dec i
        cmp i,0        ; Reapet loop untill i becomes cl
        JNE Next       
        
      ; Divide total GPA by tch to compute the result
        
        fild tch
		fdiv
      ; Displaying the result
        lea dx,show
        call displayString
		call writeFloat
        ;call ComputeResult
        JMP askForAgain  
        
      ; For invalid credit hours value...
        notValid:
             lea dx,invalid
             call displayString
             JMP takeC
             
      ; For invalid number of Subjects...
        not_Valid:
             lea dx,invalid
             call displayString
             JMP takeS           
       
      ; Asking user if he wants to continue or not          
        askForAgain:
             lea dx,ask
             call displayString
             lea dx,newline       ; newline
             call displayString
            
           ; Getting user choice in al
             Choice:
             call readInt
             cmp al,1
             JE GPA
             cmp al,2
             JE ExitP
             lea dx,invalid_
             call displayString
             JMP Choice
             
        
        ExitP: 
             ; Thanks note
             lea dx,thanks
             call displayString 
			 mov edx,OFFSET filename
	
	call CreateOutputFile;	Or OpenInputFile

	mov fileHandler, eax;	File Handler
	mov edx, offset msg	;	Msg to be read/write
	mov ecx, sizeof msg	;	Size of the Msg
	
	Call WriteToFile
	mov eax, fileHandler
	Call closefile

	;

	mov edx, offset filename
	call OpenInputFile
	;
	mov edx, offset msg1
	mov ecx, sizeof msg1

	Call ReadFromFile
	
	; Printing String from Msg1
	

	mov edx, offset msg1
	call WriteString
	
	call readInt   

exit 
main ENDP


; Function to display character value
displayChr PROC
     ;mov ah,02h
     ;int 21h
	 call writeChar
  ret
displayChr ENDP 
 
; Displaying string 
displayString PROC
     ;mov al,09h
     ;int 21h
	 call writeString
   ret
displayString ENDP

; Taking input in al
input PROC
     ;mov al,01h
     ;int 21h
	 call readInt
   ret
input ENDP
 
; Computing gpa corresponding to a grade 
compute PROC 
      up:
      cmp bl,'A'
      JE A
      cmp bl,'B'
      JE B
      cmp bl,'C'
      JE CGrade
      cmp bl,'D'
      JE D
      cmp bl,'F'
      JE F
      call invalidGrade      ; Any input other than above will be invalid
      A:
        call readChar
		call writeChar
        cmp al,'+'           ; A+ grade
        JE AA      
        cmp al,0dh           ; A  grade
        JE AA
        cmp al,'-'           ; A- grade
        JE A_
        call invalidGrade    ; If input is other than A+ or A-
      ; For A and A+ GPA will be 4.0
        AA:
           fld numArray
           JMP _Exit
      ; For A- GPA will be 3.7
        A_:
           fld numArray+4
           JMP _Exit
      B: 
        call readChar
		call writeChar
        cmp al,'+'           ; B+ grade
        JE BPositive
        cmp al,'-'           ; B- grade
        JE BNegative
        cmp al,0DH           ; B grade
        JE BB                
        call invalidGrade    ; If input is other than B+ or B- 
        
      ; For B grade GPA will be 3.0  
        BPositive:
          fld numArray+8
           JMP _Exit                 
           
      ; For B+ grade GPA will be 3.3            
        BB:
           fld numArray+12
           JMP _Exit       
           
      ; For B- grade GPA will be 2.7
        BNegative:
           fld numArray+16
           JMP _Exit
      CGrade:
        call readChar
		call writeChar
        cmp al,'+'          ; C+ grade
        JE CPositive
        cmp al,'-'          ; C- grade
        JE CNegative     
        cmp al,0DH          ; C  grade
        JE CC
        call invalidGrade   ; If input is other than C+ or C-
        
      ; For C grade GPA will be 2.0  
        CPositive:
           fld numArray+20
           JMP _Exit  
      ; For C+ grade GPA will be 2.3          
        CC:
           fld numArray+24
           JMP _Exit 
      ; For C- grade GPA will be 1.7
        CNegative:
           fld numArray+28
           JMP _Exit
      D:
        call readChar
		call writeChar
        cmp al,'+'           ; D+ grade
        JE DPositive        
        cmp al,'-'           ; D- grade
        JE DNegative         
        cmp al,0DH           ; D  grade
        JE DGrade
        call invalidGrade    ; If input is other than D+ or D-
         
      ; For D grade GPA will be 1.0  
        DPositive:
           fld numArray+32
           JMP _Exit 
      ; For D+ grade GPA will be 1.3           
        DGrade:
           fld numArray+36
           JMP _Exit  
      ; For D- grade GPA will be 0.7
        DNegative:
           fld numArray+40
           JMP _Exit
           
    ; For F grade GPA will be 0.0
      F:
        fld numArray+40
        JMP _Exit
        
     invalidGrade:  
      ; Asking for a valid grade...
        lea dx,invalidG
        call displayString
        lea dx,newline       ;newline
        call displayString
        call readChar
		call writeChar
        mov bl,al
        JMP up
      
     _Exit:
   ret
compute ENDP

; Multiplying subject's gpa with credit hours
multiply PROC
	mov temp,ebx
	fild temp
   fmul
   ret
multiply ENDP

; Adding gpa of all subjects to total...
sum PROC    
      fld total
	  fadd
	  fstp total
  ret
sum ENDP

; Divide total gpa with total number of credit hours to compute final gpa...
ComputeResult PROC
	mov eax,tch
     mov  temp,eax
	 fild temp
	 fdiv 
	 call writeFloat
  ret
ComputeResult ENDP 
            
; Displaying a three character number....            
display PROC 
      mov ax,00h
      mov al,bl
          mov bl,100
          div bl
          mov cl,al
          mov al,ah
          mov ah,0h
          mov bl,10
          div bl
          mov bl,ah
          mov ch,al
          mov dl,cl
          add dl,30h
          mov ah,02h
          cmp dl,30h
          JE M
          int 21h
          M:
          mov dl,ch
          add dl,30h
         ; int 21h
          mov dl,bl
          add dl,30h
          int 21h
  ret 
display ENDP

END main

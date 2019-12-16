
TITLE "GPA Calculator"
INCLUDE Irvine32.inc

.DATA              
    ; Declaring some string and variables in order to use further...
     newline DB 0DH,0AH,"$",0
     welcome DB "********** Welcome to the GPA Calculator ***********$",0
     thanks DB 0DH,0AH,0DH,0AH,"Thanks for using our program. See you again... $",0 
     ask DB 0DH,0AH,0DH,0AH,"Now What you want to do?"
          DB 0DH,0AH,"1- GPA "
          DB 0DH,0AH,"2- Exit ",0DH,0AH," $",0
     invalid_ DB 0DH,0AH,"Your input is not valid. Please enter a valid input $",0
     subject DB 0DH,0AH,0DH,0AH,"How many subjects do you have in your semester?",0DH,0AH," $",0
     grade DB 0DH,0AH,0DH,0AH,"Enter the grade of subject $",0
     invalidG DB 0DH,0AH,"The grade you entered is invalid. Please enter a valid grade  $" ,0
     invalid DB 0DH,0AH,"Your input is not valid please enter a valid input from 1 to 9.",0DH,0AH," $",0
     creditHour DB 0DH,0AH,"Now enter the credit hours of that subject",0DH,0AH,"$",0
	 nSub DB ?
     show DB 0AH,0DH,"Your GPA is :  $",0
     
     i DB ?

     var DB ?,?     
     total DB 0,0
     tch DB 0
     result DB ?,?
     
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
          ; Increamenting the loop value
           
            
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
                
            add tch,al  ; Adding to total credit hours
            mov bl,al   
            
          ; Multiply subjects grade with credit hours
            call multiply      
            
          ; add subject gpa to total
            call sum           
            dec i
        cmp i,0        ; Reapet loop untill i becomes cl
        JNE Next       
        
      ; Divide total GPA by tch to compute the result
        call ComputeResult
        
      ; Displaying the result
        lea dx,show
        call displayString
        mov dl,result
        add dl,30h
        call writeInt
        mov dl,'.'
        call writeInt
        mov bx,0
        mov dl,result+1
        call WriteInt
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
        cmp al,0DH           ; A  grade
        JE AA
        cmp al,'-'           ; A- grade
        JE A_
        call invalidGrade    ; If input is other than A+ or A-
      ; For A and A+ GPA will be 4.0
        AA:
           mov var,4
           mov var+1,0
           JMP _Exit
      ; For A- GPA will be 3.7
        A_:
           mov var,3
           mov var+1,7
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
        BB:
           mov var,3
           mov var+1,0
           JMP _Exit                 
           
      ; For B+ grade GPA will be 3.3            
        BPositive:
           mov var,3
           mov var+1,3
           JMP _Exit       
           
      ; For B- grade GPA will be 2.7
        BNegative:
           mov var,2
           mov var+1,7
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
        CC:
           mov var,2
           mov var+1,0
           JMP _Exit  
      ; For C+ grade GPA will be 2.3          
        CPositive:
           mov var,2
           mov var+1,3
           JMP _Exit 
      ; For C- grade GPA will be 1.7
        CNegative:
           mov var,1
           mov var+1,7
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
        DGrade:
           mov var,1
           mov var+1,0
           JMP _Exit 
      ; For D+ grade GPA will be 1.3           
        DPositive:
           mov var,1
           mov var+1,3
           JMP _Exit  
      ; For D- grade GPA will be 0.7
        DNegative:
           mov var,0
           mov var+1,7
           JMP _Exit
           
    ; For F grade GPA will be 0.0
      F:
        mov var,0
        mov var+1,0 
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
      mov ax,0h
      mov al,var+1
      mul bl
      mov var+1,al
      mov ax,0h
      mov al,var
      mul bl
      mov var,al 
      mov bl,var+1
      
      mov ax,0h
      mov al,var+1
      mov bl,10
      div bl
      cmp al,0
      JE Exit_
        add var,al
        mov var+1,ah
      Exit_:      
   ret
multiply ENDP

; Adding gpa of all subjects to total...
sum PROC    
      mov bl,var
      add total,bl
      mov bl,var+1
      add total+1,bl
      mov bl,total
      
      mov ax,0h
      mov al,total+1
      mov bl,10
      div bl
      cmp al,0
      JE Exitt
        add total,al
        mov total+1,ah
      Exitt: 
  ret
sum ENDP

; Divide total gpa with total number of credit hours to compute final gpa...
ComputeResult PROC
     mov ax,0h
     mov al,total
     mov bl,tch
     div bl
     mov result,al
     mov al,ah    
     cmp al,0
     JE Skip
     mov ah,0h
     mov cl,10
     mul cl
     add al,total+1
     div bl
     Skip:
     mov result+1,al
     
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

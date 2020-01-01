TITLE "GPA Calculator"
INCLUDE Irvine32.inc
IncludeLib Irvine32.lib
IncludeLib Kernel32.lib
IncludeLib User32.lib

.DATA              
    ; Declaring some string and variables in order to use further...
     newline DB 0DH,0AH,"$",0
     welcome BYTE " *******************************************", 0ah, 0dh
			 BYTE "	      WelCome To GPA Calculator	", 0ah, 0dh
			 BYTE " ******************************************* ", 0ah, 0dh, 0
      
     ask DB 0DH,0AH,0DH,0AH,"Now What you want to do?"
          DB 0DH,0AH,"1- GPA "
          DB 0DH,0AH,"2- CGPA "
		  DB 0DH,0AH,"3- RETURN BACK ",0DH,0AH,"Choose an Option: $ ",0
     invalid_ DB 0DH,0AH,"Your input is not valid. Please Enter a valid input: $ ",0
     subject DB 0DH,0AH,0DH,0AH,"How many Subjects do you have in your Semester?",0DH,0AH,"$ ",0
     grade DB 0DH,0AH,0DH,0AH,"Enter the Grade of Subject : $ ",0
     invalidG DB 0DH,0AH,"The Grade you Entered is invalid. Please Enter a valid Grade: $ " ,0
     invalid DB 0DH,0AH,"Your input is not valid. Please Enter a valid input from 1 to 9.",0DH,0AH,"$ ",0
     creditHour DB 0DH,0AH,"Now Enter the Credit Hours of that Subject",0DH,0AH,"$ ",0
	 login DB 0DH,0AH,0DH,0AH,"Please Select an Option"
          DB 0DH,0AH,"1- LOG-IN "
          DB 0DH,0AH,"2- RESET PASSWORD "
		  DB 0DH,0AH,"3- LOG-OUT",0DH,0AH,"Choose an Option: $",0
	 nSub DB ?
     show DB 0AH,0DH,"****** Your GPA is :  ",0
	 showCgpa DB 0AH,0DH,"****** Your CGPA is :  ",0
     numArray REAL4 1 DUP(4.0,3.7,3.3,3.0,2.7,2.3,2.0,1.7,1.3,1.0,0.0)
     i DB ?
     var REAL4 ?,?     
     total REAL4 0.0
     tch DWORD 0
     result REAL4 ?,?
	 temp REAL4 ?
	 count Byte 0
	 writeWindowMsg BYTE "File is Not Open Successfully!",0,0DH,0AH
	 inputSem DB 0DH,0AH,"Enter the Total Previous Semester :",0DH,0AH,"$ ",0
	 inputGPA DB 0DH,0AH,"Enter the GPA of Previous Semester :",0DH,0AH,"$ ",0
	 outputCgpa DB 0DH,0AH,"Your CGPA is :",0

BUFFER_SIZE   = 5000
PASSWORD_SIZE = 15                                                ; Max Pass User can Set....
INPUT_SIZE    = 17                                                ; Max User can give as Input...
bool     DWORD ?                                                  ; To store the result of Check... 
byteRead DWORD ?                                                  ; To store read Bytes from File...
fHandle  DWORD ?                                                  ; To store File Handle...                                                ; To store copy
dealRep  DWORD ?  
bytWrite DWORD ?
passFile BYTE  PASSWORD_SIZE DUP(?)                               ; To store the Password from File...
userPass BYTE  INPUT_SIZE DUP(?)                                  ; To store the Input Password...
gpaFile	 BYTE   PASSWORD_SIZE DUP(?)  

choice  BYTE "*********************************",0DH,0AH 
		BYTE "Successfully Login To Our Service",0DH,0Ah
		BYTE "*********************************",0DH,0AH,0

passFileName BYTE "Password.txt", 0
gpaFileName BYTE "Cgpa.txt", 0
passWord BYTE " Enter Password :$ ", 0
newPass  BYTE " Enter New Password less than 16 Characters :$ ", 0
wrongPas BYTE " *******************************************", 0ah, 0dh
         BYTE " |Password is incorrect or Input is Invalid.|", 0ah, 0dh
		 BYTE " ******************************************* ", 0ah, 0dh, 0
confirm  BYTE " New Password is Set. ", 0ah, 0dh, 0
caption  BYTE " Error ", 0
errMsg   BYTE " Please follow instructions correctly... ", 0
thanks	 BYTE "***********************************", 0ah, 0dh
         BYTE "|Thank You for Using Our Services |", 0ah, 0dh
		 BYTE "***********************************", 0ah, 0dh, 0
buff     DB 11 dup(?)

.CODE
inputPass        PROTO, passString :PTR BYTE					
StringToInt		 PROTO, gpaString:PTR BYTE
main PROC
   ; Display welcome string
     mov edx, OFFSET welcome                                      ; Printing Welcome...
	 call writeString
     op:
	    call crlf
	    mov edx, OFFSET login                                        ; Printing login...
		call writeString
		call crlf
		call readInt
		cmp eax, 1
		je ad
		cmp eax, 2
		je reset
		cmp eax, 3
		je  _exit
		call error                                                ; calling error Proc...
		jmp  op
		ad:                                                       ; Admin Tag...
		   call admin
		   jmp op
		reset:
			call ResetPassword
			jmp op

		_exit:
		exit
main ENDP


;-------------------------------------------------------------------
;| Call to User Procedure	                                        |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------
User Proc
PUSHAD
PUSHFD
	 askForAgain:
             lea dx,ask
             call displayString
	 ; Getting user choice in al
             Choices:
             call readInt
             cmp al,1
             JE GPA
			 cmp al,2
			 JE CGPA
             cmp al,3
             JE ExitP
             lea dx,invalid_
             call displayString
             JMP Choices
             

			 ;Calculating the CGPA
			 CGPA:
			 call readGpaFile
			 mov edx,offset show
			 call writeString
			 mov edx,offset gpaFile
			 call writeString
			 call crlf
			 call crlf
			 lea dx,inputSem
			 call writeString
			
			 call readInt
			 
			 mov ecx,eax
			 mov ebx,0
			 mov temp,ebx
			 fild temp

			 gpaLoop:
			 lea dx,inputGpa
			 call writeString
			 call readFloat
			 fadd 
			 LOOP gpaLoop

			 mov temp,eax
			 fild temp
			 fdiv 
			 lea dx,outputCgpa
			 call writeString
			 call writeFloat

			 call writegpa
			 jmp AskForAgain
   ; Calculating the GPA...
     GPA: 
		mov i,0							; Asking for number of subjects
      
        lea dx,subject
        call displayString
        TakeS:
        call readInt
      
        mov cl,al					; Saving number of subjects in cl for comparasion of loop
		mov i,al
        cmp cl,0               ; 0 is an invalid value
        JE not_valid
        cmp cl,9               ; value greater than 9 is also invalid
        JG not_valid 
        Next:  
         
         
            lea dx,grade			 ; Asking for grade
            call displayString
            lea dx,newline       ; newline
            call displayString
            call readChar 
			call displayChr
             
			
          
            mov bl,al						; moving grade into bl and computing its gpa value
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
            
          ; Multiply subjects grade with credit hours
            call multiply      
            
          ; add subject gpa to total
            call sum   
            dec i
        cmp i,0        ; Reapet loop untill i becomes cl
        JNE Next       
        
      ; Divide total GPA by tch to compute the result
      ; Displaying the result
        lea dx,show
        call displayString
        call ComputeResult
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
	   
        ExitP: 
             ; Thanks note
			 call crlf
			 call crlf
             lea dx,thanks
             call displayString
			 POPAD
			 POPFD
ret
User ENDP
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
	mov temp,eax
	fild temp
   fmul
   ret
multiply ENDP

; Adding gpa of all subjects to total...
sum PROC    
      fld total
	  fadd
	  fst total

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

inputString proc
                MOV AH,01H
				mov ebx,0
         READ:
                call readChar
				call writeChar
                CMP AL,0DH
				je _exit
				inc ebx
                JMP READ
			_exit: 
			ret
inputString ENDP

;-------------------------------------------------------------------
;| Read password from User...                                       |
;| Uses: passFile string to Password...                             |
;-------------------------------------------------------------------

StringToInt Proc,gpaString:PTR BYTE
pushad
pushfd
mov esi,gpaString ; our string
mov ecx,lengthof gpaString
atoi:
xor eax, eax ; zero a "result so far"
top:
movzx edx, byte PTR [esi] ; get a character
inc esi ; ready for next one
cmp edx, '0' ; valid?
jb done
cmp edx, '9'
ja done
sub edx, '0' ; "convert" character to number
imul eax, 10 ; multiply "result so far" by ten
add eax, edx ; add in current digit
jmp top ; until done
LOOP top

done:
popfd
popad
ret
StringToInt ENDP


admin PROC
       PUSHAD
	   PUSHFD
	   call crlf
	   call readPasswordFile                                      ; To read Password from file...
	   cmp bool, 0
	   je _exit					                            ; Bool will be 0 if something was wrong in readPasswordFile...
	   
	   INVOKE inputPass, ADDR passWord                            ; Take input from user...

	   call check                                                 ; Check both strings are equal...

	   cmp bool, 0                                                ; Check stores result in bool...
	   je wrong

		  call crlf
	      mov edx, OFFSET choice
		  call writeString
		                                                 
			 call User
			 call crlf
			 call crlf                                                ; Reset Password Tag...
		    jmp _exit
 wrong:                                                           ; Wrong Password block..
	   call crlf
       mov edx, OFFSET wrongPas                                   ; Wrong Password Message...
	   call writeString

 _exit:
	   POPFD
	   POPAD

	   RET
admin ENDP

;-------------------------------------------------------------------
;| Read password from User...                                       |
;| Uses: passFile string to Password...                             |
;-------------------------------------------------------------------

inputPass PROC passString :PTR BYTE	
		   PUSHAD
		   PUSHFD

		   mov edx, passString 
	       call writeString

	       mov edx, OFFSET userPass                               ; Point to the Destination...
           mov ecx, INPUT_SIZE                                    ; Specify max characters...
	       call readString                                        ; Take input from user...

           mov byteRead, eax                                      ; Bytes user write...

	 _exit:
		   POPFD
	       POPAD

		   RET
inputPass ENDP


;-------------------------------------------------------------------
;| Read password from Password File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

readPasswordFile PROC
			      PUSHAD
			      PUSHFD
			      INVOKE CreateFile,
                         ADDR passFileName,
                         GENERIC_READ,
                         DO_NOT_SHARE,
                         NULL,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0

			      cmp eax, INVALID_HANDLE_VALUE                   ; Checking if handle is valid...
			      je err

			      mov fHandle, eax                                ; Just for safety...      

	              mov edx, OFFSET passFile                        ; Storage string...
	              mov ecx, PASSWORD_SIZE                          ; Max buffer....
	              call ReadFromFile

	              jc err                                  ; If file is not Read Carry will be set...

			      mov byteRead, ecx                               ; No of bytes read from file...
			  
			      INVOKE CloseHandle, fHandle                     ; Calling CloseHandle function...
              
			      cmp eax, 0                                      ; Non-Zero eax means Close File...
                  je err

			      mov bool, 1                                     ; If everything is OK.
			      jmp _exit
 
			      err:                                            ; File Opening Error block... 
	                  call WriteWindowsMsg
				      mov bool, 0                                 ; if does not open

	        _exit:
		          POPFD
	              POPAD

			      RET
readPasswordFile ENDP

;-------------------------------------------------------------------
;| Read password from Password File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

writePassword PROC
			   PUSHAD
			   PUSHFD

			   INVOKE CreateFile,
                      ADDR passFileName,
                      GENERIC_WRITE,
                      DO_NOT_SHARE,
                      NULL,
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL,
                      0

               cmp eax, INVALID_HANDLE_VALUE                      ; Checking if handle is valid...
			   je err

               mov fHandle, eax                                   ; Copy handle to variable...

			   INVOKE WriteFile,
                      fHandle,
                      ADDR   userPass,
                      SIZEOF userPass,
                      ADDR   bytWrite,
                      0

               INVOKE CloseHandle, fHandle

			   mov bool, 1                                        ; If everything is OK.
			   jmp _exit
 
			   err:                                               ; File Opening Error block... 
	               call WriteWindowsMsg
				   mov bool, 0                                    ; if does not open

	     _exit:
		       POPFD
	           POPAD

			   RET
writePassword ENDP

;-------------------------------------------------------------------
;| Read GPA from GPA File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

readGpaFile PROC
			      PUSHAD
			      PUSHFD
			      INVOKE CreateFile,
                         ADDR gpaFileName,
                         GENERIC_READ,
                         DO_NOT_SHARE,
                         NULL,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0

			      cmp eax, INVALID_HANDLE_VALUE                   ; Checking if handle is valid...
			      je err

			      mov fHandle, eax                                ; Just for safety...      

	              mov edx, OFFSET gpaFile                        ; Storage string...
	              mov ecx, Sizeof PASSWORD_SIZE                         ; Max buffer....
	              call ReadFromFile

	              jc err                                  ; If file is not Read Carry will be set...

			      mov byteRead, ecx                               ; No of bytes read from file...
			  
			      INVOKE CloseHandle, fHandle                     ; Calling CloseHandle function...
              
			      cmp eax, 0                                      ; Non-Zero eax means Close File...
                  je err

			      mov bool, 1                                     ; If everything is OK.
			      jmp _exit
 
			      err:                                            ; File Opening Error block... 
	                  call WriteWindowsMsg
				      mov bool, 0                                 ; if does not open

	        _exit:
		          POPFD
	              POPAD

			      RET
readGpaFile ENDP

;-------------------------------------------------------------------
;| Read password from Password File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

writeGpa PROC
			   PUSHAD
			   PUSHFD

			   INVOKE CreateFile,
                      ADDR gpaFileName,
                      GENERIC_WRITE,
                      DO_NOT_SHARE,
                      NULL,
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL,
                      0

               cmp eax, INVALID_HANDLE_VALUE                      ; Checking if handle is valid...
			   je err

               mov fHandle, eax                                   ; Copy handle to variable...

			   INVOKE WriteFile,
                      fHandle,
                      ADDR   gpaFile,
                      SIZEOF gpaFile,
                      ADDR   bytWrite,
                      0

               INVOKE CloseHandle, fHandle

			   mov bool, 1                                        ; If everything is OK.
			   jmp _exit
 
			   err:                                               ; File Opening Error block... 
	               call WriteWindowsMsg
				   mov bool, 0                                    ; if does not open

	     _exit:
		       POPFD
	           POPAD

			   RET
writeGpa ENDP

;-------------------------------------------------------------------
;| Check password from Password File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

check PROC
       PUSHAD
	   PUSHFD

	   mov eax, byteread
	   cmp eax, PASSWORD_SIZE
	   jg notEqual
	                            ; lea: load effective address is like combination of move and offset...
	   lea esi, passfile                                          ; ds:si points to file password string...
       lea edi, userpass                                          ; ds:di points to input password string...

       lab:
            mov bl, [edi]                                         ; Moving to bl... 
			inc di                                                ; inc to get next character...
            lodsb                                                 ; load al with next char from passFile...
                                                                  ; note: lodsb inc si automatically...
            cmp al, bl                                            ; compare characters...
            jne notEqual                                          ; jump out of loop if not equal...
 
            cmp al, 0                                             ; they are the same, but end of string?
            jne lab                                               ; no - so go round loop again

            mov bool, 1
	        jmp _exit                                             ; to save from executing notEqual tag...

       notEqual:
	            mov bool, 0

 _exit:
	   POPFD
	   POPAD

	   RET
check ENDP
;-------------------------------------------------------------------
;| Shows an Error Box to customers...                               |
;| Uses:  2 strings for an input   box...                           |
;| Advan: It also works as a pause...                               |
;-------------------------------------------------------------------
error PROC
       PUSHAD
	   PUSHFD

	   call crlf

       mov ebx, OFFSET caption
	   mov edx, OFFSET errMsg
	   call msgBox
	   POPFD
	   POPAD

	   RET
error ENDP

;-------------------------------------------------------------------
;| Reset password from Password File...                              |
;| Uses: passFile string to store password...                       |
;| booL = 1 (operation succeeded) && bool = 0 (operation failed)    |
;-------------------------------------------------------------------

ResetPassword Proc
			PUSHAD
			PUSHFD
			call crlf
		     INVOKE inputPass, ADDR passWord                      ; Asking for old Password again...               
		     call check                                           ; Rechecking Pass before Changing...

		     cmp bool, 0
		     je wrongReset

             INVOKE inputPass, ADDR newPass                       ; Taking new Password again...

			 mov eax, byteRead
			 cmp eax, PASSWORD_SIZE                               ; To check our limit...
			 jg wrongReset

			 call writePassword

			 call crlf
			 mov edx, OFFSET confirm
		     call writeString

			 jmp _exit
 wrongReset:
			call crlf
            mov edx, OFFSET wrongPas                              ; Wrong Password Message...
	        call writeString
			
_exit:
POPAD
POPFD

ret
ResetPassword ENDP
END main

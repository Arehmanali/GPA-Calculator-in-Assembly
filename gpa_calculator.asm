INCLUDE Irvine32.inc 

.data
inputGrades BYTE "Please enter the grade of subject:",0
creditHour dword 25 DUP(?)
gpa REAL4 ?
creditH byte 0
sum REAL4 0
grade BYTE ?
inputCredit BYTE "Please enter the credit Hours of Previous entered subject:",0
gradeList BYTE 20 DUP(?)
numOfSubjects dword ?
numArray  REAL8 1 dup(4.0,3.7,3.3,3.0,2.7,2.3,2.0,1.7,1.3,1.0,0.0)
temp dword ?
inputSubjects BYTE "Please enter the number of Subjects: ",0
.code 
main PROC

mov edx,offset inputSubjects
call writeString
call readInt
mov numOfSubjects,eax
call inputGrade
call evaluate
call writeInt
call readInt
exit 
main ENDP

inputGrade PROC
mov  ecx, numOfSubjects
mov esi, 0
mov edi, 0
L1:
mov edx,offset inputGrades
call writeString
call readstring
call crlf
mov gradeList[si], al

mov edx, offset inputCredit
call writeString
call readInt
mov creditHour[edi], eax
add creditH, al
inc esi
inc edi
Loop L1
ret
 inputGrade ENDP

evaluate PROC
mov ecx,numOfSubjects
mov esi,0
mov edi,0
LOOP1:
mov al,gradeList[esi]
mov grade,al
.IF grade[edi]=='A' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray
fstp temp
fadd sum, temp

.ELSEIF grade[edi]=='A' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+4
fadd sum, eax

.ELSEIF grade[edi]=='A' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+8
fadd sum, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+12
fadd sum, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+16
fadd sum, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+20
fadd sum, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+24
fadd sum, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]==''
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+28
fadd sum, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+32
fadd sum, eax

.ELSEIF grade[edi]=='D' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+36
fadd sum, eax

.ELSEIF grade[edi]=='D' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+40
fstp temp
mov eax,temp
fadd sum, eax

.ELSEIF grade[edi]=='F' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
mov temp,eax
fild temp
fmul numArray+44
fadd sum, temp
.ENDIF
inc esi
loop LOOP1

ret
evaluate ENDP

totalGpa PROC




ret
totalGpa ENDP


END main

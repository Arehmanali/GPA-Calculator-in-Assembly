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
mov ebx,4
mul ebx
add sum, eax

.ELSEIF grade[edi]=='A' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mov ebx,4
mul ebx
add sum, eax

.ELSEIF grade[edi]=='A' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mov ebx,3.7
mul ebx
add sm, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]=='0dh'
mov eax,creditHour[esi+4]
mul 3.0
add sm, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mul 3.3
add sm, eax

.ELSEIF grade[edi]=='B' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mul 2.7
add sm, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mul 2.3
add sm, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]==''
mov eax,creditHour[esi+4]
mul 2.0
add sm, eax

.ELSEIF grade[edi]=='C' && grade[edi+1]=='-'
mov eax,creditHour[esi+4]
mul 1.7
add sm, eax

.ELSEIF grade[edi]=='D' && grade[edi+1]=='+'
mov eax,creditHour[esi+4]
mul 1.3
add sm, eax

.ELSEIF grade[edi]=='D' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
add sm, eax

.ELSEIF grade[edi]=='F' && grade[edi+1]==' '
mov eax,creditHour[esi+4]
mov ebx,0
mul ebx
add sm, eax
.ENDIF
inc esi
loop LOOP1

ret
evaluate ENDP

totalGpa PROC




ret
totalGpa ENDP


END main

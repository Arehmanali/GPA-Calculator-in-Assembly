
INCLUDE Irvine32.inc 

.data
inputGrades BYTE "Please enter the grade of subject:"
creditHour DWORD 25 DUP(?)
gpa DWORD ?
creditH DWORD 0
sum DWORD 0
grade BYTE ?
inputCredit BYTE "Please enter the credit Hours of Previous entered subject:"
gradeList BYTE 20 DUP(?)
numOfSubjects DWORD ?


inputSubjects BYTE "Please enter the number of Subjects: "
.code 

inputGrade proto, numOfSub:dword, crdHrList:ptr dword, crdtHr:dword, gradList:ptr dword, inputGrads:byte, inputCreditH:byte
evaluate proto, numOfSubjects:dword, grade:byte,gradeList:ptr byte,sum:dword,creditHour:ptr dword
main PROC

mov edx,offset inputSubjects
call writeString
call readInt
mov numOfSubjects,eax

invoke inputGrade, numOfSubjects, addr creditHour, creditH, addr gradeList, inputGrades, inputCredit
invoke evaluate, numOfSubjects, grade,addr gradeList,sum,addr creditHour
call readInt
exit 
main ENDP

inputGrade PROC,numOfSub:dword, crditHour:ptr dword, crdtHr:dword, gradList:ptr dword, inputGrads:byte, inputCreditH:byte
mov ecx, numOfSubjects
mov esi, 0
mov edi, 0
L1:
mov edx,offset inputGrades
call writeString
call readChar
mov gradList[si], al

mov edx, offset inputCredit
call writeString
call readInt
mov crditHour[edi], eax
add creditH, eax
inc esi
add edi,4
Loop L1
ret
 inputGrade ENDP

evaluate PROC, numOfSub:dword, grad:byte, gradList:ptr byte,sm:dword,crditHour:ptr dword
mov ecx,numOfSubjects
mov esi,0
mov edi,0
LOOP1:
mov eax,gradList[esi]
mov grad,al
.IF grad[edi]=='A' && grad[edi*1]=='0dh'
mov eax,crditHour[esi*4]
mov ebx,4
mul ebx
add sm, eax

.ELSEIF grad[edi]=='A' && grad[edi*1]=='+'
mov eax,crditHour[esi*4]
mov ebx,4
mul ebx
add sm, eax

.ELSEIF grad[edi]=='A' && grad[edi*1]=='-'
mov eax,crditHour[esi*4]
mov ebx,3.7
mul ebx
add sm, eax

.ELSEIF grad[edi]=='B' && grad[edi*1]=='0dh'
mov eax,crditHour[esi*4]
mul 3.0
add sm, eax

.ELSEIF grad[edi]=='B' && grad[edi*1]=='+'
mov eax,crditHour[esi*4]
mul 3.3
add sm, eax

.ELSEIF grad[edi]=='B' && grad[edi*1]=='-'
mov eax,crditHour[esi*4]
mul 2.7
add sm, eax

.ELSEIF grad[edi]=='C' && grad[edi*1]=='+'
mov eax,crditHour[esi*4]
mul 2.3
add sm, eax

.ELSEIF grad[edi]=='C' && grad[edi*1]=='0dh'
mov eax,crditHour[esi*4]
mul 2.0
add sm, eax

.ELSEIF grad[edi]=='C' && grad[edi*1]=='-'
mov eax,crditHour[esi*4]
mul 1.7
add sm, eax

.ELSEIF grad[edi]=='D' && grad[edi*1]=='+'
mov eax,crditHour[esi*4]
mul 1.3
add sm, eax

.ELSEIF grad[edi]=='D' && grad[edi*1]=='0dh'
mov eax,crditHour[esi*4]
add sm, eax

.ELSEIF grad[edi]=='F' && grad[edi*1]=='0dh'
mov eax,crditHour[esi*4]
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

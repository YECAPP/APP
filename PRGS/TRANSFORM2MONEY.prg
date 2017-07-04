PROCEDURE TRANSFORM2MONEY
	PARAMETERS tnVal,tcMask 
	lcSymbolMillares=","
	lcSymbolDec="."
	lcSymbolMoney="$"
	

	**calculando valores 
	lnPointDecPositionMask=AT(".",ALLTRIM(tcMask))
	lcEnteroMask=SUBSTR(tcMask,1,lnPointDecPositionMask-1)

	lnEnteroLenMask=LEN(STRTRAN(SUBSTR(tcMask,1,lnPointDecPositionMask-1),lcSymbolMoney,""))	

	lnNumDecsMask=LEN(tcMask)-lnPointDecPositionMask
 
		
	IF tnVal<>0	
		
		lcVal=TRANSFORM(ROUND(tnVal,lnNumDecsMask))
		
		lnPointDecPosition=IIF(AT(".",ALLTRIM(lcVal))=0,LEN(lcVal)+1,AT(".",ALLTRIM(lcVal)))
		

		lcEntero=SUBSTR(lcVal,1,lnPointDecPosition-1)
		lnLenEntero=LEN(STRTRAN(STRTRAN(STRTRAN(SUBSTR(lcVal,1,lnPointDecPosition-1),lcSymbolMillares,""),lcSymbolMoney,""),lcSymbolDec,""))


		lnNumDecs=LEN(lcVal)-lnPointDecPosition
		lcDec=PADR(SUBSTR(lcVal,lnPointDecPosition+1,lnNumDecs),lnNumDecsMask,"0")
		
		lcEntero2=""
		FOR n=1 TO LEN(lcEntero) 
			IF MOD(n,3)=0 AND n<>LEN(lcEntero)
				lcCaracter=","+SUBSTR(lcEntero,LEN(lcEntero)-(n-1),1)
			ELSE
				lcCaracter=SUBSTR(lcEntero,LEN(lcEntero)-(n-1),1)
			ENDIF 
			
			lcEntero2=lcCaracter+lcEntero2	
		ENDFOR 
		*MESSAGEBOX(lnEnteroLenMask-lnLenEntero)
		lcEntero2=PADL(lcEntero2,IIF((lnEnteroLenMask-lnLenEntero)>=0,lnEnteroLenMask,lnLenEntero)," ")
				
	ELSE
		lcEntero2="0"
		lcEntero2=PADL(lcEntero2,lnEnteroLenMask," ")
		lcDec=PADR("0",lnNumDecsMask,"0")
		
		*RETURN lcSymbolMoney+PADL(lcEntero2+lcSymbolDec+lcDec,lnLenFinal," ")
	ENDIF 

	RETURN lcSymbolMoney+lcEntero2+lcSymbolDec+lcDec	
	
ENDPROC 
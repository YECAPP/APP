PROCEDURE ArrayFromList
LPARAMETERS taArray,tcList,tcDelimiter
	**Ejemplo de uso:
	**LOCAL Arreglo
	**ArrayFromList(@Arreglo,"Item1,Item2,Item3,Item4,Item5")
	**contar numero de comas en la expresion
	
	******************************************************************************************************************************
	**09 de agosto de 2016 se agrego que se pueda configurar el delimitador para poder enviar elementos con comas entremezcladas
	IF VARTYPE(tcDelimiter)="L"
		lcDelimiterElements=","
	ELSE
		lcDelimiterElements=tcDelimiter
	ENDIF 		

	******************************************************************************************************************************
	
	
	lNArrayFromList=1
	DO WHILE !ATC(lcDelimiterElements,tcList,lNArrayFromList)=0
		lNArrayFromList = lNArrayFromList + 1 
	ENDDO 
	**Separar expresiones para los titulos
	DIMENSION taArray(lNArrayFromList)
	lnStartPosition=1
	lnEndPosition=0
	lnCharReturn=0
	
	FOR lNArrayFromList=1 TO ALEN(taArray)
		lnEndPosition=IIF(ATC(lcDelimiterElements,tcList,lNArrayFromList)=0,LEN(tcList)+1,ATC(lcDelimiterElements,tcList,lNArrayFromList))
		lnCharReturn=lnEndPosition-lnStartPosition
		taArray(lNArrayFromList)=SUBSTR(tcList,lnStartPosition,lnCharReturn)
		lnStartPosition=lnEndPosition+1
	ENDFOR
	RETURN .t.
ENDPROC 


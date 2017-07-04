LPARAMETERS tcCadena
lcAcumulator=""
FOR n=1 TO LEN(tcCadena)
	lcLetter=SUBSTR(tcCadena,n,1)
	IF ISDIGIT(lcLetter)
		lcAcumulator=lcAcumulator+lcLetter
	ENDIF 
ENDFOR 
RETURN INT(VAL(lcAcumulator))




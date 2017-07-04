*tccodigo="01010202"
*tdfecha=DATE()
*SELECT ;
		 costoprom,* ;
	FROM ;
		(_screen.ydataMANAGE1.tbmovinvname) ;
	WHERE ;
		codigo=tccodigo AND fecha<=tdFecha ;
	ORDER BY ;
		line DESC 
		
		
PROCEDURE costopromv3
LPARAMETERS tdFecha,tccodigo
	
	lnCostoprom=0.0000
	
	SELECT ;
		TOP 1 costoprom ;
	FROM ;
		(_screen.ydataMANAGE1.tbmovinvname) ;
	WHERE ;
		codigo=tccodigo AND fecha<=tdFecha ;
	ORDER BY ;
		line DESC ;
	INTO ARRAY ;
		lacostoprom 
	
	IF !VARTYPE(lacostoprom )="U"
		lnCostoprom=lacostoprom 
	ENDIF 
	
	RETURN lnCostoprom

ENDPROC 


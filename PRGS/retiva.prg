FUNCTION RETIVA
	LPARAMETERS lnMONTO,lnPROVEEDOR,llVenta
	IF llVenta=.f.
		IF lnMONTO>=100 AND !ISNULL(lnPROVEEDOR)
			RETURN lnmonto*IIF(INLIST(ALLTRIM(lnPROVEEDOR),"EUG00","ANT-016","GER-017","MEN-006"),gRETIVA13,gRETIVA)
		ELSE 
			RETURN 0.0000
		ENDIF 
	ELSE 
		RETURN IIF(INLIST(ALLTRIM(lnPROVEEDOR),"EUG00","ANT-016","GER-017","MEN-006"),gRETIVA13,gRETIVA)
	ENDIF 
	
ENDFUNC
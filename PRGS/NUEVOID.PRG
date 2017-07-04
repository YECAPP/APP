FUNCTION NuevoID(tcIdDoc,tbRevert)
LOCAL lcIdDoc,lnId, lcId, lnAreaAnt, lcReprAnt,lcPrefijo,lnLenForNum,lnLenstandard,lcCaracterStandard
  lcIdDoc = UPPER(ALLTRIM(tcIdDoc))
  lnId = 0
  lcId=""
  lnAreaAnt = SELECT()
  lcReprAnt = SET('REPROCESS')
  lcPrefijo=""
  lnLenForNum=0
  lnLenstandard=10
  lcCaracterStandard="0"
  lcSucursal=ALLTRIM(TRANSFORM(gnDefaultSucursal))
  SET REPROCESS TO AUTOMATIC

  IF NOT USED("DOCNUM")
    USE docnum IN 0  &&poner en uso docmun si no esta en uso 
  ENDIF
  
  SELECT docnum &&seleccionar docnum 

  IF SEEK(lcIdDoc, "DOCNUM", "IDDOC")  	&&si encuentra el id 
    IF RLOCK() 							&&bloquear registro 
    
    IF tbRevert
      	REPLACE ID WITH id - 1 IN docnum  &&sumar uno y almacenarlo en el id 
  	ELSE
  		REPLACE ID WITH id + 1 IN docnum  &&sumar uno y almacenarlo en el id 
  	ENDIF 
      lnID =docnum.id					&&guardar lnid 
      lcPrefijo=ALLTRIM(docnum.prefijo) 
      lnLenForNum=lnLenstandard-LEN(lcPrefijo)-LEN(lcSucursal)
      lcID = lcPrefijo+lcSucursal+PADL(TRANSFORM(lnId),lnLenForNum,lcCaracterStandard)
      UNLOCK
    ENDIF
  ENDIF
  
  **volver a poner sets como estaban 
  SELECT (lnAreaAnt)
  SET REPROCESS TO lcReprAnt
  RETURN lcId
ENDFUNC 

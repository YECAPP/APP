LOCAL lcValue, lcCRiva,lcCIva,lcCRenta
SELECT DETALLEGASTO

SCAN 
	lcvalue=ALLTRIM(detalleGASTO.codigo)
	IF !EMPTY(lcvalue)
		lcCRiva=IIF(SEEK(lcvalue,"cataconta","codigo"),cataconta.criva,.f.)
		lcCIva=IIF(SEEK(lcvalue,"cataconta","codigo"),cataconta.civa,.f.)
		lcCRenta=IIF(SEEK(lcvalue,"cataconta","codigo"),cataconta.crenta,.f.)

		replace detalleGASTO.criva WITH lcCRiva 
		replace detalleGASTO.civa WITH lcCIva
		replace detalleGASTO.crenta WITH lcCRenta
		
		IIF(lcCRiva,".T.",".F.")
		IIF(lcCIva,".T.",".F.")
		IIF(lcCRenta,".T.",".F.")

		WAIT 	"REEMPLAZANDO ESTADO DE IMPUESTOS PARA EL CODIGO"+CHR(13)+;
				LCVALUE+CHR(13)+;
				"CON RETENCION DE IVA ="+IIF(lcCRiva,".T.",".F.")+CHR(13)+;
				"CON IVA ="+IIF(lcCIva,".T.",".F.")+CHR(13)+;
				"CON RENTA="+IIF(lcCRenta,".T.",".F.");
			 	WINDOW TIMEOUT 1/4
			
	ENDIF 
ENDSCAN 
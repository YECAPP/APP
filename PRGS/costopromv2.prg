*DO costopromv2 WITH DATE(),"04200103"
*MESSAGEBOX(costopromv2(CTOD("01/02/2012"),"04030126"))
*	MESSAGEBOX("lnMonth:"+TRANSFORM(lnMonth)+CHR(13)+"LNyEAR:"+TRANSFORM(LNYEAR)+CHR(13)+"LCPER:"+TRANSFORM(LCPER))
PROCEDURE costopromv2
LPARAMETERS ldFecha,lcCodigo
	*DO genListMonth WITH lcCodigo
	lnReturn=0000.00000
	lnMonth=MONTH(ldFecha)
	lnYear=YEAR(ldFecha)
	lcPer=TRANSFORM(lnYear)+PADL(TRANSFORM(lnMonth),2,"0")

	SELECT TOP 1 costo2 FROM tbCOSTOS  WHERE tbCOSTOS.periodo<=lcPer AND CODIGO==lcCodigo ORDER BY periodo desc  INTO ARRAY lacosto2
		IF !vartype(laCosto2)="U"
			lnReturn=laCosto2
			IF lnReturn=0
				SELECT TOP 1 costoref FROM tbCOSTOS  WHERE tbCOSTOS.periodo<=lcPer AND CODIGO==lcCodigo ORDER BY periodo desc  INTO ARRAY lacostoRef
				lnReturn=lacostoRef
				IF lnReturn=0
					SELECT TOP 1 costo3 FROM tbCOSTOS  WHERE tbCOSTOS.periodo<=lcPer AND CODIGO==lcCodigo ORDER BY periodo desc  INTO ARRAY lacosto3
					lnReturn=lacosto3
				ENDIF 
			ENDIF 
		ELSE
			SELECT precioref FROM inventario WHERE codigo==lcCodigo INTO ARRAY laPrecioRef
			IF !VARTYPE(laPrecioRef)="U"
				lnReturn=laPrecioRef
			ELSE
				lnReturn=00000.0000
			ENDIF 
		ENDIF 

	RETURN LNRETURN  
ENDPROC





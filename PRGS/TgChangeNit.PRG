PROCEDURE TgChangeNit
LPARAMETERS tcNitOld,tcNitNew

IF !EMPTY(tcNitOld)
	IF !EMPTY(tcNitNew)
		LOCAL ARRAY laTbs2Change(8)
		laTbs2Change(1)="CLIENTES"
		laTbs2Change(2)="CONTACCLIEN"
		laTbs2Change(3)="FACTFAST"
		laTbs2Change(4)="NITDIR"
		laTbs2Change(5)="PERSONNATURALES"
		laTbs2Change(6)="PROVEEDORES"
		laTbs2Change(7)="RETENCIONESRENTA"
		laTbs2Change(8)="RIVA"

		lcArchivo="c:\TgChangeNit"+STRTRAN(strtran(TTOC(DATEtime(),1),"/","_"),":","_")+".txt"
		arch=fcreate(lcArchivo)

		lnTbAfected=0
		lnRecordAfected=0

		FOR n=1 TO ALEN(laTbs2Change,1)
			lcTb2Change=laTbs2Change(n)
			fputs(arch," ")						
			SELECT NIT FROM (lcTb2Change) WHERE nit==tcNitOld INTO ARRAY lanit 
			IF !VARTYPE(lanit)="U"
				*MESSAGEBOX(lcTb2Change)
				*MESSAGEBOX(lanit)
				UPDATE &lcTb2Change SET nit=tcNitNew WHERE nit==lanit 
				lnTbAfected = lnTbAfected + 1 
				lcMsg2Put="tabla:"+lcTb2Change+" CAMBIADA nit"+tcNitOld+" por nit nuevo"+tcNitNew+"; "+TRANSFORM(ALEN(lanit,1))+"Registros cambiados"
				fputs(arch,lcMsg2Put)		
				lnRecordAfected = lnRecordAfected + ALEN(lanit ,1)
				lnTbAfected = lnTbAfected + 1
			ELSE
				lcMsg2Put="tabla:"+lcTb2Change+" Sin cambios"
				fputs(arch,lcMsg2Put)						
			ENDIF 
			RELEASE lanit 
		ENDFOR 
		fclose(arch)
		lcMsg="Desea ver el log de los cambios"
		IF MESSAGEBOX(lcMsg,36,"Ver el log")=6
			RUN /N2 Notepad &lcArchivo
		ELSE
			MESSAGEBOX("log de cambios guardado en:"+lcArchivo,32,"Archivo de logo guardado")
		ENDIF 
	ELSE
		MESSAGEBOX("Nit nuevo no fue pasado ")
	ENDIF 
ELSE 
	MESSAGEBOX("Nit viejo no fue pasado ")
ENDIF 

RETURN TRANSFORM(lnTbAfected)+" Tablas cambiadas;"+ TRANSFORM(lnRecordAfected)+" Registros cambiados"

ENDPROC 


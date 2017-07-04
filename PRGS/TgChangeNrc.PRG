PROCEDURE TgChangeNrc
LPARAMETERS tcNrcOld,tcNrcNew

IF !EMPTY(tcNrcOld)
	IF !EMPTY(tcNrcNew)
		LOCAL ARRAY laTbs2Change(7)
		laTbs2Change(1)="CLIENTES"
		laTbs2Change(2)="CONTRIBUYENTES"
		laTbs2Change(3)="FACTFAST"
		laTbs2Change(4)="ORDENCOMPRA"
		laTbs2Change(5)="ORDENESDEGASTOS"
		laTbs2Change(6)="PROVEEDORES"
		laTbs2Change(7)="RIVA"

		lcArchivo="c:\TgChangeregistro"+STRTRAN(strtran(TTOC(DATEtime(),1),"/","_"),":","_")+".txt"
		arch=fcreate(lcArchivo)

		lnTbAfected=0
		lnRecordAfected=0
		
		FOR n=1 TO ALEN(laTbs2Change,1)
			lcTb2Change=laTbs2Change(n)
			fputs(arch," ")						
			SELECT registro FROM (lcTb2Change) WHERE registro==tcNrcOld INTO ARRAY laregistro 
			IF !VARTYPE(laregistro)="U"
				*MESSAGEBOX(lcTb2Change)
				*MESSAGEBOX(laregistro)
				UPDATE &lcTb2Change SET registro=tcNrcNew WHERE registro==laregistro 
				lnTbAfected = lnTbAfected + 1 
				lcMsg2Put="tabla:"+lcTb2Change+" CAMBIADA en registro"+tcNrcOld+" por registro nuevo"+tcNrcNew+"; "+TRANSFORM(ALEN(laregistro,1))+"Registros cambiados"
				fputs(arch,lcMsg2Put)
				lnRecordAfected = lnRecordAfected + ALEN(laregistro ,1)
				lnTbAfected = lnTbAfected + 1

			ELSE
				lcMsg2Put="tabla:"+lcTb2Change+" Sin cambios"
				fputs(arch,lcMsg2Put)						
			ENDIF 
			RELEASE laregistro 
		ENDFOR 
		fclose(arch)
		lcMsg="Desea ver el log de los cambios"
		IF MESSAGEBOX(lcMsg,36,"Ver el log")=6
			RUN /N2 Notepad &lcArchivo
		ELSE
			MESSAGEBOX("log de cambios guardado en:"+lcArchivo,32,"Archivo de logo guardado")
		ENDIF 
	ELSE
		MESSAGEBOX("registro nuevo no fue pasado ")
	ENDIF 
ELSE 
	MESSAGEBOX("registro viejo no fue pasado ")
ENDIF 

RETURN TRANSFORM(lnTbAfected)+" Tablas cambiadas;"+ TRANSFORM(lnRecordAfected)+" Registros cambiados"

ENDPROC 


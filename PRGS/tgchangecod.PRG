PROCEDURE TgChangeCod
LPARAMETERS tcCodOld,tcCodNew

IF !EMPTY(tcCodOld)
	IF !EMPTY(tcCodnew)
		LOCAL ARRAY laTbs2Change(6,2)
		laTbs2Change(1,1)="DETALLEORDEN" &&CODIGO
		laTbs2Change(1,2)="CODIGO"

		laTbs2Change(2,1)="DETALLEREQUISICION" &&CODIGO
		laTbs2Change(2,2)="CODIGO" &&CODIGO

		&&no se debe cambiar por que infringe la unicidad del codigo 
		*laTbs2Change(3,1)="INVENTARIO" &&CODIGO
		*laTbs2Change(3,2)="CODIGO" &&CODIGO
		&&no se debe cambiar por que infringe la unicidad del codigo 
				
		laTbs2Change(3,1)="DETALLEPRESUPUESTO" &&REFERENCIA
		laTbs2Change(3,2)="REFERENCIA" &&REFERENCIA		

		laTbs2Change(4,1)="FACTURASLINES" &&REFERENCIA
		laTbs2Change(4,2)="REFERENCIA" &&REFERENCIA
		
		laTbs2Change(5,1)="OT_D"  &&CODIGO
		laTbs2Change(5,2)="CODIGO"  &&CODIGO
		
		laTbs2Change(6,1)="OAGEN_D" &&CODIGO
		laTbs2Change(6,2)="CODIGO" &&CODIGO

		lcArchivo="c:\TgChangeCod"+STRTRAN(strtran(TTOC(DATEtime(),1),"/","_"),":","_")+".txt"
		arch=fcreate(lcArchivo)

		lnTbAfected=0
		lnRecordAfected=0

		FOR n=1 TO ALEN(laTbs2Change,1)
			lcTb2Change=laTbs2Change(n,1)
			lcCampo2Change=laTbs2Change(n,2)
			
			fputs(arch," ")						
			SELECT &lcCampo2Change FROM (lcTb2Change) WHERE &lcCampo2Change==tcCodOld INTO ARRAY laCampo 
			IF !VARTYPE(laCampo)="U"
				WAIT "Cambiando codigo "+tcCodOld +" por "+ tcCodNew + "en Tabla: "+lcTb2Change+" en campo: "+lcCampo2Change WINDOW NOWAIT 
				UPDATE &lcTb2Change SET &lcCampo2Change =tcCodnew WHERE &lcCampo2Change ==laCampo 
				lnTbAfected = lnTbAfected + 1 
				lcMsg2Put="tabla:"+lcTb2Change+" CAMBIADA "+tcCodOld+" por nuevo valor "+tcCodnew+"; "+TRANSFORM(ALEN(laCampo,1))+"Registros cambiados"
				fputs(arch,lcMsg2Put)		
				lnRecordAfected = lnRecordAfected + ALEN(laCampo ,1)
				lnTbAfected = lnTbAfected + 1
			ELSE
				lcMsg2Put="tabla:"+lcTb2Change+" Sin cambios"
				fputs(arch,lcMsg2Put)						
			ENDIF 
			RELEASE lacampos
		ENDFOR 
		fclose(arch)
		lcMsg="Desea ver el log de los cambios"
		IF MESSAGEBOX(lcMsg,36,"Ver el log")=6
			RUN /N2 Notepad &lcArchivo
		ELSE
			MESSAGEBOX("log de cambios guardado en:"+lcArchivo,32,"Archivo de logo guardado")
		ENDIF 
	ELSE
		MESSAGEBOX("Valor nuevo no fue pasado ")
	ENDIF 
ELSE 
	MESSAGEBOX("Valor viejo no fue pasado ")
ENDIF 

RETURN TRANSFORM(lnTbAfected)+" Tablas cambiadas;"+ TRANSFORM(lnRecordAfected)+" Registros cambiados"

ENDPROC 


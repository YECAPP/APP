**EJEMPLO DE USO 
*DO frxtoxls WITH ;
	"IDDOC",--------------------------->tcGroupField;  
	"IDDOC",--------------------------->tcGroupFieldDescrip;	
	"CATAL",----------------------------->tcTable;	
	"",-->tcLaTitles;
	"",------------->tcAFormat;
	"",------>tcAFields;
	"",---------------------->tcAnchos;
	"CATALOGO",----------------------------->tcTitle;
	"Reporte"--------------------------->tcTipoReporte;
	".t."--------------------------->tbSaveFile;
	"c:\ArchivoExcel.xls" ------------>tcFileName
	
*DO FRXTOXLSWITHOUT WITH ;
	"",;  
	"",;	
	"CATAL",;	
	"",;
	"",;
	"",;
	"",;
	"CATALOGO",;
	"Reporte"


PROCEDURE FRXTOXLSWITHOUT
LPARAMETERS tcGroupField,tcGroupFieldDescrip,tcTable,tcLaTitles,tcAFormat,tcAFields,tcAnchos,tcTitle,tcTipoReporte,tbSaveFile,tcFileName
	&&Crear obejto 
	oExcel = Createobject("Excel.Application")
	oExcel.Workbooks.Add()
	oExcel.Sheets("Hoja1").Select()
*	oExcel.Visible = .T.  &&solo si se quiere mostrar la hoja durante la ejecucion 
	
	lnRowInit=4
	lnTitleFont=10
	lnTitleColor=42
	lcTable=tcTable
	lnNumRegistros=RECCOUNT(lcTable)
	lnRowInit=5
	lcRowInit=ALLTRIM(STR(lnRowInit))
	lcRowInitTitle=ALLTRIM(STR(lnRowInit-1))
	lcGroupField=tcGroupField
	lcGroupFieldDEscrip=tcGroupFieldDescrip
	lcLastCellUsed=""

	SELECT (lctable) 
	lnCounterWait=RECCOUNT()
	lnStepCounter=20
	*FORMATOS MAS COMUNES PARA FECHA Y DINERO 
	*m/d/yyyy
	*$###0.00

	AFIELDS(aTable,lcTable)
	CREATE CURSOR TABLEINFO;
		(;
			NOMBRE C(40)  ,;
			TIPO C(10),;
			ANCHO N(10,2),;
			POSICIONES N(10,2),;
			NULOS L,;
			CONVER L,;
			REGLA  C(20),;
			RVALID C(20),;
			TVALID C(40),;
			NOMBREL C(30),;
			EINSERT C(40),;
			EUPDATE C(40),;
			EDELETE C(40),;
			COMENT C(40),;
			AUTOINCRE N(10),;
			INCREMENTO N(10);
		)

	APPEND FROM ARRAY aTable
	

	
	DO genATitles WITH tcLaTitles 	&&"Fecha,Codigo,Costo,Cantidad"
	DO genAFormat WITH tcAFormat  	&&"@,@,$###0.00,$###0.00"  
	DO genAFields WITH tcAFields  	&&"Fecha,Codigo,Costo,Cantidad"
	DO genAAnchos WITH tcAnchos   	&&"11,11,10,10"
	
	SELECT (lcTable)
	
	lcTitle=tcTitle
	lcTipoReport=tcTipoReporte

	*-- Títulos Reporte
	oExcel.Range("A1").Select()
	oExcel.ActiveCell.Value = lcTitle
	oExcel.selection.Font.Bold=.t.
	oExcel.selection.Font.size=lnTitleFont

	oExcel.Range("A2").Select()
	oExcel.ActiveCell.Value = lcTipoReport


	DO TITULOS WITH lcRowInitTitle
	DO FORMATOS 
	IF EMPTY(lcGroupField)
		DO CAMPOS 
	ELSE
		DO CAMPOSGROUP
	ENDIF 
	DO ANCHOS 
	*DO FORMATPAGE 
	SET FILTER TO IN (lcTable)
	oExcel.Range("A1").Select()
*	MESSAGEBOX("VARTYPE(tbSaveFile)"+VARTYPE(tbSaveFile)+CHR(13)+" tbSaveFile: "+TRANSFORM(tbSaveFile))
	IF tbSaveFile
		IF VARTYPE(tcFileName)="C"
			IF !EMPTY(tcFileName)

				IF FILE(tcFileName)

					DELETE FILE (tcFileName)

				ENDIF 
				
				oExcel.ActiveWorkbook.Saveas(tcFileName)
			ENDIF 
		ENDIF 
		oExcel.Visible = .f.
		oExcel.ActiveWorkbook.close
	ELSE 
		oExcel.Visible = .T.
	ENDIF 




	Release oExcel
	DO CLEANUP 
ENDPROC 

PROCEDURE CLEANUP 

	IF USED("TABLEINFO")
		SELECT tableinfo
		USE 
	ENDIF 
	*IF USED(lcTable)
	*	SELECT (lcTable)
	*	USE 
	*ENDIF 

	RELEASE acTitle
	RELEASE anAnchos
	RELEASE acFields
	RELEASE acFormat
ENDPROC 

PROCEDURE CAMPOS
	lcGroupFieldValue=""
	lnOldCellGroup=""
	lnOldCellSum=0
	lnCounterSum=0
	nCellStart=lnRowInit
	GO TOP 
	DO WHILE !EOF()
	cCell = Transform(nCellStart)
			FOR N=1 TO ALEN(acFields)
				IF N>26
					IF N>52
						IF N>78
							IF N>104
								MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
							ENDIF 
							lcColumna=CHR(67)+CHR(64+(N-78))
							lcRange=lcColumna+cCell
						ELSE
							lcColumna=CHR(66)+CHR(64+(N-52))
							lcRange=lcColumna+cCell
						ENDIF 
					ELSE 
						lcColumna=CHR(65)+CHR(64+(N-26))
						lcRange=lcColumna+cCell
					ENDIF 
				ELSE 
					lcColumna=CHR(ASC("@")+N)
					lcRange=lcColumna+cCell
				ENDIF
				
				lcFieldName=acFields(N)
				oExcel.Range(lcRange).Select()
				lcExec=lcTable+"."+lcFieldName
				
				
				IF VARTYPE(&lcExec)="D"
					IF !EMPTY(&lcExec)
						lcExec="TRANSFORM("+lcTable+"."+lcFieldName+")"
					ELSE
						lcExec="TRANSFORM("+lcTable+"."+lcFieldName+")"
					ENDIF 
				ENDIF 
				
				TRY 
					oExcel.ActiveCell.Value =&lcExec
				CATCH
					
					MESSAGEBOX(	"Problema con tabla: "+lcTable+CHR(13)+;
								"lcExec: "+TRANSFORM(lcExec)+CHR(13)+;
								"&lcExec: "+TRANSFORM(&lcExec)+CHR(13)+;
								"VARTYPE(&lcExec): "+VARTYPE(&lcExec))
				FINALLY

				ENDTRY
				
				
			ENDFOR
			lnCounterSum = lnCounterSum + 1  
			nCellStart = nCellStart +1
			SKIP 

				WAIT "Calculando...  Faltan "+TRANSFORM(lnCounterWait) WINDOW NOWAIT

			lnCounterWait= lnCounterWait- 1 

		
	ENDDO 
	DO suma  WITH cCell,lnCounterSum 
	DO grupo WITH cCell,lnCounterSum 
*	STRTOFILE(TRANSFORM(cCell)+CHR(13)+CHR(10),"C:\FRXTOXLSWITHOUT.TXT",1)
	lcLastCellUsed=cCell
ENDPROC 

PROCEDURE CAMPOSGROUP
	
	lcGroupFieldValue=""
	lnOldCellGroup=""
	lnOldCellSum=0
	lnCounterSum=0
	nCellStart=lnRowInit
	
	GO TOP 
	DO WHILE !EOF()
	cCell = Transform(nCellStart)
		lcExec=lctable+"."+lcGroupField
		IF lcGroupFieldValue=&lcExec
			FOR N=1 TO ALEN(acFields)
				IF N>26
					IF N>52
						IF N>78
							IF N>104
								MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
							ENDIF 
							lcColumna=CHR(67)+CHR(64+(N-78))
							lcRange=lcColumna+cCell
						ELSE
							lcColumna=CHR(66)+CHR(64+(N-52))
							lcRange=lcColumna+cCell
						ENDIF 
					ELSE 
						lcColumna=CHR(65)+CHR(64+(N-26))
						lcRange=lcColumna+cCell
					ENDIF 
				ELSE 
					lcColumna=CHR(ASC("@")+N)
					lcRange=lcColumna+cCell
				ENDIF
				lcFieldName=acFields(N)
				oExcel.Range(lcRange).Select()
				lcExec=lcTable+"."+lcFieldName
				oExcel.ActiveCell.Value =&lcExec
				
			ENDFOR
			lnCounterSum = lnCounterSum + 1  
			nCellStart = nCellStart +1
			SKIP 

				WAIT "Calculando...  Faltan "+TRANSFORM(lnCounterWait) WINDOW NOWAIT

			lnCounterWait= lnCounterWait- 1 
			**Si el proveedor no es el mismo crear un nuevo grupo 						
			lcExec=lctable+"."+lcGroupField
			IF !lcGroupFieldValue=&lcExec
				nCellStart = nCellStart +1
				DO suma WITH cCell,lnCounterSum 
				DO grupo WITH cCell,lnCounterSum 
				
			ENDIF 

		ELSE 
				lnCounterSum =0
				lcExec=lctable+"."+lcGroupField+IIF(EMPTY(lcGroupFieldDEscrip),"","+' '+"+lctable+"."+lcGroupFieldDEscrip)		
				
				oExcel.Range("A"+cCell+":"+chr(ASC("A")+ALEN(acfields))+cCell).Select()
				oExcel.selection.Font.Bold=.t.
				oExcel.selection.Font.size=lnTitleFont
				oExcel.selection.Borders(9).LineStyle=1
				oExcel.selection.Borders(9).weight=2
				oExcel.selection.Borders(9).ColorIndex=11
				oExcel.ActiveCell.Value = &lcExec
				
				
				lcExec=lctable+"."+lcGroupField
				nCellStart = nCellStart +1
				lcGroupFieldValue=&lcExec
			
		ENDIF 
		
	ENDDO 
	lcLastCellUsed=cCell
ENDPROC 

PROCEDURE FORMATPAGE
	oExcel.ActiveSheet.PageSetup.PrintArea="$A$1:$"+chr(ASC("A")+ALEN(acfields))+lcLastCellUsed
	oExcel.ActiveSheet.PageSetup.FitToPagesWide=1
	oExcel.ActiveSheet.PageSetup.FitToPagesTall=999
	oExcel.ActiveSheet.PageSetup.CenterHorizontally=.t.
	oExcel.ActiveSheet.PageSetup.CenterVertically =.f.
	oExcel.ActiveSheet.PageSetup.LeftHeader=TTOC(DATETIME())
	oExcel.ActiveSheet.PageSetup.CenterHeader="Página &P"
	oExcel.ActiveSheet.PageSetup.PaperSize=122
	oExcel.ActiveWindow.View = 2
	oExcel.ActiveSheet.PageSetup.FitToPagesWide = 1
	oExcel.ActiveSheet.PageSetup.FitToPagesTall = 999
	*oExcel.ActiveSheet.VPageBreaks(1).DragOff(-4161,1)
	oExcel.ActiveWindow.View = 1
ENDPROC 

PROCEDURE GRUPO
LPARAMETERS tcRow,lnRangeToGroup
	lcRowIni=TRANSFORM(VAL(tcRow)-lnRangeToGroup)
	lcRowFin=TRANSFORM(VAL(tcRow)-1)
	oExcel.Range("A"+lcRowIni+":"+"A"+lcRowFin).select()
	oExcel.Selection.Rows.Group
ENDPROC 


PROCEDURE SUMA
LPARAMETERS tcRow,lnRangeToSum
lcRangeToSum=TRANSFORM(lnRangeToSum)
tcRow=TRANSFORM(VAL(tcRow)+1)
	FOR N=1 TO ALEN(acTitle)
		IF N>26
			IF N>52
				IF N>78
					IF N>104
						MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
					ENDIF 
					lcColumna=CHR(67)+CHR(64+(N-78))
					lcRange=lcColumna+tcRow
				ELSE
					lcColumna=CHR(66)+CHR(64+(N-52))
					lcRange=lcColumna+tcRow
				ENDIF 
			ELSE 
				lcColumna=CHR(65)+CHR(64+(N-26))
				lcRange=lcColumna+tcRow
			ENDIF 
		ELSE 
			lcColumna=CHR(ASC("@")+N)
			lcRange=lcColumna+tcRow
		ENDIF 
		oExcel.Range(lcRange).Select()
		
		IF oExcel.selection.NumberFormat="$###0.00"
			oExcel.ActiveCell.FormulaR1C1="=SUM(R[-"+lcRangeToSum+"]C:R[-1]C)"
			oExcel.selection.Font.Bold=.t.
			oExcel.selection.Font.size=lnTitleFont
			oExcel.selection.interior.colorindex=lnTitleColor
			oExcel.selection.interior.Pattern=1
		ENDIF 
	ENDFOR 

ENDPROC 


PROCEDURE TITULOS 
	LPARAMETERS tcRow
	FOR N=1 TO ALEN(acTitle)
		IF N>26
			IF N>52
				IF N>78
					IF N>104
						MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
					ENDIF 
					lcColumna=CHR(67)+CHR(64+(N-78))
					lcRange=lcColumna+tcRow
				ELSE
					lcColumna=CHR(66)+CHR(64+(N-52))
					lcRange=lcColumna+tcRow
				ENDIF 
			ELSE 
				lcColumna=CHR(65)+CHR(64+(N-26))
				lcRange=lcColumna+tcRow
			ENDIF 
		ELSE 
			lcColumna=CHR(ASC("@")+N)
			lcRange=lcColumna+tcRow
		ENDIF 
		oExcel.Range(lcRange).Select()
		oExcel.ActiveCell.Value=acTitle(N)
		oExcel.selection.Font.Bold=.t.
		oExcel.selection.Font.size=lnTitleFont
		oExcel.selection.interior.colorindex=lnTitleColor
		oExcel.selection.interior.Pattern=1
	ENDFOR	
ENDPROC 

PROCEDURE ANCHOS
	FOR N=1 TO ALEN(anAnchos)
		IF N>26
			IF N>52
				IF N>78
					IF N>104
						MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
					ENDIF 
					lcColumna=CHR(67)+CHR(64+(N-78))
					lcRange=lcColumna+":"+lcColumna
				ELSE
					lcColumna=CHR(66)+CHR(64+(N-52))
					lcRange=lcColumna+":"+lcColumna
				ENDIF 
			ELSE 
				lcColumna=CHR(65)+CHR(64+(N-26))
				lcRange=lcColumna+":"+lcColumna
			ENDIF 
		ELSE 
			lcColumna=CHR(ASC("@")+N)
			lcRange=lcColumna+":"+lcColumna
		ENDIF 
		*oExcel.Columns(lcRange).Select()
		oExcel.Selection.Columns(lcRange).ColumnWidth=anAnchos(N)
	ENDFOR	
ENDPROC 

PROCEDURE FORMATOS
	FOR N=1 TO ALEN(acFormat)
		IF N>26
			IF N>52
				IF N>78
					IF N>104
						MESSAGEBOX("A sobrepasado el limite de periodos o cuentas posibles para comparar llame al programador y cotize actualizacion de sistema si desea comparar mas columnas")
					ENDIF 
					lcColumna=CHR(67)+CHR(64+(N-78))
					lcRange=lcColumna+":"+lcColumna
				ELSE
					lcColumna=CHR(66)+CHR(64+(N-52))
					lcRange=lcColumna+":"+lcColumna
				ENDIF 
			ELSE 
				lcColumna=CHR(65)+CHR(64+(N-26))
				lcRange=lcColumna+":"+lcColumna
			ENDIF 
		ELSE 
			lcColumna=CHR(ASC("@")+N)
			lcRange=lcColumna+":"+lcColumna
		ENDIF 
		oExcel.Columns(lcRange).Select()
		oExcel.selection.NumberFormat=acFormat(N)
	ENDFOR	
ENDPROC 

PROCEDURE genATitles
LPARAMETERS tcTitle
	IF !EMPTY(tcTitle)
		**contar numero de comas en la expresion
		N=1
		DO WHILE !ATC(",",tcTitle,N)=0
			N = N + 1 
		ENDDO 
		**Separar expresiones para los titulos
		PUBLIC acTitle(N)
		lnStartPosition=1
		lnEndPosition=0
		lnCharReturn=0
		FOR N=1 TO ALEN(acTitle)
			lnEndPosition=IIF(ATC(",",tcTitle,N)=0,LEN(tcTitle)+1,ATC(",",tcTitle,N))
			lnCharReturn=lnEndPosition-lnStartPosition
			acTitle(N)=SUBSTR(tcTitle,lnStartPosition,lnCharReturn)
			lnStartPosition=lnEndPosition+1
		ENDFOR
	ELSE
		PUBLIC acTitle(1)
		SELECT ;
			NOMBRE;
		FROM ;
			TABLEINFO;
		INTO ARRAY ;
			 acTitle
	ENDIF 
ENDPROC 

PROCEDURE genAAnchos
LPARAMETERS tcAnchos
	IF !EMPTY(tcAnchos)
		**contar numero de comas en la expresion
		N=1
		DO WHILE !ATC(",",tcAnchos,N)=0
			N = N + 1 
		ENDDO 
		**Separar expresiones para los titulos
		PUBLIC anAnchos(N)
		lnStartPosition=1
		lnEndPosition=0
		lnCharReturn=0
		FOR N=1 TO ALEN(anAnchos)
			lnEndPosition=IIF(ATC(",",tcAnchos,N)=0,LEN(tcAnchos)+1,ATC(",",tcAnchos,N))
			lnCharReturn=lnEndPosition-lnStartPosition
			anAnchos(N)=VAL(SUBSTR(tcAnchos,lnStartPosition,lnCharReturn))
			lnStartPosition=lnEndPosition+1
		ENDFOR
	ELSE
		PUBLIC anAnchos(1)
		SELECT ;
			ROUND(ancho,0);
		FROM ;
			tableinfo;
		into array ;
			anAnchos
			
	ENDIF 
ENDPROC 


PROCEDURE genAFormat
	LPARAMETERS tcFormat
	IF !EMPTY(tcFormat)
		**contar numero de comas en la expresion
		N=1
		DO WHILE !ATC(",",tcFormat,N)=0
			N = N + 1 
		ENDDO 
		**Separar expresiones para los titulos
		PUBLIC  acFormat(N)
		lnStartPosition=1
		lnEndPosition=0
		lnCharReturn=0
		FOR N=1 TO ALEN(acFormat)
			lnEndPosition=IIF(ATC(",",tcFormat,N)=0,LEN(tcFormat)+1,ATC(",",tcFormat,N))
			lnCharReturn=lnEndPosition-lnStartPosition
			acFormat(N)=SUBSTR(tcFormat,lnStartPosition,lnCharReturn)
			lnStartPosition=lnEndPosition+1
		ENDFOR
	ELSE
		PUBLIC acFormat(1)
		SELECT ;
			FORMATEAR(TIPO);
		FROM ;
			TABLEINFO;
		INTO ARRAY ;
			acFormat
	ENDIF 
ENDPROC 

PROCEDURE FORMATEAR 
	LPARAMETERS tcTipo
	DO CASE
	CASE tcTipo="C"
		lcFormat="@"
	CASE tcTipo="N"
		lcFormat="###0.00"
	CASE tcTipo="D"
		lcFormat="m/d/yyyy"
	OTHERWISE
		lcFormat="@"
	ENDCASE
	RETURN lcFormat
ENDPROC 

PROCEDURE genAFields
LPARAMETERS tcFields
	IF !EMPTY(tcFields)
		**contar numero de comas en la expresion
		N=1
		DO WHILE !ATC(",",tcFields,N)=0
			N = N + 1 
		ENDDO 
		**Separar expresiones para los titulos
		PUBLIC  acFields(N)
		lnStartPosition=1
		lnEndPosition=0
		lnCharReturn=0
		FOR N=1 TO ALEN(acFields)
			lnEndPosition=IIF(ATC(",",tcFields,N)=0,LEN(tcFields)+1,ATC(",",tcFields,N))
			lnCharReturn=lnEndPosition-lnStartPosition
			acFields(N)=SUBSTR(tcFields,lnStartPosition,lnCharReturn)
			lnStartPosition=lnEndPosition+1
		ENDFOR
	ELSE 
		PUBLIC  acFields(1)
		SELECT;
			nombre;
		FROM ;
			tableinfo;
		INTO ARRAY ;
			acFields
			
	ENDIF 	
ENDPROC 


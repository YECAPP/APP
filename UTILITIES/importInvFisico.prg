DO configapp 

lcnorden="OA00000199"

ldfecha=CTOD("01/01/2014")
DELETE FROM ordencompra WHERE norden=lcnorden
INSERT INTO ORDENCOMPRA(FECHA, BODEGA, IDDOC, NORDEN, PROVEEDOR, COMPRADOR, ESTADO, DEPTO, OBSERVACIONES,;
 			TIPO, EXTERIOR, PROYECTO, TIVA, TRIVA, TRENTA, MRIVA, ;
 			SNETO, SIVA, SRIVA, STOTAL, CRETENCION , SRENTA, EXENTO);
	values(;
	ldfecha,;
	"0000000001",;
	"51",;
	lcnorden,;
	"",;
	"YEC",;
	1,;
	"04",;
	"LIQUIDAR INVENTARIO",;
	"1",;
	.F.,;
	"ADMINISTRA",;
	0.13,;
	0.01,;
	0.10,;
	100,;
	0.00,;
	0.00,;
	0.00,;
	0.00,;
	"+",;
	0.00,;
	.F.)


DO FORM utilityShowLog NAME Showlog 
Showlog.edit1.value=Showlog.edit1.value+"Leyendo archivo de Inventario fisico"
lnCountDlt=0
LOCAL err as Exception

TRY 

lcFile = GETFILE("XLS")
IF !EMPTY(lcFile)
	loExcel = CREATEOBJECT("Excel.Application")
	loExcel.Workbooks.Open(lcFile)
	loExcel.Application.Visible = .f.

	lnCEll=1
	lnCellVacia=0

	lnNumCols=loExcel.ActiveSheet.UsedRange.COLUMNS.COUNT
	lnNumRows=loExcel.ActiveSheet.UsedRange.ROWS.COUNT
	lcMsgError=""
	&&limpiando detalle de orden 
	DELETE FROM detalleorden WHERE norden=lcnorden 
	FOR lnrow=1 TO lnNumRows
		WAIT "Calculando fila "+TRANSFORM(lnrow)+"Presione la tecla "+' C '+" para cancelar" WINDOW  TIMEOUT 0.2
		IF INLIST(INKEY(),99,67)
			IF MESSAGEBOX("¿Desea Cancelar la lectura del disco?",36,"¿Cancelar?")=6
				EXIT 
			ENDIF 
		ENDIF 
	
		lnValidRow=0
		FOR lnCol=1 TO lnNumCols
			lcColumna=CHR(64+lnCol)
			lcCell=TRANSFORM(lnrow)
			lcRange=lcColumna+lcCell
			loExcel.Range(lcRange).Select()

			IF !EMPTY(loExcel.ActiveCell.Value)
				lcValueCell=loExcel.ActiveCell.Value 
								
				DO CASE
				CASE VARTYPE(lcValueCell)="X"
					lcPutValue=" "
					lcError=""
					lcMsgError=TRANSFORM(lnCol)+" Valor Null| "
				CASE VARTYPE(lcValueCell)="C" &&SI ES TIPO CARACTER
					lcPutValue="Caracter: "+lcValueCell
					DO CASE
					CASE lnCol=1 &&SOLO SI MIDE ENTRE UNO Y VEINTE 
						IF BETWEEN(LEN(lcValueCell),1,20)
							RELEASE laCodInvValid 
							SELECT codigo FROM inventario WHERE UPPER(ALLTRIM(codigo))==UPPER(ALLTRIM(lcValueCell)) INTO ARRAY laCodInvValid 
							IF !VARTYPE(laCodInvValid )="U"
								lnValidRow = lnValidRow + 1 
								lcCodigoUpdt=ALLTRIM(lcValueCell)
							ELSE
								lcMsgError=lcMsgError+TRANSFORM(lnCol)+":codigo no existe| "
							ENDIF 
						ELSE 
							lcMsgError=lcMsgError+TRANSFORM(lnCol)+":no entre 1 y 20| "
						ENDIF 
					CASE lnCol=2 &&SOLO SI ES ENTRE 20 Y 60 EL LARGO 
						IF BETWEEN(LEN(lcValueCell),20,255)
							lnValidRow = lnValidRow + 1 
							lcDescripcionUpdt=lcValueCell
						ELSE 
							lcMsgError=lcMsgError+TRANSFORM(lnCol)+":no entre 20 y 60| "
						ENDIF 
					OTHERWISE
					ENDCASE
				CASE VARTYPE(lcValueCell)="N" &&SI ES TIPO NUMERICO 
					DO CASE
					CASE lnCol=3 
						lnValidRow = lnValidRow + 1 
						lnCantidadUpdt=lcValueCell
						lcPutValue="Numerico: "+TRANSFORM(lcValueCell)
					CASE lnCol=4				
						lnValidRow = lnValidRow + 1 
						lnPrecUpdt=lcValueCell
						lcPutValue="Numerico: "+TRANSFORM(lcValueCell)
					OTHERWISE
						lcPutValue="Numerico: "+TRANSFORM(lcValueCell)
					ENDCASE

				CASE VARTYPE(lcValueCell)="Y"
					DO CASE
					CASE lnCol=4
						lnValidRow = lnValidRow + 1 
						lnPrecUpdt=TRANSFORM(lcValueCell)	
						lcPutValue="Moneda: "+TRANSFORM(lcValueCell)
					ENDCASE 
				OTHERWISE
					lcPutValue="Indefinido: "+lcRange+" Vartype "+lcvartype
				ENDCASE
				
				Showlog.edit1.value=Showlog.edit1.value+lcPutValue+CHR(9)
				*MESSAGEBOX(loExcel.ActiveCell.Value )
			ELSE
				Showlog.edit1.value=Showlog.edit1.value+" Error en celda"+CHR(9)
			ENDIF 
			
		ENDFOR 
		
		IF lnValidRow=4 
			Showlog.edit1.value="Valida: "+;
								lcCodigoUpdt+" "+;
								lcDescripcionUpdt+" "+;
								TRANSFORM(lnCantidadUpdt)+" "+;
								TRANSFORM(lnPrecUpdt)+" "+;
								Showlog.edit1.value+;
								CHR(13)

			**ingresando linea 
			INSERT INTO detalleorden (norden,codigo,descripcion,cantidad,costo);
			VALUES(lcNorden,lcCodigoUpdt,lcDescripcionUpdt,lnCantidadUpdt,lnPrecUpdt)
		ELSE
			Showlog.edit1.value="No Valida"+lcMsgError+Showlog.edit1.value+CHR(13)
		ENDIF 
	ENDFOR 
	RELEASE loExcel
	
	**SUMANDO LOS TOTALES 
	SELECT SUM(CANTIDAD*COSTO ) AS TOTAL FROM DETALLEORDEN WHERE NORDEN=LCNORDEN INTO ARRAY laTotDet
	IF VARTYPE(laTotDet)="X"
		lnTotal=laTotDet
	ELSE
		lnTotal=laTotDet
	ENDIF 
	UPDATE ordencompra SET sneto=lnTotal, stotal=lnTotal WHERE norden=lcNorden
	
ELSE
	MESSAGEBOX("Debe seleccionar un archivo",48,"Error al abrir")
ENDIF 
CATCH TO err 
	MESSAGEBOX(err.Message)
	RELEASE loExcel 
ENDTRY 
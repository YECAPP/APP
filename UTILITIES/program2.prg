CREATE CURSOR clientesimport(numero n(10),nombre c(60),registro c(15),nit c(16),direccion c(100),giro c(100),descrip1 c(100),descrip2 c(100),descrip3 c(100))

DO FORM utilityShowLog NAME Showlog 
Showlog.edit1.value=Showlog.edit1.value+"Leyendo archivo de Inventario fisico"
lnCountDlt=0

*lcFile = GETFILE("XLS")
lcFile="C:\Users\YEC\Documents\FOX\TAGRO\EXCEL\Correo1\Reunion1.xlsx"
IF !EMPTY(lcFile)
	loExcel = CREATEOBJECT("Excel.Application")
	loExcel.Workbooks.Open(lcFile)
	loExcel.Application.Visible = .t.

	lnCEll=1
	lnCellVacia=0

	lnNumCols=loExcel.ActiveSheet.UsedRange.COLUMNS.COUNT
	lnNumRows=loExcel.ActiveSheet.UsedRange.ROWS.COUNT
	
lnNumero=0
lbNewRow=.f.
lnLine = 0
	FOR lnrow=3 TO lnNumRows
		**variables a utilizar 


		WAIT "Calculando fila "+TRANSFORM(lnrow)+"Presione la tecla "+' C '+" para cancelar" WINDOW  TIMEOUT 0.2
		IF INLIST(INKEY(),99,67)
			IF MESSAGEBOX("¿Desea Cancelar la lectura del disco?",36,"¿Cancelar?")=6
				EXIT 
			ENDIF 
		ENDIF 
	
		lcColumna=CHR(64+1)
		lcCell=TRANSFORM(lnrow)
		lcRange=lcColumna+lcCell
		loExcel.Range(lcRange).Select()
	
		lcValueCellNombre=loExcel.ActiveCell.Value
		
					
		IF  ISNULL(lcValueCellNombre)
			lbNewRow=.f.
		ELSE
			lbNewRow=.t.
		ENDIF 

		MESSAGEBOX("EMPTY(lcValueCellNombre)"+TRANSFORM(EMPTY(lcValueCellNombre))+CHR(13)+;
					"ISNULL(lcValueCellNombre):"+TRANSFORM(ISNULL(lcValueCellNombre))+CHR(13)+;
					"lbNewRow:"+TRANSFORM(lbNewRow)+CHR(13)+;
					"lcValueCellNombre:"+TRANSFORM(lcValueCellNombre))
		

		IF lnnumero>6
			EXIT 
		ENDIF 

		IF lbNewRow
			APPEND BLANK IN  clientesimport
			lnNumero = lnNumero + 1 
			lnLine = 1
		ELSE
			lnLine = lnLine + 1 
		ENDIF 

	
		lnValidRow=0
		FOR lnCol=1 TO lnNumCols
			lcColumna=CHR(64+lnCol)
			lcCell=TRANSFORM(lnrow)
			lcRange=lcColumna+lcCell
			loExcel.Range(lcRange).Select()
			
			lcValueCell=loExcel.ActiveCell.Value 
			lcPutValue=TRANSFORM(lcValueCell)

			IF  !ISNULL(lcValueCell)
				IF VARTYPE(lcValueCell)="C"
					lcValueCell = ALLTRIM(lcValueCell)
				ENDIF 

				REPLACE numero 	WITH lnNumero IN clientesimport
				
				DO CASE
				CASE lnCol=1
					REPLACE nombre WITH transform(lcValueCell) IN clientesimport				

				CASE lnCol=2	
					REPLACE registro WITH transform(lcValueCell) IN clientesimport				

				CASE lnCol=3
					REPLACE nit  WITH transform(lcValueCell) IN clientesimport

				CASE lnCol=4
					

						REPLACE direccion  WITH lcValueCell+" "+transform(lcValueCell) IN clientesimport


					
				CASE lnCol=5
					REPLACE GIRO  WITH transform(lcValueCell) IN clientesimport
				
				CASE lnCol=6
					DO CASE
					CASE lnLine = 1
						REPLACE descrip1 WITH transform(lcValueCell) IN clientesimport
					CASE lnLine = 2
						REPLACE descrip2 WITH transform(lcValueCell) IN clientesimport
					CASE lnLine = 3
						REPLACE descrip3 WITH transform(lcValueCell) IN clientesimport
					ENDCASE
					
				OTHERWISE
				ENDCASE				
				Showlog.edit1.value=Showlog.edit1.value+lcPutValue+CHR(9)
				*MESSAGEBOX(loExcel.ActiveCell.Value )
			ELSE
				Showlog.edit1.value=Showlog.edit1.value+" Error en celda"+CHR(9)
			ENDIF &&ActiveCelValue 
		ENDFOR 		
	ENDFOR 
	RELEASE loExcel
ELSE
	MESSAGEBOX("Debe seleccionar un archivo",48,"Error al abrir")
ENDIF 

SELECT clientesimport
BROWSE
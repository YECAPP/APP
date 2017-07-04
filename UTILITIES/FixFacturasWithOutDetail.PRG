CLOSE TABLES ALL 
USE facturas 
COPY TO FULLPATH("")+STRTRAN(STRTRAN(ttoc(DATEtime())+"_"+ALIAS(),"/","_"),":","_")

USE facturaslines 
COPY TO FULLPATH("")+STRTRAN(STRTRAN(ttoc(DATEtime())+"_"+ALIAS(),"/","_"),":","_")

SET DELETED ON 
oExcel = Createobject("Excel.Application")
oExcel.Workbooks.Add()
oExcel.Sheets("Hoja1").Select()
oExcel.Range("A1").Select()
oExcel.ActiveCell.Value ="comparativos antes y despues de modificar tablas "
oExcel.selection.Font.Bold=.t.
oExcel.visible=.t.
SELECT SUM(sneto) as neto,SUM(siva) as iva,SUM(sriva) as riva ,SUM(stotal) as total  FROM facturas  INTO ARRAY laFixFactotalCompare1

lnRow=3
lnFields=ALEN(laFixFactotalCompare1,2)
lnRegistros=ALEN(laFixFactotalCompare1,1)
FOR m=1 TO lnRegistros
	lnRow = lnRow + 1 
	lcRow = TRANSFORM(lnRow)
	
	lnColumn=ASC("A")-1
	FOR n= 1 TO lnFields
		lncolumn = lncolumn + 1 
		lcColumn=CHR(lncolumn )
		oExcel.Range(lcColumn+lcRow).select 
		oExcel.ActiveCell.Value=laFixFactotalCompare1(m,n)
	ENDFOR 
ENDFOR 


SELECT SUM(ROUND(cantidad*precio,2)) as neto FROM facturaslines  INTO ARRAY laFixFactotalCompare2

lnRow = lnRow + 1 
lcRow = TRANSFORM(lnRow)
lcColumn="A"
oExcel.Range(lcColumn+lcRow).select 
oExcel.ActiveCell.Value="Facuraslines"

lnFields=ALEN(laFixFactotalCompare2,2)
lnRegistros=ALEN(laFixFactotalCompare2,1)
FOR m=1 TO lnRegistros
	lnRow = lnRow + 1 
	lcRow = TRANSFORM(lnRow)
	
	lnColumn=ASC("A")-1
	FOR n= 1 TO lnFields
		lncolumn = lncolumn + 1 
		lcColumn=CHR(lncolumn )
		oExcel.Range(lcColumn+lcRow).select 
		oExcel.ActiveCell.Value=laFixFactotalCompare2(m,n)
	ENDFOR 
ENDFOR 


oExcel.Range("A1").Select()
oExcel.Visible = .T.


Release oExcel

SELECT idventa,numero,fecha,idcliente,sneto,siva,sriva,stotal FROM facturas WHERE idventa NOT in (SELECT idventa FROM facturaslines ) INTO CURSOR Mfacts 

SET DELETED OFF 
select idventa,DELETED() as borrado,SUM(cantidad*precio) as total FROM facturaslines WHERE DELETED()=.t. GROUP BY 1 INTO CURSOR borrado
SELECT Mfacts.*, NVL(borrado.borrado,.F.) AS BORRADO ,NVL(borrado.total,0.00) AS TOTAL FROM mfacts LEFT JOIN borrado ON mfacts.idventa=borrado.idventa INTO CURSOR compares


SELECT compares

SCAN
	RELEASE laFactlineLine
	lcIdVenta=compares.idventa 
	lnNeto=compares.sneto
	lnTotalDetail=compares.total
	
	MESSAGEBOX("RELLAMANDO: "+lcidventa )
	
	RECALL FOR idventa=lcidventa IN facturaslines 
	IF ROUND(lnNeto,2)<>ROUND(lnTotalDetail,2)
		MESSAGEBOX("EXISTE DIFERENCIA EN : "+lcidventa )
		SELECT TOP 1 line FROM facturaslines WHERE idventa=lcIdVenta ORDER BY 1 INTO ARRAY laFactlineLine
		IF !VARTYPE(laFactlineLine)="U"
			MESSAGEBOX("SE DEJARAN TODOS A CERO EN "+TRANSFORM(lcIdVenta))
			UPDATE facturaslines SET precio=0.00,cantidad=0.00 WHERE idventa=lcIdVenta
			IF lnNeto<>0.00 
				MESSAGEBOX("AHORA SE PONDRA EL VALOR DEL MAESTRO AL "+TRANSFORM(laFactlineLine))
				UPDATE facturaslines SET precio=lnNeto,cantidad=1 WHERE idventa=lcIdVenta AND line=laFactlineLine
			ENDIF 
		ELSE
			MESSAGEBOX("SE INSERTARA UNO NUEVO")
			lcDescrip="Ingresado Auto. por FixFact el:"+TTOC(DATE())
		
			INSERT INTO FACTURASLINES( IDVENTA,REFERENCIA, DESCRIPCION,CANTIDAD,PRECIO) VALUES (lcIdVenta,"",lcDescrip,1,lnNeto)
			
		ENDIF 		
	ENDIF 
ENDSCAN

SET DELETED ON 


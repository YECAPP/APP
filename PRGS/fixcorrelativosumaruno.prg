SET DELETED ON 
SET DATE FRENCH 
SET exclusive OFF 
lcApartirde="VN00016644"
lcSumaResta="+"



**creando cursor temporal para revision previa de fix correlativo
SELECT;
	idventa,numero,numero2,SPACE(10) as numero3 ,sneto ;
FROM ;
	facturas WHERE idventa=>lcApartirde AND !DELETED() AND sneto>=0 ;
ORDER BY;
	3 ;
INTO CURSOR ;
	cambiar READWRITE 
****************************************************************

**cambiando correlativos  en cursor temporal para su revision 
SELECT cambiar
SCAN
lcNumero2=cambiar.numero2	
	lcPrefix=SUBSTR(lcNumero2,1,2)
	lcNumero=SUBSTR(lcNumero2,3,8)
	lnNumero=VAL(lcNumero)
	lnNewNumero=lnNumero &lcSumaResta 1
	lcNewNumero2=lcPrefix+PADL(ALLTRIM(TRANSFORM(lnNewNumero)),8,"0")
	replace numero3 WITH lcNewNumero2 
	
ENDSCAN
SELECT cambiar 
MESSAGEBOX("Revise los datos a cambiar ")
BROWSE 
****************************************************************
SELECT * FROM facturas INTO CURSOR factemp READWRITE 
**Enviando actualizaciones en un cursor temporal para asegurar que funciono 
SELECT cambiar 
SCAN 
	lcCambiarNumero2=cambiar.numero3
	lcIdVenta=cambiar.idventa
	UPDATE factemp SET numero2=lcCambiarNumero2 WHERE idventa==lcIdVenta 
	SELECT cambiar 
ENDSCAN
MESSAGEBOX("Se han realizado los cambios en un cursor temporal para que lo verifique")
SELECT factemp 
BROWSE 

****************************************************************

**Enviando actualizaciones definitivas a tabla de facturas 
IF INPUTBOX("Desea enviar los cambios a la tabla factura, si o no","Enviar Cambios ")="si"
	
	
	**hacer un backup de facturas 
	IF !USED("facturas")
		USE facturas 
	ENDIF 
	SELECT facturas 
	COPY TO FULLPATH("")+STRTRAN(STRTRAN(ttoc(DATEtime())+"_"+ALIAS(),"/","_"),":","_")
	*************************************************************************
	
	SELECT cambiar 
	SCAN 
		lcCambiarNumero2=cambiar.numero3
		lcIdVenta=cambiar.idventa
		UPDATE facturas  SET numero2=lcCambiarNumero2 WHERE idventa==lcIdVenta 
		SELECT cambiar 
	ENDSCAN
	SELECT facturas 
	BROWSE 
	MESSAGEBOX("Cambios enviados a facturas")
ELSE 
	MESSAGEBOX("se cancelo el envio de los cambios a facturas")
ENDIF 
****************************************************************


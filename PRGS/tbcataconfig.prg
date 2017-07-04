DO tbcataconfig
PROCEDURE tbcataconfig
Create Cursor tbcataconfig(;
	CON1 	C (25 ),;
	CON1dsc 	C (60 ),;
	CON2 	C (25 ),;
	CON2dsc 	C (60 ),;
	CON3 	C (25 ),;
	CON3dsc 	C (60 ),;	
	CON4 	C (25 ),;
	CON4dsc 	C (60 ),;		
	CON5 	C (25 ),;
	CON5dsc 	C (60 ),;			
	RESULTADO 	C (25 ),;
	PRECEDENCIA 	C (10 );
)

DO insdoc WITH "04"
DO insdoc WITH "02"
DO insdoc WITH "06"
DO insdoc WITH "07"
DO insdoc WITH "16"
DO insdoc WITH "08"

DO insdoc WITH "09"
DO insdoc WITH "10"
DO insdoc WITH "11"
DO insdoc WITH "12"
DO insdoc WITH "13"

DO insdoc WITH "03"
DO insdoc WITH "05"
DO insdoc WITH "IVAS"
BROWSE 
DELETE FROM CATACONFIG 
INSERT INTO CATACONFIG ;
	SELECT CON1, CON2, CON3, CON4,CON5,RESULTADO,PRECEDENCIA   FROM tbcataconfig
	
ENDPROC 

PROCEDURE insdoc 
lparameters tciddoc 
DO CASE
CASE tciddoc="04" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"04",;
		documentos.nombre ,;
		cuentasbancarias.idbanco ,;
		bancos.descripcion,;
		cuentasbancarias.idcuenta ,;
		cuentasbancarias.numero,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		cuentasbancarias 	left join bancos on cuentasbancarias.idbanco=bancos.idbanco;
							left join documentos on "04"=documentos.iddoc

CASE tciddoc="02" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"02",;
		documentos.nombre ,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		documentos ;
	where ;
		iddoc="02"
		
CASE tciddoc="06" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"06",;
		documentos.nombre ,;
		"",;
		"",;
		proveedores.idprov,;
		proveedores.nombre,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		proveedores left join documentos on "06"=documentos.iddoc;
	WHERE ;
		idprov in (select distinct idprov FROM docprov )
	

CASE tciddoc="07" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"07",;
		documentos.nombre ,;
		"",;
		"",;
		cajas.idcaja,;
		cajas.descripcion,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		cajas left join documentos on "07"=documentos.iddoc

CASE tciddoc="16" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"16",;
		documentos.nombre ,;
		cuentasbancarias.idbanco ,;
		bancos.descripcion,;
		cuentasbancarias.idcuenta ,;
		cuentasbancarias.numero,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		cuentasbancarias left join documentos on "16"=documentos.iddoc
							
CASE tciddoc="08" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"08",;
		documentos.nombre ,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		documentos ;
	where ;
		iddoc="08"

CASE INLIST(tciddoc,"09","10" ,"11","12","13")
	INSERT INTO tbcataconfig ;
	SELECT ;
		tciddoc,;
		documentos.nombre ,;
		departamentos.iddepto ,;
		departamentos.nombre,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		departamentos left join bancos on cuentasbancarias.idbanco=bancos.idbanco;
							left join documentos on tciddoc=documentos.iddoc	
							
																
CASE tciddoc="03" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"03",;
		documentos.nombre ,;
		cuentasbancarias.idbanco ,;
		bancos.descripcion,;
		cuentasbancarias.idcuenta ,;
		cuentasbancarias.numero,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		cuentasbancarias 	left join bancos on cuentasbancarias.idbanco=bancos.idbanco;
							left join documentos on "03"=documentos.iddoc
							
														
CASE tciddoc="05" 
	INSERT INTO tbcataconfig ;
	SELECT ;
		"05",;
		documentos.nombre ,;
		cuentasbancarias.idbanco ,;
		bancos.descripcion,;
		cuentasbancarias.idcuenta ,;
		cuentasbancarias.numero,;
		"",;
		"",;
		"",;
		"",;
		"",;
		"";
	FROM ;
		cuentasbancarias 	left join bancos on cuentasbancarias.idbanco=bancos.idbanco;
							left join documentos on "05"=documentos.iddoc								

CASE tciddoc="IVAS" 
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVALOCAL",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"RIVA",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"RENTA",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"08",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"09",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"10",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"11",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"12",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"13",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"14",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"IVAVENTA",	"15",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"RIVAVENTA",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
	INSERT INTO TBCATACONFIG (CON1, CON1DSC, CON2, CON2DSC, CON3, CON3DSC, CON4, CON4DSC, CON5, CON5DSC, RESULTADO, PRECEDENCIA);	
	VALUES(	"RENTAVENTA",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"",	"")
		
OTHERWISE

ENDCASE


ENDPROC 


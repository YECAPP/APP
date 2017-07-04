CLOSE TABLES ALL 
CLOSE DATABASES ALL 
CLEAR ALL 
lcTables=	"ABONOSBANCO,"+;
			"CARGOSBANCO,"+;
			"CHEQUERAS,"+;
			"CUENTASBANCARIAS,"+;
			"DETALLEABONOSBANCO,"+;
			"DETALLECARGOSBANCO,"+;
			"CC,"+;
			"DETALLECC,"+;
			"DETALLEDOCPROV,"+;
			"DETALLEFACTURAS,"+;
			"DOCPROV,"+;
			"FACTURAS,"+;
			"FACTURASLINES,"+;
			"OTRING,"+;
			"OTRING_D,"+;
			"OTRING_TP,"+;
			"DETALLEGASTO,"+;
			"ORDENESDEGASTOS,"+;
			"DETALLEORDEN,"+;
			"DETALLEREQUISICION,"+;
			"ORDENCOMPRA,"+;
			"REQUISICIONES,"+;
			"CREDITOSFISCALES,"+;
			"DETALLECREDITOFISCAL,"+;
			"DETALLERETENCIONESRENTA,"+;
			"RETENCIONESRENTA,"+;
			"MPROGRA,"+;
			"MPROGRA_CLD,"+;
			"DETALLEPRESUPUESTO,"+;
			"EQUIPOSPRESUP,"+;
			"PRESUPUESTOS,"+;
			"EQUIPOSPRESUP,"+;
			"PRESUP_PARAM,"+;
			"EQUIPOSPRESUP,"+;
			"VEHICULOSPRESUP,"+;
			"sgaaelog,"+;			
			"EQUIPOS,"+;			
			"BITACORA,"+;			
			"MHOJA_D,"+;												
			"MHOJA,"+;
			"mcontrato_eq,"+;			
			"MPROGRA_S,"+;
			"INVENTARIO,"+;
			"CONVINV,"+;
			"INVFISDIC2009,"+;												
			"MSUCURSAL,"+;												
			"DETALLELISTACONTAC,"+;												
			"CVALES_DET,"+;												
			"MCONTRATO,"+;												
			"VEHICULOS,"+;												
			"rfact_d,"+;												
			"familiainventario,"+;												
			"MO,"+;												
			"NITDIR,"+;												
			"CFACTURAS_DET,"+;												
			"MMECA,"+;												
			"MGRUPO_MECA,"+;												
			"RFACT,"+;	
			"MPROGRA_CLD,"+;																								
			"CONTACCLIEN,"+;																														
			"existencias,"+;																																									
			"CVALES,"+;
			"CLIENTES,"+;
			"PROVEEDORES,"+;
			"contacclien,"+;
			"DETALLELISTACONTAC,"+;
			"INVENTARIO,"+;			
			"familiainventario,"+;						
			"PROYECTOS,"+;
			"PERSONNATURALES,"+;
			"CONTRIBUYENTES,"+;
			"cataconta,"+;
			"tbCOSTOS,"+;
			"CATAL,"+;
			"CFACTURAS,"+;
			"CLIQUIDACIONES_DET,"+;
			"CVEHICULOS,"+;
			"afActivos,"+;
			"CMOTORISTA,"+;
			"CLIQUIDACIONES,"+;
			"ERRORAPP,"+;
			"CAJAS,"+;
			"afUbicas,"+;
			"AUTOCORREL,"+;
			"afClasif,"+;
			"TASAIMPUESTOS,"+;
			"CLCALL,"+;				
			"FACTFAST,"+;
			"CGASOLINERAS,"+;
			"CGASOLINERAS,"+;
			"OAGEN_D,"+;
			"VNDEPOT,"+;			
			"mnper,"+;						
			"CNCTR_D,"+;									
			"OAGEN,"+;									
			"CLCLASIF,"+;												
			"CNCTR,"+;												
			"CLCLASIF,"+;
			"MGRUPO,"+;																		
			"CLCLASIF_E,"+;																					
			"PROV,"+;
			"PROV_D,"+;
			"SGAAELOG,"+;
			"VNDEPOT,"+;
			"VNDEPOTNR,"+;
			"PLVOUCH_D,"+;
			"PLVOUCH,"+;
			"RTC_D,"+;
			"RTC_M,"+;
			"RTC_R,"+;			
			"LP_D,"+;
			"PLPER,"+;
			"OCRC_D,"+;
			"OCRC_M,"+;
			"CATACONFIG,"+;
			"TBMOVINV"
			
			
			

			
			

			
			
CLOSE TABLES ALL 

DO genAtables WITH lcTables

FOR n=1 TO ALEN(aTables)
	lcTable=aTables(n)
	USE (lcTable) EXCLUSIVE IN 0 
	ZAP IN (lcTable)
	SELECT (lcTable)
	REINDEX   
	USE 
ENDFOR 

PROCEDURE genATables
LPARAMETERS tcTables
	**contar numero de comas en la expresion
	N=1
	DO WHILE !ATC(",",tcTables,N)=0
		N = N + 1 
	ENDDO 
	**Separar expresiones para los titulos
	PUBLIC aTables(N)
	lnStartPosition=1
	lnEndPosition=0
	lnCharReturn=0
	FOR N=1 TO ALEN(aTables)
		lnEndPosition=IIF(ATC(",",tcTables,N)=0,LEN(tcTables)+1,ATC(",",tcTables,N))
		lnCharReturn=lnEndPosition-lnStartPosition
		aTables(N)=SUBSTR(tcTables,lnStartPosition,lnCharReturn)
		lnStartPosition=lnEndPosition+1
	ENDFOR
ENDPROC 


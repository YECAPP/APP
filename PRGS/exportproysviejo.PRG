PROCEDURE EXPORTPROYSVIEJO
	LPARAMETERS tnTipo 
	IF PCOUNT()=1
		lnTipo=tnTipo
	ELSE
		lnTipo=2  &&scanear todos los proyectos 
	ENDIF 
	
	*EXPORT projects 
	SET EXCLUSIVE OFF
	CLOSE TABLES ALL 
	
	IF DIRECTORY("..\gamaa\planilla")
		USE ("..\gamaa\proyectos.dbf") ALIAS ProyDest IN 0
		USE ("data\proyectos") ALIAS ProyOrg IN 0 
		USE ("..\gamaa\planilla\PROYECTOSP") ALIAS ProyDestPlanilla IN 0

		SELECT ProyDest 
		COPY TO "..\gamaa\"+ALIAS()+"_"+TTOC(datetime(),1)
		
		SELECT ProyDestPlanilla
		COPY TO "..\gamaa\planilla\"+ALIAS()+"_"+TTOC(datetime(),1)

	ELSE
		lcUnidad="F:"
		lcCarpetaNuevo="Gama GA Sistemas\sgaa"
		lcCarpetaViejo="Gama GA Sistemas\gamaa"
		lcCarpetaPlanilla="Gama GA Sistemas\gamaa\planilla"
		IF DIRECTORY(lcUnidad+"\"+lcCarpetaNuevo+"\data")
			CD (lcUnidad+"\"+lcCarpetaNuevo+"\data")

			USE (lcUnidad+"\"+lcCarpetaViejo+"\proyectos") ALIAS ProyDest IN 0
			USE (lcUnidad+"\"+lcCarpetaNuevo+"\data\proyectos") ALIAS ProyOrg IN 0 
			USE (lcUnidad+"\"+lcCarpetaPlanilla+"\PROYECTOSP") ALIAS ProyDestPlanilla IN 0
		
			SELECT ProyDest
			COPY TO lcUnidad+"\"+lcCarpetaViejo+"\"+ALIAS()+"_"+TTOC(datetime(),1)
			
			SELECT ProyDestPlanilla
			COPY TO lcUnidad+"\"+lcCarpetaPlanilla+"\"+ALIAS()+"_"+TTOC(datetime(),1)
		ELSE
			lcUnidad=""
			lcCarpetaNuevo="\\Servidor\data\Gama GA Sistemas\SGAA"
			lcCarpetaViejo="\\Servidor\data\Gama GA Sistemas\gamaa"					
			lcCarpetaPlanilla="\\Servidor\data\Gama GA Sistemas\gamaa\planilla"
			IF DIRECTORY(lcCarpetaNuevo)
				CD (lcUnidad+"\"+lcCarpetaNuevo+"\data")

				USE (lcUnidad+"\"+lcCarpetaViejo+"\proyectos") ALIAS ProyDest IN 0
				USE (lcUnidad+"\"+lcCarpetaNuevo+"\data\proyectos") ALIAS ProyOrg IN 0 
				USE (lcUnidad+"\"+lcCarpetaPlanilla+"\PROYECTOSP") ALIAS ProyDestPlanilla IN 0
			
				SELECT ProyDest
				COPY TO lcUnidad+"\"+lcCarpetaViejo+"\"+ALIAS()+"_"+TTOC(datetime(),1)
				
				SELECT ProyDestPlanilla
				COPY TO lcUnidad+"\"+lcCarpetaPlanilla+"\"+ALIAS()+"_"+TTOC(datetime(),1)
			ELSE
				MESSAGEBOX("No se pudo encontrar la carpeta de la planilla ni la del sistema viejo",16,"Error")
				CANCEL 
			ENDIF 			
		ENDIF 
	ENDIF 
	**creando una copia de proyectos destino

	**crear una copia de proyectos planilla 

	


	lnYaexiste=0
	lnCreados=0

	lnYaexiste2=0
	lnCreados2=0
	SELECT proyorg 
*	MESSAGEBOX(DBF())


	 
	
	IF lntipo=1

		SELECT IDPROYECTOS,NOMBRE,IDCLIENTE, INICIA, FINALIZA, DEPTO FROM PROYORG  WHERE UPDATE2VIEJO=.F. INTO ARRAY LAPROYS2SEND

	ELSE

		SELECT IDPROYECTOS,NOMBRE,IDCLIENTE, INICIA, FINALIZA, DEPTO  FROM PROYORG  INTO ARRAY LAPROYS2SEND
	ENDIF 

IF !VARTYPE(LAPROYS2SEND)="U"
FOR LNPROYS2SEND=1 TO ALEN(LAPROYS2SEND,1)
		RELEASE laproy,laproyPlanilla
		
		lcproyecto=ALLTRIM(LAPROYS2SEND(LNPROYS2SEND,1))
		lcnombre=LAPROYS2SEND(LNPROYS2SEND,2)
		lccliente=LAPROYS2SEND(LNPROYS2SEND,3)
		lcfechai=LAPROYS2SEND(LNPROYS2SEND,4)
		lcfechaf=LAPROYS2SEND(LNPROYS2SEND,5)
		lcdepto=LAPROYS2SEND(LNPROYS2SEND,6)

*!*		SCAN &lcExec
*!*			RELEASE laproy,laproyPlanilla
*!*			lcproyecto=ALLTRIM(proyorg.idproyectos)
*!*			lcnombre=proyorg.nombre
*!*			lccliente=proyorg.idcliente
*!*			lcfechai=proyorg.inicia
*!*			lcfechaf=proyorg.finaliza
*!*			lcdepto=proyorg.depto

		**26/11/2013 atualizando en proyectos del viejo 
		
		SELECT codigo FROM ProyDest WHERE ALLTRIM(UPPER(codigo))==ALLTRIM(UPPER(lcproyecto)) INTO ARRAY laproy
		IF VARTYPE(laproy)="U"	
			INSERT 	INTO ProyDest(codigo,nombre,cliente,fechai,fechaf,depto);
				VALUES(lcproyecto,lcnombre,lccliente,lcfechai,lcfechaf,lcdepto)
			WAIT "ingresando codigo :"+lcproyecto+ " van "+TRANSFORM(lnCreados ) WINDOW NOWAIT 
			lnCreados = lnCreados + 1 
		ELSE
			lnYaexiste = lnYaexiste + 1 
			WAIT "codigo :"+lcproyecto +" ya existe " WINDOW NOWAIT 
		ENDIF 
		**Fin 26/11/2013 atualizando en proyectos del viejo 

		**26/11/2013 atualizando en proyectos en planilla 
		SELECT codigo FROM ProyDestPlanilla WHERE ALLTRIM(UPPER(codigo))==ALLTRIM(UPPER(lcproyecto)) INTO ARRAY laproyPlanilla
		IF VARTYPE(laproyPlanilla)="U"
			INSERT 	INTO ProyDestPlanilla(codigo,nombre);
				VALUES(lcproyecto,lcnombre)
			WAIT "ingresando codigo en planilla:"+lcproyecto+ " van "+TRANSFORM(lnCreados2 ) WINDOW NOWAIT 
			lnCreados2 = lnCreados2 + 1 
		ELSE
			lnYaexiste2 = lnYaexiste2 + 1 
			WAIT "codigo :"+lcproyecto +" ya existe " WINDOW NOWAIT 
		ENDIF 
		**Fin 26/11/2013 atualizando en proyectos en planilla  
		
		UPDATE PROYECTOS SET UPDATE2VIEJO=.T. WHERE IDPROYECTOS==ALLTRIM(UPPER(lcproyecto)) 
		
**	ENDSCAN



ENDFOR 


	MESSAGEBOX(	"creados "+TRANSFORM(lnCreados)+" ya existian"+TRANSFORM(lnYaexiste)+ CHR(13)+;
				"creados en planilla"+TRANSFORM(lnCreados2)+" ya existian"+TRANSFORM(lnYaexiste2),0,"Resultado")
ELSE 
	MESSAGEBOX(	"No se encontraron proyectos",0,"Resultado")
ENDIF 				
ENDPROC 

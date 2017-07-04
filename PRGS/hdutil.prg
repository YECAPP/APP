
	DO CopyFilesConta 


PROCEDURE CopyFilesConta

	CLEAR 
	LOCAL lcList AS String 
	LOCAL LAFILES 
	CopyFileContaCreateList(@lcList)
	ArrayFromList2(@LAFILES,lcList)
	
	lcPath="YEC"
	lcDirectorioTargetBase=FULLPATH('')
	lcDirectorioSourceBase="c:\users\yec\documents\fox\"+lcPath+"\"
	
	**MOSTRAR RESULTADOS DE LA COPIA 
	DO FORM utilityShowLog NAME Showlog 
	Showlog.edit1.value=Showlog.edit1.value+"Empezando copia de archivos"
	lnCountFile=0

	
	FOR n=1 TO ALEN(laFiles,1)
		lnCountFile = lnCountFile + 1 
		CLEAR
		lcFile=ALLTRIM(laFiles(n,2))
		lcFile2=ALLTRIM(laFiles(n,3))
		lcDirectorioSource=IIF(!EMPTY(laFiles(n,1)),ALLTRIM(lcDirectorioSourceBase)+ALLTRIM(laFiles(n,1))+"\",ALLTRIM(lcDirectorioSourceBase))
		
		lcDirectorioTarget=IIF(!EMPTY(laFiles(n,4)),lcDirectorioTargetBase+ALLTRIM(laFiles(n,4))+"\",lcDirectorioTargetBase)
		
		lbDeleteFile=.f.
		lbDeleteFile2=.f.
		
		lbValid=.t.
		lcMsg=""
		
		DO CopyFileContaVerificar
		*?lcFile	+	" Borrar File en Source: "+TRANSFORM(lbDeleteFile)+" "+;
		lcFile2	+	" Borrar File2 en Source: "+TRANSFORM(lbDeleteFile2)+" "+;
					" Existen Files: "+TRANSFORM(lbValid)+" "+CHR(13)
		
		*?lcMsg
		IF lbValid 
			
			COPY FILE (lcDirectorioSource+lcFile) TO (lcDirectorioTarget+lcFile)
			COPY FILE (lcDirectorioSource+lcFile2) TO (lcDirectorioTarget+lcFile2)	
			
		ENDIF 

*!*		IF lbDeleteFile2
*!*			messagebox(lbDeleteFile2)
*!*		ENDIF 
		IF !EMPTY(lcMsg)
			*MESSAGEBOX(lcMsg)
			Showlog.edit1.value=lcMsg+Showlog.edit1.value
		ENDIF 
		*lcFile=lcFile+" "+TRANSFORM(laFiles(n,m))+" "
	ENDFOR 
	Showlog.edit1.value=TRANSFORM(lnCountFile )+ " Copiados con éxito"+CHR(13)+Showlog.edit1.value
	Showlog.show
ENDPROC 

PROCEDURE CopyFileContaCreateList
LPARAMETERS lcList
	*utilityShowLog.scx no se copia 
	*hdutil.prg no se copia 
	
	lcList=	" :altertable2.FXP:altertable2.PRG:,"+;
			"FORMS:cataver20.SCT:cataver20.SCX:FORMS,"+;
			"FORMS:cncta.SCT:cncta.scx:FORMS,"+;
			"FORMS:CNPDA.SCT:CNPDA.SCX:FORMS,"+;
			"FORMS:fccnc1.SCT:fccnc1.scx:FORMS,"+;
			"FORMS:gridcnctas.SCT:gridcnctas.scx:FORMS,"+;
			"FORMS:gridcnctasprueba.SCT:gridcnctasprueba.scx:FORMS,"+;
			"FORMS:gridcnpdas.SCT:gridcnpdas.scx:FORMS,"+;
			"FORMS:gridcnpdassel.SCT:gridcnpdassel.scx:FORMS,"+;
			"FORMS:msgbox.SCT:msgbox.scx:FORMS,"+;
			"FORMS:reportes.SCT:reportes.scx:FORMS,"+;
			"FORMS:ventanacomandos.SCT:ventanacomandos.scx:FORMS,"+;
			"LIB1.0:_Conta.VCT:_Conta.VCX:LIB1.0,"+;
			"LIB1.0:_vars.VCT:_vars.VCX:LIB1.0,"+;
			"LIB1.0:lmcal.VCT:lmcal.VCX:LIB1.0,"+;
			"LIB1.0:ycomapps.VCT:ycomapps.VCX:LIB1.0,"+;			
			"LIB1.0:ycomponents.VCT:ycomponents.VCX:LIB1.0,"+;			
			"LIB1.0:yoapp.VCT:yoapp.VCX:LIB1.0,"+;			
			"PRGS:cambiarnombre.FXP:cambiarnombre.PRG:PRGS,"+;
			"PRGS:cleanbd.FXP:cleanbd.PRG:PRGS,"+;
			"PRGS:frxtoxls.FXP:frxtoxls.PRG:PRGS,"+;			
			"PRGS:importcata.FXP:importcata.PRG:PRGS,"+;			
			"PRGS:contamain.FXP:contamain.PRG:PRGS,"+;
			"CONTA\CNREPORTS:auxiliar.FRT:auxiliar.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:balancecompro.FRT:balancecompro.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:balancegen.FRT:balancegen.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:balancegen2.FRT:balancegen2.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:cata.FRT:cata.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:CNpda.FRT:CNpda.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:CNPDAV2.FRT:CNPDAV2.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:diamay.FRT:diamay.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:er.FRT:er.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:mayor.FRT:mayor.FRX:REPORTS,"+;
			"CONTA\CNREPORTS:pda.FRT:pda.FRX:REPORTS"
ENDPROC


PROCEDURE CopyFileContaVerificar
	*verificar si existe DIRECTORIO en SOURCE
	IF !DIRECTORY(lcDirectorioSource)
		lbValid=.f.
		lcMsg="Directorio Source:"+lcDirectorioSource+" no existe"+CHR(13)
	ENDIF 
	
	*verificar si existe archivo en SOURCE
	IF !FILE(lcDirectorioSource+lcFile)
		lbValid=.f.
		lcMsg=lcmsg+"Archivo Source:"+lcDirectorioSource+lcFile+" no existe"+CHR(13)
	ENDIF 
	
	*verificar si existe archivo2  en SOURCE
	IF !FILE(lcDirectorioSource+lcFile2)
		lbValid=.f.
		lcMsg=lcmsg+"Archivo2 Source:"+lcDirectorioSource+lcFile2+" no existe"+CHR(13)				
	ENDIF 

	
	*verificar si existe DIRECTORIO en TARGET
	IF !DIRECTORY(lcDirectorioTarget)
		lbValid=.f.
		lcMsg=lcmsg+"Directorio Target:"+lcDirectorioTarget+" no existe"+CHR(13)				
	ENDIF 
	
	
	*verificar si existe archivo en TARGET
	IF FILE(lcDirectorioTarget+lcFile)
		lbDeleteFile=.t.
	ENDIF 
	*verificar si existe archivo2 en TARGET
	IF FILE(lcDirectorioTarget+lcFile2)
		lbDeleteFile2=.t.
	ENDIF 			
ENDPROC


PROCEDURE getSerialDisk
	clear
	objwmi = GETOBJECT("winmgmts:\\")
	ccadwmi = "Select * from Win32_LogicalDisk where Name = "+CHR(34)+SYS(5)+CHR(34)
	osistema = objwmi.execquery(ccadwmi)
	FOR EACH disco IN osistema
		a = disco.volumeserialnumber
		?disco.volumeserialnumber
	ENDFOR
	tohere = VAL(CHR(50)+CHR(48)+CHR(48))
	?tohere 
	MESSAGEBOX(a )
	_cliptext=a
ENDPROC 
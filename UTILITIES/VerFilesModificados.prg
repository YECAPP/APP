SET DATE FRENCH 
LOCAL LCFOLDER,LCARCHIVO
LCFOLDER="C:\Users\YEC\Documents\FOX\GAA\"
LCARCHIVO="*.*"
LDFECHA1=CTOD("05/07/2012")
LDFECHA2=CTOD("31/07/2012")


LOCAL loFiler AS 'Filer.FileUtil'
arch=fcreate("c:\archivo1.txt")
fputs(arch,"Archivos modificados:"+tTOC(DATEtime()))

*-- Creo el objeto
loFiler = CREATEOBJECT('Filer.FileUtil')
*-- Indico la ruta
loFiler.SearchPath = LCFOLDER &&HOME(1)
*-- Indico el archivo o mascara (Ej: *.dbf)
loFiler.FileExpression =LCARCHIVO && 'Customer.dbf'
*-- Indico que busque en subcarpetas
loFiler.SubFolder = 1
*-- Busco...
loFiler.Find(0)

IF loFiler.Files.Count > 0
	lcfolderant=""
	FOR lnCant = 1 TO loFiler.Files.Count
		LDFECHAARCH=TTOD(DATETIME(1899,12,30) + loFiler.Files.Item(lnCant).LastWriteTime * 86400)
		IF 	BETWEEN(LDFECHAARCH,LDFECHA1,LDFECHA2) AND ;
	  		loFiler.Files.Item(lnCant).Size<>0 AND ;
	  		!UPPER(loFiler.Files.Item(lnCant).path)==UPPER(LCFOLDER)
		  	fputs(arch,' ' )
		  	WITH loFiler.Files.Item(lnCant)	  
				IF lcfolderant<>'Ruta: ' + .Path
				    fputs(arch,' ' )
				    fputs(arch,' ' )
				    fputs(arch,'Ruta: ' + .Path) 
				    lcfolderant='Ruta: ' + .Path
			    ENDIF 
				*fputs(arch,'Archivo ' + TRANSFORM(lnCant))      
			    fputs(arch, 'Nombre: >>' + .Name)
				fputs(arch, 'Tamaño: ' + TRANSFORM(.Size/(1024))+"KB")
				*fputs(arch,'Creado: ' + TRANSFORM(DATETIME(1899,12,30) + .DateTime * 86400))
				fputs(arch,'Modificado: ' +TRANSFORM(DATETIME(1899,12,30) + .LastWriteTime * 86400))
				*fputs(arch,'Ultimo acceso: ' + TRANSFORM(DATETIME(1899,12,30) + .LastAccessTime * 86400))
	    	ENDWITH
	  	ENDIF   
	ENDFOR
ELSE
	? 'El archivo no se encontró.'
ENDIF
loFiler = NULL
fclose(arch)
RUN /N2 Notepad c:\Archivo1.txt 

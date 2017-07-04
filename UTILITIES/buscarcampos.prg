**SIRVE PARA BUSCAR TODAS LAS TABLAS QUE TENGAN UN DETERMINADO CAMPO

DO buscarcampos WITH "NIT",""
PROCEDURE buscarcampos
LPARAMETERS tcParam,tcdirectory
**generando archivo de resultados 
arch=fcreate("c:\archivo3.txt")
	**generando matriz con archivos en los que se buscara 
	IF !EMPTY(tcdirectory)
		CD &tcdirectory
	ENDIF 

	ADIR(laFiles,"*.dbf")
	**generando arcchivos
	*CLEAR 
	*buscar(tcParam)
	buscar("NIT")
	buscar("REGISTRO")
fclose(arch)
RUN /N2 Notepad c:\Archivo3.txt 
ENDPROC 

PROCEDURE BUSCAR 
LPARAMETERS tcparam 
	fputs(arch," ")
	fputs(arch, "Campo  a buscar:"+tcparam)
	FOR n=1 TO ALEN(laFiles,1)
		lcTable=UPPER(laFiles(n,1))
		lcTable=STRTRAN(lcTable,".DBF","")
			USE (lcTable) EXCLUSIVE 
			AFIELDS(lafields)
			FOR m=1 TO ALEN(lafields,1)
				lcCampo=lafields(m,1)
		*		MESSAGEBOX(lcCampo)
				IF ALLTRIM(UPPER(lcCampo))=tcparam 
					fputs(arch, lcTable )
				ENDIF 
			ENDFOR 
			USE 
	ENDFOR 
ENDPROC 

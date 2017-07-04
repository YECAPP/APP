PROCEDURE CONVERTMES 
	LPARAMETERS tiMes 
	lcReturn=""
	DO CASE
	CASE tiMes=1
		lcReturn="Enero"
	CASE tiMes=2
		lcReturn="Febrero"	
	CASE tiMes=3
		lcReturn="Marzo"	
	CASE tiMes=4
		lcReturn="Abril"	
	CASE tiMes=5	
		lcReturn="Mayo"	
	CASE tiMes=6
		lcReturn="Junio"	
	CASE tiMes=7
		lcReturn="Julio"	
	CASE tiMes=8		
		lcReturn="Agosto"		
	CASE tiMes=9
		lcReturn="Septiembre"	
	CASE tiMes=10
		lcReturn="Octubre"	
	CASE tiMes=11
		lcReturn="Noviembre"	
	CASE tiMes=12			
		lcReturn="Diciembre"		
	OTHERWISE
		lcReturn=""		

	ENDCASE
	
	RETURN lcreturn 
ENDPROC 

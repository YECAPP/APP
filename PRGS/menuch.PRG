PROCEDURE MENUCH
PARAMETERS lcIdDoc,lcRef
	LOCAL lcValue
	DO CASE
		CASE INLIST(lcIdDoc,"03","05","06","07")
			&&nivel principal 
			DEFINE POPUP MENUCH SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF MENUCH PROMPT "Nuevo Documento";
				PICTURE "..\ico\inventario.png"
			DEFINE BAR 2 OF MENUCH PROMPT "Buscar";
				PICTURE "..\ico\gastos.png"
			DEFINE BAR 3 OF MENUCH PROMPT "Modificar";
				PICTURE "..\ico\MANODEOBRA.png"
			ON SELECTION BAR 1 OF MENUCH DO FORM FcMenu with 1 to lcValue 
			ON SELECTION BAR 2 OF MENUCH DO FORM FcMenu with 2 to lcValue 
			ON SELECTION BAR 3 OF MENUCH MESSAGEBOX("No disponible por el momento")											
			ACTIVATE POPUP MENUCH
	OTHERWISE
	ENDCASE
	RETURN lcValue 
ENDPROC 

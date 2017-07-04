PROCEDURE insertgridformat 
LPARAMETERS lcAlias,lcForm

IF PCOUNT()<2
	lcAlias=INPUTBOX("Ingrese nombre de cursor")
	lcForm=INPUTBOX("Ingrese nombre de formulario")
ENDIF 

IF !EMPTY(lcForm)
	IF !EMPTY(lcAlias)
		AFIELDS(laCampos,lcAlias)
		FOR n=1 TO ALEN(laCampos,1)
			RELEASE laLine
			SELECT line FROM GRDCOLS WHERE cursor=lcAlias AND campo=laCampos(n,1) AND caption=laCampos(n,1) AND form=lcForm INTO ARRAY laLine
			IF VARTYPE(laLine)="U"
				INSERT INTO GRDCOLS(form,cursor,campo,caption,orden,visible,width,sombrear );
					VALUES (UPPER(lcForm),UPPER(lcAlias),UPPER(laCampos(n,1)),UPPER(laCampos(n,1)),n,.t.,0,.F.)
			ELSE
				UPDATE ;
					GRDCOLS ;
				SET ;
					cursor=lcAlias,;
					campo=laCampos(n,1),;
					caption=laCampos(n,1),;
					orden=n,;
					visible=.t.;
				WHERE ;
					line=laLine
			ENDIF 
		ENDFOR 
	ENDIF 
ENDIF 
ENDPROC 
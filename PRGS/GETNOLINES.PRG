PROCEDURE GETNOLINES
LPARAMETERS LCIDDOC

IF VARTYPE(gcReportFF)="U"
	DO CONFIGAPP 
ENDIF 


lnreturn=10
DO CASE
CASE LCIDDOC="09" &&FF
	lnreturn=gnLinesFF
CASE LCIDDOC="10" &&CF
	lnreturn=gnLinesCF
CASE LCIDDOC="11" &&NF
	lnreturn=gnLinesNF
CASE LCIDDOC="12" &&ND
	lnreturn=gnLinesND
CASE LCIDDOC="13" &&FE
	lnreturn=gnLinesFE
CASE LCIDDOC="14" &&NR
	lnreturn=gnLinesNR
CASE LCIDDOC="15" &&RI
	lnreturn=gnLinesRI
OTHERWISE

ENDCASE


RETURN lnreturn 

ENDPROC 
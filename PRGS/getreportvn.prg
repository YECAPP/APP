PROCEDURE GETREPORTVN
LPARAMETERS LCIDDOC

IF VARTYPE(gcReportFF)="U"
	DO CONFIGAPP 
ENDIF 



lcreturn="VN"
DO CASE
CASE LCIDDOC="09" &&FF
	lcreturn=gcReportFF
CASE LCIDDOC="10" &&CF
	lcreturn=gcReportCF
CASE LCIDDOC="11" &&NF
	lcreturn=gcReportNF
CASE LCIDDOC="12" &&ND
	lcreturn=gcReportND
CASE LCIDDOC="13" &&FE
	lcreturn=gcReportFE
CASE LCIDDOC="14" &&NR
	lcreturn=gcReportNR
CASE LCIDDOC="15" &&RI
	lcreturn=gcReportRI
OTHERWISE

ENDCASE

RETURN lcreturn 

ENDPROC 
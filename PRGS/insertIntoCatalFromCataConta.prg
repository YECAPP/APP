**27 MAY 2014 SE AGREGO INSERCION DE CTAS DE CATACCONTA A CATAL 
**CATACONTA: contiene todas las cuentas del catalogo de cuentas 
**CATAL: 	contiene todas las cuentas que se usan en los documentos 
**WARNING: no ejecutar dos veces o dupllicara las cuentas en CATAL


lcCodigo="5102"
lcDoc="42"
INSERT INTO catal(codigo,nombre,iddoc) SELECT codigo, nombre ,lcDoc FROM cataconta WHERE codigo=lcCodigo AND LEN(ALLTRIM(codigo))>LEN(ALLTRIM(lcCodigo))
lcCodigo="5103"
INSERT INTO catal(codigo,nombre,iddoc) SELECT codigo, nombre ,lcDoc FROM cataconta WHERE codigo=lcCodigo AND LEN(ALLTRIM(codigo))>LEN(ALLTRIM(lcCodigo))
lcCodigo="5104"
INSERT INTO catal(codigo,nombre,iddoc) SELECT codigo, nombre ,lcDoc FROM cataconta WHERE codigo=lcCodigo AND LEN(ALLTRIM(codigo))>LEN(ALLTRIM(lcCodigo))

lcCodigo="5102"
lcDoc="41"
INSERT INTO catal(codigo,nombre,iddoc) SELECT codigo, nombre ,lcDoc FROM cataconta WHERE UPPER(NOMBRE)="VIATICOS" 
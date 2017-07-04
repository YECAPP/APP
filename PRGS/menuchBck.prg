PROCEDURE MENUCH
PARAMETERS lcIdDoc,lcRef
	LOCAL lcValue
	DO CASE
		CASE INLIST(lcIdDoc,"03","06","07")
			&&nivel principal 
			DEFINE POPUP MENUCH SHORTCUT RELATIVE FROM MROW(),MCOL()
			DEFINE BAR 1 OF MENUCH PROMPT "Compras";
				PICTURE "..\ico\inventario.png"
			DEFINE BAR 2 OF MENUCH PROMPT "Gastos";
				PICTURE "..\ico\gastos.png"
			DEFINE BAR 3 OF MENUCH PROMPT "Mano de Obra";
				PICTURE "..\ico\MANODEOBRA.png"
			DEFINE BAR 4 OF MENUCH PROMPT "Cajas Chicas";
				PICTURE "..\ico\CAJACHICA_peq.png"
			DEFINE BAR 5 OF MENUCH PROMPT "Quedans";
				PICTURE "..\ico\QUEDAN_LITLE.png"				
			ON BAR 1 OF MENUCH ACTIVATE POPUP COMPRAS
			ON BAR 2 OF MENUCH ACTIVATE POPUP GASTOS
			ON BAR 3 OF MENUCH ACTIVATE POPUP MANODEOBRA
			ON BAR 4 OF MENUCH ACTIVATE POPUP CAJACHICA
			ON BAR 5 OF MENUCH ACTIVATE POPUP QUEDAN
			
			
********************************************************************************************************************************************************************************************************************						
				&&Compras NIVEL DOS 
				DEFINE POPUP COMPRAS SHORTCUT RELATIVE
				DEFINE BAR 1 OF COMPRAS PROMPT "Buscar Orden de Compra";
					SKIP FOR SKIPPER(50101);
					PICTURE "..\ico\ordencompra.png"
				DEFINE BAR 2 OF COMPRAS PROMPT "Modificar Orden de Compra";
					SKIP FOR SKIPPER(50101);
					PICTURE "..\ico\ordencompra.png"
				DEFINE BAR 3 OF COMPRAS PROMPT "Crear Orden de Compra";
					SKIP FOR SKIPPER(50101);
					PICTURE "..\ico\ordencompra.png"
				
					ON SELECTION BAR 1 OF compras DO FORM FcOC TO lcValue 
					IF SUBSTR(LCREF,1,2)=="OC"
						ON SELECTION BAR 2 OF compras DO FORM ORDENCOMPRA WITH 2,lcRef,8 TO lcValue
					ENDIF 
					ON SELECTION BAR 3 OF compras DO FORM ORDENCOMPRA WITH 1,"",8 TO lcValue
********************************************************************************************************************************************************************************************************************						
				&&Gastos NIVEL DOS 
				DEFINE POPUP GASTOS SHORTCUT RELATIVE
				DEFINE BAR 1 OF GASTOS PROMPT "Viaticos";
					SKIP FOR SKIPPER(50202);
					PICTURE "..\ico\viaticos.png"
				DEFINE BAR 2 OF GASTOS PROMPT "Ordenes de Gastos";
					SKIP FOR SKIPPER(50201);
					PICTURE "..\ico\gastos.png"
				DEFINE BAR 3 OF GASTOS PROMPT "Activo Fijo";
					SKIP FOR SKIPPER(50212);
					PICTURE "..\ico\ACTIVOFIJO.png"
				DEFINE BAR 4 OF GASTOS PROMPT "Prestamos";
					SKIP FOR SKIPPER(50203);
					PICTURE "..\ico\prestamos.png"
				DEFINE BAR 5 OF GASTOS PROMPT "\-"
				DEFINE BAR 6 OF GASTOS PROMPT "Combustible";
					SKIP FOR SKIPPER(50210);
					PICTURE "..\ico\combustible.png"
				DEFINE BAR 7 OF GASTOS PROMPT "Servicios Basicos ";
					SKIP FOR SKIPPER(50204);
					PICTURE "..\ico\SERVICIOSBASICOS.png"
				DEFINE BAR 8 OF GASTOS PROMPT "Reparacion de Vehiculos";
					SKIP FOR SKIPPER(50213);
					PICTURE "..\ico\REPVEHICULO.png"
				DEFINE BAR 9 OF GASTOS PROMPT "Honorarios de Vigilancia";
					SKIP FOR SKIPPER(50216);
					PICTURE "..\ico\HONORARIOSVIGILANCIA.png"
				DEFINE BAR 10 OF GASTOS PROMPT "Complementos";
					SKIP FOR SKIPPER(50215);
					PICTURE "..\ico\COMPLEMENTOS.png"
				DEFINE BAR 11 oF GASTOS PROMPT "Herramientas y/o Equipo de Oficina ";
					SKIP FOR SKIPPER(50211);
					PICTURE "..\ico\HERRAMIENTAS.png"
				DEFINE BAR 12 oF GASTOS PROMPT "Gases";
					SKIP FOR SKIPPER(50209);
					PICTURE "..\ico\GASES.png"
				DEFINE BAR 13 oF GASTOS PROMPT "Articulos de Oficina";
					SKIP FOR SKIPPER(50205);
					PICTURE "..\ico\ARTICULOSOFICINA.png"
				DEFINE BAR 14 oF GASTOS PROMPT "Mantto de Instalaciones";
					SKIP FOR SKIPPER(50206);
					PICTURE "..\ico\MANTTOOFICINA.png"
				DEFINE BAR 15 oF GASTOS PROMPT "Gastos Financieros";
					SKIP FOR SKIPPER(50207);
					PICTURE "..\ico\GASTOSFINANCIEROS.png"
				DEFINE BAR 16 OF GASTOS PROMPT "Planilla Afp/Isss";
					SKIP FOR SKIPPER(50208);
					PICTURE "..\ico\PLANILLAISSS.png"


						ON BAR 1 OF gastos ACTIVATE POPUP viaticos
						ON BAR 2 OF gastos ACTIVATE POPUP ordenesdeg
						ON BAR 3 OF gastos ACTIVATE POPUP ActivoFijo
						ON BAR 4 OF gastos ACTIVATE POPUP prestamos
						ON BAR 6 OF gastos ACTIVATE POPUP Combustible					
						ON BAR 7 OF gastos ACTIVATE POPUP ServiciosBasicos  	
						ON BAR 8 OF gastos ACTIVATE POPUP RepVehiculos 						
						ON BAR 9 OF gastos ACTIVATE POPUP HonorVigilancia				
						ON BAR 10 OF gastos ACTIVATE POPUP Complementos
						ON BAR 11 OF gastos ACTIVATE POPUP HerEqOficina
						ON BAR 12 OF gastos ACTIVATE POPUP Gases
						ON BAR 13 OF gastos ACTIVATE POPUP ArticulosdeOficina
						ON BAR 14 OF gastos ACTIVATE POPUP ManttodeOficina
						ON BAR 15 OF gastos ACTIVATE POPUP GastosFinancieros
						ON BAR 16 OF gastos ACTIVATE POPUP PLANILLAAFPISSS
						
						
						
									&&Gases 
									DEFINE POPUP Gases SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF Gases PROMPT "Buscar Gases";
										PICTURE "..\ico\GASES.png"
									DEFINE BAR 2 OF Gases PROMPT "Modificar Gases";
										SKIP FOR SKIPPER(50209);
										PICTURE "..\ico\GASES.png"
									DEFINE BAR 3 OF Gases PROMPT "Crear Gases";
										SKIP FOR SKIPPER(50209);
										PICTURE "..\ico\GASES.png"

									ON SELECTION BAR 1 OF Gases do form fcOg WITH "456" to lcValue
									IF SUBSTR(LCREF,1,2)=="GS"
									ON SELECTION BAR 2 OF Gases do form gastos WITH 2,lcRef,8,"456" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF Gases do form gastos WITH 1,lcRef,8,"456" TO lcValue	


 
 									&&Honorarios de Vigilancia 
									DEFINE POPUP HonorVigilancia SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF HonorVigilancia PROMPT "Buscar Honorarios de Vigilancia";
										PICTURE "..\ico\HONORARIOSVIGILANCIA.png"
									DEFINE BAR 2 OF HonorVigilancia PROMPT "Modificar Honorarios de Vigilancia";
										SKIP FOR SKIPPER(50216);
										PICTURE "..\ico\HONORARIOSVIGILANCIA.png"
									DEFINE BAR 3 OF HonorVigilancia PROMPT "Crear Honorarios de Vigilancia";
										SKIP FOR SKIPPER(50216);
										PICTURE "..\ico\HONORARIOSVIGILANCIA.png"

									ON SELECTION BAR 1 OF HonorVigilancia do form fcOg WITH "453" to lcValue
									IF SUBSTR(LCREF,1,2)=="HV"
									ON SELECTION BAR 2 OF HonorVigilancia do form gastos WITH 2,lcRef,8,"453" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF HonorVigilancia do form gastos WITH 1,lcRef,8,"453" TO lcValue	
 
 
 
 
									&&Herramienta y Equipo de Oficina
									DEFINE POPUP MttoInstalaciones SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF MttoInstalaciones PROMPT "Buscar Herramienta y Equipo de Oficina";
										PICTURE "..\ico\HERRAMIENTAS.png"
									DEFINE BAR 2 OF MttoInstalaciones PROMPT "Modificar Herramienta y Equipo de Oficina";
										SKIP FOR SKIPPER(50206);
										PICTURE "..\ico\HERRAMIENTAS.png"
									DEFINE BAR 3 OF MttoInstalaciones PROMPT "Crear Herramienta y Equipo de Oficina";
										SKIP FOR SKIPPER(50206);
										PICTURE "..\ico\HERRAMIENTAS.png"

									ON SELECTION BAR 1 OF MttoInstalaciones do form fcOg WITH "472" to lcValue
									IF SUBSTR(LCREF,1,2)=="MO"
										ON SELECTION BAR 2 OF MttoInstalaciones do form gastos WITH 2,lcRef,8,"472" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF MttoInstalaciones do form gastos WITH 1,lcRef,8,"472" TO lcValue						







									&&Herramienta y Equipo de Oficina
									DEFINE POPUP HerEqOficina SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF HerEqOficina PROMPT "Buscar Herramienta y Equipo de Oficina";
										PICTURE "..\ico\ARTICULOSOFICINA.png"
									DEFINE BAR 2 OF HerEqOficina PROMPT "Modificar Herramienta y Equipo de Oficina";
										SKIP FOR SKIPPER(50211);
										PICTURE "..\ico\ARTICULOSOFICINA.png"
									DEFINE BAR 3 OF HerEqOficina PROMPT "Crear Herramienta y Equipo de Oficina";
										SKIP FOR SKIPPER(50211);
										PICTURE "..\ico\ARTICULOSOFICINA.png"

									ON SELECTION BAR 1 OF HerEqOficina do form fcOg WITH "455" to lcValue
									IF SUBSTR(LCREF,1,2)=="HR"
										ON SELECTION BAR 2 OF HerEqOficina do form gastos WITH 2,lcRef,8,"455" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF HerEqOficina do form gastos WITH 1,lcRef,8,"455" TO lcValue						







									&&Complementos
									DEFINE POPUP Complementos SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF Complementos PROMPT "Buscar Complemento ";
										PICTURE "..\ico\COMPLEMENTOS.png"
									DEFINE BAR 2 OF Complementos PROMPT "Modificar Complemento";
										SKIP FOR SKIPPER(50215);
										PICTURE "..\ico\COMPLEMENTOS.png"
									DEFINE BAR 3 OF Complementos PROMPT "Crear Complemento";
										SKIP FOR SKIPPER(50215);
										PICTURE "..\ico\COMPLEMENTOS.png"

									ON SELECTION BAR 1 OF Complementos do form fcOg WITH "454" to lcValue
									IF SUBSTR(LCREF,1,2)=="CP"
										ON SELECTION BAR 2 OF Complementos do form gastos WITH 2,lcRef,8,"454" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF Complementos do form gastos WITH 1,lcRef,8,"454" TO lcValue						





									&&Reparacion de Vehiculos 
									DEFINE POPUP RepVehiculos SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF RepVehiculos PROMPT "Buscar Reparacion de Vehiculo ";
										PICTURE "..\ico\REPVEHICULO.png"
									DEFINE BAR 2 OF RepVehiculos PROMPT "Modificar Reparacion de Vehiculo";
										SKIP FOR SKIPPER(50213);
										PICTURE "..\ico\REPVEHICULO.png"
									DEFINE BAR 3 OF RepVehiculos PROMPT "Crear Reparacion de Vehiculo";
										SKIP FOR SKIPPER(50213);
										PICTURE "..\ico\REPVEHICULO.png"

									ON SELECTION BAR 1 OF RepVehiculos do form fcOg WITH "452" to lcValue
									IF SUBSTR(LCREF,1,2)=="RV"
										ON SELECTION BAR 2 OF RepVehiculos do form gastos WITH 2,lcRef,8,"452" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF RepVehiculos do form gastos WITH 1,lcRef,8,"452" TO lcValue						






									&&Combustible
									DEFINE POPUP Combustible SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF Combustible PROMPT "Buscar Combustible ";
										PICTURE "..\ico\combustible.png"
									DEFINE BAR 2 OF Combustible PROMPT "Modificar Combustible ";
										SKIP FOR SKIPPER(50210);
										PICTURE "..\ico\combustible.png"
									DEFINE BAR 3 OF Combustible PROMPT "Crear Combustible ";
										SKIP FOR SKIPPER(50210);
										PICTURE "..\ico\combustible.png"

									ON SELECTION BAR 1 OF Combustible do form fcOg WITH "48" to lcValue
									IF SUBSTR(LCREF,1,2)=="CB"
										ON SELECTION BAR 2 OF Combustible do form gastos WITH 2,lcRef,8,"48" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF Combustible do form gastos WITH 1,lcRef,8,"48" TO lcValue						
						
						
						
						
						
						
									&&Activo Fijo
									DEFINE POPUP ActivoFijo SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF ActivoFijo PROMPT "Buscar Activo Fijo";
										PICTURE "..\ico\ACTIVOFIJO.png"
									DEFINE BAR 2 OF ActivoFijo PROMPT "Modificar Activo Fijo";
										SKIP FOR SKIPPER(50212);
										PICTURE "..\ico\ACTIVOFIJO.png"
									DEFINE BAR 3 OF ActivoFijo PROMPT "Crear Activo Fijo";
										SKIP FOR SKIPPER(50212);
										PICTURE "..\ico\ACTIVOFIJO.png"

									ON SELECTION BAR 1 OF ActivoFijo do form fcOg WITH "43" to lcValue
									IF SUBSTR(LCREF,1,2)=="AF"
										ON SELECTION BAR 2 OF ActivoFijo do form gastos WITH 2,lcRef,8,"43" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF ActivoFijo do form gastos WITH 1,lcRef,8,"43" TO lcValue
						
						
									
						

										&&ServiciosBasicos
									DEFINE POPUP ServiciosBasicos SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF ServiciosBasicos PROMPT "Buscar Servicios Basicos";
										PICTURE "..\ico\SERVICIOSBASICOS.png"
									DEFINE BAR 2 OF ServiciosBasicos PROMPT "Modificar Servicios Basicos";
										SKIP FOR SKIPPER(50204);
										PICTURE "..\ico\SERVICIOSBASICOS.png"
									DEFINE BAR 3 OF ServiciosBasicos PROMPT "Crear Servicios Basicos";
										SKIP FOR SKIPPER(50204);
										PICTURE "..\ico\SERVICIOSBASICOS.png"

									ON SELECTION BAR 1 OF ServiciosBasicos do form fcOg WITH "451" to lcValue
									IF SUBSTR(LCREF,1,2)=="SB"
										ON SELECTION BAR 2 OF ServiciosBasicos do form gastos WITH 2,lcRef,8,"451" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF ServiciosBasicos do form gastos WITH 1,lcRef,8,"451" TO lcValue

									&&ArticulosdeOficina
									DEFINE POPUP ArticulosdeOficina SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF ArticulosdeOficina PROMPT "Buscar Articulos de Oficina";
										PICTURE "..\ico\ARTICULOSOFICINA.png"
									DEFINE BAR 2 OF ArticulosdeOficina PROMPT "Modificar Articulos de Oficina";
										SKIP FOR SKIPPER(50205);
										PICTURE "..\ico\ARTICULOSOFICINA.png"
									DEFINE BAR 3 OF ArticulosdeOficina PROMPT "Crear Articulos de Oficina";
										SKIP FOR SKIPPER(50205);
										PICTURE "..\ico\ARTICULOSOFICINA.png"

									ON SELECTION BAR 1 OF ArticulosdeOficina do form fcOg WITH "471" to lcValue
									IF SUBSTR(LCREF,1,2)=="AO"
										ON SELECTION BAR 2 OF ArticulosdeOficina do form gastos WITH 2,lcRef,8,"471" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF ArticulosdeOficina do form gastos WITH 1,lcRef,8,"471" TO lcValue

									&&ManttodeOficina
									DEFINE POPUP ManttodeOficina SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF ManttodeOficina PROMPT "Buscar Mantto de Oficina ";
										PICTURE "..\ico\MANTTOOFICINA.png"
									DEFINE BAR 2 OF ManttodeOficina PROMPT "Modificar Mantto de Oficina ";
										SKIP FOR SKIPPER(50206);
										PICTURE "..\ico\MANTTOOFICINA.png"
									DEFINE BAR 3 OF ManttodeOficina PROMPT "Crear Mantto de Oficina ";
										SKIP FOR SKIPPER(50206);
										PICTURE "..\ico\MANTTOOFICINA.png"

									ON SELECTION BAR 1 OF ManttodeOficina do form fcOg WITH "472" to lcValue
									IF SUBSTR(LCREF,1,2)=="MO"
										ON SELECTION BAR 2 OF ManttodeOficina do form gastos WITH 2,lcRef,8,"472" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF ManttodeOficina do form gastos WITH 1,lcRef,8,"472" TO lcValue				
									
									&&GastosFinancieros
									DEFINE POPUP GastosFinancieros SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF GastosFinancieros PROMPT "Buscar Gastos Financieros";
										PICTURE "..\ico\GASTOSFINANCIEROS.png"
									DEFINE BAR 2 OF GastosFinancieros PROMPT "Modificar Gastos Financieros";
										SKIP FOR SKIPPER(50207);
										PICTURE "..\ico\GASTOSFINANCIEROS.png"
									DEFINE BAR 3 OF GastosFinancieros PROMPT "Crear Gastos Financieros";
										SKIP FOR SKIPPER(50207);
										PICTURE "..\ico\GASTOSFINANCIEROS.png"

									ON SELECTION BAR 1 OF GastosFinancieros do form fcOg WITH "473" to lcValue
									IF SUBSTR(LCREF,1,2)=="GF"
										ON SELECTION BAR 2 OF GastosFinancieros do form gastos WITH 2,lcRef,8,"473" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF GastosFinancieros do form gastos WITH 1,lcRef,8,"473" TO lcValue
									
									&&Viaticos
									DEFINE POPUP viaticos SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF viaticos PROMPT "Buscar Viatico";
										PICTURE "..\ico\viaticos.png"
									DEFINE BAR 2 OF viaticos PROMPT "Modificar Viatico";
										SKIP FOR SKIPPER(50202);
										PICTURE "..\ico\viaticos.png"
									DEFINE BAR 3 OF viaticos PROMPT "Crear Viatico";
										SKIP FOR SKIPPER(50202);
										PICTURE "..\ico\viaticos.png"

									ON SELECTION BAR 1 OF viaticos do form fcOg WITH "41" to lcValue
									IF SUBSTR(LCREF,1,2)=="VT"
										ON SELECTION BAR 2 OF viaticos do form gastos WITH 2,lcRef,8,"41" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF viaticos do form gastos WITH 1,lcRef,8,"41" TO lcValue

									&&Ordenes De Gastos
									DEFINE POPUP ordenesdeg SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF ordenesdeg PROMPT "Buscar Orden de Gasto";
										PICTURE "..\ico\ordengasto.png"
									DEFINE BAR 2 OF ordenesdeg PROMPT "Modificar Orden de Gasto";
										SKIP FOR SKIPPER(50201);
										PICTURE "..\ico\ordengasto.png"
									DEFINE BAR 3 OF ordenesdeg PROMPT "Crear Orden de Gasto";
										SKIP FOR SKIPPER(50201);
										PICTURE "..\ico\ordengasto.png"

									ON SELECTION BAR 1 OF ordenesdeg do form fcOg WITH "42" to lcValue
									IF SUBSTR(LCREF,1,2)=="OG"
										ON SELECTION BAR 2 OF ordenesdeg do form gastos WITH 2,lcRef,8,"42" TO lcValue
									ENDIF
									ON SELECTION BAR 3 OF ordenesdeg do form gastos WITH 1,lcRef,8,"42" TO lcValue



									&&Prestamos
									DEFINE POPUP prestamos SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF prestamos PROMPT "Buscar Ptmo";
										PICTURE "..\ico\prestamos.png"
									DEFINE BAR 2 OF prestamos PROMPT "Modificar Ptmo";
										SKIP FOR SKIPPER(50203);
										PICTURE "..\ico\prestamos.png"
									DEFINE BAR 3 OF prestamos PROMPT "Crear Ptmo";
										SKIP FOR SKIPPER(50203);
										PICTURE "..\ico\prestamos.png"

									ON SELECTION BAR 1 OF prestamos do form fcOg WITH "44" to lcValue
									IF SUBSTR(LCREF,1,2)=="PT"
										ON SELECTION BAR 2 OF prestamos do form gastos WITH 2,lcRef,8,"44" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF prestamos do form gastos WITH 1,lcRef,8,"44" TO lcValue
									
									&&PLANILLAAFPISSS 
									DEFINE POPUP PLANILLAAFPISSS SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF PLANILLAAFPISSS PROMPT "Buscar Planillas Afp/Isss";
										PICTURE "..\ico\PLANILLAISSS.png"
									DEFINE BAR 2 OF PLANILLAAFPISSS PROMPT "Modificar Planillas Afp/Isss";
										SKIP FOR SKIPPER(50208);
										PICTURE "..\ico\PLANILLAISSS.png"
									DEFINE BAR 3 OF PLANILLAAFPISSS PROMPT "Crear Planillas Afp/Isss";
										SKIP FOR SKIPPER(50208);
										PICTURE "..\ico\PLANILLAISSS.png"

									ON SELECTION BAR 1 OF PLANILLAAFPISSS do form fcOg WITH "468" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("468")
										ON SELECTION BAR 2 OF PLANILLAAFPISSS do form gastos WITH 2,lcRef,8,"468" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF PLANILLAAFPISSS do form gastos WITH 1,lcRef,8,"468" TO lcValue
									
********************************************************************************************************************************************************************************************************************						
				&&Mano de Obra 
				DEFINE POPUP manodeobra SHORTCUT RELATIVE
				DEFINE BAR 1 OF manodeobra PROMPT "Trabajos Efectuados";
					SKIP FOR SKIPPER(5021401);
					PICTURE "..\ico\TRABAJOPOROBRA.png"
				DEFINE BAR 2 OF manodeobra PROMPT "Comisiones";
					SKIP FOR SKIPPER(5021403);
					PICTURE "..\ico\COMISIONES.png"
				DEFINE BAR 3 OF manodeobra PROMPT "Imdemnizaciones";
					SKIP FOR SKIPPER(5021402);
					PICTURE "..\ico\INDEMNIZACIONES.png"
				DEFINE BAR 4 OF manodeobra PROMPT "Retenciones Empleados";
					SKIP FOR SKIPPER(5021404);
					PICTURE "..\ico\RETENCIONESEMPLEADOS.png"
				DEFINE BAR 5 OF manodeobra PROMPT "\-"
				DEFINE BAR 6 OF manodeobra PROMPT "Planillas";
					SKIP FOR SKIPPER(5021405);
					PICTURE "..\ico\PLANILLA.png"
				DEFINE BAR 7 OF manodeobra PROMPT "Planillas de Obra Externa";
					SKIP FOR SKIPPER(5021406);
					PICTURE "..\ico\PLANILLAOBRA EXTERNA.png"
				DEFINE BAR 8 OF manodeobra PROMPT "Retenciones Bancarias";
					SKIP FOR SKIPPER(5021407);
					PICTURE "..\ico\RETENCIONESBANCARIAS.png"
									
					ON BAR 1 OF manodeobra ACTIVATE POPUP TRABAJOEFECT
					ON BAR 2 OF manodeobra ACTIVATE POPUP COMISIONES
					ON BAR 3 OF manodeobra ACTIVATE POPUP INDEMNIZACIONES
					ON BAR 4 OF manodeobra ACTIVATE POPUP RETENCIONESEMPLEADOS
					ON BAR 6 OF manodeobra ACTIVATE POPUP PLANILLA
					ON BAR 7 OF manodeobra ACTIVATE POPUP PLANILLAOBRAEXTERNA
					ON BAR 8 OF manodeobra ACTIVATE POPUP RETENCIONESBANC

									&&TRABAJOPOROBRA
									DEFINE POPUP TRABAJOEFECT SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF TRABAJOEFECT PROMPT "Buscar Trabajos por Obra";
										PICTURE "..\ico\TRABAJOPOROBRA.png"
									DEFINE BAR 2 OF TRABAJOEFECT PROMPT "Modificar Trabajos por Obra";
										PICTURE "..\ico\TRABAJOPOROBRA.png"
									DEFINE BAR 3 OF TRABAJOEFECT PROMPT "Crear Trabajos por Obra";
										PICTURE "..\ico\TRABAJOPOROBRA.png"

									ON SELECTION BAR 1 OF TRABAJOEFECT do form fcOg WITH "461" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("461")
										ON SELECTION BAR 2 OF TRABAJOEFECT do form gastos WITH 2,lcRef,8,"461" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF TRABAJOEFECT do form gastos WITH 1,lcRef,8,"461" TO lcValue
									
									&&COMISIONES
									DEFINE POPUP COMISIONES SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF COMISIONES PROMPT "Buscar Comisiones";
										PICTURE "..\ico\COMISIONES.png"
									DEFINE BAR 2 OF COMISIONES PROMPT "Modificar Comisiones";
										PICTURE "..\ico\COMISIONES.png"
									DEFINE BAR 3 OF COMISIONES PROMPT "Crear Comisiones";
										PICTURE "..\ico\COMISIONES.png"

									ON SELECTION BAR 1 OF COMISIONES do form fcOg WITH "462" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("462")
										ON SELECTION BAR 2 OF COMISIONES do form gastos WITH 2,lcRef,8,"462" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF COMISIONES do form gastos WITH 1,lcRef,8,"462" TO lcValue
									
									&&INDEMNIZACIONES
									DEFINE POPUP INDEMNIZACIONES SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF INDEMNIZACIONES PROMPT "Buscar Imdemnizaciones";
										PICTURE "..\ico\INDEMNIZACIONES.png"
									DEFINE BAR 2 OF INDEMNIZACIONES PROMPT "Modificar Imdemnizaciones";
										PICTURE "..\ico\INDEMNIZACIONES.png"
									DEFINE BAR 3 OF INDEMNIZACIONES PROMPT "Crear Imdemnizaciones";
										PICTURE "..\ico\INDEMNIZACIONES.png"

									ON SELECTION BAR 1 OF INDEMNIZACIONES do form fcOg WITH "463" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("463")
										ON SELECTION BAR 2 OF INDEMNIZACIONES do form gastos WITH 2,lcRef,8,"463" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF INDEMNIZACIONES do form gastos WITH 1,lcRef,8,"463" TO lcValue
									
									&&RETENCIONESEMPLEADOS
									DEFINE POPUP RETENCIONESEMPLEADOS SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF RETENCIONESEMPLEADOS PROMPT "Buscar Retenciones Empleados";
										PICTURE "..\ico\RETENCIONESEMPLEADOS.png"
									DEFINE BAR 2 OF RETENCIONESEMPLEADOS PROMPT "Modificar Retenciones Empleados";
										PICTURE "..\ico\RETENCIONESEMPLEADOS.png"
									DEFINE BAR 3 OF RETENCIONESEMPLEADOS PROMPT "Crear Retenciones Empleados";
										PICTURE "..\ico\RETENCIONESEMPLEADOS.png"

									ON SELECTION BAR 1 OF RETENCIONESEMPLEADOS do form fcOg WITH "464" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("464")
										ON SELECTION BAR 2 OF RETENCIONESEMPLEADOS do form gastos WITH 2,lcRef,8,"464" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF RETENCIONESEMPLEADOS do form gastos WITH 1,lcRef,8,"464" TO lcValue
									
									&&PLANILLA
									DEFINE POPUP PLANILLA SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF PLANILLA PROMPT "Buscar Planillas";
										PICTURE "..\ico\PLANILLA.png"
									DEFINE BAR 2 OF PLANILLA PROMPT "Modificar Planillas";
										PICTURE "..\ico\PLANILLA.png"
									DEFINE BAR 3 OF PLANILLA PROMPT "Crear Planillas";
										PICTURE "..\ico\PLANILLA.png"

									ON SELECTION BAR 1 OF PLANILLA do form fcOg WITH "465" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("465")
										ON SELECTION BAR 2 OF PLANILLA do form gastos WITH 2,lcRef,8,"465" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF PLANILLA do form gastos WITH 1,lcRef,8,"465" TO lcValue

									&&PLANILLAOBRAEXTERNA
									DEFINE POPUP PLANILLAOBRAEXTERNA SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF PLANILLAOBRAEXTERNA PROMPT "Buscar Planillas de Obra Externa";
										PICTURE "..\ico\PLANILLAOBRA EXTERNA.png"
									DEFINE BAR 2 OF PLANILLAOBRAEXTERNA PROMPT "Modificar Planillas de Obra Externa";
										PICTURE "..\ico\PLANILLAOBRA EXTERNA.png"
									DEFINE BAR 3 OF PLANILLAOBRAEXTERNA PROMPT "Crear Planillas de Obra Externa";
										PICTURE "..\ico\PLANILLAOBRA EXTERNA.png"

									ON SELECTION BAR 1 OF PLANILLAOBRAEXTERNA do form fcOg WITH "466" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("466")
										ON SELECTION BAR 2 OF PLANILLAOBRAEXTERNA do form gastos WITH 2,lcRef,8,"466" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF PLANILLAOBRAEXTERNA do form gastos WITH 1,lcRef,8,"466" TO lcValue
					

									&&Retenciones bancarias 
									DEFINE POPUP RETENCIONESBANC SHORTCUT RELATIVE  FROM  MROW()+3,MCOL()
									DEFINE BAR 1 OF RETENCIONESBANC PROMPT "Buscar Retenciones Bancarias";
										PICTURE "..\ico\RETENCIONESBANCARIAS.png"
									DEFINE BAR 2 OF RETENCIONESBANC PROMPT "Modificar Retenciones Bancarias";
										PICTURE "..\ico\RETENCIONESBANCARIAS.png"
									DEFINE BAR 3 OF RETENCIONESBANC PROMPT "Crear Retenciones Bancarias";
										PICTURE "..\ico\RETENCIONESBANCARIAS.png"

									ON SELECTION BAR 1 OF RETENCIONESBANC do form fcOg WITH "467" to lcValue
									IF SUBSTR(LCREF,1,2)==genprefijodoc("467")
										ON SELECTION BAR 2 OF RETENCIONESBANC do form gastos WITH 2,lcRef,8,"467" TO lcValue
									ENDIF 
									ON SELECTION BAR 3 OF RETENCIONESBANC do form gastos WITH 1,lcRef,8,"467" TO lcValue
									
									
									
********************************************************************************************************************************************************************************************************************						
				&&CajaChica 
				DEFINE POPUP cajachica SHORTCUT RELATIVE
				DEFINE BAR 1 OF cajachica  PROMPT "Buscar Caja Chica";
					PICTURE "..\ico\CAJACHICA_peq.png"
				DEFINE BAR 2 OF cajachica PROMPT "Modificar Caja Chica";
					PICTURE "..\ico\CAJACHICA_peq.png"
				
					ON SELECTION BAR 1 OF cajachica Do form fccc to lcValue
					IF SUBSTR(LCREF,1,2)==genprefijodoc("07")
						ON SELECTION BAR 2 OF cajachica Do form caja  WITH 2,lcRef,5,"","07" TO lcValue
					ENDIF 
							
********************************************************************************************************************************************************************************************************************						
				&&Quedans 
				DEFINE POPUP quedan SHORTCUT RELATIVE
				DEFINE BAR 1 OF quedan  PROMPT "Buscar Quedan";
					PICTURE "..\ico\QUEDAN_LITLE.png"
				DEFINE BAR 2 OF quedan PROMPT "Modificar Quedan";
					PICTURE "..\ico\QUEDAN_LITLE.png"
				
					ON SELECTION BAR 1 OF quedan Do form fcquedan to lcValue
					IF SUBSTR(LCREF,1,2)==genprefijodoc("06")
						ON SELECTION BAR 2 OF quedan Do form quedan  WITH 2,lcRef,5 TO lcValue
					ENDIF 
********************************************************************************************************************************************************************************************************************						

				ACTIVATE POPUP MENUCH
			
	OTHERWISE

	ENDCASE
	RETURN lcValue 
ENDPROC 

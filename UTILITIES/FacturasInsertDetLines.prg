SELECT * FROM FACTURAS WHERE IDVENTA NOT IN (SELECT IDVENTA FROM FACTURASLINES )
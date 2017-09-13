SELECT 
	gemeindenummer, laufnummer, fundstellennummer, gemeinde, flurname_adresse, art, 
	geschuetzt, qualitaet_lokalisierung, kurzbeschreibung, grundbuchnummer, 
	koord_x, koord_y, hoehe, landeskarte, "archive", archive_date, new_date,  
	geometrie, "source", status
FROM
	ada_adagis_a.punktfundstellen;
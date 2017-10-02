# nplso-umbau-kantonale-daten

Verschiedene kantonale Daten sind Inhalt der Nutzungsplanung (im Sinne von Bauzonenplan, Gesamteplan, ...). Während des Relaunches des NPLSO-Projektes wurde beschlossen, dass diese kantonalen Daten aus der internen Geodatenbank in das Nutzungsplanungsmodell kopiert/transformiert werden und als "Starterkit" dem Erfassungsbüro abgegeben wird. Im technisch einfachsten Fall kann das Büro das XTF importieren und die kommunale Nutzungsplanung erfassen.

## Kantonale Daten

Noch nicht sämtliche kantonale Daten werden behandelt. Die Herausforderung ist v.a. das Mapping der Attribute und grundsätzlich das Verstehen allfällig vorhandener Daten. Zum jetzigen Zeitpunkt (2017-10-01) werden folgende kantonale Daten im Prozess behandelt:

* Planerischer Gewässerschutz
* Geschützte archäologische Fundstellen
* BLN-Gebiete (eigentlich Bundesdaten, Geometrie durch Kanton verbessert)

## Prozess

Der Umbau- und Exportprozess wird als GRETL-Job definiert. Bis zum Betrieb der definitiven Orchestrierungslösung ("GRETL-Jenkins") muss der Umbau und XTF-Export manuell auf der Konsole ausgelöst werden.

## Entwicklungsumgebung (init-dev-environment)

### terraform

Für die Entwicklung wird eine AWS-RDS-Datenbank verwendet. Das Aufsetzen wird mit Terraform gemacht. 

### gretl

Anschliessend werden alle benötigten Daten aus der SOGIS-Geodatenbank in die AWS-Datenbank mit einem GRETL-Job kopiert. Jar-Repositories und das Auslesen der Umgebungsvariablen (für DB-Credentials) passiert in der `init.gradle`-Datei.

## Datenumbau (conversion)

In der Datenbank wird ein Export-Schema benötigt:

`java -jar ~/apps/ili2pg-3.9.1/ili2pg.jar --dbhost geodb-dev.cgjofbdf5rqg.eu-central-1.rds.amazonaws.com --dbdatabase xanadu2 --dbusr stefan --dbpwd XXXXXXXX --nameByTopic --disableValidation --defaultSrsCode 2056 --createDatasetCol --sqlEnableNull --createGeomIdx --models SO_Nutzungsplanung_20170915 --dbschema arp_npl_kantdaten_export --modeldir "http://models.geo.admin.ch;." --schemaimport`

Anforderung war das gemeindeweise Exportieren der kantonalen Daten. Aus diesem Grund gibt es eine `initCommonTables.sql`-Datei. Dort werden für dieses Vorhaben benötigte ili2db-Metatabellen abgefüllt. Für jeden kantonalen Datensatz wird eine SQL-Datei mit der Umbaulogik (=SELECT-Befehle) geschrieben. Wird `initCommonTables.sql` ausgeführt, müssen wiederum alle Umbau-SQL-Dateien ausgeführt werden. 

Der Export der Daten erfolgt mit der Angabe der BfS-Nummer (= dataset identifier):

`java -jar ~/apps/ili2pg-3.9.1/ili2pg.jar --dbhost geodb-dev.cgjofbdf5rqg.eu-central-1.rds.amazonaws.com --dbdatabase xanadu2 --dbusr stefan --dbpwd XXXXXXXX --disableValidation --models SO_Nutzungsplanung_20170915 --modeldir "http://models.geo.admin.ch;." --dbschema arp_npl_kantdaten_export --dataset 2502 --export wisen_export.xtf`

Anmerkung: Der Export des ganzen Kantons funktioniert eventuelle nicht richtig. 

`xmllint --format wisen_export.xtf -o wisen_export.xtf`

`java -jar ~/apps/ilivalidator-1.4.0/ilivalidator.jar wisen_export.xtf`

In Zukunft kann auch der ili2pg-Export mit GRETL erledigt werden.

## TODO

* Integration in AGI-Produktionsumgebung
* ili2db-Tasks anstelle von Kommandozeile
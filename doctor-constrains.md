# Zusätzliche Bedingungen

Sofern nicht anders angegeben, sind Attribute grundsätzlich nicht leer.

~~Ärzt:innen haben als Primärschlüssel eine sogenannte lebenslange Arztnummer (LANR). Diese wird gemäß dem entsprechenden Standard formatiert. Der korrekte Aufbau der Nummer wird dabei durch die Applikationssoftware geprüft, achten Sie daher vor allem auf die korrekte Länge der Nummer.~~

~~Ein Fachgebiet eines:einer Ärzt:in beschreibt, welche Fachärzt:innenausbildung diese abgeschlossen haben. Ein Beispiel hierfür wäre "Innere Medizin – Nephrologie".~~

~~Es sollen nur Ärzt:innen aufgenommen werden, die jünger als 68 Jahre alt sind. Gehen Sie vom 17. Mai 2024 als Stichtag aus.~~

~~Bei Ärzt:innen werden die gesprochenen Sprachen sowie der Name grundsätzlich vermerkt.~~

Ärzt:innen dürfen nicht an einem Feiertag eingestellt werden. Als Feiertage gelten dabei der 01.01., 08.03., 01.05., 03.10., 25.12. und 26.12..

~~Das Gehalt soll nur Werte zwischen dem minimalen und maximalen Gehalt aus der Entgelttabelle des TV Ärzte VKA aus dem Jahr 2024 annehmen können.~~

~~Bei Patient:innen muss das Geschlecht sowie die Beschäftigung im Gegensatz zum Namen und Geburtsdatum nicht angegeben werden. Soll ein Geschlecht angegeben werden, ist dies "d", "w" oder "m". Als Versichertennummer wird die auf den elektronischen Gesundheitskarten vermerkte unveränderliche Teil der Versichertennummer benutzt. Gehen Sie sicher, dass diese korrekt strukturiert sind. Hinweis: Sie müssen die korrekte Berechnung der Prüfsumme nicht überprüfen.~~

Gesundheitseinrichtungen müssen eine deutsche SteuerID, eine Adresse, ein Bundesland-Kürzel und einen Vermerk über den letztjährigen Umsatz besitzen. Beachten Sie zur Formatierung der SteuerID die Regeln zur Formatierung von Umsatzsteuer-Identifikationsnummern.

Bundesland-Kürzel sollen nach dem ISO 3166-2 Standard formatiert werden. Außerdem soll sichergestellt werden, dass nur deutsche Bundesländer eingefügt werden können.

~~Der maximal speicherbare Umsatz einer Gesundheitseinrichtung beträgt 9.999.999.999.999,99 €.~~

Die „Gesundheitseinrichtung”-Generalisierung soll Attribut-sparend im Null-Stil (diskriminieren Sie mit einem nicht-leeren Attribut Typ) abgebildet werden. Für die Repräsentation der Typen soll ihr Entitätsname verwendet werden. Achten Sie darauf, dass die Attribute der Spezialisierungen abhängig vom Typ-Attribut nicht NULL sein dürfen.

Krankenhäuser speichern die Bettenauslastung als Gleitkommazahl mit geringer Genauigkeit als Verhältnis zwischen der Anzahl der belegten und der maximalen Anzahl der Betten (Hinweis: Die Berechnung müssen Sie nicht durchführen). Kein Krankenhaus hat mehr als 1500 Betten.

~~Privatpraxen haben immer einen Fachrichtung und akzeptieren die Zahlungsarten "Versichert" und "Selbstzahler".~~

Die Dringlichkeit einer Operation (OP) kann "Notoperation", "dringliche Operation", "frühelektive Operation" oder "elektive Operation" sein. Um sich einfacher mit anderen Krankenhäusern vergleichen zu können, wird ein möglichst universell eindeutiger Identifier (128 bit Länge) verwendet. Es wird immer vermerkt, ob die OP unter Vollnarkose stattfindet oder nicht.

~~Für jede Operation wird immer das Datum sowie getrennt die jeweilige Start- und Enduhrzeit angegeben. Die schnellste Operation dauert 15 Minuten, die Maximaldauer beträgt 9 Stunden (Hinweis: Sekunden werden bei dieser Integritätsbedingung ignoriert).~~

~~Diagnosen werden gemäß ICD-Schlüssel bis zur Kategorie-Ebene (also nur Stellen vor einem möglichen Punkt) vermerkt. Als Zusatzinformation wird außerdem ein Kürzel angegeben. Zugelassen sind hier "G", "V", "A", "L", "R" und "B". Diagnosen können auch ohne Beschreibung gestellt werden.~~

Stellen Sie sicher, dass ein:e Ärzt:in zu jedem Zeitpunkt nur eine Diagnose stellen kann, und dass ein:e Ärzt:in nur in einem Termin gleichzeitig sein kann.

~~Ein Termin hat immer einen Zeitpunkt sowie die Information, ob der:die Patient:in neu zum:zur Ärzt:in kommt. Es können bis zu 500 € Zusatzgebühren anfallen. Wenn keine Zusatzgebühren anfallen, soll der Wert "0" eingetragen werden. Hinweis: Die Zusatzgebühren dürfen nicht leer sein.~~

Die ID eines Termins ist nicht negativ und soll bis zu drei Millionen verschiedene Werte abbilden können. Außerdem wird die ID eines Termins automatisch sequenziell vergeben (Hinweis: Die DuckDB-Funktionalitäten für Sequenzen und Standardwerte können Ihnen hier weiterhelfen).

~~In einem Krankenhaus kann es maximal 20 OP-Säle geben, welche aufsteigend von 0 nummeriert werden. Negative Raumnummern sollen unmöglich sein.~~

# Hinweise

Legen Sie Tabellen, wo möglich, zusammen. Normalisieren Sie nicht.

Benennen Sie Fremdschlüsselattribute wie in der Referenztabelle.

In den Tests zur Korrektheit einer Tabelle prüfen wir Ihre Wahl des Tabellennamens, der Attributnamen und -datentypen, der Primär- und Fremdschlüssel sowie Ihre Definition von eindeutigen und nicht-leeren Attributen. Weitergehende Integritätsbedingungen und die erfolgreiche Interaktion mit der Datenbank (einfügen/löschen/abfragen von Daten) werden in den übrigen Tests geprüft.

Beachten Sie, dass eine falsch definierte Tabelle bzw. Integritätsbedingung durch Fremdschlüssel-Beziehungen auch zu Fehlern in Tests für eine andere Tabelle führen kann.

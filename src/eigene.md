# Eigene Esoterische Programmiersprache

## Idee:
### Architektur:
- Viele Parallele Maschinen sind in einem 2D-Gitter angeordnet.
- Jede Maschine kann eine Zahl speichern, Zahlen sind beliebig groß.
- Eine Maschine kann ihren 4 Nachbarn Nachrichten senden.
- Der Programmcode ist für alle Maschinen gleich und hat Einstiegspunkte.
- Alle Maschinen arbeiten in einem synchronen Takt.
- Die Ausführung wird beendet wenn alle Maschinen warten / keine Maschine was tut.

### Nachrichten:
- Eine Nachricht besteht aus 4 bit und wird Hexadezimal notiert.
- Aufeinanderfolgende Nachrichten ergeben eine Zahl.
- Treffen mehrere Nachrichten gleichzeitig ein, wird eine zufällig gewählt.
  Auf diesem Weg können Zahlen verschiedener Eingänge gemischt sein.
- Eine empfangene Nachricht kommt zunächst in die Queue.
- Empfängt eine inaktive Maschine eine Zahl, so liest sie diese komplett ein,
  interpretiert sie als Einstiegspunkt und beginnt dort mit der Ausführung.
  Ist die Zahl kein gültiger Einstiegspunkt, so beginnt die Maschine bei Marke 0.
- Empfängt eine aktive Maschine eine Zahl,
  so bleibt diese in der queue bis zur aktiven Auswertung.
- Will eine aktive Maschine eine Zahl empfangen, so wartet sie, bis eine kommt.

### Priorität
- Maschinen können 3 Prioritäten haben und starten mit der mittleren Prio.
- Nur Code auf Maschinen der höchsten Priorität wird ausgeführt,
- Maschinen mit nicht höchster Priorität warten.

### IO
- Eine Maschine kann ein ASCII(UTF-x)-Zeichen nur an seiner Position ausgeben.
  (0,0) ist oben links auf dem Bildschirm.
- Eingelesene Zeichen werden erst am Ende eines Taktes aus der Queue entfernt.
  Wenn also mehrere Maschinen in einem Takt ein Zeichen lesen, erhalten alle das gleiche.


##Kommandos:
### Programmstruktur
- **(HH)** Einstiegspunkt mit Nummer HH. Empfängt eine inaktive Maschine die
  Zahl HH, so beginnt sie mit der Ausführung des Codes nach diesem Einstiegspunkt.
  Führende 0en werden ignoriert. 01 = 1 und andersherum.

### Steuerbefehle
- **?** Führt folgenden Befehl nur aus, wenn eigene Zahl==0
- **:** Überspringt nächsten Befehl.

### I/O
- **C** "Output Cipher" Gibt letzte 4bit-Stelle als Hexadezimalziffer aus und shiftet um 4 bit nach rechts.
- **A** "Output ASCII" Gibt letztes Byte als ASCII-Zeichen aus und shiftet um 8 bit nach rechts.
- **I** "Input" liest nächstes ASCII-Zeichen ein.

### Senden
- **#** Sendet nächste Zahl an alle 4 Nachbarn. (Startkonfiguration)
- **><v^** Sendet nächste Zahl nach rechts (1,0), links (-1,0), unten (0,1) oder oben (0,-1)
- **0-F** Sendet Hexadezimalziffer als Nachricht. Jedes andere Kommando beendet die Zahl.
- **$** Sendet Zahl aus dem Speicher (Nachrichtenweise von links nach rechts)

### Empfangen
Empfangen blockiert, wartet auf Nachricht, ignoriert Steuerbefehl.
- **+** Addiert empfangene Zahl auf eigene Speicherzelle
- **-** Subtrahiert empfangene Zahl von eigene Speicherzelle
- **\*** Multipliziert eigene Speicherzelle mit empfangene Zahl
- **/** Dividiert eigene Speicherzelle durch empfangene Zahl (ganzzahlig)
- **%** Rest der Division von eigener Speicherzelle durch empfangene Zahl
- Wird 0 empfangen, so ist das Ergebnis von / und % immer 0.
- **|** Bitweises 'Oder' von Zahl auf eigene Speicherzelle
- **&** Bitweises 'Und' von Zahl auf eigene Speicherzelle
- **X** Bitweises 'XOR' von Zahl auf eigene Speicherzelle

### Stop (inaktiviert Zelle)
- **[** Beendet die Ausführung und setzt Zelle auf 0
- **]** Beendet die Ausführung und behält aktuellen Wert in der Zelle

### Priorität
- **`** Setzt niedrigste Priorität
- **'** Setzt mittlere Priorität (Startkonfiguration)
- **′** Setzt höchste Priorität

- Spaces werden ignoriert
- Alles hinter = ist ein Kommentar.
- Spaces und Kommentare sind innerhalb von Zahlen möglich.

## Beispiele:

### Eigene Zahl auf 0 setzen:
    (0)1

### Einsen schicken


### Runterzählen

# Lab 2 – Gegevensvalidatie en thresholds voor bronsystemen

## Wat ga je doen?

In dit lab ga je aan de slag met twee belangrijke beveiligingsmaatregelen in HelloID:

- **Thresholds**: hiermee blokkeer je automatisch een import als er onverwacht veel wijzigingen plaatsvinden — zoals het ineens verdwijnen van meerdere personen, of dat er in één run ineens veel personen tegelijk worden toegevoegd, of dat er ineens veel velden leeg worden gemaakt.
- **Gegevensvalidatie**: hiermee voorkom je dat onvolledige gegevens in HelloID terechtkomen door het verplicht stellen van velden via de optie **‘Require this field’** in de field mapping.

💡 HelloID vergelijkt bij elke import de nieuwe brondata met de laatste snapshot. Daarbij wordt gecontroleerd of er personen zijn toegevoegd of verwijderd, of dat velden leeg zijn geraakt. In dit lab leer je hoe je dat proces onder controle houdt.

---

## 🛡️ Stap 1 – Threshold instellen tegen onverwachte verwijderingen

HelloID vergelijkt bij elke import de nieuwe brongegevens met de vorige snapshot van dezelfde bron. Daarbij kijkt het systeem naar:

- hoeveel personen zijn **verwijderd**,  
- hoeveel personen zijn **toegevoegd**,  
- en of er velden **leeg zijn geraakt** terwijl ze eerst nog gevuld waren.  

Dit soort onverwachte verschillen kunnen wijzen op een fout in het bronbestand. Daarom kun je hier met thresholds op ingrijpen: je stelt in hoeveel afwijkingen nog acceptabel zijn, en vanaf welk punt HelloID de import blokkeert.

### 🔧 Threshold configureren

1. Ga naar je bronsysteem in **Provisioning → Source Systems**.  
2. Open het tabblad **Thresholds**.  
3. De schakelaar voor **Removal (Verwijderde personen)** staat standaard ingeschakeld.  
4. Controleer of bij de **Removal threshold** de waarde `1` is ingevuld.  
   - Dit betekent: als 1 of meer personen verdwijnen uit de bronkoppeling, wordt de import geblokkeerd.

### 🔒 Wat gebeurt hier onder water?

HelloID merkt een verschil op tussen de nieuwe data en de vorige snapshot. Als die wijziging groter is dan je ingestelde threshold toestaat, wordt de hele import automatisch geblokkeerd.  
Je voorkomt hiermee dat personen onbedoeld uit HelloID verdwijnen, dat er per ongeluk veel nieuwe accounts worden aangemaakt, of dat velden plots leeg zijn.

Dit beschermt je provisioningproces tegen fouten door onjuiste of incomplete gegevens.  
💡 In een productieomgeving staan thresholds meestal hoger dan 1 — bijvoorbeeld op 5 of 10 — zodat je kleine afwijkingen niet direct hoeft goed te keuren.

---

### 🧪 Test: verwijder één persoon uit de brondata

1. Open het bestand `T4E_HelloID_Persons.csv`.  
2. Verwijder de regel van bijvoorbeeld **Xaviera Foley**.  
3. Sla het bestand op.  
4. Ga terug naar HelloID en start een import van het nieuwe csv-bronsysteem met **'Start Import'**.

> ⛔️ De import wordt nu geblokkeerd. HelloID ziet dat er een persoon ontbreekt en grijpt in — precies wat je met de threshold wilde bereiken. Een geblokkeerde import kun je handmatig goedkeuren via de overzichtspagina van de van je bronsystemen.

---

## ✅ Stap 2 – Gegevensvalidatie instellen voor verplichte velden

Soms wil je niet de hele import blokkeren, maar alleen records waarbij belangrijke velden ontbreken. Dit kun je regelen met **gegevensvalidatie**.

Je stelt dit per veld in via de optie **‘Require this field’** in de field mapping.  
Dit is vooral belangrijk voor velden die je gebruikt bij de naamgeneratie van gebruikersnamen of e-mailadressen — bijvoorbeeld `NickName`, `FamilyName` of `Initials`. Als zo’n veld leeg is, kan HelloID bijvoorbeeld geen correcte gebruikernaam genereren, wat kan leiden tot fouten of incomplete accounts.

### 🔧 Validatie inschakelen

1. Ga naar het tabblad **Person** van je bronsysteem.  
2. Zoek het veld `Name.NickName`.  
3. Zet de schakelaar aan bij **Require this field**.  
4. Klik op **Apply** en sluit de configuratie van de bronkoppeling door op **Close** te klikken.

---

### 🧪 Test: laat NickName leeg bij één persoon

1. Open opnieuw het bestand `T4E_HelloID_Persons.csv`.  
2. Maak het veld `NickName` leeg bij de regel van bijvoorbeeld **Walker Clark**.  
3. Sla het bestand op.  
4. Ga naar HelloID en start een import van het nieuwe csv-bronsysteem met **'Start Import'**.

> ✅ De import wordt uitgevoerd, maar **Walker Clark** wordt geblokkeerd en verschijnt op het tabblad **Blocked Persons**.  
> **Let op:** Een geblokkeerde persoon kan niet goedgekeurd of doorgezet worden. Je kunt dit alleen oplossen door het veld in het HR-systeem in te vullen of de optie **Require this field** uit te schakelen.

---

## 🛑 Stap 3 – Geblokkeerde personen controleren

Wanneer een persoon geblokkeerd wordt vanwege ontbrekende verplichte velden, kun je deze niet goedkeuren of verder verwerken. Je moet eerst de oorzaak van de blokkade verhelpen.

### 🔧 Geblokkeerde personen bekijken

1. Ga naar je bronsysteem in **Provisioning → Source Systems**.  
2. Klik op het **moersleutelicoon** naast je bronsysteem.  
3. Ga naar het tabblad **Blocked Persons**.  
4. Hier zie je een lijst van personen die geblokkeerd zijn. Klik op het **rapporticoontje** om de reden van blokkering te bekijken.

> Deze lijst bevat personen die zijn tegengehouden omdat een verplicht veld leeg is gelaten (zoals `NickName`).

---

### 🔄 Oplossingen voor geblokkeerde personen

- **Als een veld leeg is**, zoals bij `NickName`, kun je het veld invullen in het HR-systeem en een nieuwe import starten.  
- **Als je het veld niet kunt invullen**, kun je de optie **Require this field** uitschakelen om de blokkade op te heffen, maar dit kan gevolgen hebben voor de datakwaliteit.

---

### 🔄 Wanneer werkt dit?

Deze controles — zoals het blokkeren van een import of het tegenhouden van een persoon — gebeuren bij elke nieuwe import.  
HelloID vergelijkt dan de ruwe data met de laatste **snapshot**, en voert de ingestelde thresholds en veldvalidatie uit.  
Als je een wijziging hebt aangebracht in de mapping of het script, moet je dus een nieuwe import uitvoeren om die wijziging te testen.  
💡 Een nieuwe snapshot wordt automatisch aangemaakt bij elke import.

---

### ✅ Wat heb je geleerd?

- Je hebt een threshold ingesteld om ongewenste bulkverwijderingen te blokkeren.  
- Je weet nu hoe je velden als verplicht kunt instellen.  
- Je hebt gezien hoe HelloID automatisch personen kan blokkeren bij ontbrekende gegevens.  
- Je weet hoe je deze blokkades kunt herkennen, controleren en eventueel oplossen.

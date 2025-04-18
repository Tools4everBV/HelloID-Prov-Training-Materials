# Lab 2 – Gegevensvalidatie en thresholds voor bronsystemen

## Wat ga je doen?

In dit lab ga je aan de slag met twee belangrijke beveiligingsmaatregelen in HelloID:

- **Thresholds**: hiermee blokkeer je automatisch een import als er onverwacht veel wijzigingen plaatsvinden — zoals het ineens verdwijnen van meerdere personen, of dat er in één run ineens veel personen tegelijk worden toegevoegd, of dat er ineens veel velden leeg worden gemaakt.
- **Gegevensvalidatie**: hiermee voorkom je dat onvolledige of foutieve gegevens in HelloID terechtkomen.

💡 Beide zorgen ervoor dat je provisioningproces betrouwbaar en veilig blijft, zelfs als er fouten in de brondata zitten.

---

## 🛡️ Stap 1 – Threshold instellen tegen onverwachte verwijderingen

HelloID vergelijkt bij elke import de nieuwe brongegevens met de vorige snapshot. Als er ineens veel personen zijn verdwenen, wil je dat die import automatisch wordt geblokkeerd. **Dit regel je door thresholds in te stellen.**

### 🔧 Threshold configureren

1. Ga naar je bronsysteem in **Provisioning → Source Systems**.
2. Open het tabblad **Thresholds**.
3. De schakelaar voor **Removal (Verwijderde personen)** staat bij een nieuwe bronkoppeling standaard ingeschakeld.
4. Controleer of bij de **Removal threshold** de waarde `1` is ingevuld.
   - Dit betekent: als 1 of meer personen verdwijnen uit de bronkoppeling, wordt de import geblokkeerd.
5. Klik op **Save** en sluit de configuratie van de bronkoppeling door op **Close** te klikken.

---

### 🧪 Test: verwijder één persoon uit de brondata

1. Open het bestand [`T4E_HelloID_Persons.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source%20data/T4E_HelloID_Persons.csv).
2. Verwijder de regel van bijvoorbeeld `Xaviera Foley`.
3. Sla het bestand op.
4. Ga terug naar HelloID en start een import van het nieuwe bronsysteem met **'Start Import'**.

> ⛔️ De import wordt nu geblokkeerd. HelloID ziet dat er een persoon ontbreekt en grijpt in — precies wat je met de threshold wilde bereiken. Een geblokkeerde import kun je handmatig goedkeuren via het tabblad **Import** van je bronsysteem.

---

### 🔒 Wat gebeurt hier onder water?

HelloID merkt een verschil op tussen de nieuwe data en de vorige snapshot. Omdat de wijziging groter is dan je threshold toestaat, wordt de import tijdelijk geblokkeerd. Je voorkomt hiermee dat personen onbedoeld uit HelloID verdwijnen, dat er te veel personen worden toegevoegd, of dat er ineens veel velden leeg worden gemaakt. Dit beschermt je provisioningproces tegen fouten door onjuiste of incomplete gegevens. (De thresholds staan in een productieomgeving uiteraard hoger dan 1.)

---

## ✅ Stap 2 – Gegevensvalidatie instellen voor verplichte velden

Soms wil je niet de hele import blokkeren, maar alleen records waarbij belangrijke velden ontbreken. Dit kun je regelen met **gegevensvalidatie**.

### 🔧 Validatie inschakelen

1. Ga naar het tabblad **Persons** van je bronsysteem. Hier staat de field mapping van de Personen.
2. Zoek het veld `Name.NickName`.
3. Zet de schakelaar aan bij **Require this field**.
4. Klik op **Save** en sluit de configuratie van de bronkoppeling door op **Close** te klikken.

---

### 🧪 Test: laat NickName leeg bij één persoon

1. Open opnieuw het bestand `T4E_HelloID_Persons.csv`.
2. Maak het veld `NickName` leeg bij de regel van bijvoorbeeld `Walker Clark`.
3. Sla het bestand op.
4. Ga naar HelloID en start een import van het nieuwe bronsysteem met **'Start Import'**.

> ✅ De import wordt uitgevoerd, maar **Walker Clark** wordt geblokkeerd en verschijnt op het tabblad **Blocked Persons**.  
> **Let op:** Een geblokkeerde persoon kan niet goedgekeurd of doorgezet worden. Je kunt dit alleen oplossen door het veld in het HR-systeem in te vullen of de optie **Require this field** uit te schakelen.

---

## 🛑 Stap 3 – Geblokkeerde personen controleren

Wanneer een persoon geblokkeerd wordt vanwege ontbrekende verplichte velden, kun je deze niet goedkeuren of verder verwerken. Je moet eerst de oorzaak van de blokkade verhelpen.

### 🔧 Geblokkeerde personen bekijken

1. Ga naar je bronsysteem in **Provisioning → Source Systems**.
2. Klik op het tandwielicoon (⚙️) naast je bronsysteem.
3. Ga naar het tabblad **Blocked Persons**.
4. Hier zie je een lijst van personen die geblokkeerd zijn. Klik op het **oogje (👁)** of het **rapporticoontje** om de reden van blokkering te bekijken.

---

### 🔄 Oplossingen voor geblokkeerde personen

- **Als een veld leeg is**, zoals bij `NickName`, kun je het veld invullen in het HR-systeem en een nieuwe import starten.
- **Als je het veld niet kunt invullen**, kun je de optie **Require this field** uitschakelen om de blokkade op te heffen, maar dit kan gevolgen hebben voor de datakwaliteit.

---

### 📌 Wat is Raw data precies?

Dit tabblad toont de ruwe informatie die HelloID via het script heeft opgehaald, voordat er iets wordt gemapt of gevalideerd. Handig om te controleren of de gegevens wel zijn aangekomen.

### 🔄 Wanneer werkt dit?

Validatie en thresholdcontrole werken altijd op basis van de ruwe data en de mapping die daarbovenop komt. Bij elke nieuwe import wordt alles opnieuw vergeleken met de laatst bekende snapshot.

---

### ✅ Wat heb je geleerd?

- Je hebt een threshold ingesteld om ongewenste bulkverwijderingen te blokkeren.
- Je weet nu hoe je velden als verplicht kunt instellen.
- Je hebt gezien hoe HelloID automatisch personen kan blokkeren bij ontbrekende gegevens.
- Je weet hoe je deze blokkades kunt herkennen, controleren en eventueel oplossen.


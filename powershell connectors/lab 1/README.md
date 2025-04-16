# Lab 1 – Een PowerShell-bronsysteem maken

## Wat ga je doen?

In dit lab ga je een **PowerShell-bronsysteem** configureren in HelloID. Je koppelt een script aan een connector en zorgt ervoor dat de gegevens uit het bronsysteem zichtbaar worden in HelloID.

💡 *Waarom dit belangrijk is?*  
Een bronsysteem levert de basisdata waarmee HelloID bepaalt welke accounts of permissies een persoon nodig heeft. Zonder bronsysteem is er geen input voor provisioning.

---

## 🧰 Stap 1 – Bronsysteem aanmaken in HelloID

1. Ga naar **Provisioning → Data sources → PowerShell** en klik op **New**.
2. Geef de bron een herkenbare naam, zoals `PowerShell - Medewerkers`.
3. Klik op **Save** om de bron aan te maken.
4. Open daarna de bron en klik op **Edit script**.

---

## 🔧 Stap 2 – Script koppelen aan de bron

1. Download het startscript van GitHub:  
   [`source.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source.ps1)

2. Kopieer de inhoud en plak deze in de script editor in HelloID.

3. Sla het script op en voer een test uit met de knop **Run script**.  
   Je ziet als het goed is een lijst met personen.

📌 *Wat is Raw data precies?*  
Dit tabblad toont de ruwe informatie die HelloID via het script heeft opgehaald, voordat er iets wordt gemapt of gefilterd. Handig als je wilt weten: “Komt m’n data überhaupt binnen?”

🔄 *Hoe werkt een bronimport in HelloID?*  
Elke import doorloopt dezelfde stappen:  
`Script → Raw Data → Mapping → Snapshot → Personen`  
Deze flow zie je in actie vanaf het moment dat je op **Import raw data** klikt.

---

## 🧪 Stap 3 – Import uitvoeren en controleren

1. Klik op **Import raw data** om een volledige import uit te voeren.
2. Bekijk het resultaat in het tabblad **Persons**.
3. Controleer of de gegevens uit het script zijn overgenomen.

---

## 📁 Bijlage: Fieldmapping-bestand

Als je met een los fieldmapping-bestand werkt, zorg dan dat je het bestand **fieldMapping.json** tweemaal inlaadt (zowel voor create als update) en klik daarna op **Apply**.

👉 [`fieldMapping.json`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/fieldMapping.json)

---

✅ Je hebt nu een PowerShell-bronsysteem opgezet, gekoppeld aan een script en succesvol geïmporteerd in HelloID!

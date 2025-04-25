# Lab 1 – Een PowerShell-bronsysteem maken

### Wat ga je doen?

In dit lab ga je een nieuw PowerShell-bronsysteem instellen in HelloID. Dit bronsysteem vormt de basis van je provisioningproces: hier haal je de personeelsgegevens op die HelloID gebruikt om accounts aan te maken en te beheren. Bij elke bronimport doorloopt HelloID namelijk een vaste flow: **Script ➞ Raw Data ➞ Mapping ➞ Snapshot ➞ Personen**. Dit is de basis voor een goed werkende koppeling. Als je deze flow begrijpt, wordt het bouwen, testen en oplossen van fouten een stuk overzichtelijker.

> 💡 Waarom PowerShell?  
> Alle standaard bronsystemen in HelloID zijn gebouwd met PowerShell-scripts. Deze aanpak biedt maximale flexibiliteit: je kunt data ophalen uit CSV-bestanden, eigen systemen, API’s of databases. Zo kun je vrijwel elk type bron koppelen, ook als er geen commerciële HR-oplossing beschikbaar is.

---

### 🧰 Stap 1 – Voorbereiding

1. Maak op de HelloID-server een nieuwe map aan, bijvoorbeeld:  
   `C:\HelloID\SourceData`

2. Download de voorbeeldgegevens van de volgende GitHub-pagina:  
   👉 [Source data - GitHub](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/tree/Feature-2025-material/powershell%20connectors/lab%201/source%20data). Klik op elk bestand om het te openen:
   - [`T4E_HelloID_OrganizationalFunctions.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source%20data/T4E_HelloID_OrganizationalFunctions.csv)
   - [`T4E_HelloID_OrganizationalUnits.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source%20data/T4E_HelloID_OrganizationalUnits.csv)
   - [`T4E_HelloID_Persons.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source%20data/T4E_HelloID_Persons.csv)
   - [`T4E_HelloID_Contracts.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/source%20data/T4E_HelloID_Contracts.csv)
   - In het geopende scherm klik je rechtsboven op de **"Download"** knop. Dit is een icoontje met een pijl naar beneden.  
     Wanneer je met je muis over het icoontje gaat, verschijnt de tekst 'Download raw file'. Klik op dit icoontje om het bestand te downloaden.
   - Herhaal dit voor alle vier de bestanden.

3. Plaats de gedownloade bestanden in de map die je eerder hebt aangemaakt op de HelloID-server.

---

### ⚙️ Stap 2 – Bronsysteem aanmaken in HelloID

1. Ga in HelloID naar **Provisioning → Source Systems** en voeg een nieuw bronsysteem toe.
2. Kies de template **Source Template**.
3. Geef het bronsysteem een herkenbare naam, bijvoorbeeld **HR CSV bron**.
4. Zet **Execute on-premises** aan, zodat de scripts lokaal worden uitgevoerd via de agent.
5. Vervang nu de standaard scripts:
   - Gebruik [`persons.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/persons.ps1) voor personen.
   - Gebruik [`departments.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/departments.ps1) voor afdelingen.
6. Pas in beide scripts de variabele `$importSourcePath` aan naar het pad van de map die je eerder hebt aangemaakt.
7. Klik op **Import raw data** om een eerste testimport uit te voeren.
8. Controleer de gegevens via het tabblad **Raw data**.

📌 Wat is Raw data precies?  
Dit tabblad toont de ruwe informatie die HelloID via het script heeft opgehaald, voordat er iets wordt gemapt of gefilterd. Het is handig als je wilt weten: “Komt m’n data überhaupt binnen?”

🔄 Hoe werkt een bronimport in HelloID?  
Elke import doorloopt dezelfde stappen:  
**Script → Raw Data → Mapping → Snapshot → Personen**

📚 Meer uitleg:  
[Add a source system – HelloID Docs](https://docs.helloid.com/en/provisioning/source-systems/add,-edit,-or-remove-a-source-system.html#add-a-source-system)

---

### 🧩 Stap 3 – Field mapping configureren

1. Importeer het mappingbestand [`fieldMapping.json`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/fieldMapping.json) vanuit de GitHub-repository.

2. Lees dit bestand twee keer in:
   - Eén keer op het **Persons** tabblad
   - Eén keer op het **Contracts** tabblad  
   Vergeet niet in beide gevallen op **Apply** te klikken om de mapping toe te passen.

3. Voer opnieuw een import uit.

4. Open het onderdeel **Persons** in je bronsysteem en klik op een persoon om te controleren of de velden goed zijn gevuld.

🔄 Let op bij wijzigingen:  
Heb je net iets aangepast aan je mapping of script?  
Klik dan altijd opnieuw op **Apply** om de wijziging toe te passen.  
Je ziet de verandering pas terug na een **nieuwe import** of als je een **nieuwe snapshot** maakt.  
HelloID past wijzigingen niet automatisch toe in het bestaande overzicht.

---

### 🧠 Stap 4 – Complex field mapping toevoegen

In HelloID kun je brongegevens op drie manieren mappen: **Fixed**, **Field**, of **Complex**.  
- Bij een Fixed mapping geef je een vaste waarde op.  
- Bij een Field mapping kies je een veld uit de bron.  
- Bij een Complex mapping schrijf je een stukje JavaScript om de waarde zelf te berekenen of om te zetten.

In deze stap gebruik je een complex mapping om een naamconventiecode af te leiden uit een numerieke bronwaarde. Je schrijft dus een JavaScript-functie die HelloID uitvoert voor elke persoon die binnenkomt. Zo kun je logica toevoegen zoals “als de waarde 1 is, zet dan ‘PB’ in het veld `Name.Convention`”.

👉 HelloID voert deze functie uit voor elke persoon in de brondata. Je gebruikt daarbij het `source` object, waarin alle velden uit de oorspronkelijke import beschikbaar zijn.

1. Open de mapping voor personen en voeg een veld toe: `Name.Convention`.

2. Schrijf een JavaScript-functie die de bronwaarde (`source.Naamgebruik_code`) vertaalt naar de juiste HelloID-conventie.  
   Gebruik alleen de waarden uit de kolom HelloID-conventie in de mapping. De kolom Uitleg is er alleen als naslag.

| Bronwaarde | HelloID-conventie | Uitleg |
|------------|-------------------|--------|
| 0 | B | Geboortenaam |
| 1 | PB | Partnernaam – Geboortenaam |
| 2 | P | Partnernaam |
| 3 | BP | Geboortenaam – Partnernaam |

3. Gebruik als basis het startscript voor naamconventie:  
👉 [formatNamingConvention.js – GitHub](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%201/formatNamingConvention.js)

4. Gebruik `source.Naamgebruik_code` als invoer voor je script.

5. Test je functie via Preview en sla je mapping op (Apply).

6. Voer opnieuw een import uit om de wijziging toe te passen.

📚 Meer info over complex mapping:  
[Complex Source Mappings – HelloID Docs](https://docs.helloid.com/en/provisioning/complex-source-mappings.html)

---

### 🧾 Stap 5 – Invoerformulier maken voor configuratie

1. Ga naar het tabblad **System** van je bronsysteem.

2. Klik op het moersleutel-icoontje naast de tekst `Custom connector configuration` om de **Form JSON editor** te openen.

3. Voeg een tekstveld toe voor het pad naar je brondata (`csvPath`).

4. Pas je script aan om de waarde uit de configuratie op te halen:
```powershell
$connectionSettings = ConvertFrom-Json $configuration
$importSourcePath = $connectionSettings.Path
```

5. Doe een testimport om te controleren of het werkt.

6. Herhaal dit voor het scheidingsteken (`$delimiter`).

💡 Waarom dit formulier gebruiken?  
Met een configuratieformulier voorkom je hardcoded instellingen in je scripts.  
Zo kun je het script flexibel hergebruiken in andere omgevingen, en collega’s kunnen het makkelijker beheren zonder in de code te hoeven duiken.

📚 Meer info over inputformulieren:  
[Input Forms – HelloID Docs](https://docs.helloid.com/en/provisioning/input-forms.html)

---

### ✅ Wat heb je geleerd?

- Je hebt een PowerShell-bronsysteem aangemaakt in HelloID.
- Je weet hoe je gegevens importeert en bekijkt via Raw Data.
- Je hebt field mappings geconfigureerd, inclusief een complex veld.
- Je hebt een JavaScript-functie toegevoegd om naamconventies om te zetten.
- Je weet hoe je configuratie-instellingen toevoegt via een invoerformulier.

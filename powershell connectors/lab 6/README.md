# Lab 6 – Invoerformulier maken voor configuratie

## Wat ga je doen?

In dit lab maak je een **invoerformulier (configuration form)** aan voor je PowerShell-doelsysteem. Hiermee kun je eenvoudig instellingen meegeven aan je scripts, zoals het pad naar het CSV-bestand of het scheidingsteken.

💡 *Waarom dit handig is?*  
Met een configuratieformulier heb je alle parameters op één plek.  
- Scripts gebruiken automatisch de ingevulde waarden.  
- Je hoeft de scripts niet aan te passen bij wijzigingen.  
- Beheerders zonder scriptkennis kunnen de instellingen aanpassen.  
- Je voorkomt dat gevoelige info hardcoded in je script of GitHub-backup terechtkomt.  
- Je kunt dezelfde scripts hergebruiken in meerdere omgevingen.

---

## 🧰 Stap 1 – Inputformulier aanmaken

1. Ga naar je PowerShell-doelsysteem en open het tabblad **Input form**.
2. Klik op **+ Add field** en voeg de benodigde velden toe:
   - `csvPath` (Type: text)
   - `csvDelimiter` (Type: text)

   👉 Deze twee heb je nodig om het pad en het scheidingsteken door te geven aan je scripts.

3. Klik op **Save**.

---

## 🧪 Stap 2 – Configuratiewaarden invullen

1. Na het opslaan van het formulier verschijnt er een nieuw tabblad: **Configuration**.
2. Vul hier de juiste waarden in:
   - `csvPath`: `C:\HelloID\Training\accounts.csv`
   - `csvDelimiter`: `;`
3. Klik op **Save**.

---

### 🔎 Hoe gebruik je de configuratiewaarden in je script?

De waarden die je invult in het formulier zijn beschikbaar in je script via:

```powershell
$actionContext.Configuration.csvPath
$actionContext.Configuration.csvDelimiter

# Lab 7 – Create-script configureren en testen

## Wat ga je doen?

In dit lab ga je het **create-script** configureren. Dit script wordt uitgevoerd wanneer HelloID een account moet aanmaken in het CSV-bestand `accounts.csv`.

💡 *Waarom dit belangrijk is?*  
Het script in de create-actie zorgt dat HelloID een account aanmaakt in het doelsysteem, als dat er nog niet is.  
Deze actie is cruciaal in het provisioningproces: als dit niet werkt, wordt er simpelweg niks aangemaakt.

---

## 🧰 Stap 1 – Voorbereidingen

1. Open je PowerShell-doelsysteem en ga naar het tabblad **Account → Create**.
2. Vervang het standaardscript door het **startscript van GitHub**:  
   [`create.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%207/create.ps1)

3. Controleer op het tabblad **Configuration** of de juiste waarden zijn ingevuld.  
   Die heb je in Lab 6 aangemaakt:
   - `csvPath`: `C:\HelloID\Training\accounts.csv`
   - `csvDelimiter`: `;`

4. Verwijder de scripts bij de acties **Enable** en **Disable**, zodat HelloID deze niet uitvoert.  
   > ✂️ Ga naar het tabblad **Account**, open Enable en Disable, en leeg het scriptveld.

---

## 🔁 Stap 2 – Correlatie instellen in het script

1. Zoek in het script naar het blok `'CorrelateAccount'`.

2. Implementeer de functie `Get-CsvUser` en gebruik de juiste parameters:
   - Het pad naar het CSV-bestand
   - Het scheidingsteken
   - De waarde waarmee je het account opzoekt

3. Sla het resultaat op in de variabele `$correlatedAccount`.

4. Bekijk de logica binnen het `CorrelateAccount`-blok.  
   Dit blok wordt automatisch aangeroepen als HelloID wil controleren of een account al bestaat.  
   Je geeft hier terug of er een match is, en welke accountreferentie erbij hoort.

---

### ℹ️ Hoe weet HelloID welk veld gebruikt moet worden?

Dat geef je op in de correlatieconfiguratie van HelloID. Deze instellingen zijn beschikbaar in het script via:

```powershell
$actionContext.CorrelationConfiguration.AccountField
$actionContext.CorrelationConfiguration.PersonFieldValue

# Lab 9 – Delete-script configureren en testen

## Wat ga je doen?

In dit lab ga je het **delete-script** voor je doelsysteem instellen. Daarmee zorg je dat HelloID automatisch een account uit het CSV-bestand verwijdert als een entitlement wordt ingetrokken.

💡 Waarom is dit belangrijk?  
Als een persoon uit dienst gaat, of om een andere reden geen toegang meer mag hebben, moet het account netjes worden verwijderd.  
Met dit script regel je dat HelloID de juiste regel uit het CSV-bestand haalt.

---

## 🧰 Stap 1 – Startscript toevoegen

We beginnen met het toevoegen van het juiste script aan je PowerShell-doelsysteem.

### Wat moet je doen?

1. Download het **startscript** voor het delete-event vanuit de GitHub-repository:  
   👉 [`delete.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%209/delete.ps1)

2. Voeg dit script toe in HelloID bij je PowerShell-doelsysteem, onder het tabblad:  
   **Account → Account delete**

---

## ⚙️ Stap 2 – Gebruiker ophalen op basis van de account reference

Bij een delete-actie weet HelloID al welk account verwijderd moet worden. Die info komt via de **account reference** uit een eerdere create- of update-actie.

### Wat moet je doen?

1. In het script gebruik je de **account reference** van HelloID om het juiste account op te zoeken.  
   Deze reference is beschikbaar via:  
   ```powershell
   $actionContext.References.Account
   ```  
   👉 Dit is de unieke waarde die eerder is opgeslagen toen het account werd aangemaakt of gecorreleerd, en die je nu gebruikt om het juiste account in `accounts.csv` te vinden.

2. Voeg een aanroep toe naar `Get-CsvUser` om de juiste regel op te halen. Gebruik:
   - het pad (`csvPath`) en delimiter (`csvDelimiter`) uit de configuratie
   - de account reference als zoekwaarde

3. Test de get-functionaliteit met de **Preview-knop** in de script editor:
   - Kies een persoon die al een account heeft
   - Check of de juiste gebruiker wordt gevonden
   - Als de gebruiker niet wordt gevonden, logt het script een melding, maar zet wel `Success = $true`

ℹ️ Let op: het delete-script moet altijd succesvol zijn — ook als er geen match is. Je wilt namelijk niet dat een foutmelding de hele workflow blokkeert.

---

## 🧽 Stap 3 – Verwijderen van de gebruiker

Als de gebruiker is gevonden, moet je deze verwijderen uit het CSV-bestand.

### Wat moet je doen?

1. Gebruik hiervoor de functie `Remove-CsvUser` die al in het startscript aanwezig is.

2. Geef dezelfde parameters mee als bij de get-functie:
   - het pad (`csvPath`)
   - het scheidingsteken (`csvDelimiter`)
   - de account reference

3. Zorg ervoor dat deze actie **alleen wordt uitgevoerd als `dryRun` op `$false` staat**.  
   Zo voorkom je dat er per ongeluk echt iets verwijderd wordt tijdens een test of preview.

---

## 🧪 Stap 4 – Testen met Preview (dryRun = false)

In deze stap controleer je of het script daadwerkelijk een regel uit het CSV-bestand verwijdert.

### Wat moet je doen?

1. Zet **tijdelijk** bovenin het script:
   ```powershell
   $actionContext.dryRun = $false
   ```

2. Kies een testpersoon die al in `accounts.csv` staat en een uitgedeeld account entitlement heeft.

3. Voer een preview uit in de script editor. Als alles goed gaat:
   - zie je in de auditlog dat het account is verwijderd
   - is de bijbehorende regel uit het CSV-bestand verdwenen

4. Verwijder de regel `$actionContext.dryRun = $false` direct na het testen.  
   Zo voorkom je dat toekomstige previews echte acties uitvoeren.

---

## 🧪 Stap 5 – Testen via business rule

Tot slot controleer je of het delete-script ook goed werkt binnen de volledige provisioningflow van HelloID — dus via een echte business rule.

### Wat moet je doen?

1. Kies een persoon die in lab 7 via een business rule een account entitlement heeft gekregen voor het PowerShell-doelsysteem, en die nog voorkomt in het bestand `accounts.csv`.

2. Pas de business rule aan zodat deze persoon niet meer binnen de conditie van de business rule valt.

3. Voer een evaluate uit om te controleren of de gewijzigde situatie leidt tot een Revoke-actie voor deze persoon.

4. Controleer of er een Revoke-accountactie wordt voorgesteld in het evaluatierapport.  
   Als dat niet zo is, controleer dan of de conditie van de business rule goed is ingesteld.

5. Voer een enforcement uit om de voorgestelde Revoke-actie daadwerkelijk uit te voeren.

6. Controleer in HelloID of de actie succesvol is uitgevoerd:  
   - Bekijk het auditlog van de persoon  
   - Bekijk het auditlog van het PowerShell-doelsysteem  
   - Of ga naar Business → Entitlements → History

7. Open het bestand `accounts.csv` en controleer of de regel van deze persoon is verwijderd.

---

## ✅ Wat heb je geleerd?

- Je weet nu hoe je een delete-script toevoegt en configureert in HelloID.
- Je kunt een account opzoeken en verwijderen op basis van de account reference.
- Je hebt geleerd hoe je het script veilig test via de previewfunctie met dryRun.
- Je hebt het script getest in de volledige provisioningflow via een business rule.
- Je weet hoe je de uitvoering controleert via auditlogs en CSV-validatie.
- Je begrijpt dat een delete-actie altijd succesvol moet zijn — ook als het account niet (meer) gevonden wordt.

🎉 Dit was het laatste lab van de training! Je hebt nu de volledige lifecycle van een account ingericht: van aanmaken tot aanpassen én verwijderen — allemaal met je eigen PowerShell-scripts in HelloID.

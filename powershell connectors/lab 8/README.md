
# Lab 8 – Update-script configureren en testen

## Wat ga je doen?

In dit lab ga je het **update-script** van je doelsysteem configureren en testen. Dit script wordt gebruikt om bestaande accounts bij te werken in het bestand `accounts.csv`.

💡 Waarom dit belangrijk is?  
HelloID voert een update uit als er een account entitlement is uitgedeeld én er een wijziging is vastgesteld in de snapshot van de persoon.  
Tijdens een HR-import vergelijkt HelloID de bestaande snapshot met de nieuwe gegevens.  
Als er minimaal één verschil wordt gevonden, en het account-entitlement is eerder succesvol uitgedeeld, dan wordt automatisch de update-actie uitgevoerd voor het doelsysteem.

---

## 🧰 Stap 1 – Voorbereidingen

1. Download het **startscript** voor het update-event:  
   👉 [`update.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/tree/main/powershell%20connectors/lab%208/update.ps1)

2. Voeg dit script toe aan je PowerShell-doelsysteem onder het tabblad **Account → Account update**.

---

## ⚙️ Stap 2 – Gebruiker ophalen op basis van de Account Reference

Bij een update-actie geeft HelloID automatisch de **account reference** mee van het account dat eerder is uitgedeeld.  
Deze waarde is eerder teruggegeven door het create-script, toen het account werd aangemaakt of gecorreleerd. HelloID slaat deze waarde intern op in het account entitlement.

Bij vervolgacties, zoals een update, wordt deze waarde opnieuw beschikbaar gesteld in het script. Je gebruikt deze om de juiste gebruiker op te zoeken in het bestand `accounts.csv`.

De waarde is beschikbaar via:

```powershell
$actionContext.References.Account
```

1. Implementeer op de juiste plek in het script de functieaanroep `Get-CsvUser`.  
   Geef hierbij de juiste parameters mee: het pad en de delimiter van het bestand, en de account reference.  
   **Sla het resultaat op in de variabele `$correlatedAccount`.** Je gebruikt dit object later om te vergelijken en bij te werken.

2. Test of het ophalen van een gebruiker goed werkt.  
   In het startscript is standaard een foutmelding opgenomen voor het geval er geen gebruiker wordt gevonden. Controleer of deze foutafhandeling werkt zoals bedoeld.

   👉 Gebruik hiervoor de **Preview-knop** in de script editor:
   - Kies een persoon die een uitgedeeld **account entitlement** heeft. Het script zou dan moeten aangeven dat er een gebruiker is gevonden.
   - Kies daarna een persoon zonder uitgedeeld account. Het script zou nu de foutmelding moeten tonen.

   👉 Let op: dit is een **leesactie** — er wordt nog niets aangepast in het bestand.

---

## 🔧 Stap 3 – Gegevens bijwerken in het CSV-bestand

1. 💡 **Ga na of het script controleert of er iets gewijzigd is.**  
   HelloID voert alleen een update uit als de nieuwe gegevens verschillen van wat er al in het CSV-bestand staat.  
   In het script wordt dit automatisch gecontroleerd met `Compare-Object`.

   👉 Deze logica zit al in het startscript én in het HelloID-doelsysteemtemplate dat we als basis gebruiken:  
   [`HelloID-Conn-Prov-Target-V2-Template`](https://github.com/Tools4everBV/HelloID-Conn-Prov-Target-V2-Template)

   Kijk in je eigen update-script in HelloID hoe deze vergelijking met `Compare-Object` is opgebouwd.  
   Zo zie je wanneer het script besluit dat er iets gewijzigd is en een update moet worden uitgevoerd.

2. **Werk de update-actie uit op de juiste plek in het script.**  
   Een schrijfactie (zoals het bijwerken van het CSV-bestand) mag alleen worden uitgevoerd als `dryRun` niet op `true` staat.  
   Deze controle zit al in het startscript — zoek op basis daarvan de juiste plek om de update toe te voegen.

   Roep op die plek de functie `Set-CsvUser` aan om de juiste regel in het bestand `accounts.csv` bij te werken.

   Gebruik hiervoor de variabelen die je eerder in de labs hebt toegepast.  
   👉 Deze gebruik je als inputparameters voor de functie `Set-CsvUser`. Ze bevatten:
   - Het pad naar het CSV-bestand (uit de configuratie)
   - De delimiter van het bestand (uit de configuratie)
   - De account reference van het entitlement
   - De data uit de field mapping (dit bepaalt wat er geüpdatet moet worden)

3. **Test het script in de script editor met de Preview-knop.**  
   Controleer of je geen fouten krijgt en of het script alleen een update voorstelt als er echt iets is gewijzigd.  
   👉 Let op: de update wordt pas daadwerkelijk uitgevoerd in de volgende stap, wanneer je `dryRun = false` zet.

---

## 🧪 Stap 4 – Testen met Preview (dryRun = false)

In deze stap controleer je of het script daadwerkelijk een wijziging aanbrengt in het bestand `accounts.csv`.  
Je voert de test uit via de **previewfunctie** van HelloID, maar schakelt tijdelijk `dryRun` uit zodat de schrijfactie ook echt wordt uitgevoerd.

1. Voeg **tijdelijk bovenin het script** de volgende regel toe:
   ```powershell
   $actionContext.dryRun = $false
   ```

2. Kies een persoon die al een account heeft in het bestand `accounts.csv`.  
   Deze persoon moet een uitgedeeld **account entitlement** hebben — anders is er geen account reference beschikbaar en kan de update niet worden uitgevoerd.

3. Pas handmatig een veld aan in het bestand `accounts.csv` voor deze persoon.  
   Denk bijvoorbeeld aan de afdeling of functie.

4. Voer een **preview** uit in HelloID voor deze persoon.  
   Controleer of het script de gewijzigde gegevens heeft bijgewerkt naar de juiste contractgegevens in het bestand `accounts.csv`.

5. Verwijder de regel `$actionContext.dryRun = $false` **na het testen**.  
   Zo voorkom je dat toekomstige previews echte wijzigingen uitvoeren.

---

(het document gaat verder — volgende blok volgt in de tweede helft)

---

## 🧪 Stap 5 – Testen via business rule

Tot slot test je of de update ook correct wordt uitgevoerd binnen de volledige provisioningflow van HelloID.

1. Kies een persoon die al een uitgedeeld **account entitlement** heeft voor het PowerShell-doelsysteem.

2. Pas de gegevens van deze persoon aan in de brondata — bijvoorbeeld in het bestand `T4E_HelloID_Contracts.csv`.  
   Kies een veld dat zichtbaar is in het bestand `accounts.csv`, zoals de afdeling of functie.  
   💡 Let op: het veld moet opgenomen zijn in de **field mapping** én het **update-event** voor dat veld moet zijn ingeschakeld.

3. Importeer de brongegevens opnieuw in HelloID.  
   Deze import zorgt ervoor dat de wijziging wordt verwerkt in de snapshot van de persoon.

4. Voer een **evaluate** uit op de business rule waarin deze persoon voorkomt.  
   Controleer of er een **update-actie** wordt voorgesteld.

5. Voer een **enforcement** uit.

6. Controleer in HelloID of de update correct is uitgevoerd:
   - Bekijk de **auditlog van de persoon**, of
   - Controleer de status in het tabblad **Business → Entitlements → History**

7. Open het bestand `accounts.csv` en controleer of de wijziging is doorgevoerd zoals verwacht.

---

## 🧪 Stap 6 – Testen van de update tijdens correlatie (via het create-script)

In deze stap test je of het **update-script** ook correct wordt aangeroepen tijdens een **correlatieactie** in het create-script.

Dit gebeurt niet standaard bij elke create-actie, maar alleen wanneer HelloID tijdens de correlatie vaststelt dat het account al bestaat én je in het script aangeeft dat het account is gecorreleerd via:

```powershell
$outputContext.AccountCorrelated = $true
```

💡 HelloID voert dan géén nieuwe **create** uit, maar wél een **update**.

Om dit scenario in de testomgeving na te bootsen, gaan we eerst het bestaande account entitlement **unmanagen**.  
HelloID “vergeet” dan dat het account eerder is uitgedeeld, en gaat het opnieuw uitdelen. Tijdens de create-actie wordt het account gecorreleerd, en direct daarna wordt het update-script gestart.

1. Doe een **unmanage** op het bestaande account entitlement van een persoon die al eerder een account heeft gekregen.  
   - Ga naar **Persons → Entitlements** of **Business → Entitlements → Granted**.
   - Klik op het **support-icoontje** bij het uitgedeelde account entitlement.
   - Klik rechtsboven op **Start action** en kies vervolgens voor **Unmanage**.

2. Pas de gegevens van deze persoon aan in het bronbestand `T4E_HelloID_Contracts.csv`.  
   Wijzig bijvoorbeeld de **einddatum** in de kolom `EndDate` naar de laatste dag van de huidige maand.  
   💡 Let op: gebruik het formaat `mm/dd/yyyy` (bijvoorbeeld `05/31/2025` voor 31 mei 2025).

3. Voer een **import** uit van het HR-bronsysteem.

4. Controleer of de wijziging zichtbaar is op de **History-tab** van de betreffende persoon in HelloID.

5. Voer een **evaluate** uit.  
   Als het goed is, wordt het account opnieuw uitgedeeld via een **create-actie**.  
   Omdat het account al bestaat, wordt in het script gecorreleerd en wordt daarna automatisch het **update-script** gestart.

6. Voer een **enforcement** uit.

7. Controleer in HelloID of de acties correct zijn uitgevoerd:
   - Bekijk de **auditlog** van het PowerShell-doelsysteem.
   - Je zou twee meldingen moeten zien:
     - Eén melding dat het account is gecorreleerd (via het create-script),
     - Én een melding dat het account is geüpdatet (via het update-script).

8. Open het bestand `accounts.csv` en controleer of de wijziging correct is doorgevoerd.

---

✅ Je hebt nu het update-script geconfigureerd, getest in de script editor, via preview én via een business rule. Ook heb je geleerd hoe HelloID het update-script aanroept tijdens correlatie.

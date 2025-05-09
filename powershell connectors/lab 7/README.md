# Lab 7 – Create-script configureren en testen

## Wat ga je doen?

In dit lab ga je het **create-script** voor je doelsysteem opbouwen. Je begint met een startscript dat nog niet compleet is. Je vult zelf de logica aan voor:

- het herkennen van bestaande accounts (correlatie),
- en het aanmaken van een nieuw account als dat nodig is (create-actie).

💡 **Waarom dit belangrijk is?**  
Het script in de create-actie zorgt dat HelloID een account aanmaakt in het doelsysteem, als dat er nog niet is. Deze actie is cruciaal in het provisioningproces: als dit niet werkt, wordt er simpelweg niks aangemaakt.

---

## 🧰 Stap 1 – Voorbereidingen

1. Download het  accountsbestand en plaats dit in de map `C:\HelloID\TargetData`:  
   👉 [`accounts.csv`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%207/accounts.csv)
3. Controleer in HelloID op het tabblad **Configuration** of de waarden kloppen met wat je in Lab 6 hebt ingevuld:
   - `csvPath`: `C:\HelloID\TargetData\accounts.csv`
   - `csvDelimiter`: `;`

---

## 🔧 Stap 2 – Scripts koppelen en onnodige acties verwijderen

1. Ga naar het tabblad **Account → Account create** van je PowerShell-doelsysteem.
2. Vervang het standaardvoorbeeld door de **tekst uit het script [`create.ps1`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%207/create.ps1)** dat je in de vorige stap hebt gedownload.
3. Verwijder de scripts voor de **Enable-** en **Disable-acties**.  
   Deze acties zijn niet nodig voor deze connector, en door de placeholder-scripts te verwijderen houd je de configuratie overzichtelijk en correct.

---

## 🔗 Stap 3 – Correlatie instellen in de HelloID-interface

In deze stap geef je in de interface van HelloID aan **hoe een persoon wordt gecorreleerd aan een bestaand account** in het doelsysteem.

💡 **Waarom correlatie belangrijk is?**  
HelloID moet weten welk bestaand account bij welke persoon hoort.  
Zonder goede correlatie worden er óf geen accounts herkend, óf per ongeluk dubbele accounts aangemaakt.  
Deze instellingen zijn ook nodig in het script: ze worden beschikbaar gesteld via `$actionContext.CorrelationConfiguration`.

1. Ga in HelloID naar je PowerShell-doelsysteem.
2. Open het tabblad **Correlation**.
3. Schakel de optie **Enable correlation** in.
4. Stel de volgende configuratie in:
   - **HelloID-veld**: `ExternalId`
   - **Doelsysteemveld**: `Id`

ℹ️ Je wijzigingen worden automatisch opgeslagen.

---

## ⚙️ Stap 4 – Correlatie verwerken in het script

Nu je de correlatie hebt ingesteld in de interface, ga je deze ook verwerken in het script.

💡 **Waarom correlatie belangrijk is?**  
Met deze stap voorkom je dat HelloID dubbele accounts aanmaakt. Je script geeft namelijk expliciet terug dat er al een account bestaat, inclusief de bijbehorende referentie (*de zogenaamde account reference*).

1. Open het script bij **Account → Account create** van je PowerShell-doelsysteem.
2. Voeg in het script de aanroep toe van de functie `Get-CsvUser` om te controleren of de persoon al in het bestand `accounts.csv` staat.  
   Deze functie verwacht een aantal parameters:  
   Gebruik hiervoor de volgende variabelen en sla het resultaat van de functie op in de variabele `$correlatedAccount`:
   - `$actionContext.Configuration.csvPath`: pad naar het accountsbestand.
   - `$actionContext.Configuration.csvDelimiter`: het scheidingsteken uit het formulier.
   - `$correlationField`: het doelsysteemveld waarmee je correleert.
   - `$correlationValue`: de waarde uit het persoonsobject waarmee je correleert.
3. Bekijk de logica binnen het `CorrelateAccount`-blok. Deze logica staat al in het startscript:

   ```powershell
   'CorrelateAccount' {
       Write-Information 'Correlating Training account'

       $outputContext.Data = $correlatedAccount
       $outputContext.AccountReference = $correlatedAccount.Id
       $outputContext.AccountCorrelated = $true
       $auditLogMessage = "Correlated account: [$($outputContext.AccountReference)] on field: [$($correlationField)] with value: [$($correlationValue)]"
       break
   }
   ```

💡 Dit blok in het startscript wordt automatisch aangeroepen als HelloID wil controleren of een account al bestaat.  
Met `$outputContext.AccountCorrelated = $true` geef je aan dat er een bestaand account is gevonden.  
Via `$outputContext.AccountReference` geef je de unieke ID (referentie) van het account terug aan HelloID — dit is belangrijk voor vervolgacties zoals updates of deletes.  
De `$outputContext.Data` bevat optioneel extra gegevens over het gevonden account.

4. Test nu het script in de script editor met de **Preview-knop**.  
   Controleer of het script een bestaande gebruiker herkent op basis van de ingestelde correlatie.  
   👉 Kies hiervoor een persoon die **al voorkomt in het bestand `accounts.csv`**.  
   Zie je een foutmelding of werkt het script niet? Controleer je syntax en los het op voordat je doorgaat.

---

## 🆕 Stap 5 – Create-actie toevoegen aan het script

In deze stap breid je het script uit met de **create-actie**. Als HelloID geen bestaand account vindt, moet het script een nieuw account aanmaken in het bestand `accounts.csv`.

💡 **Waarom dit belangrijk is?**  
Als deze logica ontbreekt, worden er geen nieuwe accounts aangemaakt — ook niet als dat wel zou moeten. Je script moet dus expliciet kunnen aangeven: “er is geen match, dus ik maak een nieuw account aan”.

1. Voeg in het script de aanroep toe van de functie `New-CsvUser` om een nieuwe regel toe te voegen aan het bestand `accounts.csv`.  
   Plaats deze aanroep binnen het blok dat wordt uitgevoerd als er tijdens de correlatie **geen account is gevonden** (dus wanneer `$correlatedAccount` leeg is).  
   Schrijf de aanroep als volgt:

   ```powershell
   $createdAccount = New-CsvUser ...
   ```

   Hiermee sla je de uitvoer op in `$createdAccount`, zodat je de accountreferentie later kunt teruggeven aan HelloID.

   Gebruik hiervoor de volgende variabelen als parameters van de functie:
   - `$actionContext.Configuration.csvPath`: pad naar het CSV-bestand.
   - `$actionContext.Configuration.csvDelimiter`: scheidingsteken.
   - `$actionContext.Data`: dit object bevat alle gegevens van de gebruiker op basis van de mapping in HelloID.

2. Test het script in de script editor met de **Preview-knop**:
   - Kies een persoon die **nog niet** voorkomt in het bestand `accounts.csv`.
   - Controleer of HelloID aangeeft dat er een **nieuw account aangemaakt zou worden**.

💡 Tijdens een preview voert HelloID provisioningacties standaard uit in **dry run**-modus.  
Je script wordt wel uitgevoerd, maar **wijzigt het CSV-bestand nog niet echt**.  
Je controleert in deze stap dus alleen of het script technisch correct reageert op een nieuwe gebruiker.

---

## 🧪 Stap 6 – Testen met preview (dryRun = false)

Je hebt het script eerder getest in de editor. Nu ga je het gedrag van het script **echt testen** met een preview in HelloID Provisioning.  
In deze stap controleer je of het script een nieuw account aanmaakt in het bestand `accounts.csv`, zoals bedoeld bij de create-actie.

💡 **Waarom dit belangrijk is?**  
HelloID voert provisioningacties standaard uit in **dry run**-modus tijdens een preview. Dat betekent dat het script wel draait, maar er geen echte wijziging plaatsvindt.  
Omdat je nu wilt controleren of er daadwerkelijk iets wordt toegevoegd aan het CSV-bestand, moet je deze beveiliging tijdelijk uitschakelen.

1. Voeg **tijdelijk bovenin het script** de volgende regel toe:
   ```powershell
   $actionContext.dryRun = $false
   ```
   Hiermee geef je expliciet aan dat HelloID de schrijfactie wél mag uitvoeren tijdens de preview.
2. Kies in HelloID een persoon die **nog niet voorkomt** in het bestand `accounts.csv`.

   Je test nu of het script een nieuw account aanmaakt door een extra regel toe te voegen aan het CSV-bestand.  
   Dit is de eerste keer dat je controleert of de create-actie daadwerkelijk iets schrijft.
3. Voer een preview uit via de **Preview-knop** van het script.
4. Controleer of er een nieuwe regel is toegevoegd aan het CSV-bestand — met de juiste gegevens uit de mapping.
5. Verwijder na het testen de regel `$actionContext.dryRun = $false` **direct** uit het script.  
   💡 **Sla het script nooit op met deze regel erin!**  
   Zo voorkom je dat toekomstige previews of live-uitvoeringen onbedoeld echte acties uitvoeren.

---

## 🧪 Stap 7 – Testen via business rule

In deze stap controleer je of de create-actie ook correct wordt uitgevoerd binnen de volledige provisioningflow van HelloID — dus niet alleen in de script editor, maar als onderdeel van een business rule.

💡 **Waarom dit belangrijk is?**  
De previewfunctie is handig voor losse scripts, maar uiteindelijk wil je weten of alles samenwerkt: de mapping, de correlatie, het script en de business rules.  
HelloID geeft **alleen via een business rule** een entitlement uit. Pas op dat moment wordt ook de **account reference** opgeslagen.  
Die reference heb je nodig om vervolgscripts zoals update of delete goed te kunnen testen. Als je dus verder wilt testen via de previewfunctie, moet het account eerst zijn uitgedeeld via een business rule.

1. Open de business rule die je eerder hebt aangemaakt (in **Lab 5.2**) en voeg twee personen toe aan de conditie:
   - Eén persoon die **al voorkomt** in het bestand `accounts.csv`.
   - Eén persoon die **nog niet voorkomt**.

2. Controleer op het tabblad **Entitlements** of er zowel een Active Directory-account als een account van het PowerShell-doelsysteem gekoppeld wordt.

3. Voer een **Evaluate** uit.  
   Controleer of er acties zijn gegenereerd voor het PowerShell-doelsysteem en of deze overeenkomen met wat je verwacht.  
   (Bijvoorbeeld: wordt er voor beide personen een create-actie voorgesteld?)

4. Voer daarna de **enforcement** uit om de acties echt uit te voeren.

5. Controleer in HelloID bij de betreffende personen of de Active Directory-accounts zijn aangemaakt.  
   Ga naar het tabblad **Accounts** van de persoon en kijk of de `SamAccountName` wordt weergegeven.  
   (Deze heb je in **Lab 5.2** zichtbaar gemaakt via accountdata.)

6. Controleer of de **acties** voor het PowerShell-doelsysteem correct zijn uitgevoerd:
   - Bekijk de **auditlog van de persoon** of
   - Ga naar **Business → Entitlements → History** om de status terug te zien.

7. Open het bestand `accounts.csv` en controleer of de nieuwe persoon correct is toegevoegd.

---

## ✅ Wat heb je geleerd?

- Je hebt het **create-script stap voor stap opgebouwd**: van correlatie tot account aanmaken.
- Je weet hoe HelloID controleert of een account al bestaat — via **correlatie in de interface én in het script**.
- Je hebt geleerd hoe je een **nieuw account aanmaakt** als er geen match is gevonden.
- Je hebt het script getest met een **preview (in dry run-modus)** én als onderdeel van een **volledige business rule**.
- Je weet hoe je **$actionContext.Configuration** gebruikt om scripts flexibel te maken via configuratieparameters.
- Je hebt gezien waarom je **$actionContext.dryRun = $false alleen tijdelijk** toevoegt, en dat je deze regel **nooit mag opslaan**.

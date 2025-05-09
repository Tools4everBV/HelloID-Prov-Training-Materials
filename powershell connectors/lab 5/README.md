# Lab 5 – Field mapping instellen

## Wat ga je doen?
In dit lab leer je hoe je de **field mapping** van een doelsysteem configureert. Je werkt met een voorgevulde mapping, voert aanpassingen uit, koppelt Active Directory en voegt optioneel een complexe mapping toe voor de displayname.

💡 **Waarom is dit belangrijk?**  
De field mapping bepaalt welke gegevens vanuit de HelloID-persoon beschikbaar zijn voor je scripts.  
Je kunt hiermee ook gegevens uit andere systemen, zoals Active Directory, beschikbaar maken voor je doelsysteem.

---

## 🧰 Stap 1 – Field mapping importeren

In deze stap begin je niet met een lege mapping, maar met een voorgedefinieerd startbestand. Zo hoef je niet alle velden zelf handmatig aan te maken en kun je meteen focussen op de relevante wijzigingen.

---

### 🧹 Verwijder de bestaande mapping

Als je deze connector **net hebt aangemaakt**, dan heeft HelloID automatisch een standaardmapping gegenereerd.  
Voordat je de nieuwe mapping importeert, moet je die bestaande mapping eerst verwijderen.

1. Ga naar het tabblad **Fields** van je PowerShell-doelsysteem.  
2. Klik rechtsboven op **Delete all**.  
3. Bevestig dat je alle bestaande velden wilt verwijderen.

> 💡 Als je deze stap overslaat, blijven velden uit de standaardmapping bestaan — ook als ze niet in het nieuwe field mapping bestand staan.  
> Dit kan leiden tot fouten in je doelsysteem, bijvoorbeeld als er velden worden verwerkt of doorgestuurd die daar helemaal niet bestaan of ondersteund worden.

---

### 📥 Startbestand importeren

1. Download het startbestand `fieldMapping.json` uit de GitHub-repository:  
   👉 [`fieldMapping.json`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%205/fieldMapping.json)

2. Klik op **Import mapping**.  
3. Selecteer het JSON-bestand dat je net hebt gedownload en bevestig de import.

> 💡 De velden in deze mapping zijn al gedeeltelijk ingevuld op basis van het ontwerp. Een aantal velden zijn bewust nog leeg of vereisen aanpassing — dat ga je doen in stap 2.

---

### ✅ Controle na import

- Controleer of de velden correct zijn ingeladen.  
- Je zou nu deze velden moeten zien:  
  `Department`, `DisplayName`, `EndDate`, `FamilyName`, `FamilyNamePrefix`, `Id`, `Manager`, `NickName`, `StartDate`, `Title` en `UserName`.

---

## 🧰 Stap 2 – Field mapping aanpassen op basis van je ontwerp

Open je PowerShell-doelsysteem in HelloID en ga naar het tabblad **Fields**.

Gebruik de tabel **3.3 Field mapping** uit je ontwerp (zie hieronder) als uitgangspunt.  
Deze tabel komt uit het lab *Lab 3 – Ontwerp maken voor het doelsysteem*.

> 💡 Je werkt in deze stap verder met de mapping die je zojuist hebt geïmporteerd. Daarin staan al een aantal velden. Nu ga je de mapping verder aanvullen en corrigeren zodat deze precies klopt met je ontwerp en de eisen van je doelsysteem.

---

### 🔧 Aanpassingen die je moet doen

#### ➕ Voeg de volgende velden toe aan de mapping:

| Veldnaam            | Bronveld                               | Mapping type | Use in notifications | Store in account data |
|---------------------|-----------------------------------------|--------------|-----------------------|------------------------|
| `PartnerNamePrefix` | `Person.Name.FamilyNamePartnerPrefix`  | Field        | ❌                    | ❌                     |
| `PartnerName`       | `Person.Name.FamilyNamePartner`        | Field        | ❌                    | ❌                     |
| `NameConventionCode`| `Person.Name.Convention`               | Field        | ❌                    | ❌                     |

---

#### ❌ Verwijder het volgende veld:
- `Manager` (dit wordt niet gebruikt in deze training)

---

#### ✔️ Controleer per veld de instellingen:

- Moet het veld **zichtbaar zijn op het accounttabblad** van de persoon? → vink **Store in account data** aan.  
- Moet het veld **gebruikt worden in notificaties**? → vink **Use in notifications** aan.

Gebruik hiervoor onderstaande referentie uit **tabel 3.3 van Lab 3**:

| Attribuut            | Bronveld                                               | Update? | Zichtbaar bij persoon | Notificatie? |
|----------------------|---------------------------------------------------------|---------|------------------------|--------------|
| Department           | PrimaryContract.Department.DisplayName                  | ✅      | ❌                     | ❌           |
| DisplayName          | DisplayName                                             | ✅      | ✅                     | ✅           |
| EndDate              | PrimaryContract.EndDate                                 | ✅      | ❌                     | ❌           |
| Id                   | ExternalID                                              | ❌      | ❌                     | ❌           |
| FamilyName           | Name.FamilyName                                         | ✅      | ❌                     | ❌           |
| NickName             | Name.NickName                                           | ✅      | ❌                     | ❌           |
| StartDate            | PrimaryContract.StartDate                               | ✅      | ❌                     | ❌           |
| Title                | PrimaryContract.Title.Name                              | ✅      | ❌                     | ✅           |
| UserName             | Person.Accounts.MicrosoftActiveDirectory.SamAccountName | ❌      | ✅                     | ✅           |
| FamilyNamePrefix     | Name.FamilyNamePrefix                                   | ✅      | ❌                     | ❌           |
| PartnerNamePrefix    | Name.FamilyNamePartnerPrefix                            | ✅      | ❌                     | ❌           |
| PartnerName          | Name.FamilyNamePartner                                  | ✅      | ❌                     | ❌           |
| NameConventionCode   | Name.Convention                                         | ✅      | ❌                     | ❌           |

---

#### 🧪 Testen van de mapping

- Gebruik de **Preview-functionaliteit** (rechtsboven in het scherm)  
- Test zowel het **create-event** als het **update-event**  
- Controleer of de waarden correct, compleet en logisch zijn op basis van jouw testpersoon

---

## 🧰 Stap 3 – AD-veld gebruiken in je PowerShell-connector

In deze stap maak je gebruik van een veld uit de AD-connector binnen je PowerShell-doelsysteem.  
Het doel is om de waarde van `SamAccountName` uit Active Directory te hergebruiken in de mapping van het PowerShell-systeem.

---

### 🪝 Het PowerShell-systeem afhankelijk maken van data uit het Active Directory-systeem

1. Ga naar het tabblad **Accounts** van je PowerShell-doelsysteem.

2. Open de optie **Use account data from systems**.

3. Selecteer het **Active Directory-doelsysteem** als afhankelijk systeem.

> 💡 Hierdoor kun je gegevens uit het AD-systeem ophalen en gebruiken in deze connector, bijvoorbeeld de gebruikersnaam uit het AD-veld `SamAccountName`.

---

### 🗺️ Controleren of het AD-veld correct is ingesteld

1. Ga naar je AD-doelsysteem en open het tabblad **Fields**.

2. Zoek het veld `SamAccountName` in de lijst.

3. Controleer of de volgende instelling is ingeschakeld:
   - ✅ **Store in account data** staat aan

> 📌 Door deze optie aan te vinken, kun je de waarde van `SamAccountName` gebruiken in andere connectors, zoals je PowerShell-doelsysteem.

---

### 🧪 Koppeling testen via een business rule

1. Maak een business rule waarbij slechts één persoon wordt geselecteerd (bijvoorbeeld op personeelsnummer) uit de csv-bronconnector, zodat je zeker weet dat de benodigde gegevens beschikbaar zijn.

2. Voer een evaluatie uit van de business rule.  
   Wordt er een create-actie voorgesteld voor het AD-doelsysteem? Voer dan een enforcement uit om het account daadwerkelijk toe te wijzen.

3. Controleer bij de betreffende persoon op het tabblad Audit Logs of HelloID het AD-account succesvol heeft uitgedeeld.

4. Ga vervolgens naar het tabblad Accounts en controleer of het veld SamAccountName zichtbaar is onder het AD-account.

---

### 🧠 SamAccountName ophalen in PowerShell-mapping

1. Ga terug naar je PowerShell-doelsysteem en open het tabblad **Fields**.

2. Zoek het veld `UserName` en wijzig de mapping naar **Complex (JavaScript)**.

3. Gebruik het startscript van GitHub als basis voor je mapping:  
   👉 [`getValueFromOtherSystem.js`](https://github.com/Tools4everBV/HelloID-Prov-Training-Materials/blob/Feature-2025-material/powershell%20connectors/lab%205/getValueFromOtherSystem.js)

4. Pas het script aan zodat het de waarde ophaalt uit het veld `SamAccountName` van het AD-doelsysteem.

> 💡 In de script editor kun je gebruikmaken van **autocomplete**.  
> Typ `Person.Accounts.` gevolgd door de naam van je AD-connector, en HelloID toont automatisch een lijstje met beschikbare velden — zoals `sAMAccountName`. Zo weet je zeker dat je het juiste veld gebruikt.

> ℹ️ Het AD-doelsysteem in HelloID heet standaard **Microsoft Active Directory**.  
> Onder de optie **Use account data from systems** zie je zowel de weergavenaam als de technische naam van het systeem.  
> De technische naam gebruik je in je script. Meestal is dit de weergavenaam van de connector zonder spaties.

---

## ⭐ Stap 4 – Bonusopdracht: DisplayName genereren via helperfunctie

In deze stap ga je een complexe JavaScript-mapping maken voor het veld `DisplayName`.  
Je gebruikt hiervoor een helperfunctie uit de GitHub-bibliotheek, zodat de naam automatisch wordt opgebouwd volgens een vaste conventie.

> 💡 Deze stap is optioneel en kun je alleen doen als je genoeg tijd over hebt en alle eerdere labs volledig hebt uitgevoerd. Het is een goede oefening om te werken met complexe mappings en helperfuncties.

---

### 🧰 Wat ga je doen?

1. Zet het veld `DisplayName` om van een gewone mapping naar een **Complexe mapping (JavaScript)**.

2. Gebruik daarbij de naamconventie uit je ontwerp (zie Lab 3, tabel 3.4).

3. Zoek op GitHub de juiste helperfunctie die hoort bij jouw gekozen naamconventie:  
   👉 [`HelloID-Lib-Prov-HelperFunctions`](https://github.com/Tools4everBV/HelloID-Lib-Prov-HelperFunctions)  
   → Navigeer naar `Javascript/Target/DisplayName/` en raadpleeg de `README.md` om de juiste functie te kiezen.

4. Plak de gekozen functie in het veld `DisplayName` in HelloID.

---

### ✅ Testen van de DisplayName-mapping

#### 1. Testen in de script editor

- Open de script editor van het veld `DisplayName`.
- Selecteer een aantal verschillende personen uit de csv-bronconnector.
- Controleer per persoon of de gegenereerde `DisplayName` overeenkomt met de gekozen naamconventie.

#### 2. Testen via de field mapping preview

- Sluit de script editor en ga terug naar het tabblad **Fields**.
- Klik op **Preview** bij het veld `DisplayName`.
- Controleer het resultaat bij zowel het **create-event** als het **update-event**.

---

✅ Je hebt nu de field mapping geconfigureerd, gecontroleerd én verrijkt met gegevens uit een dependent system. Dit vormt de basis voor de provisioningacties in de komende labs.

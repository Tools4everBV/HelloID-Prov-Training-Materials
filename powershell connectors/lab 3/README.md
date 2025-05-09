# Lab 3 – Ontwerp maken voor het doelsysteem

## Business consultancy-fase

### Wat ga je doen?
In dit lab ga je een ontwerp maken voor een doelsysteem. Dit is een belangrijke voorbereidende stap voordat je scripts en configuratie gaat opzetten. Je brengt in kaart wat de connector moet doen, welke gegevens er nodig zijn, en hoe je die wilt aanleveren.

Of je nou implementatiepartner bent of zelf HelloID beheert binnen je eigen organisatie: met dit ontwerp leg je de basis voor een goede provisioning-koppeling.

---

> 💡 **Waarom dit belangrijk is**  
> Voordat je met scripts en configuratie aan de slag gaat, moet je een duidelijk beeld hebben van:
>
> - wat het systeem moet aanmaken of aanpassen,  
> - welke data daarvoor nodig is,  
> - waar die data vandaan komt,  
> - en hoe die eruit moet zien.  
>
> Dit helpt je om gericht te bouwen én voorkomt foutieve provisioningacties later in het proces.

---

## 3.1 Het scenario

Stel: je bent HelloID-beheerder bij een organisatie die een eigen intranet heeft. Het management verwacht dat nieuwe medewerkers automatisch een account krijgen. Hiervoor wil je een PowerShell-connector maken die deze accounts beheert op basis van de gegevens uit het bronsysteem.

---

## 3.2 Plan van eisen

| Onderdeel             | Omschrijving                                               |
|-----------------------|------------------------------------------------------------|
| Bestandstype          | CSV-bestand op een lokale server                           |
| Formaat               | Eén regel per persoon, puntkomma gescheiden                |
| Acties                | Create, Update, Delete                                     |
| Extra gegevensbron    | Active Directory (voor gebruikersnaam)                     |
| Eisen                 | SamAccountName uit AD moet meegestuurd worden              |

---

## 3.3 Field mapping bepalen

In deze stap zet je op een rij welke velden je nodig hebt, waar ze vandaan komen en of ze zichtbaar of wijzigbaar moeten zijn. Denk vanuit de provisioning-actie: welke gegevens zijn echt nodig om een account aan te maken of te wijzigen?

ℹ️ Een *bronveld* is een veld dat via de ruwe data afkomstig is uit het HR-systeem (bijvoorbeeld via een CSV-bestand of API).  
Het HelloID-veld hoort bij het **standaard persoonsmodel** van HelloID. Via de field mapping koppel je het bronveld aan het juiste HelloID-veld.

| Attribuut            | Bronveld                                                 | Update? | Zichtbaar bij persoon | Notificatie? |
|----------------------|-----------------------------------------------------------|---------|------------------------|--------------|
| Department           | PrimaryContract.Department.DisplayName                    | ✅      | ❌                     | ❌           |
| DisplayName          | DisplayName                                               | ✅      | ✅                     | ✅           |
| EndDate              | PrimaryContract.EndDate                                   | ✅      | ❌                     | ❌           |
| Id                   | ExternalID                                                | ❌      | ❌                     | ❌           |
| FamilyName           | Name.FamilyName                                           | ✅      | ❌                     | ❌           |
| NickName             | Name.NickName                                             | ✅      | ❌                     | ❌           |
| StartDate            | PrimaryContract.StartDate                                 | ✅      | ❌                     | ❌           |
| Title                | PrimaryContract.Title.Name                                | ✅      | ❌                     | ✅           |
| UserName             | Person.Accounts.MicrosoftActiveDirectory.SamAccountName   | ❌      | ✅                     | ✅           |
| FamilyNamePrefix     | Name.FamilyNamePrefix                                     | ✅      | ❌                     | ❌           |
| PartnerNamePrefix    | Name.FamilyNamePartnerPrefix                              | ✅      | ❌                     | ❌           |
| PartnerName          | Name.FamilyNamePartner                                    | ✅      | ❌                     | ❌           |
| NameConventionCode   | Name.Convention                                           | ✅      | ❌                     | ❌           |

---

## 3.4 Naamconventies bepalen

Sommige doelsystemen verwachten een specifieke volgorde in de naamopbouw. Je bepaalt samen met de betrokkenen — of dat nu je klant is of je eigen organisatie — welke naamconventie je gebruikt:

| Code | Voorbeeld                                 | Uitleg                             |
|------|--------------------------------------------|------------------------------------|
| B    | Angie van den Hoeger                      | Geboortenaam                       |
| PB   | Angie van de Dooley                       | Partnernaam – Geboortenaam         |
| P    | Angie van den Hoeger – van de Dooley      | Partnernaam                        |
| BP   | Angie van de Dooley – van den Hoeger      | Geboortenaam – Partnernaam         |

---

## 3.5 Correlatie configureren

Correlatie is essentieel om te voorkomen dat een connector dubbele accounts aanmaakt. Je koppelt één uniek kenmerk van de persoon aan een uniek kenmerk van het account in het doelsysteem:

| Beschrijving            | Waarde       |
|-------------------------|--------------|
| HelloID-veld (person)   | ExternalId   |
| Doelsysteemveld         | Id           |

> 📌 **Waarom dit belangrijk is:**  
> Zonder correlatie weet HelloID niet welk bestaand account bij welke persoon hoort. Dat kan leiden tot dubbele accounts of foutieve acties.

---

## 3.6 Configuratieparameters vastleggen

Je maakt het script flexibel door instellingen zoals pad en scheidingsteken aan te bieden via een configuratieformulier.

| Label              | Key (PowerShell) | Voorbeeldwaarde                        |
|--------------------|------------------|----------------------------------------|
| Pad naar bestand   | `csvPath`        | `C:\HelloID\TargetData\accounts.csv`     |
| Scheidingsteken    | `csvDelimiter`   | `;`                                    |

> 🧠 **Tip:**  
> Door parameters via het formulier in te stellen, hoef je het script niet aan te passen als er iets verandert in de omgeving.

---

## 3.7 Plan van Aanpak

Maak samen een plan van aanpak waarin je alle benodigde stappen opsomt. Dit helpt om niets te vergeten én zorgt dat je het project gestructureerd opbouwt.

1. Maak het ontwerp compleet en stel een plan van aanpak op. (Lab 3)  
2. Voeg de connector toe in HelloID. (Lab 4)  
3. Stel de field mapping in. (Lab 5)  
4. Maak het invoerformulier voor de configuratieparameters. (Lab 6)  
5. Configureer de correlatieactie in het create-script. (Lab 7)  
6. Configureer de create-actie in het create-script. (Lab 7)  
7. Configureer het update-script. (Lab 8)  
8. Configureer het delete-script. (Lab 9)

> 💡 **Waarom dit handig is:**  
> Je voorkomt dat je onderdelen overslaat, en je houdt overzicht in je project.

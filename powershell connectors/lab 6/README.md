
# Lab 6 – Invoerformulier maken voor configuratie

## 🧭 Wat ga je doen?

In dit lab maak je een **configuratieformulier** aan in HelloID. Daarmee kun je instellingen zoals het pad naar het CSV-bestand en het scheidingsteken invullen via de interface, zonder dat je die hardcoded in je PowerShell-script hoeft te zetten.

💡Waarom dit handig is:
Met een configuratieformulier houd je alle instellingen overzichtelijk bij elkaar, op één centrale plek. Dat heeft een paar voordelen:

- Als er iets verandert, hoef je niet je script aan te passen, je past gewoon de waarden in het formulier aan.
- Andere beheerders kunnen dit ook aanpassen via de HelloID-interface, zonder dat ze iets in de PowerShell-code hoeven te wijzigen.
- Je voorkomt dat gevoelige of klantspecifieke gegevens hardcoded in het script staan.
- Je script blijft flexibel en makkelijk herbruikbaar in andere omgevingen.

---

## 🛠️ Stap 1 – Formulier aanmaken

We gaan een formulier toevoegen aan je PowerShell-doelsysteem waarin je het pad naar het CSV-bestand en het scheidingsteken kunt instellen. Zo houd je die instellingen netjes uit je script.

### Wat moet je doen

1. Ga in HelloID naar je PowerShell-doelsysteem.  
2. Open het tabblad **Account**.  
3. Open de configuratie van de **Custom connector configuration**.

> ✂️ **Let op:** de eerste keer dat je het formulier opent, zie je een voorbeeldconfiguratie met allerlei invoervelden zoals wachtwoord, e-mail, radioknoppen en dropdowns.  
> Voor deze training heb je die allemaal niet nodig.  
> 
> **Verwijder alles behalve het eerste veld** (type `"input"` met als label “Example required text”).  
> Gebruik dat veld als basis en pas de inhoud aan voor `csvPath`.  
> Vervolgens kun je het veld dupliceren en aanpassen voor `csvDelimiter`.

4. Voeg twee tekstvelden toe:
   - Eén met de key `csvPath`  
     Labelvoorbeeld: *Pad naar het accountsbestand*  
     Omschrijving: `Het pad naar het csv-bestand waar de accounts in staan`
   - Eén met de key `csvDelimiter`  
     Labelvoorbeeld: *Scheidingsteken voor CSV*  
     Omschrijving: `De delimiter die gebruikt wordt in het CSV-bestand`
5. Geef de velden duidelijke namen zodat collega’s snappen wat ze moeten invullen.
6. Klik op **Apply** om het formulier op te slaan.

Na het opslaan verschijnt er een extra tabblad genaamd **Configuration**. Daar vul je de waarden in die het script straks nodig heeft.

7. Ga naar het tabblad **Configuration** en vul de twee velden als volgt in:
   - `csvPath`: `C:\HelloID\TargetData\accounts.csv`
   - `csvDelimiter`: `;`
8. Klik ook hier rechtsboven op **Apply** om de waarden op te slaan.

> Tip: Als je meer wilt weten over welke type invoervelden je kunt gebruiken of wat er nog meer mogelijk is, bekijk dan de documentatie:  
> [Configure an input form – HelloID Docs](https://docs.helloid.com/en/provisioning/target-systems/powershell-target-systems/input-forms--provisioning-systems-.html)

---

## ℹ️ Hoe werkt dit straks in je script?

Je gaat de waarden uit het configuratieformulier pas gebruiken vanaf Lab 7, wanneer je het create-script gaat schrijven. Maar het is goed om nu alvast te begrijpen hoe je in HelloID die gegevens straks beschikbaar maakt in je scripts.

Alles wat je invult in het formulier (zoals het pad naar het bestand en het scheidingsteken), wordt door HelloID automatisch doorgegeven via:

```powershell
$actionContext.Configuration.csvPath
$actionContext.Configuration.csvDelimiter
```

Bijvoorbeeld:

```powershell
$csvPath = $actionContext.Configuration.csvPath
$delimiter = $actionContext.Configuration.csvDelimiter
```

HelloID maakt van het formulier geen losse variabelen, maar bundelt alle ingevulde waarden in één PowerShell-object. Dat object heet `configuration` en is beschikbaar via `$actionContext.Configuration` in je script. Zo kun je deze configuratie direct gebruiken zonder extra parsing of conversie.
Je ziet dit terug in het script zodra je straks met de create-actie aan de slag gaat in Lab 7.

---

## ✅ Wat heb je geleerd?

- Je hebt een configuratieformulier toegevoegd aan je PowerShell-doelsysteem in HelloID.
- Je weet hoe je gebruikersinstellingen zoals `csvPath` en `csvDelimiter` flexibel kunt instellen via de interface.
- Je begrijpt hoe HelloID deze waarden doorgeeft aan je script via `$actionContext.Configuration`.
- Je scripts maak je herbruikbaar, overzichtelijk en vrij van hardcoded of gevoelige gegevens.

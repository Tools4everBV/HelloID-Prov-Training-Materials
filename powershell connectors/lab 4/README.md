# ✅ Lab 4 – Een PowerShell-doelsysteem toevoegen

## 🔍 Wat ga je doen?

In dit lab voeg je een PowerShell-doelsysteem toe in HelloID. Dit systeem wordt gebruikt om provisioningacties uit te voeren, zoals het aanmaken, wijzigen of verwijderen van accounts, op basis van de persoonsgegevens en de business rules uit HelloID.

Het doelsysteem is de plek waar de provisioning echt plaatsvindt. Denk aan systemen zoals Active Directory, Microsoft 365, Topdesk of — zoals in deze training — een lokaal CSV-bestand. HelloID stuurt de acties aan, en voor elke actie zoals create, update of delete gebruik je een eigen PowerShell-script dat bepaalt wat er precies moet gebeuren.

---

## 🧰 Stap 1 – Doelsysteem aanmaken

We beginnen met het aanmaken van een nieuw doelsysteem in HelloID. Dit is het systeem waarin straks je PowerShell-scripts worden uitgevoerd.

### 🔨 Wat moet je doen?

1. Ga in HelloID naar **Provisioning → Target → Systems**.
2. Klik rechtsbovenin op het plusje (+) om een nieuw systeem toe te voegen.
3. Kies het type PowerShell.
4. Klik op Create om het doelsysteem aan te maken.
5. Geef het systeem daarna een herkenbare naam, bijvoorbeeld:  
   `Intranet CSV`.

---

## ⚙️ Stap 2 – Uitvoering via de lokale agent inschakelen

HelloID kan PowerShell-scripts op twee manieren uitvoeren: in de cloud of via een lokale agent op jouw server. Omdat je straks werkt met een lokaal CSV-bestand, moet HelloID de scripts lokaal uitvoeren via de agent.

### 🔨 Wat moet je doen?

1. Open je zojuist aangemaakte doelsysteem (Intranet CSV).
2. Zet de optie Execute on-premises aan.  
   👉 Deze wijziging wordt automatisch opgeslagen.

### ℹ️ Waarom is dit nodig?

Als je deze optie niet inschakelt, wordt het script uitgevoerd via de cloud agent. En die heeft geen toegang tot bestanden op `C:\HelloID\Training\Target\accounts.csv`. Door de lokale agent te gebruiken, zorg je ervoor dat HelloID het script uitvoert op jouw eigen server — waar dat bestand wél bereikbaar is.

---

## 🚫 Stap 3 – Zet de connector op actief

Standaard staat een nieuw doelsysteem op disabled. Dat betekent dat HelloID nog geen acties uitvoert, zelfs niet als je business rules al goed staan.

### 🔨 Wat moet je doen?

1. Ga naar het tabblad General van je doelsysteem.
2. Zet de optie Disable target system uit, zodat je systeem actief is.
3. Klik op Apply om de wijziging op te slaan.

---

## 📊 Stap 4 – Thresholds instellen

Thresholds zorgen ervoor dat HelloID niet zomaar provisioningacties uitvoert als er onverwacht veel accounts worden aangepast, aangemaakt of verwijderd. HelloID blokkeert de acties dan tijdelijk, zodat je eerst kunt controleren of alles klopt.

Tijdens deze training werk je vaak met 1 of 2 testpersonen. Daarom stellen we de Thresholds iets ruimer in, zodat je niet telkens handmatig goedkeuring hoeft te geven.

### 🔨 Wat moet je doen?

1. Open je doelsysteem en ga naar het tabblad Thresholds.
2. Stel per actie de Threshold in op minimaal 3 wijzigingen per actie:
   - Create (grant account)
   - Update (update account)
   - Delete (revoke account)

> 💡 Dit betekent: pas als een actie drie of meer keer tegelijk voorkomt, wordt deze geblokkeerd. Met 1 of 2 wijzigingen kun je gewoon testen zonder extra handelingen.

---

## 🔁 Stap 5 – Aantal gelijktijdige acties beperken

Je gaat straks met een CSV-bestand werken waarin HelloID provisioningacties opslaat. Omdat HelloID acties voor meerdere personen tegelijk kan uitvoeren, wil je voorkomen dat er meerdere schrijfacties tegelijk naar hetzelfde bestand plaatsvinden.

### 🔨 Wat moet je doen?

1. Open je doelsysteem en ga naar het tabblad General.
2. Open de configuratie van de **Concurrent action configuration**.
3. Zet het maximum aantal gelijktijdige acties op 1.
4. Klik op Apply om de wijziging op te slaan.

### 🧠 Waarom is dit belangrijk?

HelloID voert provisioningacties per persoon uit, en kan meerdere acties tegelijkertijd uitvoeren. Als die acties tegelijk proberen te schrijven naar hetzelfde CSV-bestand, kunnen er fouten of bestandsvergrendelingen optreden. Door het maximum op 1 te zetten, zorg je ervoor dat deze acties netjes één voor één worden verwerkt.

---

## 🧪 Stap 6 – Voorbereiding op scriptuitvoering

Je doelsysteem staat nu klaar om provisioningacties te ontvangen van HelloID. Welke actie er straks wordt uitgevoerd — create, update of delete — hangt af van de business rules én van de scripts die je in de volgende labs gaat configureren.

HelloID voert deze acties uit op basis van de actuele gegevens in de persoonssnapshot. Zodra iemand in scope valt voor een entitlement, bepaalt HelloID wat er moet gebeuren en roept het juiste PowerShell-script aan in het doelsysteem.

Daarom heb je in dit lab alvast gezorgd dat:
- HelloID de scripts uitvoert via de lokale agent, zodat je kunt werken met bestanden op je eigen server.
- het doelsysteem actief is (niet disabled).
- de thresholds zo zijn ingesteld dat testacties soepel doorgaan, maar een onverwacht hoog aantal acties toch wordt tegengehouden.
- acties netjes één voor één worden uitgevoerd, zodat je geen last hebt van bestandsvergrendeling in je CSV-bestand.

📚 In de volgende labs leer je hoe je de provisioning-scripts configureert en test:
- Lab 5 – Field mapping instellen  
- Lab 6 – Configuratieformulier toevoegen  
- Lab 7 t/m 9 – Create-, Update- en Delete-scripts maken en testen  

---

## ✅ Wat heb je geleerd?

- Je hebt een nieuw PowerShell-doelsysteem aangemaakt in HelloID.
- Je hebt ingesteld dat HelloID de scripts uitvoert via de lokale agent.
- Je hebt thresholds ingesteld die testacties toelaten maar grootschalige wijzigingen tegenhouden.
- Je hebt ervoor gezorgd dat acties één voor één worden uitgevoerd om fouten met bestandsvergrendeling te voorkomen.
- Je weet hoe en wanneer HelloID provisioningacties naar jouw doelsysteem stuurt.

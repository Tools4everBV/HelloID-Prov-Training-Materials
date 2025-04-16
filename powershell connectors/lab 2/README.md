# Lab 2 – Gegevensvalidatie en thresholds voor bronsystemen

## Wat ga je doen?

In dit lab stel je **validatieregels** in voor je PowerShell-bronsysteem. Je leert ook hoe je met **thresholds** voorkomt dat onbedoelde wijzigingen meteen provisioningacties starten.

💡 *Waarom dit belangrijk is?*  
Met validatie en thresholds voorkom je fouten. Je wilt bijvoorbeeld niet dat door een scriptfout ineens alle accounts worden verwijderd of opnieuw aangemaakt.

---

## ✅ Stap 1 – Validatieregels instellen

1. Ga naar je PowerShell-bronsysteem in HelloID en open het tabblad **Validation**.
2. Voeg een nieuwe validatieregel toe:
   - **Name**: `Controle op leeg emailadres`
   - **Script**:
     ```powershell
     if ([string]::IsNullOrEmpty($person.PrimaryEmail)) {
         throw "E-mailadres mag niet leeg zijn"
     }
     ```
3. Sla de validatieregel op.
4. Voer een **Import raw data** uit.
5. Controleer of je validatiefouten ziet verschijnen bij personen zonder e-mailadres.

---

## 🚦 Stap 2 – Thresholds configureren

1. Ga naar **Provisioning → Configuration → Thresholds**.
2. Stel per actie een drempelwaarde in (toggle aanzetten en waarde instellen):

   - **Grant account**: minimaal 2
   - **Update account**: minimaal 2
   - **Revoke account**: minimaal 2

> 💡 HelloID telt alleen acties die écht uitgevoerd worden. Alles onder de ingestelde drempel wordt als "te klein" gezien om automatisch door te voeren.

---

## 🧪 Stap 3 – Testen van je instellingen

1. Doe een aanpassing in je brondata, bijvoorbeeld één nieuwe persoon toevoegen.
2. Voer een nieuwe **Import raw data** uit.
3. Ga naar **Preview → Evaluate**.
4. Je zou nu moeten zien dat er **één create-actie** wordt voorgesteld.
5. Omdat dit onder de threshold valt, moet je handmatig bevestigen via **Enforcement**.

---

✅ Je hebt nu validatie en drempelwaardes ingesteld op je bronsysteem. HelloID helpt je zo om fouten op tijd te signaleren en onbedoelde acties tegen te houden!

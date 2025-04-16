# Lab 4 – Een PowerShell-doelsysteem toevoegen

## Wat ga je doen?

In dit lab voeg je een **PowerShell-doelsysteem** toe aan HelloID. Je koppelt dit systeem aan je CSV-bestand en stelt de basisinstellingen in zodat je het kunt gebruiken voor provisioning.

💡 *Waarom dit belangrijk is?*  
Het doelsysteem is de plek waar provisioning plaatsvindt. HelloID stuurt acties naar dit systeem zodra de business rules dat aangeven. Aan iedere actie hangt een script.

---

## 🧰 Stap 1 – Nieuw doelsysteem aanmaken

1. Ga naar **Provisioning → Target systems → PowerShell** en klik op **New**.
2. Geef het systeem een herkenbare naam, zoals `PowerShell - Intranet`.
3. Kies voor **One-time execution** (eenmalige acties).
4. Klik op **Create** om het systeem aan te maken.

---

## 🗂️ Stap 2 – Scripts aanmaken voor alle acties

HelloID verwacht voor ieder provisioningevent een script. Voeg placeholder-scripts toe voor:

- **Create**
- **Update**
- **Delete**
- **Enable**
- **Disable**

> 💡 Dit zijn lege scripts. Je gaat deze later invullen tijdens Lab 7, 8 en 9.

---

## 🔁 Stap 3 – Thresholds instellen

1. Ga naar het tabblad **Thresholds** van je PowerShell-doelsysteem.
2. Zet de threshold op minimaal 2 wijzigingen per actie:
   - Create → Grant account
   - Update → Update account
   - Delete → Revoke account

> 💡 Zo voorkom je dat HelloID bij een kleine wijziging (zoals één nieuwe medewerker) meteen provisioning uitvoert. Je moet dan handmatig bevestigen via enforcement.

---

## 🧪 Stap 4 – Testen of het systeem juist is gekoppeld

1. Open het doelsysteem en klik op **Preview**.
2. Selecteer een persoon uit je brondata.
3. Controleer of je een scriptvenster te zien krijgt (met lege scripts).
4. Er moet een provisioningactie klaarstaan, ook al doet het script nog niets.

---

✅ Je hebt nu een doelsysteem gekoppeld aan HelloID en bent klaar om scripts toe te voegen!

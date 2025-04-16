# Lab 3 – Ontwerp maken voor het doelsysteem

## Wat ga je doen?

In dit lab maak je een functioneel ontwerp voor het doelsysteem. Je gebruikt hiervoor drie tabellen: accounts, velden en naamconventies. Dit lab is een denk- en voorbereidopdracht die je later gebruikt in de volgende labs.

💡 *Waarom dit belangrijk is?*  
Een goed doordacht ontwerp voorkomt dat je later moet terugkomen op keuzes of scripts moet aanpassen. Je weet zo precies welke gegevens je nodig hebt, welke naamconventie je gebruikt en hoe je die inricht.

---

## 🧠 Stap 1 – Context: de situatie

Stel: je organisatie gebruikt een intranet waarin medewerkers kunnen samenwerken en nieuws kunnen delen.  
Het management wil dat nieuwe medewerkers **automatisch een account** krijgen zodra ze starten.

---

## 📊 Stap 2 – Maak een accounts-tabel

1. Open je eigen (lege) accounts-tabel of gebruik een template.
2. Vul voor elke medewerker minimaal de volgende gegevens in:
   - Id
   - Voornaam
   - Achternaam
   - Afdeling
   - Functie
   - Startdatum
   - Einddatum (optioneel)

3. Voeg extra velden toe die je denkt nodig te hebben in je connector (bijv. naamconventiecode).

---

## 📋 Stap 3 – Maak een veldentabel

1. Maak een overzicht van alle velden die je wilt gebruiken in je connector.

2. Voor elk veld geef je aan:
   - De naam van het veld
   - Oorsprong: komt het uit de bron of een andere connector?
   - Type mapping: Field, Fixed of Complex
   - Gebruik in notificaties: ja/nee
   - Nodig voor dependent system: ja/nee

> 💡 Gebruik bij voorkeur de namen van je bronvelden of eerder gebruikte velden.

---

## 🧩 Stap 4 – Kies een naamconventie

1. Bedenk hoe de gebruikersnaam eruit moet zien. Bijvoorbeeld:
   - `achternaam`
   - `voorletter.achternaam`
   - `achternaam-voornaam`

2. Noteer meerdere opties in je overzicht. Geef aan welke de voorkeur heeft.

---

## ✅ Stap 5 – Maak het ontwerp compleet

Combineer de drie tabellen tot een consistent ontwerp:
- De velden in je veldentabel sluiten aan op de kolommen in het accounts.csv-bestand.
- Je hebt bepaald welke velden worden gemapt, welke berekend worden, en welke je nodig hebt voor andere systemen of notificaties.
- Je naamconventie is afgeleid van bestaande velden en past binnen het gekozen patroon.

---

## 🧭 Stap 6 – Actieplan (volgt in de labs hierna)

Je ontwerp is de basis voor de stappen in de komende labs. Je gaat nu:

- Het doelsysteem toevoegen in HelloID (Lab 4)
- Field mapping instellen (Lab 5)
- Configuratieformulier maken (Lab 6)
- Correlatie instellen in het create-script (Lab 7)
- Create-actie toevoegen in het create-script (Lab 7)
- Update-script instellen (Lab 8)
- Delete-script instellen (Lab 9)

# Lab 0 – Voorbereiding: HelloID Provisioning Agent

### Wat ga je doen?

Voordat je met provisioning aan de slag kunt, moet HelloID kunnen communiceren met je lokale netwerk. Hiervoor gebruik je de HelloID Provisioning Agent. In dit lab controleer je of de agent actief is, en installeer je deze als dat nog niet zo is.

### Waarom is dit belangrijk?

De Provisioning Agent is een soort brug tussen HelloID in de cloud en je lokale omgeving (zoals Active Directory of lokale scripts). Zonder deze agent kunnen scripts niet lokaal uitgevoerd worden.

---

### 🧰 Stap 1 – Controleren of de HelloID Agent actief is (via HelloID portal en Windows Services)

1. **Log in op de HelloID portal** als beheerder.
2. Ga in het menu links naar **Agents**.
3. Controleer de status van de agent in HelloID:
   - **Groene statusindicator (Online):** De agent draait correct en is verbonden met HelloID.
   - **Rode statusindicator (Offline):** De agent is niet bereikbaar.
4. **Controleer de Windows services:**
   - Open de **Windows Services** door `services.msc` in te typen in het zoekvak van je Windows-systeem en op Enter te drukken.
   - Zoek naar de volgende services:
     - **HelloID Directory Agent**
     - **HelloID Service Automation Agent**
     - **HelloID Provisioning Agent**
   - Controleer of deze services **gestart zijn**. Als een van de services **niet gestart is**, klik je er met de rechtermuisknop op en kies je **Starten**.
5. **Controleer of de services blijven draaien:**
   - Nadat je de services hebt gestart (indien nodig), controleer je of ze **blijven draaien**.  
   - Als een service onverwacht stopt, kan dit betekenen dat er iets aan de hand is waardoor de service niet kan starten. Mogelijke oorzaken kunnen zijn:
     - **De server had geen internetverbinding** tijdens de installatie van de agent.
     - Het **wachtwoord van het serviceaccount** is mogelijk niet correct.

✅ **Als de agent actief is in zowel de HelloID portal als in de Windows Services, en de services blijven draaien, kun je verder met het volgende lab.**

---

### 🛠️ Stap 2 – Agent installeren (alleen als deze nog niet draait)

1. Open de volgende documentatiepagina:  
   👉 **[Install the on-premises agent](https://docs.helloid.com/en/agent/install-the-on-premises-agent-services.html)**
2. Volg de stappen in het artikel om de **HelloID Agent** te downloaden en te installeren op de server.
3. Zorg ervoor dat:
   - De service na installatie automatisch opstart.
   - De server toegang heeft tot internet (voor communicatie met HelloID).

---

### 📦 Stap 3 – Controleer of de agent up-to-date is

1. In de kolom **Version** zie je het versienummer van de agent. De versie heeft het formaat **jaar.maand.xx.xxxx**, bijvoorbeeld: `2025.3.20.6947`.

2. **Check bij de trainer of de mede-cursisten** welk versienummer de agent zou moeten hebben. We brengen halverwege de maand een nieuwe release uit. Vergelijk het versienummer van de agent met het verwachte versienummer. Als het versienummer lager is dan verwacht, kan er iets mis zijn gegaan met de update.

3. **Mogelijke oorzaken van een verouderde versie**:
   - De **rechten van het serviceaccount** op de server kunnen niet correct ingesteld zijn.
   - Er kan een probleem zijn met de **netwerkverbinding** van de server, waardoor de agent niet goed is bijgewerkt.

4. **Als je merkt dat de versie verouderd is**, controleer dan de serviceaccount-rechten en de netwerkverbinding om ervoor te zorgen dat de agent correct kan worden bijgewerkt.  
   Je kunt de agent bijwerken door een nieuwe versie te downloaden van de **HelloID portal** en deze te installeren.

---

### ✅ Wat heb je geleerd?

- Je weet nu hoe je controleert of de **HelloID Provisioning Agent** actief is.
- Je kunt de agent installeren als dat nodig is.
- Je weet hoe je controleert of de agent up-to-date is.
- Je bent klaar om te starten met het inrichten van bron- en doelsystemen in **HelloID**.

# Toetsopdracht DevOps — NSE Thermometer
_april 2025_

De Nationale Studenten Enquête is een grootschalig landelijk tevredenheidsonderzoek waarin studenten hun mening geven over hun HBO-opleiding en onderwijsinstelling. Waarschijnlijk heb jij deze enquête ook wel eens ingevuld.

HBO-ICT gebruikt verschillende systemen om de NSE te promoten. Een van deze systemen is de NSE Stretch Goal Thermometer. De applicatie die op verschillende schermen binnen Saxion zichtbaar is en die het huidige aantal stemmen en de behaalde stretch goals weergeeft.

In deze examenopdracht is het jouw taak om deze applicatie goed draaiende te krijgen in de cloud. Alles moet zo geautomatiseerd worden zodat een simpele push naar Gitlab de applicatie uitrolt naar een schaalbare cloud gebaseerde oplossing.

### Voorwaardelijke Eisen

-   Het is verplicht om alle *oefenopdrachten* in te leveren en te laten
    aftekenen door je docent, voordat deze eindopdracht kan worden
    ingeleverd. Uiteraard kun je ondertussen alvast wel een beginnetje
    maken met deze examenopdracht.

-   Voor elke requirement (zie hieronder) leg je uit hoe je het probleem
    hebt opgelost en waarom je het op deze manier hebt opgelost. Dit
    beschrijf je in je eigen woorden worden op een manier die te
    begrijpen is voor de docent die je werk beoordeelt. Je kunt het
    opschrijven in een Markdown-bestand in je repository of in
    commentaar in de source code (in het laatste geval verwijs je in het
    Markdown-bestand naar de locaties van deze comments).

-   Zorg ervoor dat je een repository gebruikt in de Saxion Gitlab
    organisatie, gemaakt via
    [https://repo.hboictlab.nl](https://repo.hboictlab.nl/)

-   Upload een gezipte export van je Gitlab-project naar Brightspace
    (Settings → General → Advanced → Export Project).\
    **Vermeld ook de URL van je repository in het opmerkingenveld op
    Brightspace.**

### Toetsregels

-   De deadline voor het inleveren van de opdracht is zondag 6 april
    23:59 (eind week 3.8).

-   De opdracht wordt gemaakt in groepjes van twee studenten die zich
    hebben aangemeld bij de docent. Groepjes worden gevormd in week 6,
    waarbij groepsleden allebei evenveel oefenopdrachten ingeleverd
    moeten hebben om te mogen samenwerken (maximaal 1 week verschil).

-   Je cijfer wordt bepaald op basis van het assessment dat plaatsvindt
    nadat je je opdracht hebt ingeleverd. Zorg dus dat je alle
    onderdelen die je gemaakt hebt goed begrijpt, er zullen ook
    theoretische vragen worden gesteld over je gemaakte oplossing.

-   Je krijgt alleen punten voor onderdelen van je werk die je tijdens
    het assessment kunt uitleggen. Bijvoorbeeld: als je code werkt, maar
    je kunt niet uitleggen wat het doet of waarom het zo werkt, dan telt
    dat onderdeel van de opdracht niet mee voor je eindcijfer.

-   Het is **niet** toegestaan om hulp te krijgen van iemand buiten je
    toetsgroepje, behalve van je docent. Het is ook **niet** toegestaan
    om hulp te verlenen aan iemand anders.

-   Je mag online posts, artikelen, tutorials, boeken, video\'s
    gebruiken. Je moet wel verwijzingen toevoegen [[1]](https://libguides.murdoch.edu.au/IEEE) voor alle bronnen en codefragmenten die je in je tekst/code gebruikt.

## Proces Requirements

Tijdens het uitvoeren van de opdracht moet je een gedegen
softwareontwikkelingsproces volgen, zoals behandeld in week 1. Dit omvat
dingen zoals het bijhouden van taken met behulp van Gitlab Issues, het
gebruik van Git om samen te werken aan de code, en het gebruik van
branches en merge request om code reviews te kunnen doen. Dit zou
allemaal duidelijk moeten blijken uit je Gitlab-repository.

## Functionele Requirements

### 1. Voeg gegevens toe aan de backend

In de repository vind je een map met daarin een backend applicatie.
Dit is een Laravel-applicatie die door ons wordt geleverd en die
gegevens in JSON-formaat teruggeeft. In de `README.md` in de backend map vind je meer informatie over het project. Als je de applicatie uitvoert en naar http://localhost:8080/api/goals gaat, krijg je een lijst
met stretch goals te zien die op dit moment in de database aanwezig zijn.
Initieel is de database leeg.

Om doelen aan de backend toe te voegen, moet je een POST request doen
in het juiste format (zie de map `seed-application`). Je kunt hiervooor
`curl` gebruiken. Zorg ervoor dat je het content type instelt op
`application/json` in je Curl commando. Daarnaast moet het REST endpoint
instelbaar zijn door middel van een environment variabele. Het script moet de bestandsnaam bevatten van het databestand, zodat we eenvoudig een ander bestand kunnen inladen.

Schrijf het Bash script `add_data.sh`, waarmee je het databestand
`data.md` inleest en de stretch goals vervolgens toevoegt aan de
backend (ook wel 'seeding' genoemd in het Engels). Zorg voor nette
foutafhandeling.

### 2. Containerisatie van de applicaties

De hele applicatie (backend, frontend, database en seed script) moet worden gecontaineriseerd met Docker en
Docker Compose. Er moeten aparte backend- en frontend containers zijn.

Zorg voor een handige manier om de containers te bouwen, uit te voeren
en te stoppen door een script te schrijven. Let erop dat tijdelijke
bestanden die zijn gemaakt door de applicatie buiten Docker uit te
voeren, niet in de image terechtkomen.

Breid het compose bestand uit zodat de gegevens opgeslagen worden in een
PostgreSQL database. In de `README.md` van de backend staat uitgelegd welke
variabelen nodig zijn om de backend aan de database te koppelen.

Het is toegestaan om NGINX te gebruiken om de frontend te hosten.

Vergeet niet een docker image te maken voor het seeden van de apllicatie. Dit kan enkel gedaan worden wanneer de backend en de database draaien. Daarom kan het handig zijn om te kijken naar healthcheck mechanismes in docker om de opstart volgorde van de containers aan te passen.

Andere onderwerpen waar je naar kunt kijken:
- Environment variabelen en .env bestanden
- Dockerignore bestanden, zodat enkel de noodzakelijke bestanden in de docker container terrecht komen
- Healthcheck mechanismes voor databases en webservers
- Multi-stage builds met docker

### 3. Continuous Integration

Implementeer een ontwikkelstraat met continuous integration voor de app.
De CI/CD moet uit ten minste twee fasen bestaan. Eén voor testen en bouwen van de backend en één voor het bouwen van de frontend. De gebouwde frontend moet als artefact te downloaden zijn in Gitlab.

### 4. Maak een infrastructuur om de applicatie op te draaien

Creëer een geschikte infrastructuur voor de applicatie in AWS met behulp
van Terraform. De infrastructuur hoeft (nog) niet high availability te
zijn. Als dit niet lukt met Terraform mag je handmatig de infrastructuur
aanmaken (hiermee verlies je natuurlijk wel punten). Je
Terraform-configuratie moet in de meegeleverde `infra` map worden
geplaatst.

De applicatie hoeft nog niet uitgerolt te worden met terraform naar de zojuist gemaakte infrastructuur. Dit ga je doen in de volgende stap met Continious Deployment.

### 5. Automatiseer de deployment van de applicaties

Automatiseer de deployment van de backend zodat, wanneer we committen
naar de main branch, de Gitlab CI:

-   de benodigde Docker images bouwt voor de backend

-   de image(s) upload naar de [private container
    registry](https://docs.gitlab.com/ee/user/packages/container_registry/index.html)
    van je Gitlab repository

-   verbinding maakt met de EC2-instantie met behulp van SSH, de
    Docker image(s) binnenhaalt en uitvoert

-   de gebouwde frontend web files uploadt als een statische website.

Om dit voor elkaar te krijgen, moet je de inhoud van je AWS private
SSH-sleutel (die je gebruikt om verbinding te maken met de instantie)
kopiëren naar een environment variable in Gitlab CI (Settings → CI/CD
→ Variables, klik op "Expand"). In je `.gitlab-ci.yml` bestand kun je
deze variabele vervolgens gebruiken om verbinding te maken met de
EC2-instantie via SSH.

Bij gebruik van SSH controleert de client of de server een bekende
server is. Voor onze geautomatiseerde implementatie is dit niet erg
handig (omdat iemand dan 'yes' moet intypen). Als je deze controle wil
uitschakelen, kun je de optie `-o StrictHostKeyChecking=no` meegeven aan
SSH.

Aanvullende ideeën:
- Je kunt manual steps opnemen in je pipeline om de infrastructuur aan te maken of weer neer te halen (tear down).

### 7. Maak een backend met high availability

Breid je Terraform-configuratie uit met een high availability backend.
Vergeet niet om de database ook highly available (d.w.z. redundant) te
maken. Als dit niet lukt mag je ook met een enkele database instance
werken, al krijg je daar natuurlijk wel minder punten voor.

Zorg ervoor dat de instances niet rechtstreeks toegankelijk zijn van
buiten je netwerk. Vergeet niet om de frontend aan te passen om
verbinding te maken met je nieuwe infrastructuur. Om te valideren of je
infrastructuur correct is ingesteld, check je of je frontend de stretch goals laat zien.

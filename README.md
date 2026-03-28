# x_french_travel

A new Flutter project.


## voor testen 

code zit in integration_test folder dan app_test.dart

run in terminal: flutter test integration_test/app_test.dart

opdracht en test requirements staan in de pdf

ik heb nu 20/40 tests geschreven binnen de tijd...


### planning
- 2 uur applicatie bouwen,
- 1uur besteden aan tests.


1. homepagina
- titel met de app naam en fance flaag met een icon knop top rechts
- zoek balk en een lijst met hotels
- zoek balk heeft een hint text "Search a hotel name"
- met de zoekbalk kan je hotels zoeken gebaseerd op de ingevoerde text
- de zoek knop is op het systeem toetsenbord
- de filter list icon moet rechts van de zoekbalk en wanneer geklicked laat het de filters dist en rating zien.
- de filters moet met de extra filters werken zoals bij punt 5 (zoek en met text en filteren tegelijk)
- wanneer de filter list icon uit staat rating en distance moeten verborgenzijn en in de state blijven
- een hotel moet dit tonen: 
    - naam
    - rating en sterren rating
    - afstand  "x km from Alp's ski lift"
    - book button
    - hotel cover image
- click de book button om naar de detail pagina te gaan
- click de icon rechts bovenaan om naar de my bookings pagina te gaan

2. detail pagina
    1. title bar bevat een terug knop en de tekst "Booking"
    2. klik op terug knop om naar de vorige pagina te gaan
    3. hotel informatie bar toont de huidige hotel naam
    4. gebruik tabs om te navigeren tussen subpagina's:
        - guest reviews
        - room selection

2.1 Booking Details pagina (guest reviews)
    1. Ratings area bevat:
        - titel "Ratings"
        - meerdere rating items
        - per rating item: progress bar + score
    2. Reviews area bevat:
        - titel "Reviews"
        - horizontale lijst met reviews
        - elk review item toont:
            - naam
            - nationaliteit
            - cirkelvormig avatar vlak
            - review tekst
        - initiaal in de cirkel is de eerste letter van de reviewer naam

2.2 Booking Details pagina (room selection)
    1. Rooms area bevat:
        - titel "Rooms"
        - lijst met rooms
    2. Elke room toont:
        - Room Type
        - Bed type: "Bed: XX"
        - "Total number of guests: XX"
        - korte room features introductie tekst
        - "€" icon met prijs tekst
    3. Klik op een boekbare room om naar de bijbehorende Booking Confirm pagina te gaan

3. Booking Confirm pagina
    1. title bar bevat:
        - terug knop
        - tekst "Booking Confirm"
        - tekst "You are going to reserve:"
    2. klik op terug knop om terug te gaan naar de vorige pagina
    3. hotel informatie komt uit de vorige selectie
    4. Form area bevat:
        - "First Name" en "Last Name" input velden
        - "Check-in date" en "Check-out date" input velden
        - room type die geboekt wordt
        - "Adults" en "Children" input velden
        - automatisch berekend aantal "Rooms"
        - "Travel for business?" radio keuze met opties:
            - "For sightseeing"
            - "+ €150 For business with a meeting room"
        - "Which way to pay?" radio keuze met opties:
            - "Cash"
            - "Credit card"
            - "E-Pay"
        - "€" icon met automatisch berekende prijs
        - "Book now" knop

4. My Bookings pagina
    1. title bar bevat terug knop + tekst "My Bookings"
    2. subtitle: "List of my bookings"
    3. booking list
    4. elk list item bevat:
        - numerieke volgorde (start bij 1)
        - naam van de persoon die reserveerde
        - start en einddatum in format: "Tue, Sep 10, 2024"
        - aantal adults, children en rooms
        - booking type en payment method
        - prijs
    5. Sorting controls (rechts van subtitle) met 2 sorteer knoppen:
        - "Calendar Clock" icon:
            - 1e klik: sorteer op Start Date (descending)
            - 2e klik: sorteer op Start Date (ascending)
            - 3e klik: terug naar 1e klik status
        - "Attach Money" icon:
            - 1e klik: sorteer op Price (descending)
            - 2e klik: sorteer op Price (ascending)
            - 3e klik: terug naar 1e klik status
    6. "My Booking CAL" knop

5. My Booking CAL pagina
    1. title bar bevat terug knop + tekst "My Booking CAL"
    2. kalender highlight datums met booking data op basis van Start Date
    3. bij klik op een datum met bookings:
        - navigeer terug naar My Bookings pagina
        - toon alleen records waarvan Start Date gelijk is aan de geselecteerde datum
    4. kalender blijft op de huidige systeem maand
    5. tekst van vandaag heeft een unieke highlight kleur, anders dan booking datums
    

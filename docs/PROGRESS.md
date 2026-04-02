# BlackBox Flight Tracker - Progress

## Status
**Prototyp dokončen a rozšířen!** Aplikace je plně funkční pro offline sledování, záznam letu i vyhledávání tras přes API.

## Roadmap
- [x] Project setup (Godot 4 Mobile)
- [x] GPS implementation (Vylepšený simulátor letu A -> B)
- [x] Multi-language Support (EN, DE, CS, IT - CSV Ready)
- [x] Mobile UI Refinement (Větší ovládací prvky, Zoom tlačítka)
- [x] Battery Saving (ECO Mode - 1 FPS, Black screen logic)
- [x] POI System (Bohatá data: Populace, Výška, Průtok řek)
- [x] Airport Database (47k letišť pro offline hledání)
- [x] Offline Map Engine (Zoom 0-2 Světový základ stažen)
- [x] Tonda-Package (Offline mapy pro trasu PRG-VIE-NAP-SUF staženy!)
- [x] BlackBox Archive & Playback (Rychlost 1x-100x, archiv letů)
- [x] Flight Data API (Vyhledávání trasy podle čísla letu s potvrzením)

## Poslední akce
- Implementována integrace s `FlightApiService` pro vyhledávání letů (např. OK380).
- Přidán `ConfirmationDialog` pro komfortní nastavení trasy.
- UI kompletně lokalizováno do 4 jazyků.

## Otevřené otázky / Budoucí vylepšení
- **Real-time API klíč:** Nutnost registrace na Aviationstack.com pro vlastní klíč (zatím používáme Mock).
- **Mapy a Data:** Vše je zdarma (OSM, OurAirports), aplikace je 100% tvoje.
- **Regionální Mapy:** Stahování celých kontinentů přímo z UI.

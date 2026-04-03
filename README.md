✈️ FLY2 – Offline Flight Context Explorer

A lightweight offline-first flight tracking & replay app built in Flutter.

Cílem není navigace.
Cílem je odpověď na otázku:

„Kde právě jsem — a co je pode mnou?“

🌍 Co aplikace dělá

FLY2 zobrazuje:

✈️ aktuální nebo replayovaný let
🗺️ offline mapu (MBTiles)
🌊 řeky, 🧭 hranice, 🏙️ města
📍 kontext pod letadlem (co je pod tebou)

A funguje offline.

🧠 Filozofie

Tahle aplikace není o trasování.

Je o vnímání prostoru.

letíš → vidíš svět pod sebou
replay → chápeš kudy jsi letěl
kontext → víš co je dole
✅ Hotové funkce
🗺️ Map engine
MBTiles rendering (offline)
vrstvy:
hranice států
řeky
POI (města, letiště)
zoom 4–9
AUTO vrstvy podle zoomu
🎛️ Ovládání mapy
plynulý zoom
+ / - tlačítka
vrstvy v jednom tlačítku:
AUTO
ALL
MAP+R
MAP
OFF
✈️ Flight Replay
přehrávání letu z DB
scrubber (časová osa)
rychlosti:
1x / 2x / 5x / 10x / 50x
skok:
⏪ -30s
⏩ +30s
✔ funguje dopředu i zpět
📍 Kontext pod letadlem
nearest POI lookup
vzdálenost
jednoduchá info karta
📥 Import letu
ruční zadání
Aviationstack API:
podle flight number
autocomplete:
letiště (IATA / ICAO / city)
📅 Datum & čas
picker (date + time)
fallback na API data
💾 Data
SQLite (Drift)
track points
sessions
📂 Struktura projektu (zjednodušeně)
lib/
├── app/
├── features/
│   ├── flight/
│   ├── import_flight/
│   ├── replay/
│   └── tracker/
├── map/
│   ├── widgets/
│   │   └── live_map.dart
│   └── sources/
├── data/
│   ├── db/
│   ├── models/
│   ├── services/
│   └── source/
├── shared/
🗺️ Mapové balíčky

Používáme:

world_base_z4_z5.mbtiles
europe_detail_z6_z7.mbtiles

MapRegistry:

WORLD → zoom 4–5
EUROPE → zoom 6–9
📦 Assets
data/source/
├── airports.json
├── cities.json
├── borders.json
├── europe_rivers.json
⚙️ Build
flutter pub get
flutter run

APK:

flutter build apk
🚧 Co je potřeba dodělat

Tady začíná ta zajímavá část.

1. ✈️ Flight → napojení na real data

Teď:

Unknown → Unknown

Potřebujeme:

uložit import jako session
napojit FlightScreen na DB
zobrazit:
from / to
ETA
progress
2. 🧭 Kontext engine (core feature)

Teď:

nearest POI

Chceme:

více vrstev:
řeky
města
hory
státy
priorita:
co je přímo pod tebou
typy:
„letíš nad Alpami“
„blízko Dunaje“
3. 🌍 Geodata rozšíření

Chybí:

🏔️ hory
🌊 jezera
🛣️ silnice (E-roads)
🏙️ města s populací
4. 🧠 Inteligentní vrstvy

AUTO je teď jednoduché:

Z4–5 → nic
Z5–6 → borders + rivers
Z6+ → + cities

Chceme:

jemnější přechody
hustota podle zoomu
clustering POI
5. 🎯 Flight path inteligence
deviation od trasy
nearest airport
emergency awareness
6. 📡 Live tracking (budoucnost)
GPS device
ADS-B (možná)
online/offline hybrid
7. 🧭 „Co je pode mnou“ (hlavní feature)

Tohle je klíč:

Chceme:

„Letíš nad severní Itálií, poblíž Alp, 12 km od Milána, nad řekou Pád“

To znamená:

multi-source context
kombinace:
region
city
river
terrain
8. 🎨 UI / UX
sjednotit Flight / Replay / Tracker mapu
bottom bar funkční:
Center
Layers
zjednodušit overlay
🧭 Směr projektu

Tohle není navigace.

Tohle je:

spatial awareness tool for flight

Offline. Lehký. Přehledný.

🔥 Další krok

Až se k tomu vrátíš:

napojit FlightScreen na DB session
uložit z importu:
lat/lon letišť
udělat první „context sentence generator“

Pokud chceš příště, poskládáme:
👉 ContextEngine v2 (to bude gamechanger)
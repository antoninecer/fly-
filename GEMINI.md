# FLY2 - Gemini Implementation Guide

## 1. Vision

FLY2 is an offline-first tracking and replay platform with map-centric UX.

Primary use-case:
- flight companion

Secondary use-cases:
- GPS tracker
- blackbox recorder
- route replay system

The app MUST work offline.

The app is NOT just a flight tracker.
It is a tracker + blackbox + replay + offline map + contextual geodata application.

---

## 2. LLM / Tooling Rules (CRITICAL)

Gemini MUST prefer local models through Ollama whenever possible.

### Primary model policy
1. Use LOCAL Ollama models first.
2. Use cloud / paid models only if absolutely necessary.
3. Avoid wasting credits on exploratory or repetitive tasks.
4. Work in small, verifiable steps.
5. After each meaningful step:
   - summarize what changed
   - update progress notes
   - do not leave hidden assumptions

### Expected local workflow
Gemini should assume the developer wants to use:
- local Ollama-hosted models
- local project files
- local emulator / local Flutter tooling

### Token / credit safety rules
Gemini MUST:
- avoid giant rewrites unless explicitly requested
- avoid regenerating unchanged files
- avoid repeating large unchanged code blocks
- propose targeted edits
- prefer patch-style work over rewriting everything

### Implementation style
- produce practical code
- no vague architecture essays when code is requested
- when uncertain, preserve existing structure
- respect existing mode separation

---

## 3. Core Product Rules

Gemini MUST preserve these rules:

1. Each mode has its own screen and its own control panel.
2. Do NOT merge Flight, Import, Tracker, Replay, Archive, Maps into one mixed screen.
3. The app must support offline usage.
4. A world fallback map must always exist visually.
5. Replay must not destroy or replace active tracking state.
6. Blackbox tracking is a first-class feature, not an extra.
7. The app must be modular.
8. Avoid giant files.
9. Avoid debug-style UI as final UX.
10. Android is the main target platform.

---

## 4. Main Modes

### Flight
Purpose:
- current flight session
- route A -> B
- ETA, elapsed, remaining
- speed
- altitude
- route deviation
- underflight context

### Import Flight
Purpose:
- manually enter flight number and route
- later fetch flight data from API
- create a Flight session

### Tracker
Purpose:
- passive GPS recording
- blackbox mode
- works even when no flight is imported

### Replay
Purpose:
- replay demo route
- replay archived session
- scrub / speed control

### Archive
Purpose:
- manage stored sessions

### Maps
Purpose:
- manage map packages
- inspect raster/vector sources

### Settings
Purpose:
- language
- saver mode
- replay defaults
- data options

---

## 5. UI Rule Update - Flight and Replay

FlightScreen and ReplayScreen must be map-first immersive screens.

Rules:
- The map must fill almost the entire screen.
- Large central info cards must not remain in final UX.
- Main telemetry must be shown as small corner overlays.
- Corner overlays must be tappable and cycle through multiple info modes.

FlightScreen corner overlay examples:
- left overlay cycles: speed / altitude / gps
- right overlay cycles: elapsed / remaining / ETA / route deviation

ReplayScreen corner overlay examples:
- left overlay cycles: speed / altitude / gps
- right overlay cycles: elapsed / remaining / ETA / playback speed

Bottom overlay:
- small, semi-transparent
- contains only key controls
- Flight: start / stop / center / layers / saver / share
- Replay: scrubber / play / pause / -10s / +10s / speed

Archive, Import, Maps may keep card-based layouts.
Flight and Replay must not.

---

## 6. Map System (CRITICAL)

### 6.1 Map Types

App must support:

1. Raster tiles / raster packages
   - world_base_z4_z5
   - europe_detail_z6_z7

2. Vector data layer (MANDATORY)
   - rivers
   - cities
   - mountains
   - borders / regions

Vector layer is NOT optional.

---

### 6.2 Map Behavior

Gemini MUST implement:

#### Automatic zoom logic
Zoom based on:
- speed
- altitude
- mode

Examples:
- airplane fast -> zoom out
- slow movement -> zoom in
- replay -> adaptive zoom

#### Manual override
User must be able to:
- pinch zoom
- pan map

Manual interaction temporarily disables auto-follow.

#### Default map visibility
- default visible map must always show the world fallback layer
- if detailed regional map exists and zoom requires it, switch automatically
- if detail is missing, fall back to world layer

---

### 6.3 Layer Composition

Final map =
- world base (low zoom)
- regional detail (mid zoom)
- vector overlay (data layer)

---

### 6.4 Map Switching

- automatic based on zoom level
- seamless transition
- no flicker
- no blank screen

---

## 7. Vector Data Layer

Gemini MUST implement support for:

### Cities
- name
- country
- population
- importance
- coordinates

### Mountains
- name
- elevation
- range
- coordinates

### Rivers
- name
- length
- flows into
- geometry or representative coordinates

### Borders / Regions
- country / region names
- boundaries or region identifiers

### Behavior
- visible depending on zoom
- tap -> quick info
- long tap -> pin location
- used for "what is under you" context

---

## 8. Flight Mode

Map-first UI.

Features:
- route A -> B
- ETA
- elapsed / remaining
- speed
- altitude
- route deviation
- contextual info under aircraft

Overlay behavior:

Left corner cycles:
- speed
- altitude
- GPS

Right corner cycles:
- elapsed
- remaining
- ETA
- route deviation

---

## 9. Replay Mode

- replay route (demo + real)
- scrub timeline
- change speed

### MUST support
- 1x / 2x / 5x / 10x
- jump +-10s
- pause / resume

Replay does NOT stop tracking.

---

## 10. Tracker (Blackbox)

- passive GPS recording
- runs in background
- works with screen off

Features:
- start / stop
- mark point
- save session
- share last fix

Tracker / Blackbox is a core feature.

---

## 11. Import Flight

Gemini MUST implement:

### 11.1 Manual input
- flight number
- from / to
- date / time

### 11.2 API lookup (IMPORTANT)
Implement connector for:
- aviationstack or similar flight API
- fallback manual input if API unavailable

Result should provide when possible:
- route
- coordinates
- timing
- airports / city names

---

## 12. Archive

Store:
- flights
- tracker sessions
- replays
- demo routes

Features:
- search
- play
- delete
- details

Archive must not be file-name-only.

---

## 13. Saver Mode (Battery)

Modes:
1. Full
2. Reduced
3. Saver

Saver mode:
- disable heavy animations
- reduce map redraw activity
- dim UI
- keep tracking alive
- allow quick wake

---

## 14. Screen OFF Behavior

- tracking continues
- replay may pause unless explicitly allowed
- minimal battery usage
- session must not be lost

---

## 15. Localization

Languages:
- en
- de
- it
- cs

Must support adding more later.

All visible text should be localizable.

---

## 16. Demo Data

Gemini MUST create / use:

### Demo route
Prague -> Naples

Includes:
- coordinates
- timestamps
- altitude
- speed

Used for:
- replay
- speed controls
- scrubber validation

---

## 17. Data Model Expectations

Core entities:

### Session
- id
- type
- title
- fromName
- toName
- fromLat
- fromLon
- toLat
- toLon
- startedAt
- endedAt
- durationSec
- distanceKm
- isActive
- sourceType
- notes

### TrackPoint
- sessionId
- timestamp
- lat
- lon
- altMeters
- speedKmh
- headingDeg
- phase

### PlaybackState
- sessionId
- currentTimeSec
- speedMultiplier
- isPlaying

### MapPackage
- id
- name
- fileName
- minZoom
- maxZoom
- priority
- isFallback

---

## 18. Non-Goals

Do NOT:
- overcomplicate UI
- mix modes into one screen
- block map with large panels
- remove blackbox mode
- rewrite architecture without reason

---

## 19. Priority Order

1. Map engine + zoom logic
2. Demo replay (Prague -> Naples)
3. Flight mode overlays
4. Tracker / blackbox
5. Vector data layer
6. API flight import
7. Archive persistence

---

## 20. Working Method

When implementing:
1. inspect current files
2. edit only necessary files
3. keep changes small
4. summarize changes clearly
5. update markdown notes after meaningful progress

Gemini must behave like an incremental local coding assistant, not like a one-shot code generator.

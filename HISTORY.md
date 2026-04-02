# History

## Godot Prototype Phase

The original prototype established key ideas:

- offline map ambition
- GPS / blackbox-like tracking
- playback concepts
- flight import idea
- POI / underflight context concept
- saver / eco mode idea
- multi-language direction

That prototype proved the product direction, but UI/UX and architecture were not suitable for long-term growth.

## Flutter Rewrite Phase

The project was restarted in Flutter to gain:

- better mobile-first development
- cleaner UI composition
- clearer mode separation
- easier future Android deployment

## Structural Decisions

Main decisions made during rewrite:

- Android first
- separate modes:
  - Flight
  - Import
  - Tracker
  - Replay
  - Archive
  - Maps
- Settings separate from main workflow
- map-first UX for Flight and Replay
- world fallback map required
- Europe detail map layered above fallback
- vector overlay must be added
- blackbox remains a core feature, not optional

## Current Stage

The app now has:
- emulator running
- working Flutter structure
- distinct screen layout
- base UI for all main modes

Next major milestone:
- real map engine + replay + tracking

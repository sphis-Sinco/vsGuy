# vs Guy plus
## v1.3 [Song Pack 1] - November 22nd 2024
### Changed
- Depending on the character, the ResultScore text can change asset as long as it has the suffix of `-[char]`
- Loading DLCS
  - DLCS must have a `pack.json`
- Preloader Color from light green to light blue
### Added
- Game Option Substate
- Reset Save Option (only accessable through main menu)
- NEW SONG: Nerve
- Update nickname to changelog (example: v1.2-1 is Playable Pico)
### Fixed
- Removing player registries that aren't unused

## v1.2-2 - November 17th 2024
### Fixed
- OutdatedState New release URL
- Lua scripts double folder
- Bug where Results Music would play in freeplay
### Added
- playedSongs Save data
- New Song Symbol
- "-indev" version suffix for when compiling in a Debug version
- Dialogue to Week 1 (only the song guy)
- Naughtyness option in Gameplay
### Removed
- Pico Week 1 from Story menu
### Changed
- Removed some notes from Guy (Pico Mix) Hard Difficulty
- Hard parts of Vex Hard Difficulty

## v1.2-1 [Playable Pico] - November 17th 2024
### Removed
- ElomentoPlayz
- DLC Folder
### Changed
- modVer text no longer has the `v` for version. In similar style to the `PSlice 2.1` version text
- Update checking to support patch updates (like 1.2-1)
- Zoom event (ease is automatically sinein)
### Fixed
- Fixed Animated Credit Icons
- ResultsScreen Results (No longer get like 80% and somehow get perfect)
### Added
- Animated Credit Icon Support (requires the animation name to be the icon name)
- PICO PLAYABLE CHARACTER
- NEW SONG: Guy (Pico Mix)
- Settings Reset (not to keybinds) to TitleState (press your reset keybind)

## v1.2 [ElomentoPlayz Build] - November 16th 2024
### Added
- NEW SONG: Vex
- ElomentoPlayz everywhere


## v1.1 - November 16th 2024
### Changed
- OutdatedState now checks for if the Current Version is lower than the online (github) Version
- Preloader now says "GUY+" instead of "FNF"
- Pacing of the "presents" Intro texts
### Fixed
- PlayerRegistry no longer traces a blank removed registries array after removing old Player Registries
### Removed
- openfl shader traces on debug builds
### Added
- vs Guy Plus Team Credits
- vs Guy Plus Team to "presents" Intro Text

## v1.0 - November 16th 2024
### Added
- Guy Week (1 song)

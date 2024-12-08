# vs Guy plus
## 2.0 [Holiday Pack] - December 15th 2024
### Added
- WEEK 3: PURPLE GUY
  - 1 New song: Galaxy
- XP SYSTEM
  - XP popup to results
- SHOP MENU
- SHOP ITEMS
  - Double XP: Doubles your XP at the end of a song (requires 7000 XP)
- New Title Screen Track (FlexRack) which replaces every instance of freakyMenu
- Engine Watermark to Gameplay (top right)
- Minecraft Font (unused)
- Comic Sans Font
- New Optional Metadata Arguments for songs
  - `artist` (String (default: 'Unknown')) - tells the artist of the song
  - `charter` (String (default: 'Unknown')) - tells the charter of the song
  - These new Fields have been added to DLCPack1 (12/8/2024)
- Automatic saving for any new Metadata arguments for songs (ex: `dialogueMusic`)
- Buttons and Inputs for any new Metadata arguments for songs (ex: `censoredDialogue`)
- InitState
- Credit Text at beginning of gameplay which says who made the song and who charted it
### Fixed
- Rank changing when the rank is lower then the previous rank
### Removed
- Debug Keybinds for changing song position
- Popup angle changing keybinds
- Memory Counter
- FPS Counter
- Ability to have Songs with a Rating over 20
- Donate Menu Item
### Changed
- AttractState can now be toggled if you have the flag `ATTRACT_ALLOWED` enabled
- Width of Chart editor Main UI Box
- Metadata tab in Chart Editor (many edits)
- Size of Main Menu Menu Items

## v1.5-2 - November 29th 2024
### Added
- New UI elements based on Arrow Funk
  - popups are now in the bottom left corner of your gameplay (upscroll, downscroll is top left corner)
- Combo to songText
- Achievements
### Removed
- Popup Sprite
- Combo Popup
- Combo Numbers Popup
- Adjust Delay and Combo Option Selection
- Achievements that dont apply to the mod (ex: week7_nomiss)
### Fixed
- Boyfriend great Rank animation offsets

## v1.5-1 - November 29th 2024
### Fixed
- Pause Menu Exit to Button Crash
- Songs with spaces (like "Red Guy") forever being considered a new song
### Added
- More specification to the `Reset Save` Option's Description
- Checks to make sure null or blank song names are ignored and not added to the playedSongs list

## v1.5 [Red Pack] - November 28th 2024
### Added
- WEEK 2: RED MAN
  - 2 New Songs: Red Guy and Waste
- Custom Mod Logo
- Bonky credit (new team member)
- New Optional Metadata Arguments for songs
  - `endDialogue` (Bool (default: false)) - controls if you have dialogue at the end of your song
### Changed
- Sinco Credit Icon
- Title Logo Position (X centered now)
### Removed
- The song's Mod name from the Results Screen
- V from `gitVersion.txt`
- Results Screen StickerSubState Transition
- Freeplay Capsule Week Display Thing
- Title GF
### Fixed
- Black screen bug after results screen on freeplay
- Random Character Select crash (it made 2 freeplay states)
- Guy having the beginning dialogue repeat for the end

## v1.4 [DLC Pack 1] - November 23rd 2024
### Added
- JERY DLC PACK
  - New Song: Jerith
- `source/objects/MenuBG.hx` - a QOL file to make adding menu backgrounds easier (this is now used in any menu (i remembered) that has a menuBG)
- Optional Metadata Arguments for songs
  - `dialogue` (Bool (default: false)) - controls if you have dialogue or not
  - `censoredDialogue` (Bool (default: false)) - controls if you get your dialogue censored when little timmy turns of naughtyness cause his parents are watching
  - `freeplayDialogue` (Bool (default: false)) - controls if the dialogue plays when entering the song from freeplay
  - `dialogueFile` (String (default: "dialogue")) - tells the game the dialogue file name
  - `dialogueMusic` (String (default: "breakfast")) - controls the background music of the dialogue
- Background to OutdatedState
- Text gags to OutdatedState when you press enter to update your game and when you press escape to continue anyway
- Custom Application Icons
- Censored Results Screen "Shit" (when naughtyness is off)
- Censored "Shit" popup (when naughtyness is off)
### Fixed
- Guy Week Dialogue
### Changed
- Dialogue functionality (more hardcoded with softcoded elements)
### Removed
- Debug conditional for dlcs menu to appear

## v1.3 [Song Pack 1] - November 22nd 2024
### Changed
- Depending on the character, the ResultScore text can change asset as long as it has the suffix of `-[char]`
- Loading DLCS
  - DLCS must have a `pack.json`
- Preloader Color from light green to light blue
### Added
- Game Option Substate
- Reset Save Option (only accessable through main menu)
- NEW SONGS: Nerve and Vex (pico mix)
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

# TouchDJ – touchscreen DJ UI for Mixxx

Entry point: `main.qml` loads `TouchDJ/TouchWindow.qml` instead of the stock `MainWindow.qml`.
QML is read from `res/` at runtime, so edits only need a restart (no rebuild).

Run: `./touchdj.sh [files to load into decks]` (uses its own `~/.mixxx-dev` profile).

## Views (permanent top bar, one tap to switch)
- **DECKS** (`DeckView`): 2 stacked waveforms, 2 `DeckPanel`s + `MixerPanel`. Top-right button swaps to decks 3/4.
  Each deck has tabs: hotcues / loop+beatjump / key+reverse+headphone+eject+FX assign.
- **LIBRARY** (`LibraryView`): stock `Library.qml` scaled 1.8x for touch; LOAD → 1..4 buttons, returns to decks.
- **EFFECTS** (`EffectsView`): 4 units x 3 slots, `EffectPicker` popup, parameter knobs from the slot's model.
- **SAMPLERS** (`SamplersView`): 16 samplers (8 per page); LOAD jumps to the library with that sampler as target.
- **AUDIO** (`AudioView`): master/headphones, 4 mics, 4 aux, record, Auto DJ, developer tools, quit (hold).
- SETTINGS: tap = stock settings popup, long-press = classic preferences dialog.

## Building blocks
`TouchButton`, `HotcuePad`, `TouchFader` (relative drag, double-tap resets), `TouchKnob`, `NavButton`,
`TouchJogWheel` (inner platter scratches via scratch_position, outer ring bends via jog).
All use pointer handlers (not MouseArea) so several fingers work at once.

## Gotchas
- Layouts nested in a Column/RowLayout default to fillHeight/fillWidth = true; set false for fixed rows.
- `TouchWindow` must set `[App] num_decks/num_samplers` like the stock window, or decks 3/4 and samplers don't exist.
- Delegates with `required property` need `required property int index` declared explicitly.

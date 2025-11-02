> [!WARNING]
> This project is under development and is not yet functional. A such, this README file is currently serving the purpose of a note-pad. Stating goals, guidelines and ideas to be implemented. Information on this page may change, as the project moves forward.

# Harmonizer 02

Harmonizer 02 is the second iteration in a series of harmonizer projects, aimed at developing a harmonizer for supercollider.

## Goals

* Will include MusicEgine, which is currently being developed in a separate repository. MusicEngine will act as a dynamic note range generating tool, and allow for a wider variety of chords, other than triads.
* Will allow extended chord syntax to determine bass note, top note, as well as anticipations and retardations.
* Backtracking funcions will be improved for efficiency.
* Valid Note ranges, for each of the voices, will be sorted by proximity to previous chord notes. The idea is to make the system biased towards preserving common tones and towards privileging smaller melodic intervals within each voice.
* Will be able to handle 4 to 7 voices.

## Extended Syntax

To the current verbose notation being implemented in MusicEngine:

```supercollider
"DbM3P5m7" // Dominant seventh chord, over Db
```

Will be added:

```supercollider
"DbM3P5m7(m7-;_M3;^Rt)"
```

Where:
* ***m7-*** means the minor seventh will be retarded onto the next chord
* ***M3*** means the major third will be the bass note
* ***Rt*** means the root will be played by the top voice
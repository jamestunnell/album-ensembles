# album-ensembles
An album of computer-music performance, showcasing the [musicality](https://github.com/jamestunnell/musicality) Ruby gem. The songs begin as code for an internal DSL that is a blend between straight Ruby and a custom music notation syntax. The code is processed to produce the musical score objects, which are then prepped for computer performance by converting them to MIDI files.

## The DSL
The internal DSL is built on Ruby and the [musicality](https://github.com/jamestunnell/musicality) gem. A song file consists of a *score* block that defines all the notes, dynamics, tempos, etc. to produce a Musicality score object.

## Building the Score
Using the `rake yaml` command the song file can be processed to build a YAML file that represents a Musicality score object.

## Building the MIDI
Using the `rake midi` command the YAML file can be processed to build a MIDI file that. Also, a `.midify` file can be created a given song file, in order to specify command-line options for the `midify` executable that is used to process the YAML file. For example, for a song file `mysong.song`, a companion file `mysong.midify` could be created to specify the MIDI instrument patch numbers for each part in the score.
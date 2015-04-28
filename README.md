# album-ensembles
An album of computer-music performance, showcasing the [musicality](https://github.com/jamestunnell/musicality) Ruby gem. The songs begin as code for an internal DSL that is a blend between straight Ruby and a custom music notation syntax. The code is processed to produce the musical score objects, which are then prepped for computer performance by converting them to MIDI files.

## Installation
The album source code uses the Ruby language, so it must be installed first. See the [Ruby homepage](https://www.ruby-lang.org/) for instructions on downloading and installing the standard Ruby runtime.

With the Ruby runtime installed, the next step is to install the `bundler` gem using

    $ gem install bundler

Now the album code can be obtained simply by using

    $ git clone https://github.com/jamestunnell/album-ensembles

In the album code folder, install the remaining Ruby gem dependencies using

    $ cd album-ensembles
    $ bundle install

## The DSL
The internal DSL is built on Ruby and uses the music abstractions provided by the [musicality](https://github.com/jamestunnell/musicality) gem. A song file consists of a *score* block that defines all the notes, dynamics, tempos, etc. to produce a Musicality score object.

## Building the Score
The song file can be processed to build a YAML file that represents a Musicality score object using the command line

    $ rake yaml
    
## Building the MIDI
The YAML file can be processed to build a MIDI file using the command line 

    $ rake midi

Also, a `.midify` file can be created a given song file, in order to specify command-line options for the `midify` executable that is used to process the YAML file. For example, for a song file `mysong.song`, a companion file `mysong.midify` could be created to specify the MIDI instrument patch numbers for each part in the score. See the song files See the `midify` command line usage for help with this, using

    $ midify --help
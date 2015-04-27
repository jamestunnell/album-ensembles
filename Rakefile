require 'rake'

require_relative 'songs/song_helper'

SONG_EXT = ".song"
YAML_EXT = ".yml"
MIDI_EXT = ".mid"
MIDIFY_EXT = ".midify"

song_files = Rake::FileList["songs/*#{SONG_EXT}"]
yaml_files = song_files.ext(YAML_EXT)
midi_files = song_files.ext(MIDI_EXT)
midify_files = song_files.ext(MIDIFY_EXT)

midify_files.each do |fname|
  unless File.exists? fname
    File.write(fname,"")
  end
end

task :yaml => yaml_files
task :midi => midi_files

task :clean do
  outfiles = (yml_files + midi_files).select {|fname| File.exists? fname }
  if outfiles.any?
    puts "Deleting output files:"
    outfiles.each do |fname|
      puts " " + fname
      File.delete fname
    end
  end
end

rule YAML_EXT => SONG_EXT do |t|
  puts "#{t.source} -> #{t.name}"
  yml = SongDSL.load(t.source).export_yaml
  File.write(t.name, yml)
end

rule MIDI_EXT => [YAML_EXT, MIDIFY_EXT] do |t|
  sh "midify #{t.sources[0]} #{File.read(t.sources[1])}"
  puts
end

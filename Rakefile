require 'rake'

require 'musicality'
include Musicality
include Pitches
include Meters
include Dynamics
include Articulations

SCORE_EXT = ".score"
YAML_EXT = ".yml"
MIDI_EXT = ".mid"
MIDIFY_EXT = ".midify"

score_files = Rake::FileList["scores/*#{SCORE_EXT}"]
yaml_files = score_files.ext(YAML_EXT)
midi_files = score_files.ext(MIDI_EXT)
midify_files = score_files.ext(MIDIFY_EXT)

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

rule YAML_EXT => SCORE_EXT do |t|
  puts "#{t.source} -> #{t.name}"
  yml = ScoreDSL.load(t.source).score_yaml
  File.write(t.name, yml)
end

rule MIDI_EXT => [YAML_EXT, MIDIFY_EXT] do |t|
  sh "midify #{t.sources[0]} #{File.read(t.sources[1])}"
  puts
end

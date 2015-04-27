require 'musicality'
require 'yaml'

include Musicality
include Pitches
include Articulations
include Meters

def transpose(notes,i)
  notes.map {|n| n.transpose(i) }
end

def e_notes(pitch_groups)
  pitch_groups.map {|pg| Note.eighth(pg) }
end

def q_notes(pitch_groups)
  pitch_groups.map {|pg| Note.quarter(pg) }
end

def dq_notes(pitch_groups)
  pitch_groups.map {|pg| Note.dotted_quarter(pg) }
end

# def triplet_e_notes(pitch_groups)
#   pitch_groups.map {|pg| Note.new("1/12".to_r,pg) }
# end

def song name, &block
  song = Song.new(name)
  song.instance_eval(&block)
end

class NoScoreError < RuntimeError; end

class Song
  def initialize title
    @title = title
    @score = nil
  end

  def score start_meter, start_tempo, &block
    @score = Score::Measured.new(start_meter,start_tempo)
    @score.instance_eval(&block)
  end

  def midify args = []
    raise NoScoreError if @score.nil?

    yml_fname = @title + ".yml"
    File.open(yml_fname, "w") do |file|
      file.write @score.pack.to_yaml
    end
    `midify "#{yml_fname}" #{args.join(" ")}`
  end
end

class SongDSL
  def self.load fname
    song = SongDSL.new
    song.instance_eval(File.read(fname), fname)
    song
  end

  def initialize
    @score = nil
  end

  # def title str
  #   @title = str
  # end

  # def author str
  #   @authors.push str
  # end

  def score start_meter, start_tempo, &block
    @score = Score::Measured.new(start_meter,start_tempo)
    @score.instance_eval(&block)
  end

  def export_yaml
    @score.pack.to_yaml
  end

  def midify args = []
    raise NoScoreError if @score.nil?

    yml_fname = @title + ".yml"
    File.open(yml_fname, "w") do |file|
      file.write @score.pack.to_yaml
    end
    `midify "#{yml_fname}" #{args.join(" ")}`
  end
end

class SectionDurationError < RuntimeError; end

class Score::Measured < Score::TempoBased
  def meter_change new_meter, offset: 0
    meter_changes[measures_long + offset] = Change::Immediate.new(new_meter)
  end

  def tempo_change new_tempo, duration: 0, offset: 0
    if duration == 0
      tempo_changes[measures_long + offset] = Change::Immediate.new(new_tempo)
    else
      tempo_changes[measures_long + offset] = Change::Gradual.linear(new_tempo, duration)
    end
  end

  def measures part_notes, default_start_dynamic = Dynamics::MF
    raise ArgumentError if part_notes.empty?

    # Ensure that notes, if being added, have same total duration
    durs = part_notes.values.map {|notes| notes.map {|n| n.duration }.inject(0,:+) }
    durs_uniq = durs.uniq
    raise SectionDurationError if durs_uniq.size > 1
    dur = durs_uniq.first
    raise SectionDurationError if dur == 0

    a = measures_long
    nl = notes_long
    part_notes.each do |part,notes|
      unless parts.has_key? part
        parts[part] = Part.new default_start_dynamic
        if nl > 0
          parts[part].notes.push Note.new(nl)
        end
      end
      parts[part].notes += notes
    end
    (parts.keys - part_notes.keys).each do |part|
      parts[part].notes.push Note.new(dur)
    end
    b = measures_long
    
    program.push a...b
    a...b
  end

  def section title, &block
    if @sections.nil?
      @sections = {}
    end
    @sections[measures_long] = title
    self.instance_eval(&block)
  end
end
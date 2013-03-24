require_relative './dbfile'
require_relative './exifinfotool'

class Configuration
  attr_reader :dbfile, :infotool, :optionstate

  def initialize
    @optionstate = OptionState.new(self)
    @dbfile = DBFile.new(File.join(ENV['HOME'], '.cache', 'playmusic',
      'database'), optionstate.rebuild_db)
    if infotool_available
      @infotool = ExifInfoTool.new
    end
  end

  private

  def infotool_available
    result = false
    etfile = 'exiftool'
    pathparts = ENV['PATH'].split(':')
    i = 0
    while result == false and i < pathparts.length
      result = File.exists?(File.join(pathparts[i], etfile))
      i += 1
    end
    result
  end
end

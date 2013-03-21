require_relative './dbfile'
require_relative './exifinfotool'

class Configuration
  attr_reader :dbfile, :infotool

  def initialize(optionstate)
    @dbfile = DBFile.new(File.join(ENV['HOME'], '.cache', 'playmusic',
      'database'), optionstate.rebuild_db)
#@infotool = InfoTool.new
    @infotool = ExifInfoTool.new
  end
end
